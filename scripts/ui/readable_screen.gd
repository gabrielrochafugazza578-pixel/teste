class_name ReadableScreen
extends Control
## Documento/bilhete/transcrição em papel.

signal closed

var title_text: String = ""
var body_text: String = ""


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(UIKit.dim_bg(0.65))
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UITheme.box(Color(0.86, 0.83, 0.74), Color(0.5, 0.45, 0.35), 1, 2, 34))
	p.custom_minimum_size = Vector2(700, 560)
	var v := UIKit.vbox(12)
	p.add_child(v)
	v.add_child(UIKit.label(title_text, 24, Color(0.15, 0.12, 0.1)))
	var t := RichTextLabel.new()
	t.text = body_text
	t.custom_minimum_size = Vector2(630, 420)
	t.add_theme_color_override("default_color", Color(0.12, 0.11, 0.1))
	t.add_theme_font_size_override("normal_font_size", 18)
	v.add_child(t)
	var b := UIKit.button("Fechar", close, 160)
	b.size_flags_horizontal = Control.SIZE_SHRINK_END
	v.add_child(b)
	add_child(UIKit.center(p))
	AudioManager.play_ui("search", -8.0)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel") or event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	if not is_inside_tree():
		return
	closed.emit()
	queue_free()
