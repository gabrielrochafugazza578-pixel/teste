class_name InputPrompt
extends Control
## Tecla ou botão de uma ação, desenhado conforme o que o jogador está usando:
## tecla do teclado ("E", "Tab"), ou o botão do controle no estilo certo —
## PlayStation (✕ ○ □ △ em cores, L1/R2, Options, Share, touchpad), Xbox (A B X Y
## coloridos, LB/RT, Menu, View) ou Nintendo. Troca sozinho quando o aparelho muda.

var action: String = "":
	set(v):
		action = v
		_relayout()
## Ação usada no controle, se for outra (ex.: telas fecham com ○/B no controle,
## mas com Esc/Tab no teclado).
var pad_action: String = "":
	set(v):
		pad_action = v
		_relayout()
## Texto fixo no teclado (em vez da tecla da ação).
var key_override: String = ""
var px: float = 18.0

const PS_COLORS := {JOY_BUTTON_A: Color(0.49, 0.69, 0.92), JOY_BUTTON_B: Color(0.92, 0.45, 0.47), JOY_BUTTON_X: Color(0.86, 0.6, 0.82), JOY_BUTTON_Y: Color(0.32, 0.78, 0.66)}
const XB_COLORS := {JOY_BUTTON_A: Color(0.36, 0.73, 0.28), JOY_BUTTON_B: Color(0.88, 0.28, 0.24), JOY_BUTTON_X: Color(0.25, 0.52, 0.9), JOY_BUTTON_Y: Color(0.95, 0.76, 0.19)}


static func make(act: String, size_px: float = 18.0, pad_act: String = "") -> InputPrompt:
	var p := InputPrompt.new()
	p.px = size_px
	p.action = act
	p.pad_action = pad_act
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return p


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size_flags_vertical = Control.SIZE_SHRINK_CENTER
	Pad.device_changed.connect(_on_device)
	_relayout()


func _on_device(_p: bool) -> void:
	_relayout()


func _pad() -> bool:
	return (Pad.using_pad or has_meta("force_pad")) and _pad_button() != -1


func _pad_button() -> int:
	return InputSetup.pad_button(pad_action if pad_action != "" else action)


func _key_text() -> String:
	return key_override if key_override != "" else InputSetup.key_text(action)


func _font() -> Font:
	return get_theme_default_font() if is_inside_tree() else ThemeDB.fallback_font


