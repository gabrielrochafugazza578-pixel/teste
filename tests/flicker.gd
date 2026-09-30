extends Node
## Cena de entrada do teste de piscar (driver persistente na raiz).

func _ready() -> void:
	var d := Node.new()
	d.set_script(load("res://tests/flicker_driver.gd"))
	d.name = "FlickerDriver"
	get_tree().root.add_child.call_deferred(d)
