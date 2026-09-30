extends Node
## Cena de entrada do teste de fumaça: cria o driver persistente na raiz.

func _ready() -> void:
	var d := Node.new()
	d.set_script(load("res://tests/smoke_driver.gd"))
	d.name = "SmokeDriver"
	get_tree().root.add_child.call_deferred(d)
