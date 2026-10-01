class_name GameMenu
extends CanvasLayer
## Menus em estilo cartoon: tela inicial, pausa, configuracoes e "desmaiou".

signal play_pressed(world_seed: int)
signal resume_pressed
signal save_menu_pressed
signal save_quit_pressed
signal respawn_pressed
signal settings_changed

enum Screen { NONE, TITLE, PAUSE, SETTINGS, DEATH }

const OUTLINE := Color(0.10, 0.07, 0.15)
const YELLOW := Color(1.0, 0.84, 0.3)

var screen := Screen.NONE
var _back_to := Screen.TITLE
var _dim: ColorRect
var _root: Control
var _title: Label
var _t := 0.0
var _seed_edit: LineEdit
var has_save := false


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	_dim = ColorRect.new()
	_dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_dim)
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.theme = make_theme()
	add_child(_root)
	visible = false


func _process(delta: float) -> void:
	_t += delta
	if _title and is_instance_valid(_title):
		_title.rotation = sin(_t * 1.3) * 0.025
		_title.scale = Vector2.ONE * (1.0 + sin(_t * 2.1) * 0.02)


# ------------------------------------------------------------- telas --

func show_screen(s: Screen) -> void:
	screen = s
	for c in _root.get_children():
		c.queue_free()
	_title = null
	visible = s != Screen.NONE
	match s:
		Screen.TITLE:
			_dim.color = Color(0.05, 0.03, 0.12, 0.25)
			_build_title()
		Screen.PAUSE:
			_dim.color = Color(0.05, 0.03, 0.12, 0.55)
			_build_pause()
		Screen.SETTINGS:
			_dim.color = Color(0.05, 0.03, 0.12, 0.6)
			_build_settings()
		Screen.DEATH:
			_dim.color = Color(0.35, 0.02, 0.08, 0.55)
			_build_death()


func _center_box(width := 520.0) -> VBoxContainer:
	var cc := CenterContainer.new()
	cc.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(cc)
	var vb := VBoxContainer.new()
	vb.custom_minimum_size.x = width
	vb.add_theme_constant_override("separation", 14)
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	cc.add_child(vb)
	return vb


