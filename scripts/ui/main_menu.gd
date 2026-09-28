class_name MainMenu
extends Control
## Menu principal: Novo Jogo, Continuar, Carregar, Configurações (Gráficos,
## Áudio, Controles, Acessibilidade), Créditos e Sair. Fundo animado leve
## (shader de neblina/brasas) — nada de vídeo pré-renderizado.

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
	// brasas subindo
	vec2 ep = vec2(uv.x * 60.0, uv.y * 30.0 + t * 1.2);
	float emb = step(0.992, h(floor(ep))) * smoothstep(0.3, 1.0, uv.y);
	col += vec3(1.0, 0.45, 0.15) * emb * 0.6;
	// vinheta
	float vig = smoothstep(1.2, 0.35, length(uv - vec2(0.5, 0.55)));
	COLOR = vec4(col * vig, 1.0);
}
"""

var _bg_mat: ShaderMaterial
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
	var root := MarginContainer.new()
	UIKit.full_rect(root)
	root.add_theme_constant_override("margin_left", 110)
	root.add_theme_constant_override("margin_top", 120)
	add_child(root)
	var v := UIKit.vbox(6)
	root.add_child(v)
	var t1 := UIKit.label("O INÍCIO", 64, Color(0.92, 0.9, 0.86))
	var t2 := UIKit.label("DO FIM", 64, UITheme.ACCENT)
	v.add_child(t1)
	v.add_child(t2)
	v.add_child(UIKit.label("Santa Aurora, algumas semanas depois.", 18, UITheme.TEXT_DIM))
	v.add_child(UIKit.spacer(40))
	_buttons = UIKit.vbox(8)
	v.add_child(_buttons)
	var latest := SaveManager.latest_slot()
	if latest != "":
		var meta := SaveManager.read_meta(latest)
		_buttons.add_child(UIKit.button("Continuar", func() -> void: _continue(latest)))
		_buttons.add_child(UIKit.label("   Capítulo %d · Dia %d · %s" % [int(meta.get("chapter", 1)), int(meta.get("day", 1)), str(meta.get("location", ""))], 14, UITheme.TEXT_DIM))
	_buttons.add_child(UIKit.button("Novo Jogo", _new_game))
	_buttons.add_child(UIKit.button("Carregar", _open_load))
	_buttons.add_child(UIKit.button("Configurações", _open_settings))
	_buttons.add_child(UIKit.button("Créditos", _open_credits))
	_buttons.add_child(UIKit.button("Sair", func() -> void: get_tree().quit()))
	var ver := UIKit.label("v%s · Godot %s · Compatibility (OpenGL 3.3)" % [ProjectSettings.get_setting("application/config/version", "0.9"), Engine.get_version_info()["string"]], 13, Color(0.45, 0.45, 0.43))
	ver.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	ver.position = Vector2(-420, -34)
	ver.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	add_child(ver)
	(_buttons.get_child(0) as Control).grab_focus()
	if AudioManager.is_ready:
		AudioManager.music.play_cue("mus_title", 0.8)
	else:
		AudioManager.audio_ready.connect(func() -> void: AudioManager.music.play_cue("mus_title", 0.8), CONNECT_ONE_SHOT)


func _process(delta: float) -> void:
	_t += delta
	_bg_mat.set_shader_parameter("t", _t)


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
