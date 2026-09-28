class_name CarProbe
extends Interactable
## Interação reaproveitável com um carro estático próximo (pool de 4):
## revistar porta-malas/porta-luvas, sifonar gasolina, ligação direta.

var manager: VehicleManager
var car: Dictionary = {}
var car_uid: String = ""
var chunk: Vector2i
var inv: Inventory


func bind(c: Dictionary, ch: Vector2i) -> void:
	car = c
	car_uid = str(c["uid"])
	chunk = ch
	enabled = true
	for k in get_children():
		k.queue_free()
	var dims := VehicleMeshBuilder.dims(str(c["type"]))
	add_shape(Vector3(float(dims["W"]) + 0.8, 1.6, float(dims["L"]) + 0.6), Vector3(0, 0.8, 0))
	global_position = c["pos"]
	rotation.y = float(c["yaw"])
	inv = Inventory.new("trunk_" + car_uid, 40.0, 12, "Carro")
	var st := GameState.container_state("trunk_" + car_uid)
	if not st.is_empty():
		inv.from_data({"id": "trunk_" + car_uid, "w": 40.0, "slots": 12, "stacks": st.get("items", [])})
	inv.changed.connect(func() -> void: GameState.store_container("trunk_" + car_uid, inv.stacks))


func unbind() -> void:
	enabled = false
	car_uid = ""
	car = {}
	global_position = Vector3(0, -1000, 0)


func _burned() -> bool:
	return str(car.get("state", "")) == "burned"


func _mode(player: Node) -> String:
	var p := player as Player
	if p == null or car.is_empty():
		return "none"
	if not _burned() and manager.is_hotwirable(car_uid) and p.has_tool("screw") and p.inventory.has("fios"):
		return "hotwire"
	if not _burned() and p.has_tool("siphon") and p.inventory.has("galao_vazio") and manager.car_fuel(car_uid) >= 1.0:
		return "siphon"
	return "search"


func get_prompt(player: Node) -> String:
	match _mode(player):
		"hotwire": return "Fazer ligação direta (chave de fenda + fios)"
		"siphon": return "Sifonar gasolina do tanque"
		"search":
			if _burned():
				return "Revistar carcaça queimada"
			var opened := not GameState.container_state("trunk_" + car_uid).is_empty()
			return "Abrir carro" if opened else "Revistar carro abandonado"
	return ""


func hold_time(player: Node) -> float:
	match _mode(player):
		"hotwire": return 4.0
		"siphon": return 3.0
	return 0.0 if not GameState.container_state("trunk_" + car_uid).is_empty() else 1.0


func interact(player: Node) -> void:
	super.interact(player)
	match _mode(player):
		"hotwire":
			(player as Player).inventory.remove("fios", 1)
			(player as Player).use_tool("screw", 0.05)
			var c := car
			var ch := chunk
			unbind()
			manager.hotwire(c, ch)
		"siphon":
			manager.siphon(car_uid)
		"search":
			if GameState.container_state("trunk_" + car_uid).is_empty():
				var stacks: Array = []
				if not _burned():
					stacks = LootTables.roll("car", "trunk", car_uid, "", Settings.loot_multiplier())
					stacks.append_array(LootTables.roll("car", "glovebox", car_uid + "g", "", Settings.loot_multiplier()))
				for s in stacks:
					inv.add_stack(s, true)
				GameState.store_container("trunk_" + car_uid, inv.stacks)
				GameState.add_stat("looted")
			AudioManager.play_3d("search", global_position)
			EventBus.make_noise(global_position, 5.0, player, &"search")
			EventBus.container_ui_requested.emit(inv, "Carro abandonado", self)
