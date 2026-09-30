class_name CinematicOverlay
extends Control
## Camada da cinemática: barras de letterbox animadas, cartelas de texto
## (ex.: "ALGUMAS SEMANAS DEPOIS"), fade para preto e dica de pular
## (segurar Enter/Y).

signal skip_requested

var top: ColorRect
var bottom: ColorRect
var fade: ColorRect
var card: Label
var card_sub: Label
var skip_hint: Label
var skip_bar: ProgressBar
var letterbox: float = 0.0
var letterbox_target: float = 0.0
var skippable: bool = true
var _skip_hold: float = 0.0
var _hint_t: float = 0.0
var _card_tw: Tween
var _card_box: Control


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_mode = Node.PROCESS_MODE_ALWAYS
	top = ColorRect.new()
	top.color = Color.BLACK
	top.set_anchors_preset(Control.PRESET_TOP_WIDE)
	add_child(top)
	bottom = ColorRect.new()
	bottom.color = Color.BLACK
	bottom.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	add_child(bottom)
	fade = ColorRect.new()
	fade.color = Color(0, 0, 0, 0)
	UIKit.full_rect(fade)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fade)
	var v := UIKit.vbox(6)
	card = UIKit.label("", 46, Color(0.92, 0.9, 0.85), HORIZONTAL_ALIGNMENT_CENTER)
	card_sub = UIKit.label("", 20, UITheme.TEXT_DIM, HORIZONTAL_ALIGNMENT_CENTER)
	v.add_child(card)
	v.add_child(card_sub)
	v.modulate.a = 0.0
	v.name = "Card"
	_card_box = v
	var cc := UIKit.center(v)
	cc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(cc)
	var sh := UIKit.vbox(2)
	sh.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	sh.position = Vector2(-300, -60)
	skip_hint = UIKit.label("Segure [%s] para pular" % InputSetup.code_to_text(InputSetup.current_code("skip")), 14, Color(1, 1, 1, 0.6), HORIZONTAL_ALIGNMENT_RIGHT)
	skip_hint.custom_minimum_size = Vector2(270, 0)
	sh.add_child(skip_hint)
	skip_bar = UIKit.bar(Color(1, 1, 1, 0.7), 1.0)
	skip_bar.custom_minimum_size = Vector2(120, 3)
	skip_bar.size_flags_horizontal = Control.SIZE_SHRINK_END
	sh.add_child(skip_bar)
	sh.modulate.a = 0.0
	sh.name = "Skip"
	add_child(sh)


func _process(delta: float) -> void:
	letterbox = move_toward(letterbox, letterbox_target, delta * (0.6 if letterbox_target > letterbox else 1.4))
	var h := size.y * 0.12 * smoothstep(0.0, 1.0, letterbox)
	top.size = Vector2(size.x, h)
	top.position = Vector2(0, 0)
	bottom.size = Vector2(size.x, h)
	bottom.position = Vector2(0, size.y - h)
	var sk := get_node("Skip") as Control
	if _hint_t > 0.0:
		if Pad.using_pad:
			skip_hint.text = "Segure [%s] para pular" % InputSetup.pad_text("skip", Pad.glyph_style())
		else:
			skip_hint.text = "Segure [%s] para pular" % InputSetup.code_to_text(InputSetup.current_code("skip"))
	_hint_t -= delta
	if skippable and letterbox_target > 0.0:
		if Input.is_action_pressed("skip") or Input.is_action_pressed("pause"):
			_skip_hold += delta
			_hint_t = 2.5
			if _skip_hold > 1.2:
				_skip_hold = 0.0
				skip_requested.emit()
		else:
			_skip_hold = maxf(0.0, _skip_hold - delta * 2.0)
	skip_bar.value = _skip_hold / 1.2
	sk.modulate.a = move_toward(sk.modulate.a, 1.0 if _hint_t > 0.0 else 0.0, delta * 3.0)


func _input(event: InputEvent) -> void:
	if letterbox_target > 0.0 and skippable and (event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton) and event.is_pressed():
		_hint_t = 3.0


func show_card(text: String, sub: String = "", hold: float = 3.0) -> void:
	card.text = text
	card_sub.text = sub
	var v := _card_box
	if _card_tw:
		_card_tw.kill()
	_card_tw = create_tween()
	_card_tw.tween_property(v, "modulate:a", 1.0, 1.2)
	_card_tw.tween_interval(hold)
	_card_tw.tween_property(v, "modulate:a", 0.0, 1.2)


func fade_to(alpha: float, dur: float) -> Tween:
	var tw := create_tween()
	tw.tween_property(fade, "color:a", alpha, dur)
	return tw
