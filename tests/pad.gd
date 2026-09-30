extends Node
## Cena de entrada do teste do controle (driver persistente na raiz).

func _ready() -> void:
	var d := Node.new()
	d.set_script(load("res://tests/pad_driver.gd"))
	d.name = "PadDriver"
	get_tree().root.add_child.call_deferred(d)
