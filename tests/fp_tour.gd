extends Node
## Cena de entrada do tour visual: cria o driver persistente na raiz (sobrevive à troca de cena).

func _ready() -> void:
	var d := Node.new()
	d.set_script(load("res://tests/fp_tour_driver.gd"))
	d.name = "FpTourDriver"
	get_tree().root.add_child.call_deferred(d)
