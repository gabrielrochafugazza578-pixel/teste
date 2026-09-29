class_name HUD
extends Control
## HUD: some quando parado e sem ameaça, reaparece com dano/eventos.
## Cartões translúcidos com ícones: vitais e condições (sup. esq.), bússola com
## objetivo (topo), relógio/clima e objetivo atual (sup. dir.), dica de
## interação com a tecla, furtividade/ruído e botões Mochila/Diário/Mapa
## (inf. esq., clicáveis segurando Alt), arma e atalhos (inf. dir.), veículo,
## legendas, notificações, banners, vinhetas e marcador de acerto na mira.

var player: Player = null
var game: Node = null
var vitals: PanelContainer
var bars: Dictionary = {}
var values: Dictionary = {}
var cond_box: HFlowContainer
var compass: Control
var clock_card: PanelContainer
var clock: Label
var weather_label: Label
var time_icon: UIGlyph
var weather_icon: UIGlyph
var objective_card: PanelContainer
var objective_title: Label
var objective_text: Label
var objective_dist: Label
var prompt_box: HBoxContainer
var prompt_key: PanelContainer
var prompt: Label
var hold_bar: ProgressBar
var eye: Control
var noise_bar: ProgressBar
var stealth_card: PanelContainer
var menu_bar: HBoxContainer
var cursor_hint: Label
var weapon_card: PanelContainer
var weapon_icon: UIGlyph
var weapon_label: Label
var weapon_cond: ProgressBar
var ammo_label: Label
var slots: HBoxContainer
var slot_icons: Array = []
var slot_counts: Array = []
var vehicle_box: VBoxContainer
var vehicle_label: Label
var fuel_bar: ProgressBar
var subtitle_panel: PanelContainer
var subtitle_label: RichTextLabel
var toasts: VBoxContainer
var banner: Label
var banner_sub: Label
var crosshair: Control
var vignette: ColorRect
var log_label: Label
var fps_label: Label
var nearby: HUDNearby

var _sub_t: float = 0.0
var _banner_t: float = 0.0
var _damage_flash: float = 0.0
var _fade_hud: float = 1.0
var _idle_t: float = 0.0
var _visible_user: bool = true
var _hold_p: float = 0.0
var _vign_mat: ShaderMaterial
var _last_prompt: String = ""

const VIGNETTE_SHADER := """
shader_type canvas_item;
uniform float damage = 0.0;
uniform float low = 0.0;
uniform float infection = 0.0;
uniform float cold = 0.0;
void fragment(){
	vec2 d = UV - 0.5;
	float r = length(d * vec2(1.3, 1.0));
	float v = smoothstep(0.35, 0.85, r);
	vec3 col = vec3(0.45, 0.02, 0.02) * (damage + low * 0.6);
	col += vec3(0.25, 0.3, 0.05) * infection;
	col += vec3(0.4, 0.55, 0.7) * cold;
	float a = v * clamp(damage * 0.9 + low * 0.55 + infection * 0.45 + cold * 0.4, 0.0, 0.92);
	COLOR = vec4(col, a);
}
"""

const HUD_BG := Color(0.03, 0.033, 0.036, 0.62)


func _ready() -> void:
	theme = UITheme.game_theme()
	UIKit.full_rect(self)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()
	_outline_labels(self)
	EventBus.subtitle.connect(_on_subtitle)
	EventBus.notify.connect(_on_notify)
	EventBus.interaction_prompt.connect(_on_prompt)
	EventBus.chapter_started.connect(_on_chapter)
	EventBus.location_discovered.connect(_on_discovered)
	EventBus.player_damaged.connect(func(a: float, _s: Node) -> void:
		_damage_flash = minf(1.0, _damage_flash + a / 25.0)
		_idle_t = 0.0)
	EventBus.hud_visibility.connect(func(v: bool) -> void: _visible_user = v)
	EventBus.mission_updated.connect(func(_id: String) -> void: _idle_t = 0.0)
	EventBus.settings_changed.connect(_apply_settings)
	EventBus.combat_hit.connect(func(a: Node, _t: Node, _d: float) -> void:
		if a == player:
			(crosshair as HUDCrosshair).flash(false)
			_idle_t = 0.0)
	EventBus.enemy_killed.connect(func(_k: String, _p: Vector3, killer: Node) -> void:
		if killer == player:
			(crosshair as HUDCrosshair).flash(true))
	_apply_settings()


