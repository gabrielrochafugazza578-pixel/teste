class_name VehicleDoor
extends Interactable
## Porta do motorista: dirigir, abastecer (galão) ou consertar.

var vehicle: Vehicle


func _mode(player: Node) -> String:
	var p := player as Player
	if vehicle.is_broken():
		return "repair"
	if vehicle.fuel < vehicle.fuel_max - 3.0 and p != null and p.inventory.has("galao_gasolina") and vehicle.fuel < 1.0:
		return "refuel"
	return "drive"


func get_prompt(player: Node) -> String:
	match _mode(player):
		"repair":
			if not vehicle.needs_repair.is_empty():
				var parts: Array = []
				for it in vehicle.needs_repair.keys():
					parts.append(ItemDB.item_name(it))
				return "Consertar veículo (%s)" % ", ".join(parts)
			return "Consertar veículo"
		"refuel":
			return "Abastecer com galão"
	var extra := ""
	if vehicle.fuel < 1.0:
		extra = " — sem combustível"
	return "Dirigir (%d%% combustível)%s" % [int(vehicle.fuel / vehicle.fuel_max * 100.0), extra]


func hold_time(player: Node) -> float:
	match _mode(player):
		"repair": return 4.0
		"refuel": return 2.0
	return 0.0


func interact(player: Node) -> void:
	super.interact(player)
	var p := player as Player
	if p == null:
		return
	match _mode(player):
		"repair":
			vehicle.repair(p)
		"refuel":
			vehicle.refuel_from_can(p)
		_:
			vehicle.enter(p)
