extends Node
## Cena de entrada do fotos dos prédios (driver persistente na raiz).

func _ready() -> void:
	var d := Node.new()
	d.set_script(load("res://tests/buildings_driver.gd"))
	d.name = "BuildingsDriver"
	get_tree().root.add_child.call_deferred(d)
