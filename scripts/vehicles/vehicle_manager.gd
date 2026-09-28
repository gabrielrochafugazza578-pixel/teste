class_name VehicleManager
extends Node3D
## Veículos dirigíveis persistentes (picape do Tonho, viatura, SUV da
## Corvalis...) com streaming por distância, e interação com os carros
## estáticos do mundo: revistar, sifonar combustível e ligação direta.

const SPAWN_R := 170.0
const DESPAWN_R := 240.0

## Veículos de história/mundo. place: POI; along: metros à frente da porta.
const DEFS := {
	"picape_tonho": {"type": "pickup", "poi": "oficina", "along": 7.0, "side": 3.0, "color": Color(0.55, 0.18, 0.12),
		"fuel": 0.0, "engine": 0.35, "battery": false, "needs": {"pecas_motor": 1, "bateria_carro": 1, "galao_gasolina": 1},
		"storage": [["corda", 1], ["lona", 1]]},
	"viatura_delegacia": {"type": "police", "poi": "delegacia", "along": 8.0, "side": -5.0, "color": Color(0.92, 0.92, 0.94),
		"fuel": 9.0, "engine": 0.6, "battery": true, "storage": [["cassetete", 1], ["bandagem", 2]]},
	"suv_corvalis": {"type": "suv", "poi": "corvalis_hq", "along": 9.0, "side": 4.0, "color": Color(0.06, 0.06, 0.07),
		"fuel": 30.0, "engine": 0.9, "battery": true, "storage": [["racao_militar", 2], ["kit_primeiros_socorros", 1]]},
	"van_estrada": {"type": "van", "poi": "acampamento_estrada", "along": 0.0, "side": 9.0, "color": Color(0.75, 0.74, 0.68),
		"fuel": 4.0, "engine": 0.55, "battery": false, "needs": {"bateria_carro": 1}, "storage": [["lona", 2], ["agua_garrafa", 2]]},
	"hatch_posto": {"type": "hatch", "poi": "posto_vila", "along": 11.0, "side": 6.0, "color": Color(0.2, 0.35, 0.6),
		"fuel": 0.0, "engine": 0.7, "battery": true, "storage": []},
}

var player: Player = null
var world: World = null
var vehicles: Dictionary = {}      # id -> Vehicle (instanciados)
var states: Dictionary = {}        # id -> dados persistidos
var _probes: Array = []            # interações com carros estáticos
var _tick: float = 0.0
var _probe_t: float = 0.0
var _pending_claims: Array = []    # [{"uid", "chunk", "vehicle"}]


func setup(p: Player, w: World) -> void:
	player = p
	world = w
	for i in 4:
		var pr := CarProbe.new()
		pr.manager = self
		add_child(pr)
		pr.enabled = false
		pr.position = Vector3(0, -1000, 0)
		_probes.append(pr)


func _state(id: String) -> Dictionary:
	if states.has(id):
		return states[id]
	if not DEFS.has(id):
		return {}
	var d: Dictionary = DEFS[id]
	var pos := Vector3.ZERO
	var yaw := 0.0
	var poi: String = d["poi"]
	var bi := world.building_for_poi(poi) if world else -1
	if bi >= 0:
		var di := BuildingGen.door_info(world.layout.buildings[bi])
		var p0: Vector3 = di[0]
		var n: Vector3 = di[1]
		var side := n.cross(Vector3.UP)
		pos = p0 + n * float(d["along"]) + side * float(d["side"])
		yaw = atan2(-side.x, -side.z)
	else:
		pos = world.poi_pos(poi) + Vector3(float(d["side"]), 0, float(d["along"]))
	pos.y = world.ground_y(pos.x, pos.z) + 0.25
	var inv := Inventory.new("veh_" + id, 200.0, 30, "Porta-malas")
	for it in d.get("storage", []):
		inv.add(str(it[0]), int(it[1]), 1.0, {}, true)
	var st := {"id": id, "type": d["type"], "color": d["color"], "pos": pos, "yaw": yaw, "fuel": float(d["fuel"]),
		"engine": float(d["engine"]), "battery": bool(d["battery"]), "needs": (d.get("needs", {}) as Dictionary).duplicate(),
		"hp": 100.0, "storage": inv.to_data()}
	states[id] = st
	return st


