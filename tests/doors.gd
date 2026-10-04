extends Node
## Cena de entrada do teste das portas (driver persistente na raiz).

func _ready() -> void:
	var d := Node.new()
	d.set_script(load("res://tests/doors_driver.gd"))
	d.name = "DoorsDriver"
	get_tree().root.add_child.call_deferred(d)
