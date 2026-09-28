class_name FuelPump
extends Interactable
## Bomba de posto sem energia: com mangueira + galão vazio o jogador sifona
## combustível do tanque subterrâneo (quantidade finita, persistente).

var fuel_left: float = 60.0


func setup(pos: Vector3, id: String) -> void:
	uid = id
	position = pos
	add_shape(Vector3(1.2, 1.8, 1.2), Vector3(0, 0.9, 0))
	fuel_left = float(GameState.get_flag("fuel_" + uid, 40.0 + float(Util.hash_str(id) % 60)))
	prompt = "Sifonar combustível"


func get_prompt(_player: Node) -> String:
	return "Bomba seca" if fuel_left < 1.0 else "Sifonar combustível (%d L restantes)" % int(fuel_left)


func hold_time(_player: Node) -> float:
	return 3.0


func interact(player: Node) -> void:
	super.interact(player)
	if fuel_left < 1.0 or player == null:
		return
	if not player.has_method("has_tool") or not player.has_tool("siphon"):
		EventBus.toast("Você precisa de uma mangueira.", "warn")
		return
	if not player.inventory.has("galao_vazio"):
		EventBus.toast("Você precisa de um galão vazio.", "warn")
		return
	player.inventory.remove("galao_vazio", 1)
	var amount := minf(10.0, fuel_left)
	fuel_left -= amount
	player.inventory.add("galao_gasolina", 1, 1.0, {"fuel": amount}, true)
	GameState.set_flag("fuel_" + uid, fuel_left)
	EventBus.toast("Galão cheio (%d L)." % int(amount), "good")
	EventBus.make_noise(global_position, 5.0, player, &"siphon")