func bind(p: Player, g: Node) -> void:
	player = p
	game = g
	nearby.player = p
	p.interact_hold_progress.connect(func(v: float) -> void: _hold_p = v)


func _apply_settings() -> void:
	var sizes := [18, 22, 27, 34]
	if subtitle_label:
		subtitle_label.add_theme_font_size_override("normal_font_size", sizes[clampi(int(Settings.accessibility.get("subtitle_size", 1)), 0, 3)])
		subtitle_label.add_theme_font_size_override("bold_font_size", sizes[clampi(int(Settings.accessibility.get("subtitle_size", 1)), 0, 3)])
	if subtitle_panel:
		var bg_on := bool(Settings.accessibility.get("subtitle_background", true))
		subtitle_panel.add_theme_stylebox_override("panel", UITheme.box(Color(0, 0, 0, 0.62 if bg_on else 0.0), Color(0, 0, 0, 0), 0, 6, 14))
	if fps_label:
		fps_label.visible = bool(Settings.graphics.get("show_fps", false))
	if menu_bar:
		_refresh_menu_keys()


# ---------------------------------------------------------------------------
# Construção
# ---------------------------------------------------------------------------
## Contorno escuro em todo texto do HUD: legível sobre céu claro, neblina e neve.
func _outline_labels(n: Node) -> void:
	for c in n.get_children():
		if c is Label and not (c as Label).has_theme_constant_override("outline_size"):
			(c as Label).add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.7))
			(c as Label).add_theme_constant_override("outline_size", 3)
		_outline_labels(c)


func _hud_card(pad: int = 10, accent: Color = Color(0, 0, 0, 0)) -> PanelContainer:
	var p := PanelContainer.new()
	var sb := UITheme.box(HUD_BG, Color(1, 1, 1, 0.07), 1, 8, pad)
	if accent.a > 0.0:
		sb.border_width_left = 4
		sb.border_color = accent
	p.add_theme_stylebox_override("panel", sb)
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return p


func _anchor(c: Control, preset: int, pos: Vector2) -> void:
	c.set_anchors_preset(preset)
	c.position = pos


