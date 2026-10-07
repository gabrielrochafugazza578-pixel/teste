class_name MainMenu
extends Control
## Menu principal: Novo Jogo, Continuar, Carregar, Configurações (Gráficos,
## Áudio, Controles, Acessibilidade), Créditos e Sair. Fundo: cena 3D ao vivo
## (MenuScene — apartamento abandonado ao entardecer, sol entrando pela janela,
## o Caio sentado no chão), com a coluna de texto escurecida à esquerda, vinheta
## e grão de filme. Itens só em texto, sem caixas.
## O shader antigo (silhueta da cidade) fica de reserva se a cena 3D falhar.

const BG_SHADER := """
shader_type canvas_item;
uniform float t = 0.0;
float h(vec2 p){ return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
float n(vec2 p){ vec2 i = floor(p); vec2 f = fract(p); f = f*f*(3.0-2.0*f);
	return mix(mix(h(i), h(i+vec2(1,0)), f.x), mix(h(i+vec2(0,1)), h(i+vec2(1,1)), f.x), f.y); }
float fbm(vec2 p){ float v = 0.0; float a = 0.5; for (int i = 0; i < 5; i++){ v += a*n(p); p *= 2.03; a *= 0.5; } return v; }
void fragment(){
	vec2 uv = UV;
	float sky = smoothstep(1.0, 0.0, uv.y);
	vec3 col = mix(vec3(0.015, 0.017, 0.022), vec3(0.09, 0.07, 0.06), pow(sky, 3.0));
	// silhueta da cidade (prédios)
	float x = uv.x * 38.0;
	float bh = 0.18 + 0.22 * h(vec2(floor(x), 3.0)) + 0.1 * h(vec2(floor(x * 0.5), 9.0));
	float city = step(1.0 - uv.y, bh * 0.9);
	// janelas raras acesas
	vec2 wcell = floor(vec2(uv.x * 260.0, uv.y * 140.0));
	float win = step(0.985, h(wcell)) * city * step(0.25, 1.0 - uv.y) * (0.6 + 0.4 * sin(t * 0.7 + h(wcell) * 30.0));
	col = mix(col, vec3(0.012, 0.012, 0.014), city);
	col += vec3(0.9, 0.55, 0.25) * win * 0.35;
	// fumaça e neblina
	float fog = fbm(vec2(uv.x * 3.0 + t * 0.02, uv.y * 4.0 - t * 0.015));
	col += vec3(0.11, 0.1, 0.09) * fog * smoothstep(0.2, 0.9, uv.y) * 0.8;
	// clarão de incêndios no horizonte, atrás dos prédios
	float glow = exp(-abs((1.0 - uv.y) - 0.34) * 9.0) * (0.55 + 0.45 * fbm(vec2(uv.x * 5.0, t * 0.08)));
	col += vec3(0.28, 0.1, 0.03) * glow * (1.0 - city * 0.85);
	// brasas subindo: pontos pequenos e suaves (não quadrados), com deriva lateral
	vec2 ep = vec2(uv.x * 48.0 * (16.0 / 9.0), uv.y * 48.0 + t * 0.9);
	vec2 cell = floor(ep);
	float r = h(cell);
	vec2 c = vec2(0.5 + 0.35 * sin(t * 0.6 + r * 40.0), 0.5);
	float d = length(fract(ep) - c);
	float emb = step(0.975, r) * smoothstep(0.09, 0.0, d) * smoothstep(0.35, 1.0, uv.y) * (0.5 + 0.5 * sin(t * 3.0 + r * 60.0));
	col += vec3(1.0, 0.5, 0.18) * emb * 0.9;
	// vinheta
	float vig = smoothstep(1.2, 0.35, length(uv - vec2(0.5, 0.55)));
	COLOR = vec4(col * vig, 1.0);
}
"""

# por cima da cena 3D: escurece a coluna do menu, vinheta, barras de cinema e grão
const OVERLAY_SHADER := """
shader_type canvas_item;
uniform float t = 0.0;
float h(vec2 p){ return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
void fragment(){
	vec2 uv = UV;
	// coluna do texto: escurece da esquerda, mais embaixo (onde ficam os itens)
	float left = smoothstep(0.55, 0.0, uv.x) * mix(0.55, 0.85, smoothstep(0.2, 0.9, uv.y));
	float a = left;
	float vig = smoothstep(0.5, 1.3, length((uv - vec2(0.56, 0.48)) * vec2(1.2, 1.0)));
	a = max(a, vig * 0.75);
	vec3 col = vec3(0.012, 0.01, 0.008);
	float grain = (h(uv * vec2(1920.0, 1080.0) + fract(t * 23.0) * 91.0) - 0.5) * 0.05;
	COLOR = vec4(col + grain, clamp(a + abs(grain) * 0.4, 0.0, 1.0));
}
"""