func _relayout() -> void:
	var h := px * 1.25
	var w := h
	var f := _font()
	var fs := int(px * 0.62)
	if _pad():
		var b := _pad_button()
		var t := InputSetup.pad_button_text(b, Pad.glyph_style())
		if _is_face(b) or b in [JOY_BUTTON_DPAD_UP, JOY_BUTTON_DPAD_DOWN, JOY_BUTTON_DPAD_LEFT, JOY_BUTTON_DPAD_RIGHT] or _is_stick(b):
			w = h
		else:
			w = maxf(h, f.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x + px * 0.8)
	else:
		w = maxf(h, f.get_string_size(_key_text(), HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x + px * 0.7)
	custom_minimum_size = Vector2(w, h)
	queue_redraw()


static func _is_face(b: int) -> bool:
	return b in [JOY_BUTTON_A, JOY_BUTTON_B, JOY_BUTTON_X, JOY_BUTTON_Y]


static func _is_stick(b: int) -> bool:
	return b in [JOY_BUTTON_LEFT_STICK, JOY_BUTTON_RIGHT_STICK] or (b <= -10 and -10 - b <= JOY_AXIS_RIGHT_Y)


func _draw() -> void:
	var f := _font()
	var fs := int(px * 0.62)
	var r := Rect2(Vector2.ZERO, custom_minimum_size)
	r.position.y = (size.y - r.size.y) * 0.5
	var txt_col := Color(0.95, 0.93, 0.88)
	if not _pad():
		var sb := UITheme.box(Color(0.14, 0.14, 0.14, 0.92), Color(0.62, 0.6, 0.54, 0.8), 1, 4, 0, 0)
		sb.border_width_bottom = 3
		draw_style_box(sb, r)
		_text(f, _key_text(), r.grow_individual(0, 0, 0, -2), fs, txt_col)
		return
	var b := _pad_button()
	var st := Pad.glyph_style()
	var c := r.get_center()
	var rad := r.size.y * 0.5 - 0.5
	if _is_face(b):
		draw_circle(c, rad, Color(0.07, 0.07, 0.08, 0.95))
		draw_arc(c, rad, 0, TAU, 28, Color(0.55, 0.54, 0.5, 0.9), 1.2, true)
		if st == "ps":
			var col: Color = PS_COLORS[b]
			var s := rad * 0.46
			var lw := maxf(1.6, px * 0.1)
			match b:
				JOY_BUTTON_A:
					draw_line(c + Vector2(-s, -s), c + Vector2(s, s), col, lw, true)
					draw_line(c + Vector2(-s, s), c + Vector2(s, -s), col, lw, true)
				JOY_BUTTON_B:
					draw_arc(c, s * 1.05, 0, TAU, 24, col, lw, true)
				JOY_BUTTON_X:
					draw_rect(Rect2(c - Vector2(s, s) * 0.92, Vector2(s, s) * 1.84), col, false, lw)
				JOY_BUTTON_Y:
					var pts := PackedVector2Array([c + Vector2(0, -s * 1.1), c + Vector2(s * 1.05, s * 0.75), c + Vector2(-s * 1.05, s * 0.75), c + Vector2(0, -s * 1.1)])
					draw_polyline(pts, col, lw, true)
		else:
			var col2: Color = XB_COLORS[b] if st == "xbox" else Color(0.92, 0.92, 0.9)
			_text(f, InputSetup.pad_button_text(b, st), r, int(px * 0.7), col2)
		return
	if b in [JOY_BUTTON_DPAD_UP, JOY_BUTTON_DPAD_DOWN, JOY_BUTTON_DPAD_LEFT, JOY_BUTTON_DPAD_RIGHT]:
		var a := rad * 0.3
		var l := rad * 0.82
		draw_circle(c, rad, Color(0.07, 0.07, 0.08, 0.95))
		draw_arc(c, rad, 0, TAU, 28, Color(0.55, 0.54, 0.5, 0.9), 1.2, true)
		var base := Color(0.5, 0.5, 0.48, 0.95)
		draw_rect(Rect2(c - Vector2(a, l), Vector2(a * 2, l * 2)), base)
		draw_rect(Rect2(c - Vector2(l, a), Vector2(l * 2, a * 2)), base)
		var hi := Color(0.95, 0.93, 0.88)
		match b:
			JOY_BUTTON_DPAD_UP: draw_rect(Rect2(c + Vector2(-a, -l), Vector2(a * 2, l - a * 0.4)), hi)
			JOY_BUTTON_DPAD_DOWN: draw_rect(Rect2(c + Vector2(-a, a * 0.4), Vector2(a * 2, l - a * 0.4)), hi)
			JOY_BUTTON_DPAD_LEFT: draw_rect(Rect2(c + Vector2(-l, -a), Vector2(l - a * 0.4, a * 2)), hi)
			JOY_BUTTON_DPAD_RIGHT: draw_rect(Rect2(c + Vector2(a * 0.4, -a), Vector2(l - a * 0.4, a * 2)), hi)
		return
	var t := InputSetup.pad_button_text(b, st)
	if _is_stick(b):
		draw_circle(c, rad, Color(0.07, 0.07, 0.08, 0.95))
		draw_arc(c, rad, 0, TAU, 28, Color(0.6, 0.58, 0.54, 0.9), 1.2, true)
		draw_arc(c, rad * 0.68, 0, TAU, 24, Color(0.4, 0.4, 0.38, 0.9), 1.0, true)
		_text(f, t, r, int(px * 0.5), txt_col)
		return
	# ombros, gatilhos, Options/Share/touchpad: pílula com o nome
	var trig := b in [InputSetup.PAD_L2, InputSetup.PAD_R2] or (b <= -10 and -10 - b >= JOY_AXIS_TRIGGER_LEFT)
	var sb2 := StyleBoxFlat.new()
	sb2.bg_color = Color(0.07, 0.07, 0.08, 0.95)
	sb2.border_color = Color(0.6, 0.58, 0.54, 0.9)
	sb2.set_border_width_all(1)
	if trig:
		sb2.corner_radius_top_left = int(r.size.y * 0.5)
		sb2.corner_radius_top_right = int(r.size.y * 0.5)
		sb2.corner_radius_bottom_left = 3
		sb2.corner_radius_bottom_right = 3
	else:
		sb2.set_corner_radius_all(int(r.size.y * 0.3))
	draw_style_box(sb2, r)
	_text(f, t, r, fs if t.length() <= 3 else int(px * 0.5), txt_col)


func _text(f: Font, t: String, r: Rect2, fs: int, col: Color) -> void:
	var asc := f.get_ascent(fs)
	var desc := f.get_descent(fs)
	var y := r.position.y + (r.size.y + asc - desc) * 0.5
	draw_string(f, Vector2(r.position.x, y), t, HORIZONTAL_ALIGNMENT_CENTER, r.size.x, fs, col)