func _process(delta: float) -> void:
	if player == null or world == null:
		return
	_update_claims()
	_probe_t -= delta
	if _probe_t <= 0.0:
		_probe_t = 0.35
		_update_probes()
	_tick -= delta
	if _tick > 0.0:
		return
	_tick = 1.2
	if GameState.world_phase != GameState.Phase.POST:
		return
	var pp := player.global_position
	var ids := DEFS.keys()
	for id in states.keys():
		if not ids.has(id):
			ids.append(id)
	for id in ids:
		if vehicles.has(id):
			var v: Vehicle = vehicles[id]
			if not is_instance_valid(v):
				vehicles.erase(id)
				continue
			states[id] = v.to_dict()
			if v.driver == null and v.global_position.distance_to(pp) > DESPAWN_R:
				vehicles.erase(id)
				v.queue_free()
		else:
			var st := _state(id)
			if st.is_empty():
				continue
			var sp: Vector3 = st["pos"]
			if not world.is_area_ready(sp, 10.0):
				continue
			if Vector2(sp.x - pp.x, sp.z - pp.z).length() < SPAWN_R:
				_spawn(st)


## Procura um ponto livre (sem prédios/carros estáticos) perto do desejado.
func _free_spot(pos: Vector3, yaw: float, type: String) -> Vector3:
	var d := VehicleMeshBuilder.dims(type)
	var space := get_world_3d().direct_space_state
	var sq := PhysicsShapeQueryParameters3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(float(d["W"]) + 0.3, 1.2, float(d["L"]) + 0.4)
	sq.shape = box
	sq.collision_mask = 1 | (1 << 4)
	for i in 14:
		var ang := float(i) * 2.4
		var r := 0.0 if i == 0 else 1.5 + float(i) * 0.9
		var p := pos + Vector3(cos(ang) * r, 0, sin(ang) * r)
		var ray := PhysicsRayQueryParameters3D.create(p + Vector3(0, 4.0, 0), p + Vector3(0, -6.0, 0), 1)
		var hit := space.intersect_ray(ray)
		if hit.is_empty() or (hit["normal"] as Vector3).y < 0.85:
			continue
		var g: Vector3 = hit["position"]
		sq.transform = Transform3D(Basis(Vector3.UP, yaw), g + Vector3(0, 0.95, 0))
		if space.intersect_shape(sq, 1).is_empty():
			return g + Vector3(0, 0.35, 0)
	return pos


func _spawn(st: Dictionary) -> Vehicle:
	if not bool(st.get("placed", false)):
		st["pos"] = _free_spot(st["pos"], float(st.get("yaw", 0.0)), str(st.get("type", "sedan")))
		st["placed"] = true
	var v := Vehicle.new()
	v.name = "Vehicle_" + str(st["id"])
	add_child(v)
	v.setup(st)
	vehicles[str(st["id"])] = v
	return v


func current_vehicle() -> Vehicle:
	return player.in_vehicle as Vehicle if player else null


# ---------------------------------------------------------------------------
# Carros estáticos
# ---------------------------------------------------------------------------
func _update_probes() -> void:
	var pp := player.global_position
	var near: Array = []
	if player.in_vehicle == null:
		var c := Vector2i(floori(pp.x / WorldLayout.CHUNK), floori(pp.z / WorldLayout.CHUNK))
		for dz in range(-1, 2):
			for dx in range(-1, 2):
				var cc := c + Vector2i(dx, dz)
				if not world.chunks.has(cc):
					continue
				for car in (world.chunks[cc] as Chunk).cars:
					var cp: Vector3 = car["pos"]
					var d2 := cp.distance_squared_to(pp)
					if d2 < 64.0:
						near.append([d2, car, cc])
	near.sort_custom(func(a, b): return a[0] < b[0])
	for i in _probes.size():
		var pr: CarProbe = _probes[i]
		if i < near.size():
			var car: Dictionary = near[i][1]
			if pr.car_uid != str(car["uid"]):
				pr.bind(car, near[i][2])
		elif pr.enabled:
			pr.unbind()