var _bg_mat: ShaderMaterial
var _ov_mat: ShaderMaterial
var _scene: MenuScene
var _t: float = 0.0
var _buttons: VBoxContainer
var _sub: Control = null


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	UITheme.apply_scale(get_tree())
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GameState.in_game = false
	var bg := ColorRect.new()
	UIKit.full_rect(bg)
	var sh := Shader.new()
	sh.code = BG_SHADER
	_bg_mat = ShaderMaterial.new()
	_bg_mat.shader = sh
	bg.material = _bg_mat
	add_child(bg)
	if not "--menu-2d" in OS.get_cmdline_user_args():
		_scene = MenuScene.new()
		add_child(_scene)
		bg.visible = false
	var ov := ColorRect.new()
	UIKit.full_rect(ov)
	ov.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var osh := Shader.new()
	osh.code = OVERLAY_SHADER
	_ov_mat = ShaderMaterial.new()
	_ov_mat.shader = osh
	ov.material = _ov_mat
	add_child(ov)
	var root := MarginContainer.new()
	UIKit.full_rect(root)
	root.add_theme_constant_override("margin_left", 118)
	root.add_theme_constant_override("margin_top", 96)
	root.add_theme_constant_override("margin_bottom", 92)
	add_child(root)
	var v := UIKit.vbox(0)
	v.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	root.add_child(v)
	# título: letras espaçadas e finas em cima, o "DO FIM" grande e pesado
	var f_thin := FontVariation.new()
	f_thin.base_font = get_theme_default_font()
	f_thin.spacing_glyph = 16
	var f_big := FontVariation.new()
	f_big.base_font = get_theme_default_font()
	f_big.spacing_glyph = 4
	f_big.variation_embolden = 0.55
	var t1 := UIKit.label("O INÍCIO", 28, Color(0.88, 0.85, 0.8, 0.92))
	t1.add_theme_font_override("font", f_thin)
	var t2 := UIKit.label("DO FIM", 124, Color(0.96, 0.94, 0.9))
	t2.add_theme_font_override("font", f_big)
	t2.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.6))
	t2.add_theme_constant_override("shadow_offset_x", 0)
	t2.add_theme_constant_override("shadow_offset_y", 6)
	t2.add_theme_constant_override("shadow_outline_size", 18)
	t2.add_theme_constant_override("line_spacing", -18)
	v.add_child(t1)
	v.add_child(t2)
	var rule := ColorRect.new()
	rule.color = UITheme.ACCENT
	rule.custom_minimum_size = Vector2(64, 2)
	rule.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	v.add_child(rule)
	v.add_child(UIKit.spacer(16))
	var sub := UIKit.label("Santa Aurora. Três semanas depois do surto.", 17, Color(0.8, 0.76, 0.7, 0.85))
	sub.add_theme_font_override("font", f_thin)
	sub.add_theme_constant_override("outline_size", 0)
	var fs := FontVariation.new()
	fs.base_font = get_theme_default_font()
	fs.spacing_glyph = 2
	sub.add_theme_font_override("font", fs)
	v.add_child(sub)
	var gap := Control.new()
	gap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(gap)
	_buttons = UIKit.vbox(2)
	_buttons.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	v.add_child(_buttons)
	var latest := SaveManager.latest_slot()
	if latest != "":
		var meta := SaveManager.read_meta(latest)
		_buttons.add_child(_item("Continuar", func() -> void: _continue(latest)))
		var info := UIKit.label("Capítulo %d · Dia %d · %s" % [int(meta.get("chapter", 1)), int(meta.get("day", 1)), str(meta.get("location", ""))], 14, Color(0.7, 0.66, 0.6, 0.8))
		info.add_theme_constant_override("outline_size", 0)
		var im := MarginContainer.new()
		im.add_theme_constant_override("margin_left", 24)
		im.add_theme_constant_override("margin_bottom", 10)
		im.add_child(info)
		_buttons.add_child(im)
	_buttons.add_child(_item("Novo Jogo", _new_game))
	_buttons.add_child(_item("Carregar", _open_load))
	_buttons.add_child(_item("Configurações", _open_settings))
	_buttons.add_child(_item("Créditos", _open_credits))
	_buttons.add_child(_item("Sair", func() -> void: get_tree().quit()))
	v.add_child(UIKit.spacer(26))
	var hint := UIKit.label("Enter  selecionar      Esc  voltar", 13, Color(0.62, 0.6, 0.56, 0.7))
	hint.add_theme_constant_override("outline_size", 0)
	var hm := MarginContainer.new()
	hm.add_theme_constant_override("margin_left", 24)
	hm.add_child(hint)
	v.add_child(hm)
	var rend := "Forward+ (Vulkan)" if Settings.is_forward_plus() else "Compatibility (OpenGL 3.3)"
	var ver := UIKit.label("v%s · Godot %s · %s" % [ProjectSettings.get_setting("application/config/version", "0.9"), Engine.get_version_info()["string"], rend], 13, Color(0.55, 0.53, 0.5))
	add_child(ver)
	ver.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT, Control.PRESET_MODE_MINSIZE, 18)
	ver.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	ver.grow_vertical = Control.GROW_DIRECTION_BEGIN
	(_buttons.get_child(0) as Control).grab_focus()
	if AudioManager.is_ready:
		AudioManager.music.play_cue("mus_title", 0.8)
	else:
		AudioManager.audio_ready.connect(func() -> void: AudioManager.music.play_cue("mus_title", 0.8), CONNECT_ONE_SHOT)