func _build() -> void:
	vignette = ColorRect.new()
	UIKit.full_rect(vignette)
	vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sh := Shader.new()
	sh.code = VIGNETTE_SHADER
	_vign_mat = ShaderMaterial.new()
	_vign_mat.shader = sh
	vignette.material = _vign_mat
	add_child(vignette)
	# ---- vitais (superior esquerdo)
	vitals = _hud_card(12)
	_anchor(vitals, Control.PRESET_TOP_LEFT, Vector2(20, 18))
	var vv := UIKit.vbox(5)
	vitals.add_child(vv)
	for row: Array in [["health", "heart", Color(0.84, 0.24, 0.2), 200.0, 12.0], ["stamina", "wind", Color(0.88, 0.85, 0.72), 150.0, 7.0],
			["hunger", "food", Color(0.9, 0.63, 0.28), 150.0, 7.0], ["thirst", "drop", Color(0.36, 0.64, 0.95), 150.0, 7.0],
			["energy", "bolt", Color(0.68, 0.57, 0.92), 150.0, 7.0]]:
		var h := UIKit.hbox(8)
		var g := UIGlyph.make(str(row[1]), 16 if row[0] != "health" else 20, (row[2] as Color).lightened(0.15))
		g.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(g)
		var b := UIKit.bar(row[2])
		b.custom_minimum_size = Vector2(float(row[3]), float(row[4]))
		b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		b.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(b)
		var vl := UIKit.label("", 13, UITheme.TEXT)
		vl.custom_minimum_size = Vector2(30, 0)
		h.add_child(vl)
		vv.add_child(h)
		bars[row[0]] = b
		values[row[0]] = vl
	var th := UIKit.hbox(8)
	var tg := UIGlyph.make("thermo", 16, UITheme.TEXT)
	tg.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	th.add_child(tg)
	var tv := UIKit.label("36.6 °C", 14)
	th.add_child(tv)
	bars["temp"] = tv
	bars["temp_icon"] = tg
	vv.add_child(th)
	cond_box = HFlowContainer.new()
	cond_box.custom_minimum_size = Vector2(250, 0)
	cond_box.add_theme_constant_override("h_separation", 4)
	cond_box.add_theme_constant_override("v_separation", 4)
	cond_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vv.add_child(cond_box)
	add_child(vitals)
	# ---- bússola
	compass = HUDCompass.new()
	compass.hud = self
	compass.set_anchors_preset(Control.PRESET_CENTER_TOP)
	compass.custom_minimum_size = Vector2(620, 36)
	compass.size = Vector2(620, 36)
	compass.position = Vector2(-310, 16)
	add_child(compass)
	# ---- relógio e clima (superior direito)
	clock_card = _hud_card(10)
	_anchor(clock_card, Control.PRESET_TOP_RIGHT, Vector2(-300, 18))
	clock_card.custom_minimum_size = Vector2(280, 0)
	var ch := UIKit.hbox(10)
	clock_card.add_child(ch)
	time_icon = UIGlyph.make("sun", 30, Color(1.0, 0.85, 0.45))
	time_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	ch.add_child(time_icon)
	var cv := UIKit.vbox(0)
	cv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	clock = UIKit.label("", 17, UITheme.TEXT)
	cv.add_child(clock)
	var wh := UIKit.hbox(6)
	weather_icon = UIGlyph.make("cloud", 16, Color(0.8, 0.82, 0.85))
	weather_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	wh.add_child(weather_icon)
	weather_label = UIKit.label("", 13, UITheme.TEXT_DIM)
	wh.add_child(weather_label)
	cv.add_child(wh)
	ch.add_child(cv)
	add_child(clock_card)
	fps_label = UIKit.label("", 13, UITheme.GOOD, HORIZONTAL_ALIGNMENT_RIGHT)
	fps_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	fps_label.position = Vector2(-330, 2)
	fps_label.custom_minimum_size = Vector2(310, 0)
	add_child(fps_label)
	# ---- objetivo (direita, abaixo do relógio)
	objective_card = _hud_card(12, UITheme.ACCENT)
	_anchor(objective_card, Control.PRESET_TOP_RIGHT, Vector2(-400, 96))
	objective_card.custom_minimum_size = Vector2(380, 0)
	var ov := UIKit.vbox(3)
	objective_card.add_child(ov)
	var oh := UIKit.hbox(6)
	oh.add_child(UIGlyph.make("star", 14, UITheme.ACCENT))
	oh.add_child(UIKit.label("OBJETIVO", 12, UITheme.ACCENT))
	objective_dist = UIKit.label("", 12, UITheme.TEXT_DIM, HORIZONTAL_ALIGNMENT_RIGHT)
	objective_dist.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	oh.add_child(objective_dist)
	ov.add_child(oh)
	objective_title = UIKit.label("", 17, UITheme.ACCENT.lightened(0.15))
	ov.add_child(objective_title)
	objective_text = UIKit.label("", 15, UITheme.TEXT)
	objective_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	objective_text.custom_minimum_size = Vector2(350, 0)
	ov.add_child(objective_text)
	add_child(objective_card)
	# ---- dica de interação (abaixo do centro)
	var pc := UIKit.vbox(6)
	pc.set_anchors_preset(Control.PRESET_CENTER)
	pc.position = Vector2(-300, 70)
	pc.custom_minimum_size = Vector2(600, 0)
	prompt_box = UIKit.hbox(10)
	prompt_box.alignment = BoxContainer.ALIGNMENT_CENTER
	prompt_key = UIKit.keycap("E", 16)
	prompt_box.add_child(prompt_key)
	prompt = UIKit.label("", 19, UITheme.TEXT, HORIZONTAL_ALIGNMENT_CENTER)
	prompt.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	prompt.add_theme_constant_override("outline_size", 6)
	prompt_box.add_child(prompt)
	prompt_box.visible = false
	pc.add_child(prompt_box)
	hold_bar = UIKit.bar(UITheme.ACCENT, 1.0)
	hold_bar.custom_minimum_size = Vector2(180, 6)
	hold_bar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	pc.add_child(hold_bar)
	add_child(pc)
	# ---- mira
	crosshair = HUDCrosshair.new()
	crosshair.set_anchors_preset(Control.PRESET_CENTER)
	crosshair.position = Vector2(-16, -16)
	crosshair.size = Vector2(32, 32)
	add_child(crosshair)
	# ---- furtividade / ruído + botões de menu (inferior esquerdo)
	var bl := UIKit.vbox(8)
	_anchor(bl, Control.PRESET_BOTTOM_LEFT, Vector2(20, -168))
	stealth_card = _hud_card(8)
	var sh2 := UIKit.hbox(10)
	stealth_card.add_child(sh2)
	eye = HUDEye.new()
	eye.custom_minimum_size = Vector2(44, 24)
	eye.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	sh2.add_child(eye)
	var nv := UIKit.vbox(2)
	nv.add_child(UIKit.label("Ruído", 12, UITheme.TEXT_DIM))
	noise_bar = UIKit.bar(Color(0.85, 0.85, 0.8), 1.0)
	noise_bar.custom_minimum_size = Vector2(110, 6)
	noise_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	nv.add_child(noise_bar)
	sh2.add_child(nv)
	stealth_card.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	bl.add_child(stealth_card)
	log_label = UIKit.label("", 14, Color(0.75, 0.6, 0.9))
	bl.add_child(log_label)
	menu_bar = UIKit.hbox(8)
	for e in [["backpack", "Mochila", "inventory"], ["book", "Diário", "journal"], ["map", "Mapa", "map"]]:
		menu_bar.add_child(_menu_button(str(e[0]), str(e[1]), str(e[2])))
	bl.add_child(menu_bar)
	cursor_hint = UIKit.label("", 12, UITheme.TEXT_DIM)
	bl.add_child(cursor_hint)
	add_child(bl)
	# ---- arma e atalhos (inferior direito)
	var wb := UIKit.vbox(8)
	_anchor(wb, Control.PRESET_BOTTOM_RIGHT, Vector2(-420, -150))
	wb.custom_minimum_size = Vector2(400, 0)
	weapon_card = _hud_card(10)
	weapon_card.size_flags_horizontal = Control.SIZE_SHRINK_END
	var wh2 := UIKit.hbox(10)
	weapon_card.add_child(wh2)
	weapon_icon = UIGlyph.new()
	weapon_icon.custom_minimum_size = Vector2(42, 42)
	weapon_icon.glyph = "glove"
	weapon_icon.color = UITheme.TEXT_DIM
	wh2.add_child(weapon_icon)
	var wv := UIKit.vbox(2)
	weapon_label = UIKit.label("", 17, UITheme.TEXT)
	wv.add_child(weapon_label)
	weapon_cond = UIKit.bar(UITheme.ACCENT, 1.0)
	weapon_cond.custom_minimum_size = Vector2(150, 5)
	weapon_cond.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wv.add_child(weapon_cond)
	ammo_label = UIKit.label("", 13, UITheme.TEXT_DIM)
	wv.add_child(ammo_label)
	wh2.add_child(wv)
	wb.add_child(weapon_card)
	slots = UIKit.hbox(6)
	slots.alignment = BoxContainer.ALIGNMENT_END
	for i in 4:
		var sl := _hud_card(4)
		sl.custom_minimum_size = Vector2(62, 62)
		var inner := Control.new()
		inner.custom_minimum_size = Vector2(54, 54)
		inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var ic := UIGlyph.new()
		ic.position = Vector2(9, 5)
		ic.size = Vector2(36, 36)
		inner.add_child(ic)
		var kc := UIKit.keycap(str(i + 1), 11)
		kc.position = Vector2(-2, -2)
		inner.add_child(kc)
		var cnt := UIKit.label("", 12, UITheme.TEXT, HORIZONTAL_ALIGNMENT_RIGHT)
		cnt.position = Vector2(4, 38)
		cnt.size = Vector2(48, 16)
		inner.add_child(cnt)
		sl.add_child(inner)
		slots.add_child(sl)
		slot_icons.append(ic)
		slot_counts.append(cnt)
	wb.add_child(slots)
	add_child(wb)
	# ---- veículo
	vehicle_box = UIKit.vbox(4)
	_anchor(vehicle_box, Control.PRESET_BOTTOM_RIGHT, Vector2(-330, -230))
	vehicle_box.custom_minimum_size = Vector2(300, 0)
	vehicle_label = UIKit.label("", 30, UITheme.TEXT, HORIZONTAL_ALIGNMENT_RIGHT)
	vehicle_box.add_child(vehicle_label)
	var fh := UIKit.hbox(6)
	fh.alignment = BoxContainer.ALIGNMENT_END
	fh.add_child(UIGlyph.make("jerrycan", 16, Color(0.85, 0.7, 0.2)))
	fuel_bar = UIKit.bar(Color(0.85, 0.7, 0.2), 1.0)
	fuel_bar.custom_minimum_size = Vector2(150, 7)
	fuel_bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	fh.add_child(fuel_bar)
	vehicle_box.add_child(fh)
	vehicle_box.visible = false
	add_child(vehicle_box)
	# ---- legendas
	subtitle_panel = PanelContainer.new()
	subtitle_panel.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	subtitle_panel.position = Vector2(-460, -200)
	subtitle_panel.custom_minimum_size = Vector2(920, 0)
	subtitle_label = RichTextLabel.new()
	subtitle_label.bbcode_enabled = true
	subtitle_label.fit_content = true
	subtitle_label.scroll_active = false
	subtitle_label.custom_minimum_size = Vector2(890, 0)
	subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	subtitle_panel.add_child(subtitle_label)
	subtitle_panel.visible = false
	subtitle_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(subtitle_panel)
	# ---- itens por perto (direita, meio da tela)
	nearby = HUDNearby.new()
	nearby.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
	nearby.position = Vector2(-322, -150)
	add_child(nearby)
	# ---- notificações
	toasts = UIKit.vbox(6)
	toasts.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	toasts.position = Vector2(20, -40)
	toasts.custom_minimum_size = Vector2(420, 0)
	add_child(toasts)
	# ---- banner
	var bn := UIKit.vbox(2)
	bn.set_anchors_preset(Control.PRESET_CENTER_TOP)
	bn.position = Vector2(-400, 150)
	bn.custom_minimum_size = Vector2(800, 0)
	banner = UIKit.label("", 40, UITheme.ACCENT, HORIZONTAL_ALIGNMENT_CENTER)
	banner.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	banner.add_theme_constant_override("outline_size", 8)
	banner_sub = UIKit.label("", 18, UITheme.TEXT, HORIZONTAL_ALIGNMENT_CENTER)
	bn.add_child(banner)
	bn.add_child(banner_sub)
	bn.modulate.a = 0.0
	bn.name = "Banner"
	add_child(bn)
	_refresh_menu_keys()


