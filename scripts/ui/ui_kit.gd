class_name UIKit
extends RefCounted
## Construtores de controles para as telas feitas em código.


static func label(text: String, size: int = 18, color: Color = UITheme.TEXT, align: int = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.horizontal_alignment = align
	return l


static func title(text: String, size: int = 30) -> Label:
	var l := label(text, size, UITheme.ACCENT)
	l.add_theme_constant_override("outline_size", 0)
	return l


static func button(text: String, cb: Callable, min_w: float = 260.0, size: int = 20) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(min_w, 42)
	b.add_theme_font_size_override("font_size", size)
	b.focus_mode = Control.FOCUS_ALL
	b.pressed.connect(func() -> void:
		AudioManager.play_ui("ui_click", -6.0)
		cb.call())
	b.mouse_entered.connect(func() -> void: b.grab_focus())
	return b


static func vbox(sep: int = 8) -> VBoxContainer:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", sep)
	return v


static func hbox(sep: int = 8) -> HBoxContainer:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", sep)
	return h


static func panel(pad: int = 18) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UITheme.box(UITheme.BG, UITheme.LINE, 1, 4, pad))
	return p


static func spacer(h: float = 10.0) -> Control:
	var c := Control.new()
	c.custom_minimum_size = Vector2(0, h)
	return c


static func expand(c: Control) -> Control:
	c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return c


static func full_rect(c: Control) -> Control:
	c.set_anchors_preset(Control.PRESET_FULL_RECT)
	c.offset_left = 0
	c.offset_top = 0
	c.offset_right = 0
	c.offset_bottom = 0
	return c


static func center(c: Control) -> CenterContainer:
	var cc := CenterContainer.new()
	full_rect(cc)
	cc.add_child(c)
	return cc


static func dim_bg(alpha: float = 0.6) -> ColorRect:
	var r := ColorRect.new()
	r.color = Color(0, 0, 0, alpha)
	full_rect(r)
	r.mouse_filter = Control.MOUSE_FILTER_STOP
	return r


## Linha "rótulo ....... controle" das telas de configuração.
static func row(text: String, ctrl: Control, tip: String = "") -> HBoxContainer:
	var h := hbox(12)
	var l := label(text, 17)
	l.custom_minimum_size = Vector2(320, 0)
	l.tooltip_text = tip
	h.add_child(l)
	ctrl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ctrl.tooltip_text = tip
	h.add_child(ctrl)
	return h


static func slider(min_v: float, max_v: float, step: float, value: float, cb: Callable, fmt: String = "%.0f%%", mult: float = 100.0) -> HBoxContainer:
	var h := hbox(10)
	var s := HSlider.new()
	s.min_value = min_v
	s.max_value = max_v
	s.step = step
	s.value = value
	s.custom_minimum_size = Vector2(240, 24)
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var l := label(fmt % (value * mult), 16, UITheme.TEXT_DIM)
	l.custom_minimum_size = Vector2(70, 0)
	s.value_changed.connect(func(v: float) -> void:
		l.text = fmt % (v * mult)
		cb.call(v))
	h.add_child(s)
	h.add_child(l)
	return h


static func options(items: Array, selected: int, cb: Callable) -> OptionButton:
	var o := OptionButton.new()
	for i in items.size():
		o.add_item(str(items[i]), i)
	o.select(clampi(selected, 0, items.size() - 1))
	o.custom_minimum_size = Vector2(240, 36)
	o.item_selected.connect(func(i: int) -> void: cb.call(i))
	return o


static func check(on: bool, cb: Callable) -> CheckButton:
	var c := CheckButton.new()
	c.button_pressed = on
	c.toggled.connect(func(v: bool) -> void: cb.call(v))
	return c


static func bar(color: Color, max_v: float = 100.0) -> ProgressBar:
	var b := ProgressBar.new()
	b.max_value = max_v
	b.show_percentage = false
	b.custom_minimum_size = Vector2(160, 8)
	b.add_theme_stylebox_override("fill", UITheme.box(color, Color(0, 0, 0, 0), 0, 2))
	b.add_theme_stylebox_override("background", UITheme.box(Color(0.06, 0.06, 0.06, 0.75), Color(0, 0, 0, 0), 0, 2))
	return b


static func separator() -> HSeparator:
	var s := HSeparator.new()
	s.add_theme_stylebox_override("separator", UITheme.box(UITheme.LINE, Color(0, 0, 0, 0), 0, 0, 0, 1))
	return s
