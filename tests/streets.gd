extends Node
## Cena de entrada do teste das ruas (driver persistente na raiz).

func _ready() -> void:
	var d := Node.new()
	d.set_script(load("res://tests/streets_driver.gd"))
	d.name = "StreetsDriver"
	get_tree().root.add_child.call_deferred(d)