## Item do menu só em texto: sem caixa; o selecionado acende, entra um pouco
## para a direita e ganha um traço dourado à esquerda.
func _item(text: String, cb: Callable) -> Button:
	var b := UIKit.button(text, cb, 0.0, 30)
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.custom_minimum_size = Vector2(420, 50)
	b.flat = true
	var idle := StyleBoxEmpty.new()
	idle.content_margin_left = 24
	var active := StyleBoxEmpty.new()
	active.content_margin_left = 40
	for st in ["normal", "pressed", "disabled", "hover_pressed"]:
		b.add_theme_stylebox_override(st, idle)
	b.add_theme_stylebox_override("hover", active)
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	b.add_theme_color_override("font_color", Color(0.76, 0.73, 0.68, 0.82))
	b.add_theme_color_override("font_hover_color", Color(1.0, 0.97, 0.9))
	b.add_theme_color_override("font_focus_color", Color(1.0, 0.97, 0.9))
	b.add_theme_color_override("font_pressed_color", UITheme.ACCENT)
	b.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.5))
	b.add_theme_constant_override("outline_size", 4)
	var bar := ColorRect.new()
	bar.color = UITheme.ACCENT
	bar.size = Vector2(22, 2)
	bar.position = Vector2(4, 25)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.visible = false
	b.add_child(bar)
	b.focus_entered.connect(func() -> void:
		bar.visible = true
		b.add_theme_stylebox_override("normal", active))
	b.focus_exited.connect(func() -> void:
		bar.visible = false
		b.add_theme_stylebox_override("normal", idle))
	return b


func _process(delta: float) -> void:
	_t += delta
	_bg_mat.set_shader_parameter("t", _t)
	_ov_mat.set_shader_parameter("t", _t)


func _new_game() -> void:
	if SaveManager.has_slot("auto"):
		_confirm("Começar um novo jogo? O salvamento automático será substituído.", _start_new)
	else:
		_start_new()


func _start_new() -> void:
	GameState.start_mode = "new"
	GameState.skip_opening = false
	GameState.pending_save = {}
	AudioManager.music.stop_cue()
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _continue(slot: String) -> void:
	AudioManager.music.stop_cue()
	SaveManager.load_game(slot)


func _open_load() -> void:
	var m := SaveLoadMenu.new()
	m.mode = "load"
	_open(m)


func _open_settings() -> void:
	_open(SettingsMenu.new())


func _open_credits() -> void:
	var c := CreditsScreen.new()
	_open(c)


func _open(c: Control) -> void:
	if _sub and is_instance_valid(_sub):
		_sub.queue_free()
	_sub = c
	add_child(c)
	c.tree_exited.connect(func() -> void:
		if is_inside_tree() and _buttons.get_child_count() > 0:
			(_buttons.get_child(0) as Control).grab_focus())


func _confirm(text: String, cb: Callable) -> void:
	var d := ConfirmationDialog.new()
	d.dialog_text = text
	d.ok_button_text = "Sim"
	d.cancel_button_text = "Não"
	d.theme = UITheme.get_theme()
	add_child(d)
	d.confirmed.connect(cb)
	d.popup_centered(Vector2i(560, 180))