## Botão clicável do HUD (Mochila/Diário/Mapa): ícone + nome + tecla.
func _menu_button(glyph: String, text: String, action: String) -> Button:
	var b := Button.new()
	b.custom_minimum_size = Vector2(74, 70)
	b.focus_mode = Control.FOCUS_NONE
	b.tooltip_text = text
	b.mouse_filter = Control.MOUSE_FILTER_STOP
	b.add_theme_stylebox_override("normal", UITheme.box(HUD_BG, Color(1, 1, 1, 0.1), 1, 8))
	b.add_theme_stylebox_override("hover", UITheme.box(Color(0.16, 0.14, 0.1, 0.85), UITheme.ACCENT, 1, 8))
	b.add_theme_stylebox_override("pressed", UITheme.box(Color(0.24, 0.2, 0.12, 0.9), UITheme.ACCENT, 2, 8))
	var g := UIGlyph.make(glyph, 30, UITheme.TEXT)
	g.position = Vector2(22, 6)
	g.size = Vector2(30, 30)
	b.add_child(g)
	var l := UIKit.label(text, 12, UITheme.TEXT, HORIZONTAL_ALIGNMENT_CENTER)
	l.position = Vector2(0, 36)
	l.size = Vector2(74, 16)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(l)
	var k := UIKit.label("", 11, UITheme.ACCENT, HORIZONTAL_ALIGNMENT_CENTER)
	k.name = "Key"
	k.position = Vector2(0, 52)
	k.size = Vector2(74, 14)
	k.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(k)
	b.set_meta("action", action)
	b.pressed.connect(func() -> void:
		AudioManager.play_ui("ui_click", -8.0)
		EventBus.hud_menu_requested.emit(action))
	return b


