class_name UITheme
extends RefCounted
## Tema visual da interface: painéis escuros translúcidos, acento âmbar
## desbotado, alto contraste opcional (acessibilidade) e escala de UI.

const BG := Color(0.035, 0.037, 0.04, 0.9)
const BG_SOFT := Color(0.06, 0.065, 0.07, 0.82)
const LINE := Color(0.42, 0.4, 0.34, 0.55)
const TEXT := Color(0.9, 0.88, 0.82)
const TEXT_DIM := Color(0.62, 0.61, 0.57)
const ACCENT := Color(0.86, 0.72, 0.42)
const DANGER := Color(0.86, 0.26, 0.2)
const GOOD := Color(0.45, 0.78, 0.45)
const INFO := Color(0.5, 0.7, 0.9)

static var _theme: Theme = null


static func text_color() -> Color:
	return Color(1, 1, 1) if bool(Settings.accessibility.get("high_contrast_hud", false)) else TEXT


static func get_theme() -> Theme:
	if _theme != null:
		return _theme
	var t := Theme.new()
	t.default_font_size = 18
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["Noto Sans", "DejaVu Sans", "Liberation Sans", "Arial", "Sans-Serif"])
	font.antialiasing = TextServer.FONT_ANTIALIASING_GRAY
	font.hinting = TextServer.HINTING_LIGHT
	t.default_font = font
	# painéis
	t.set_stylebox("panel", "Panel", box(BG, LINE, 1, 4))
	t.set_stylebox("panel", "PanelContainer", box(BG, LINE, 1, 4, 14))
	# botões
	var normal := box(Color(0.09, 0.095, 0.1, 0.9), Color(0.3, 0.3, 0.28, 0.6), 1, 3, 10)
	var hover := box(Color(0.16, 0.15, 0.12, 0.95), ACCENT * Color(1, 1, 1, 0.8), 1, 3, 10)
	var pressed := box(Color(0.22, 0.19, 0.12, 0.95), ACCENT, 2, 3, 10)
	var disabled := box(Color(0.06, 0.06, 0.065, 0.7), Color(0.2, 0.2, 0.2, 0.5), 1, 3, 10)
	for cls: String in ["Button", "OptionButton", "CheckButton", "MenuButton"]:
		t.set_stylebox("normal", cls, normal)
		t.set_stylebox("hover", cls, hover)
		t.set_stylebox("pressed", cls, pressed)
		t.set_stylebox("focus", cls, box(Color(0, 0, 0, 0), ACCENT, 2, 3, 10))
		t.set_stylebox("disabled", cls, disabled)
		t.set_color("font_color", cls, TEXT)
		t.set_color("font_hover_color", cls, Color(1, 0.95, 0.85))
		t.set_color("font_pressed_color", cls, ACCENT)
		t.set_color("font_disabled_color", cls, Color(0.4, 0.4, 0.4))
		t.set_color("font_focus_color", cls, Color(1, 0.95, 0.85))
	t.set_color("font_color", "Label", TEXT)
	t.set_color("default_color", "RichTextLabel", TEXT)
	# barras
	t.set_stylebox("background", "ProgressBar", box(Color(0.1, 0.1, 0.1, 0.8), Color(0, 0, 0, 0), 0, 2))
	t.set_stylebox("fill", "ProgressBar", box(ACCENT, Color(0, 0, 0, 0), 0, 2))
	t.set_color("font_color", "ProgressBar", TEXT)
	# sliders
	t.set_stylebox("slider", "HSlider", box(Color(0.18, 0.18, 0.18, 0.9), Color(0, 0, 0, 0), 0, 2, 0, 4))
	t.set_stylebox("grabber_area", "HSlider", box(ACCENT * Color(1, 1, 1, 0.8), Color(0, 0, 0, 0), 0, 2, 0, 4))
	t.set_stylebox("grabber_area_highlight", "HSlider", box(ACCENT, Color(0, 0, 0, 0), 0, 2, 0, 4))
	# abas
	t.set_stylebox("tab_selected", "TabBar", box(Color(0.14, 0.13, 0.1, 0.95), ACCENT, 0, 2, 12))
	t.set_stylebox("tab_unselected", "TabBar", box(Color(0.07, 0.07, 0.075, 0.9), Color(0, 0, 0, 0), 0, 2, 12))
	t.set_stylebox("tab_hovered", "TabBar", box(Color(0.12, 0.11, 0.09, 0.95), Color(0, 0, 0, 0), 0, 2, 12))
	t.set_color("font_selected_color", "TabBar", ACCENT)
	t.set_color("font_unselected_color", "TabBar", TEXT_DIM)
	t.set_stylebox("panel", "TabContainer", box(BG, LINE, 1, 4, 12))
	t.set_stylebox("tab_selected", "TabContainer", box(Color(0.14, 0.13, 0.1, 0.95), ACCENT, 0, 2, 12))
	t.set_stylebox("tab_unselected", "TabContainer", box(Color(0.07, 0.07, 0.075, 0.9), Color(0, 0, 0, 0), 0, 2, 12))
	t.set_stylebox("tab_hovered", "TabContainer", box(Color(0.12, 0.11, 0.09, 0.95), Color(0, 0, 0, 0), 0, 2, 12))
	t.set_color("font_selected_color", "TabContainer", ACCENT)
	t.set_color("font_unselected_color", "TabContainer", TEXT_DIM)
	# listas
	t.set_stylebox("panel", "ItemList", box(Color(0.05, 0.05, 0.055, 0.85), LINE, 1, 3, 6))
	t.set_stylebox("selected", "ItemList", box(Color(0.2, 0.17, 0.1, 0.95), Color(0, 0, 0, 0), 0, 2))
	t.set_stylebox("selected_focus", "ItemList", box(Color(0.24, 0.2, 0.12, 0.95), ACCENT, 1, 2))
	t.set_stylebox("hovered", "ItemList", box(Color(0.12, 0.11, 0.09, 0.9), Color(0, 0, 0, 0), 0, 2))
	t.set_color("font_color", "ItemList", TEXT)
	t.set_color("font_selected_color", "ItemList", Color(1, 0.95, 0.85))
	t.set_stylebox("panel", "PopupMenu", box(BG, LINE, 1, 3, 6))
	t.set_stylebox("normal", "LineEdit", box(Color(0.06, 0.06, 0.065, 0.9), LINE, 1, 3, 8))
	t.set_stylebox("panel", "TooltipPanel", box(Color(0.03, 0.03, 0.035, 0.95), ACCENT, 1, 3, 8))
	# rolagem
	t.set_stylebox("scroll", "VScrollBar", box(Color(0.08, 0.08, 0.08, 0.6), Color(0, 0, 0, 0), 0, 3, 0, 4))
	t.set_stylebox("grabber", "VScrollBar", box(Color(0.35, 0.33, 0.28, 0.8), Color(0, 0, 0, 0), 0, 3, 0, 4))
	t.set_stylebox("grabber_highlight", "VScrollBar", box(ACCENT * Color(1, 1, 1, 0.8), Color(0, 0, 0, 0), 0, 3, 0, 4))
	_theme = t
	return t


static func box(bg: Color, border: Color, bw: int, radius: int, pad: int = 0, vpad: int = -1) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(radius)
	s.content_margin_left = pad
	s.content_margin_right = pad
	s.content_margin_top = pad * 0.6 if vpad < 0 else vpad
	s.content_margin_bottom = pad * 0.6 if vpad < 0 else vpad
	s.anti_aliasing = true
	return s


## Escala da UI (acessibilidade) aplicada ao content_scale da janela.
static func apply_scale(tree: SceneTree) -> void:
	var s := clampf(float(Settings.accessibility.get("ui_scale", 1.0)), 0.75, 1.6)
	tree.root.content_scale_factor = s
