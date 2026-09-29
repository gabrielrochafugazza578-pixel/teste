extends Node
## Cena de entrada das fotos dos interiores (driver persistente na raiz).

func _ready() -> void:
	var d := Node.new()
	d.set_script(load("res://tests/interiors_driver.gd"))
	d.name = "InteriorsDriver"
	get_tree().root.add_child.call_deferred(d)