func _refresh_menu_keys() -> void:
	for b in menu_bar.get_children():
		var k := b.get_node("Key") as Label
		k.text = "[%s]" % InputSetup.key_text(str(b.get_meta("action")))
	cursor_hint.text = "Segure %s para usar o mouse" % InputSetup.key_text("free_cursor")


# ---------------------------------------------------------------------------
# Atualização
# ---------------------------------------------------------------------------
func _process(delta: float) -> void:
	_damage_flash = maxf(0.0, _damage_flash - delta * 1.2)
	_sub_t -= delta
	if _sub_t <= 0.0 and subtitle_panel.visible:
		subtitle_panel.visible = false
	_banner_t -= delta
	var bn := get_node("Banner") as Control
	bn.modulate.a = clampf(minf(_banner_t, 5.5 - _banner_t) * 1.2, 0.0, 1.0) if _banner_t > 0.0 else 0.0
	if fps_label.visible:
		fps_label.text = "%d FPS · %.1f ms" % [Engine.get_frames_per_second(), 1000.0 / maxf(Engine.get_frames_per_second(), 1.0)]
	if player == null or not is_instance_valid(player):
		return
	var s := player.survival
	var cinematic := player.cinematic
	var show := _visible_user and not cinematic
	nearby.tick(delta, show and player.in_vehicle == null)
	for c in [vitals, compass, clock_card, stealth_card.get_parent(), weapon_card.get_parent(), crosshair]:
		(c as CanvasItem).visible = show
	vehicle_box.visible = show and player.in_vehicle is Vehicle
	weapon_card.get_parent().visible = show and player.in_vehicle == null
	if not show:
		prompt_box.visible = false
		objective_card.visible = false
		hold_bar.visible = false
		_vign_mat.set_shader_parameter("damage", 0.0)
		return
	# vitais: somem quando tudo está bem e sem ação
	var calm := s.health > 80.0 and s.stamina > 95.0 and s.hunger > 30.0 and s.thirst > 30.0 and s.energy > 25.0 and not player.sprinting
	_idle_t = _idle_t + delta if calm else 0.0
	_fade_hud = move_toward(_fade_hud, 0.35 if _idle_t > 6.0 else 1.0, delta * 1.5)
	vitals.modulate.a = _fade_hud
	menu_bar.modulate.a = maxf(_fade_hud, 0.6) if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else 1.0
	cursor_hint.visible = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and _fade_hud > 0.9
	var vals := {"health": s.health, "stamina": s.stamina / maxf(s.max_stamina(), 1.0) * 100.0, "hunger": s.hunger, "thirst": s.thirst, "energy": s.energy}
	for k in vals.keys():
		(bars[k] as ProgressBar).value = vals[k]
		var vl := values[k] as Label
		vl.text = "%d" % int(vals[k])
		vl.add_theme_color_override("font_color", UITheme.DANGER if float(vals[k]) < 25.0 else UITheme.TEXT)
	var tl := bars["temp"] as Label
	tl.text = "%.1f °C" % s.body_temp
	var tcol := UITheme.INFO if s.body_temp < 35.8 else (UITheme.DANGER if s.body_temp > 37.8 else UITheme.TEXT)
	tl.add_theme_color_override("font_color", tcol)
	(bars["temp_icon"] as UIGlyph).color = tcol
	_update_conditions(s)
	# relógio e clima
	clock.text = "Dia %d  ·  %s" % [TimeManager.day, Util.format_time(TimeManager.hour)]
	weather_label.text = "%s  ·  %s" % [TimeManager.period_name(), WeatherManager.state_name()]
	var night := TimeManager.is_night()
	time_icon.glyph = "moon" if night else "sun"
	time_icon.color = Color(0.8, 0.85, 1.0) if night else Color(1.0, 0.85, 0.45)
	var ws := WeatherManager.state
	weather_icon.glyph = ["sun", "cloud", "cloud", "fog", "rain", "rain"][clampi(ws, 0, 5)]
	weather_icon.color = Color(1.0, 0.85, 0.45) if ws == 0 else Color(0.8, 0.82, 0.86)
	# objetivo
	var tracked := MissionManager.tracked
	if tracked != "" and MissionManager.is_active(tracked):
		var o := MissionManager.current_objective(tracked)
		objective_card.visible = true
		objective_title.text = str(MissionDB.get_mission(tracked).get("title", ""))
		objective_text.text = MissionManager.objective_text(tracked, o) if not o.is_empty() else ""
		var tp := MissionManager.tracked_marker()
		if tp != Vector3.INF and bool(Settings.gameplay.get("show_objective_markers", true)):
			objective_dist.text = "%d m" % int(Vector2(tp.x - player.global_position.x, tp.z - player.global_position.z).length())
		else:
			objective_dist.text = ""
	else:
		objective_card.visible = false
	# dica
	hold_bar.visible = _hold_p > 0.01
	hold_bar.value = _hold_p
	if player.current_interactable == null or not is_instance_valid(player.current_interactable):
		if _last_prompt != "" and not _last_prompt.begins_with("Encher"):
			_on_prompt("")
	# furtividade
	(eye as HUDEye).level = player.visibility_level
	(eye as HUDEye).crouched = player.crouching
	(eye as HUDEye).threat = game.director.max_suspicion if game and game.director else 0.0
	eye.queue_redraw()
	noise_bar.value = lerpf(noise_bar.value, clampf(player.noise_level, 0.0, 1.0), 1.0 - exp(-delta * 6.0))
	log_label.text = ("▶ Gravação: " + str(StoryDB.log_def(StoryManager.playing_log).get("title", ""))) if StoryManager.playing_log != "" else ""
	log_label.visible = log_label.text != ""
	# arma
	var w: Dictionary = player.equipment["weapon"]
	if w.is_empty():
		weapon_label.text = "Desarmado"
		weapon_icon.item_id = ""
		weapon_icon.glyph = "glove"
		weapon_cond.visible = false
		ammo_label.text = "Socos"
	else:
		weapon_label.text = ItemDB.item_name(str(w["id"]))
		weapon_icon.item_id = str(w["id"])
		weapon_cond.visible = ItemDB.has_durability(str(w["id"]))
		weapon_cond.value = float(w.get("cond", 1.0))
		var def := ItemDB.get_item(str(w["id"]))
		if def.has("ranged"):
			var ammo: String = def["ranged"]["ammo"]
			ammo_label.text = "%s: %d" % [ItemDB.item_name(ammo), player.inventory.count(ammo)]
		else:
			ammo_label.text = "Condição %d%%" % int(float(w.get("cond", 1.0)) * 100.0) if weapon_cond.visible else ""
	for i in 4:
		var id: String = player.quick_slots[i]
		var ic := slot_icons[i] as UIGlyph
		var cnt := slot_counts[i] as Label
		if id != "":
			var n := player.inventory.count(id)
			ic.item_id = id
			ic.dim = n <= 0
			cnt.text = "×%d" % n
			(slots.get_child(i) as Control).tooltip_text = ItemDB.item_name(id)
		else:
			ic.item_id = ""
			ic.glyph = ""
			cnt.text = ""
	(crosshair as HUDCrosshair).active = player.aiming
	crosshair.queue_redraw()
	# veículo
	if player.in_vehicle is Vehicle:
		var hi: Dictionary = (player.in_vehicle as Vehicle).hud_info()
		vehicle_label.text = "%d km/h" % int(hi["speed"])
		fuel_bar.value = float(hi["fuel"]) / maxf(float(hi["fuel_max"]), 1.0)
	# vinheta
	var low := clampf(1.0 - s.health / 35.0, 0.0, 1.0)
	low *= 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.006)
	_vign_mat.set_shader_parameter("damage", _damage_flash)
	_vign_mat.set_shader_parameter("low", low)
	_vign_mat.set_shader_parameter("infection", clampf(s.infection / 100.0, 0.0, 1.0) if s.infection_incubation <= 0.0 else 0.0)
	_vign_mat.set_shader_parameter("cold", clampf((35.8 - s.body_temp) / 2.0, 0.0, 1.0))


