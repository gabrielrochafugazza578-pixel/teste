class_name HUD
extends Control
## HUD diegético-minimalista: some quando parado e sem ameaça, reaparece com
## dano/eventos. Vitais, condições, bússola com objetivo, relógio, objetivo
## atual, prompt de interação com progresso, furtividade/ruído, arma e
## atalhos, veículo, legendas, notificações, banners e vinhetas.

var player: Player = null
var game: Node = null
var vitals: VBoxContainer
var bars: Dictionary = {}
var cond_box: VBoxContainer
var compass: Control
var clock: Label
var objective_title: Label
var objective_text: Label
var prompt: Label
var hold_bar: ProgressBar
var eye: Control
var noise_bar: ProgressBar
var weapon_label: Label
var weapon_cond: ProgressBar
var ammo_label: Label
var slots: HBoxContainer
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

var _sub_t: float = 0.0
var _banner_t: float = 0.0
var _damage_flash: float = 0.0
var _fade_hud: float = 1.0
var _idle_t: float = 0.0
var _visible_user: bool = true
var _hold_p: float = 0.0
var _vign_mat: ShaderMaterial

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


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()
	EventBus.subtitle.connect(_on_subtitle)
	EventBus.notify.connect(_on_notify)
	EventBus.interaction_prompt.connect(func(t: String) -> void: prompt.text = t)
	EventBus.chapter_started.connect(_on_chapter)
	EventBus.location_discovered.connect(_on_discovered)
	EventBus.player_damaged.connect(func(a: float, _s: Node) -> void:
		_damage_flash = minf(1.0, _damage_flash + a / 25.0)
		_idle_t = 0.0)
	EventBus.hud_visibility.connect(func(v: bool) -> void: _visible_user = v)
	EventBus.mission_updated.connect(func(_id: String) -> void: _idle_t = 0.0)
	EventBus.settings_changed.connect(_apply_settings)
	_apply_settings()


func bind(p: Player, g: Node) -> void:
	player = p
	game = g
	p.interact_hold_progress.connect(func(v: float) -> void: _hold_p = v)


func _apply_settings() -> void:
	var sizes := [18, 22, 27, 34]
	if subtitle_label:
		subtitle_label.add_theme_font_size_override("normal_font_size", sizes[clampi(int(Settings.accessibility.get("subtitle_size", 1)), 0, 3)])
		subtitle_label.add_theme_font_size_override("bold_font_size", sizes[clampi(int(Settings.accessibility.get("subtitle_size", 1)), 0, 3)])
	if subtitle_panel:
		var bg_on := bool(Settings.accessibility.get("subtitle_background", true))
		subtitle_panel.add_theme_stylebox_override("panel", UITheme.box(Color(0, 0, 0, 0.62 if bg_on else 0.0), Color(0, 0, 0, 0), 0, 4, 14))
	if fps_label:
		fps_label.visible = bool(Settings.graphics.get("show_fps", false))


