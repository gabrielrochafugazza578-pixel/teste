extends Node
## Cena de entrada do teste das armas na mão (driver persistente na raiz).

func _ready() -> void:
	var d := Node.new()
	d.set_script(load("res://tests/arms_driver.gd"))
	d.name = "ArmsDriver"
	get_tree().root.add_child.call_deferred(d)