func _update_conditions(s: Survival) -> void:
	var conds := s.conditions()
	while cond_box.get_child_count() < conds.size():
		var chip := UIKit.chip("", UITheme.TEXT_DIM, 12)
		cond_box.add_child(chip)
	for i in cond_box.get_child_count():
		var chip := cond_box.get_child(i) as PanelContainer
		if i < conds.size():
			var c: Array = conds[i]
			var col: Color = [Color(0.75, 0.75, 0.72), Color(0.95, 0.75, 0.35), UITheme.DANGER][clampi(int(c[2]), 0, 2)]
			(chip.get_child(0) as Label).text = str(c[1])
			(chip.get_child(0) as Label).add_theme_color_override("font_color", col.lightened(0.2))
			chip.add_theme_stylebox_override("panel", UITheme.box(col * Color(1, 1, 1, 0.2), col * Color(1, 1, 1, 0.8), 1, 9, 8, 2))
			chip.visible = true
		else:
			chip.visible = false


# ---------------------------------------------------------------------------
# Eventos
# ---------------------------------------------------------------------------
func _on_prompt(t: String) -> void:
	_last_prompt = t
	prompt.text = t
	prompt_box.visible = t != ""
	if t != "":
		(prompt_key.get_child(0) as Label).text = InputSetup.key_text("interact")


