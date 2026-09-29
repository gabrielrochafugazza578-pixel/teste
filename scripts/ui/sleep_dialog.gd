class_name SleepDialog
extends Control
## Dormir/descansar: escolhe horas; dormir salva o jogo (se seguro).

signal closed
signal sleep_confirmed(hours: float)

var danger: bool = false
var hours: float = 6.0
var _label: Label


func _ready() -> void:
	theme = UITheme.game_theme()
	UIKit.full_rect(self)
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(UIKit.dim_bg(0.5))
	var p := UIKit.window(22)
	var v := UIKit.vbox(10)
	p.add_child(v)
	v.add_child(UIKit.title("DESCANSAR", 26))
	if danger:
		v.add_child(UIKit.label("Há perigo por perto. Não dá para dormir agora.", 16, UITheme.DANGER))
		v.add_child(UIKit.button("Voltar", close, 220))
	else:
		_label = UIKit.label("", 17)
		v.add_child(_label)
		v.add_child(UIKit.slider(1.0, 12.0, 1.0, hours, func(x: float) -> void:
			hours = x
			_update(), "%.0f h", 1.0))
		v.add_child(UIKit.label("Dormir recupera energia e saúde, mas fome e sede continuam.\nO jogo é salvo ao acordar.", 14, UITheme.TEXT_DIM))
		var h := UIKit.hbox(10)
		h.add_child(UIKit.button("Dormir", func() -> void:
			sleep_confirmed.emit(hours)
			close(), 200))
		h.add_child(UIKit.button("Cancelar", close, 160))
		v.add_child(h)
		_update()
	add_child(UIKit.center(p))


func _update() -> void:
	if _label:
		var wake := fmod(TimeManager.hour + hours, 24.0)
		_label.text = "Dormir %d horas — acordar às %s" % [int(hours), Util.format_time(wake)]


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	if not is_inside_tree():
		return
	closed.emit()
	queue_free()
