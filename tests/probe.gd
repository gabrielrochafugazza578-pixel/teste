extends Node
## Cena de entrada das sondas: cria o driver persistente na raiz (sobrevive à troca de cena).

func _ready() -> void:
	var d := Node.new()
	d.set_script(load("res://tests/probe_driver.gd"))
	d.name = "ProbeDriver"
	get_tree().root.add_child.call_deferred(d)