func _on_subtitle(text: String, speaker: String, duration: float) -> void:
	if not bool(Settings.audio.get("subtitles", true)) and speaker != "":
		return
	subtitle_panel.visible = true
	var col := UITheme.ACCENT.to_html(false)
	subtitle_label.text = ("[center][color=#%s]%s:[/color] %s[/center]" % [col, speaker, text]) if speaker != "" else "[center][i]%s[/i][/center]" % text
	_sub_t = duration


func _on_notify(text: String, kind: String) -> void:
	if kind == "chapter":
		return
	var colors := {"good": UITheme.GOOD, "warn": UITheme.DANGER, "danger": UITheme.DANGER, "mission": UITheme.ACCENT, "save": UITheme.TEXT_DIM,
		"faction": Color(0.7, 0.65, 0.9), "event": Color(0.95, 0.6, 0.3), "info": UITheme.TEXT}
	var glyphs := {"good": "check", "warn": "bolt", "danger": "bolt", "mission": "star", "save": "document", "faction": "flag", "event": "eye", "info": "target"}
	var col: Color = colors.get(kind, UITheme.TEXT)
	var p := _hud_card(10, col)
	var h := UIKit.hbox(10)
	p.add_child(h)
	var g := UIGlyph.make(str(glyphs.get(kind, "target")), 18, col)
	g.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(g)
	var l := UIKit.label(text, 15, col.lerp(UITheme.TEXT, 0.35))
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size = Vector2(360, 0)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.7))
	l.add_theme_constant_override("outline_size", 3)
	h.add_child(l)
	toasts.add_child(p)
	while toasts.get_child_count() > 6:
		toasts.get_child(0).queue_free()
		toasts.remove_child(toasts.get_child(0))
	p.modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(p, "modulate:a", 1.0, 0.2)
	tw.tween_interval(4.5)
	tw.tween_property(p, "modulate:a", 0.0, 0.8)
	tw.tween_callback(p.queue_free)
	_idle_t = 0.0


func show_banner(title: String, sub: String = "", dur: float = 5.5) -> void:
	banner.text = title
	banner_sub.text = sub
	_banner_t = dur


func _on_chapter(c: int) -> void:
	var info: Dictionary = StoryDB.CHAPTERS.get(c, {})
	show_banner("CAPÍTULO %d — %s" % [c, info.get("title", "")], str(info.get("sub", "")))
	AudioManager.play_2d("stinger", -6.0, 0.8, "Music")


func _on_discovered(id: String) -> void:
	if game and game.world and game.world.layout.pois.has(id):
		var p: Dictionary = game.world.layout.pois[id]
		show_banner(str(p["name"]).to_upper(), WorldLayout.district_name(game.world.district_at(p["pos"])), 4.0)