# ---------------------------------------------------------------------------
# Construção
# ---------------------------------------------------------------------------
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
	# vitais (canto superior esquerdo)
	vitals = UIKit.vbox(4)
	vitals.position = Vector2(26, 24)
	add_child(vitals)
	for pair: Array in [["health", "Saúde", Color(0.78, 0.2, 0.18)], ["stamina", "Fôlego", Color(0.85, 0.82, 0.7)],
			["hunger", "Fome", Color(0.85, 0.6, 0.25)], ["thirst", "Sede", Color(0.3, 0.6, 0.9)], ["energy", "Energia", Color(0.6, 0.5, 0.85)]]:
		var h := UIKit.hbox(8)
		var l := UIKit.label(pair[1], 13, UITheme.TEXT_DIM)
		l.custom_minimum_size = Vector2(62, 0)
		h.add_child(l)
		var b := UIKit.bar(pair[2])
		b.custom_minimum_size = Vector2(170 if pair[0] == "health" else 130, 9 if pair[0] == "health" else 6)
		b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(b)
		vitals.add_child(h)
		bars[pair[0]] = b
	var th := UIKit.hbox(8)
	var tl := UIKit.label("Temp.", 13, UITheme.TEXT_DIM)
	tl.custom_minimum_size = Vector2(62, 0)
	th.add_child(tl)
	var tv := UIKit.label("36.6 °C", 13)
	th.add_child(tv)
	bars["temp"] = tv
	vitals.add_child(th)
	cond_box = UIKit.vbox(2)
	vitals.add_child(UIKit.spacer(4))
	vitals.add_child(cond_box)
	# bússola
	compass = HUDCompass.new()
	compass.hud = self
	compass.set_anchors_preset(Control.PRESET_CENTER_TOP)
	compass.custom_minimum_size = Vector2(620, 36)
	compass.size = Vector2(620, 36)
	compass.position = Vector2(-310, 16)
	add_child(compass)
	# relógio (superior direito)
	clock = UIKit.label("", 15, UITheme.TEXT_DIM, HORIZONTAL_ALIGNMENT_RIGHT)
	clock.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	clock.position = Vector2(-330, 22)
	clock.custom_minimum_size = Vector2(300, 0)
	add_child(clock)
	fps_label = UIKit.label("", 13, UITheme.GOOD, HORIZONTAL_ALIGNMENT_RIGHT)
	fps_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	fps_label.position = Vector2(-330, 4)
	fps_label.custom_minimum_size = Vector2(300, 0)
	add_child(fps_label)
	# objetivo (direita)
	var ob := UIKit.vbox(2)
	ob.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	ob.position = Vector2(-430, 64)
	ob.custom_minimum_size = Vector2(400, 0)
	objective_title = UIKit.label("", 16, UITheme.ACCENT, HORIZONTAL_ALIGNMENT_RIGHT)
	objective_text = UIKit.label("", 15, UITheme.TEXT, HORIZONTAL_ALIGNMENT_RIGHT)
	objective_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	objective_text.custom_minimum_size = Vector2(400, 0)
	ob.add_child(objective_title)
	ob.add_child(objective_text)
	add_child(ob)
	# prompt de interação
	var pc := UIKit.vbox(4)
	pc.set_anchors_preset(Control.PRESET_CENTER)
	pc.position = Vector2(-250, 80)
	pc.custom_minimum_size = Vector2(500, 0)
	prompt = UIKit.label("", 18, UITheme.TEXT, HORIZONTAL_ALIGNMENT_CENTER)
	prompt.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	prompt.add_theme_constant_override("outline_size", 6)
	pc.add_child(prompt)
	hold_bar = UIKit.bar(UITheme.ACCENT, 1.0)
	hold_bar.custom_minimum_size = Vector2(160, 4)
	hold_bar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	pc.add_child(hold_bar)
	add_child(pc)
	# mira
	crosshair = HUDCrosshair.new()
	crosshair.set_anchors_preset(Control.PRESET_CENTER)
	crosshair.position = Vector2(-10, -10)
	crosshair.size = Vector2(20, 20)
	add_child(crosshair)
	# furtividade / ruído (inferior esquerdo)
	var st := UIKit.vbox(4)
	st.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	st.position = Vector2(26, -118)
	eye = HUDEye.new()
	eye.custom_minimum_size = Vector2(46, 26)
	st.add_child(eye)
	var nh := UIKit.hbox(6)
	nh.add_child(UIKit.label("Ruído", 12, UITheme.TEXT_DIM))
	noise_bar = UIKit.bar(Color(0.8, 0.8, 0.75), 1.0)
	noise_bar.custom_minimum_size = Vector2(90, 4)
	noise_bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	nh.add_child(noise_bar)
	st.add_child(nh)
	log_label = UIKit.label("", 14, Color(0.75, 0.6, 0.9))
	st.add_child(log_label)
	add_child(st)
	# arma e atalhos (inferior direito)
	var wb := UIKit.vbox(4)
	wb.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	wb.position = Vector2(-330, -128)
	wb.custom_minimum_size = Vector2(300, 0)
	weapon_label = UIKit.label("", 17, UITheme.TEXT, HORIZONTAL_ALIGNMENT_RIGHT)
	wb.add_child(weapon_label)
	weapon_cond = UIKit.bar(UITheme.ACCENT, 1.0)
	weapon_cond.custom_minimum_size = Vector2(140, 4)
	weapon_cond.size_flags_horizontal = Control.SIZE_SHRINK_END
	wb.add_child(weapon_cond)
	ammo_label = UIKit.label("", 14, UITheme.TEXT_DIM, HORIZONTAL_ALIGNMENT_RIGHT)
	wb.add_child(ammo_label)
	slots = UIKit.hbox(6)
	slots.alignment = BoxContainer.ALIGNMENT_END
	for i in 4:
		var sl := UIKit.panel(6)
		sl.custom_minimum_size = Vector2(66, 44)
		var l := UIKit.label("%d\n" % (i + 1), 11, UITheme.TEXT_DIM, HORIZONTAL_ALIGNMENT_CENTER)
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		sl.add_child(l)
		slots.add_child(sl)
	wb.add_child(slots)
	add_child(wb)
	# veículo
	vehicle_box = UIKit.vbox(4)
	vehicle_box.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	vehicle_box.position = Vector2(-330, -200)
	vehicle_box.custom_minimum_size = Vector2(300, 0)
	vehicle_label = UIKit.label("", 28, UITheme.TEXT, HORIZONTAL_ALIGNMENT_RIGHT)
	vehicle_box.add_child(vehicle_label)
	var fh := UIKit.hbox(6)
	fh.alignment = BoxContainer.ALIGNMENT_END
	fh.add_child(UIKit.label("Combustível", 12, UITheme.TEXT_DIM))
	fuel_bar = UIKit.bar(Color(0.85, 0.7, 0.2), 1.0)
	fuel_bar.custom_minimum_size = Vector2(140, 6)
	fuel_bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	fh.add_child(fuel_bar)
	vehicle_box.add_child(fh)
	vehicle_box.visible = false
	add_child(vehicle_box)
	# legendas
	subtitle_panel = PanelContainer.new()
	subtitle_panel.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	subtitle_panel.position = Vector2(-460, -190)
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
	# notificações
	toasts = UIKit.vbox(4)
	toasts.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	toasts.position = Vector2(26, -40)
	toasts.custom_minimum_size = Vector2(420, 0)
	add_child(toasts)
	# banner
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
	for c in [vitals, compass, clock, objective_title, objective_text, eye.get_parent(), weapon_label.get_parent(), crosshair]:
		(c as CanvasItem).visible = show
	vehicle_box.visible = show and player.in_vehicle is Vehicle
	weapon_label.get_parent().visible = show and player.in_vehicle == null
	if not show:
		prompt.text = ""
		hold_bar.visible = false
		_vign_mat.set_shader_parameter("damage", 0.0)
		return
	# vitais: somem quando tudo está bem e sem ação
	var calm := s.health > 80.0 and s.stamina > 95.0 and s.hunger > 30.0 and s.thirst > 30.0 and s.energy > 25.0 and not player.sprinting
	_idle_t = _idle_t + delta if calm else 0.0
	_fade_hud = move_toward(_fade_hud, 0.35 if _idle_t > 6.0 else 1.0, delta * 1.5)
	vitals.modulate.a = _fade_hud
	(bars["health"] as ProgressBar).value = s.health
	(bars["stamina"] as ProgressBar).value = s.stamina / maxf(s.max_stamina(), 1.0) * 100.0
	(bars["hunger"] as ProgressBar).value = s.hunger
	(bars["thirst"] as ProgressBar).value = s.thirst
	(bars["energy"] as ProgressBar).value = s.energy
	var tl := bars["temp"] as Label
	tl.text = "%.1f °C" % s.body_temp
	tl.add_theme_color_override("font_color", UITheme.INFO if s.body_temp < 35.8 else (UITheme.DANGER if s.body_temp > 37.8 else UITheme.TEXT))
	_update_conditions(s)
	# relógio
	clock.text = "Dia %d · %s · %s\n%s" % [TimeManager.day, Util.format_time(TimeManager.hour), TimeManager.period_name(), WeatherManager.state_name()]
	# objetivo
	var tracked := MissionManager.tracked
	if tracked != "" and MissionManager.is_active(tracked):
		var o := MissionManager.current_objective(tracked)
		objective_title.text = str(MissionDB.get_mission(tracked).get("title", ""))
		var txt := MissionManager.objective_text(tracked, o) if not o.is_empty() else ""
		var tp := MissionManager.tracked_marker()
		if tp != Vector3.INF and bool(Settings.gameplay.get("show_objective_markers", true)):
			txt += "  (%d m)" % int(Vector2(tp.x - player.global_position.x, tp.z - player.global_position.z).length())
		objective_text.text = txt
	else:
		objective_title.text = ""
		objective_text.text = ""
	# prompt
	hold_bar.visible = _hold_p > 0.01
	hold_bar.value = _hold_p
	if player.current_interactable == null or not is_instance_valid(player.current_interactable):
		prompt.text = ""
	# furtividade
	(eye as HUDEye).level = player.visibility_level
	(eye as HUDEye).crouched = player.crouching
	(eye as HUDEye).threat = game.director.max_suspicion if game and game.director else 0.0
	eye.queue_redraw()
	noise_bar.value = lerpf(noise_bar.value, clampf(player.noise_level, 0.0, 1.0), 1.0 - exp(-delta * 6.0))
	log_label.text = ("▶ Gravação: " + str(StoryDB.log_def(StoryManager.playing_log).get("title", ""))) if StoryManager.playing_log != "" else ""
	# arma
	var w: Dictionary = player.equipment["weapon"]
	if w.is_empty():
		weapon_label.text = "Desarmado"
		weapon_cond.visible = false
		ammo_label.text = ""
	else:
		weapon_label.text = ItemDB.item_name(str(w["id"]))
		weapon_cond.visible = ItemDB.has_durability(str(w["id"]))
		weapon_cond.value = float(w.get("cond", 1.0))
		var def := ItemDB.get_item(str(w["id"]))
		if def.has("ranged"):
			var ammo: String = def["ranged"]["ammo"]
			ammo_label.text = "%s: %d" % [ItemDB.item_name(ammo), player.inventory.count(ammo)]
		else:
			ammo_label.text = ""
	for i in 4:
		var id: String = player.quick_slots[i]
		var l := (slots.get_child(i) as PanelContainer).get_child(0) as Label
		l.text = "%d\n%s" % [i + 1, (ItemDB.item_name(id).substr(0, 14) + (" ×%d" % player.inventory.count(id))) if id != "" else ""]
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
		cond_box.add_child(UIKit.label("", 13))
	for i in cond_box.get_child_count():
		var l := cond_box.get_child(i) as Label
		if i < conds.size():
			var c: Array = conds[i]
			l.text = "• " + str(c[1])
			l.add_theme_color_override("font_color", [UITheme.TEXT_DIM, Color(0.95, 0.75, 0.35), UITheme.DANGER][clampi(int(c[2]), 0, 2)])
			l.visible = true
		else:
			l.visible = false


# ---------------------------------------------------------------------------
# Eventos
# ---------------------------------------------------------------------------
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
	var colors := {"good": UITheme.GOOD, "warn": UITheme.DANGER, "mission": UITheme.ACCENT, "save": UITheme.TEXT_DIM,
		"faction": Color(0.7, 0.65, 0.9), "event": Color(0.95, 0.6, 0.3), "info": UITheme.TEXT}
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UITheme.box(Color(0, 0, 0, 0.55), Color(0, 0, 0, 0), 0, 3, 10))
	var l := UIKit.label(text, 15, colors.get(kind, UITheme.TEXT))
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size = Vector2(400, 0)
	p.add_child(l)
	toasts.add_child(p)
	while toasts.get_child_count() > 6:
		toasts.get_child(0).queue_free()
		toasts.remove_child(toasts.get_child(0))
	var tw := create_tween()
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
