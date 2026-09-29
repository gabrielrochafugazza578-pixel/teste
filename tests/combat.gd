extends Node
## Cena de entrada do teste de combate (driver persistente na raiz).

func _ready() -> void:
	var d := Node.new()
	d.set_script(load("res://tests/combat_driver.gd"))
	d.name = "CombatDriver"
	get_tree().root.add_child.call_deferred(d)
