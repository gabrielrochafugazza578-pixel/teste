class_name VehicleTrunk
extends Interactable
## Porta-malas: armazenamento do veículo (e abastecimento pelo tanque).

var vehicle: Vehicle


func get_prompt(player: Node) -> String:
	var p := player as Player
	if p != null and p.inventory.has("galao_gasolina") and vehicle.fuel < vehicle.fuel_max - 3.0:
		return "Porta-malas  ·  [segure] abastecer"
	return "Abrir porta-malas (%d itens)" % vehicle.storage.stacks.size()


func hold_time(player: Node) -> float:
	var p := player as Player
	if p != null and p.inventory.has("galao_gasolina") and vehicle.fuel < vehicle.fuel_max - 3.0:
		return 1.5
	return 0.0


func interact(player: Node) -> void:
	super.interact(player)
	var p := player as Player
	if p != null and p.inventory.has("galao_gasolina") and vehicle.fuel < vehicle.fuel_max - 3.0:
		vehicle.refuel_from_can(p)
		return
	AudioManager.play_3d("door_open", vehicle.global_position, -6.0, 0.8)
	EventBus.container_ui_requested.emit(vehicle.storage, "Porta-malas", vehicle)