func _big_label(parent: Control, text: String, size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", OUTLINE)
	l.add_theme_constant_override("outline_size", maxi(6, size / 4))
	parent.add_child(l)
	return l


func _button(parent: Control, text: String, cb: Callable, color := YELLOW) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(0, 62)
	parent.add_child(b)
	if color != YELLOW:
		for st in ["normal", "hover", "pressed"]:
			var sb: StyleBoxFlat = b.get_theme_stylebox(st).duplicate()
			sb.bg_color = color if st == "normal" else (color.lightened(0.2) if st == "hover" else color.darkened(0.15))
			b.add_theme_stylebox_override(st, sb)
	b.pressed.connect(cb)
	return b


func _build_title() -> void:
	var vb := _center_box(540)
	_title = _big_label(vb, "TERRA REDONDA", 84, YELLOW)
	_title.pivot_offset = Vector2(270, 50)
	_big_label(vb, "um mundo infinito, redondo e cheio de bichos", 22, Color(1, 1, 1))
	var sp := Control.new()
	sp.custom_minimum_size.y = 16
	vb.add_child(sp)
	_button(vb, "Continuar mundo" if has_save else "Jogar", func(): play_pressed.emit(_read_seed()), Color(0.55, 0.88, 0.35))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	vb.add_child(row)
	var lbl := Label.new()
	lbl.text = "Semente:"
	row.add_child(lbl)
	_seed_edit = LineEdit.new()
	_seed_edit.text = str(Game.world_seed)
	_seed_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_seed_edit.custom_minimum_size = Vector2(0, 52)
	row.add_child(_seed_edit)
	var rnd := Button.new()
	rnd.text = "Novo mundo"
	rnd.custom_minimum_size = Vector2(170, 52)
	rnd.pressed.connect(func(): _seed_edit.text = str(randi() % 999999999))
	row.add_child(rnd)
	_button(vb, "Configurações", func(): _open_settings(Screen.TITLE))
	_button(vb, "Sair", func(): get_tree().quit(), Color(1.0, 0.55, 0.5))
	var help := Label.new()
	help.text = "WASD andar  -  Espaço pular  -  Shift correr  -  Clique esquerdo cavar/bater\nClique direito construir  -  1-0 materiais  -  G modo criativo  -  F11 tela cheia  -  Esc pausa"
	help.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	help.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	help.position = Vector2(-500, -80)
	help.size = Vector2(1000, 60)
	help.add_theme_font_size_override("font_size", 17)
	_root.add_child(help)


func _read_seed() -> int:
	var txt := _seed_edit.text.strip_edges()
	if txt.is_valid_int():
		return int(txt)
	return hash(txt) & 0x7fffffff  # palavras tambem viram semente


func _build_pause() -> void:
	var vb := _center_box(460)
	_big_label(vb, "Pausado", 64, YELLOW)
	_button(vb, "Continuar", func(): resume_pressed.emit(), Color(0.55, 0.88, 0.35))
	_button(vb, "Configurações", func(): _open_settings(Screen.PAUSE))
	_button(vb, "Salvar e voltar ao menu", func(): save_menu_pressed.emit())
	_button(vb, "Salvar e sair", func(): save_quit_pressed.emit(), Color(1.0, 0.55, 0.5))


func _open_settings(back: Screen) -> void:
	_back_to = back
	show_screen(Screen.SETTINGS)


func _build_settings() -> void:
	var vb := _center_box(560)
	_big_label(vb, "Configurações", 56, YELLOW)
	var dist_lbl := Label.new()
	vb.add_child(dist_lbl)
	var dist := HSlider.new()
	dist.min_value = 4
	dist.max_value = 14
	dist.step = 1
	dist.value = Game.view_distance
	dist.custom_minimum_size.y = 36
	vb.add_child(dist)
	dist_lbl.text = "Distância de visão: %d chunks" % Game.view_distance
	dist.value_changed.connect(func(v):
		Game.view_distance = int(v)
		dist_lbl.text = "Distância de visão: %d chunks" % int(v)
		settings_changed.emit())
	var sens_lbl := Label.new()
	vb.add_child(sens_lbl)
	var sens := HSlider.new()
	sens.min_value = 0.2
	sens.max_value = 3.0
	sens.step = 0.1
	sens.value = Game.mouse_sens
	sens.custom_minimum_size.y = 36
	vb.add_child(sens)
	sens_lbl.text = "Sensibilidade do mouse: %.1fx" % Game.mouse_sens
	sens.value_changed.connect(func(v):
		Game.mouse_sens = v
		sens_lbl.text = "Sensibilidade do mouse: %.1fx" % v
		settings_changed.emit())
	var fs := CheckButton.new()
	fs.text = "Tela cheia"
	fs.button_pressed = Game.fullscreen
	fs.toggled.connect(func(on):
		Game.fullscreen = on
		Game.apply_fullscreen()
		settings_changed.emit())
	vb.add_child(fs)
	var ol := CheckButton.new()
	ol.text = "Contorno de desenho animado"
	ol.button_pressed = Game.outline
	ol.toggled.connect(func(on):
		Game.outline = on
		settings_changed.emit())
	vb.add_child(ol)
	_button(vb, "Voltar", func():
		Game.save_config()
		show_screen(_back_to))


func _build_death() -> void:
	var vb := _center_box(520)
	_big_label(vb, "Você desmaiou!", 70, Color(1.0, 0.45, 0.45))
	_big_label(vb, "As criaturas da noite foram mais rápidas...", 22, Color(1, 1, 1))
	var sp := Control.new()
	sp.custom_minimum_size.y = 20
	vb.add_child(sp)
	_button(vb, "Renascer", func(): respawn_pressed.emit(), Color(0.55, 0.88, 0.35))


# -------------------------------------------------------------- tema --

static func make_theme() -> Theme:
	var th := Theme.new()
	var normal := StyleBoxFlat.new()
	normal.bg_color = YELLOW
	normal.set_corner_radius_all(20)
	normal.set_border_width_all(5)
	normal.border_color = OUTLINE
	normal.content_margin_left = 24
	normal.content_margin_right = 24
	normal.content_margin_top = 8
	normal.content_margin_bottom = 12
	normal.shadow_color = Color(0, 0, 0, 0.35)
	normal.shadow_offset = Vector2(0, 6)
	normal.shadow_size = 1
	var hover: StyleBoxFlat = normal.duplicate()
	hover.bg_color = YELLOW.lightened(0.25)
	var pressed: StyleBoxFlat = normal.duplicate()
	pressed.bg_color = YELLOW.darkened(0.12)
	pressed.shadow_offset = Vector2(0, 2)
	th.set_stylebox("normal", "Button", normal)
	th.set_stylebox("hover", "Button", hover)
	th.set_stylebox("pressed", "Button", pressed)
	th.set_stylebox("focus", "Button", StyleBoxEmpty.new())
	th.set_color("font_color", "Button", OUTLINE)
	th.set_color("font_hover_color", "Button", OUTLINE)
	th.set_color("font_pressed_color", "Button", OUTLINE)
	th.set_color("font_focus_color", "Button", OUTLINE)
	th.set_font_size("font_size", "Button", 26)
	th.set_font_size("font_size", "Label", 22)
	th.set_color("font_color", "Label", Color(1, 1, 1))
	th.set_color("font_outline_color", "Label", OUTLINE)
	th.set_constant("outline_size", "Label", 7)
	var le := StyleBoxFlat.new()
	le.bg_color = Color(1, 1, 1)
	le.set_corner_radius_all(14)
	le.set_border_width_all(4)
	le.border_color = OUTLINE
	le.content_margin_left = 14
	le.content_margin_right = 14
	th.set_stylebox("normal", "LineEdit", le)
	th.set_stylebox("focus", "LineEdit", le)
	th.set_color("font_color", "LineEdit", OUTLINE)
	th.set_font_size("font_size", "LineEdit", 24)
	th.set_font_size("font_size", "CheckButton", 22)
	th.set_color("font_color", "CheckButton", Color(1, 1, 1))
	th.set_color("font_hover_color", "CheckButton", YELLOW)
	th.set_color("font_outline_color", "CheckButton", OUTLINE)
	th.set_constant("outline_size", "CheckButton", 6)
	var track := StyleBoxFlat.new()
	track.bg_color = Color(1, 1, 1, 0.9)
	track.set_corner_radius_all(8)
	track.set_border_width_all(3)
	track.border_color = OUTLINE
	track.content_margin_top = 6
	track.content_margin_bottom = 6
	th.set_stylebox("slider", "HSlider", track)
	var fill: StyleBoxFlat = track.duplicate()
	fill.bg_color = Color(0.55, 0.88, 0.35)
	th.set_stylebox("grabber_area", "HSlider", fill)
	th.set_stylebox("grabber_area_highlight", "HSlider", fill)
	return th
