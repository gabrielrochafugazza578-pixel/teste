extends Node
## Cena de entrada do teste das telas (driver persistente na raiz).

func _ready() -> void:
	var d := Node.new()
	d.set_script(load("res://tests/ui_driver.gd"))
	d.name = "UIDriver"
	get_tree().root.add_child.call_deferred(d)