## Ligação direta num carro estático: vira um Vehicle dirigível.
func hotwire(car: Dictionary, chunk: Vector2i) -> void:
	var uid: String = car["uid"]
	var h := Util.hash_str(uid)
	var type: String = car["type"]
	if not Vehicle.TYPES.has(type):
		type = "sedan"
	var st := {"id": uid, "type": type, "color": (car["color"] as Color).lerp(Color(0.35, 0.32, 0.28), 0.35),
		"pos": (car["pos"] as Vector3) + Vector3(0, 0.3, 0), "yaw": float(car["yaw"]),
		"fuel": car_fuel(uid), "engine": 0.4 + float(h % 40) / 100.0, "battery": true, "needs": {}, "hp": 70.0}
	var inv := Inventory.new("veh_" + uid, 100.0, 12, "Porta-malas")
	var cs := GameState.container_state("trunk_" + uid)
	for s in cs.get("items", []):
		inv.add_stack(s, true)
	st["storage"] = inv.to_data()
	states[uid] = st
	world.claim_car(uid, chunk)
	var v := _spawn(st)
	v.freeze = true
	_pending_claims.append({"uid": uid, "chunk": chunk, "vehicle": v, "t": 0.0})
	EventBus.toast("Ligação direta feita. O carro é seu.", "good")
	AudioManager.play_3d("vehicle_start", v.global_position, 0.0)


func _update_claims() -> void:
	for pc in _pending_claims.duplicate():
		var v: Vehicle = pc["vehicle"]
		var c: Vector2i = pc["chunk"]
		pc["t"] = float(pc["t"]) + get_process_delta_time()
		var still := false
		if world.chunks.has(c):
			for car in (world.chunks[c] as Chunk).cars:
				if str(car["uid"]) == str(pc["uid"]):
					still = true
		if not still or float(pc["t"]) > 4.0:
			if is_instance_valid(v):
				v.freeze = false
			_pending_claims.erase(pc)


func car_fuel(uid: String) -> float:
	var key := "carfuel_" + uid
	if GameState.has_flag(key):
		return float(GameState.get_flag(key))
	var h := Util.hash_str(uid)
	return float(h % 100) / 100.0 * 14.0 if h % 3 != 0 else 0.0


func is_hotwirable(uid: String) -> bool:
	return Util.hash_str(uid + "hw") % 100 < 9


func siphon(uid: String) -> void:
	if not player.has_tool("siphon"):
		EventBus.toast("Você precisa de uma mangueira.", "warn")
		return
	if not player.inventory.has("galao_vazio"):
		EventBus.toast("Você precisa de um galão vazio.", "warn")
		return
	var f := car_fuel(uid)
	if f < 1.0:
		EventBus.toast("O tanque está seco.", "info")
		GameState.set_flag("carfuel_" + uid, 0.0)
		return
	var amount := minf(10.0, f)
	GameState.set_flag("carfuel_" + uid, f - amount)
	player.inventory.remove("galao_vazio", 1)
	player.inventory.add("galao_gasolina", 1, 1.0, {"fuel": amount}, true)
	player.use_tool("siphon", 0.02)
	EventBus.toast("Sifonado: %d L de gasolina." % int(amount), "good")
	EventBus.make_noise(player.global_position, 5.0, player, &"siphon")


# ---------------------------------------------------------------------------
# Save
# ---------------------------------------------------------------------------
func to_dict() -> Dictionary:
	for id in vehicles.keys():
		var v: Vehicle = vehicles[id]
		if is_instance_valid(v):
			states[id] = v.to_dict()
	var drv := ""
	if player and player.in_vehicle is Vehicle:
		drv = (player.in_vehicle as Vehicle).vehicle_id
	return {"states": states.duplicate(true), "claimed": world.claimed_cars.duplicate() if world else {}, "driving": drv}


func from_dict(d: Dictionary) -> void:
	for id in vehicles.keys():
		var v: Vehicle = vehicles[id]
		if is_instance_valid(v):
			v.queue_free()
	vehicles.clear()
	states = d.get("states", {})
	if world:
		world.claimed_cars = d.get("claimed", {})
	var drv: String = d.get("driving", "")
	if drv != "" and states.has(drv):
		var v := _spawn(states[drv])
		call_deferred("_reenter", v)


func _reenter(v: Vehicle) -> void:
	if is_instance_valid(v) and player:
		v.enter(player)
