class_name Vehicle
extends RigidBody3D
## Veículo dirigível com suspensão por raycast (independe do motor de física),
## combustível, condição do motor, lataria, bateria, porta-malas, faróis,
## buzina, ruído que atrai infectados, dano por colisão e atropelamento.
##
## LOD de física: parado e longe do jogador o corpo é congelado (sem custo);
## só o veículo dirigido e os próximos simulam.

const TYPES := {
	"compact": {"mass": 950.0, "engine": 5200.0, "top": 34.0, "grip": 1.0, "fuel_max": 38.0, "drive": "front", "slots": 8, "cap": 60.0},
	"hatch": {"mass": 1050.0, "engine": 5800.0, "top": 36.0, "grip": 1.0, "fuel_max": 42.0, "drive": "front", "slots": 10, "cap": 80.0},
	"sedan": {"mass": 1250.0, "engine": 7200.0, "top": 42.0, "grip": 1.05, "fuel_max": 50.0, "drive": "front", "slots": 14, "cap": 110.0},
	"police": {"mass": 1350.0, "engine": 8600.0, "top": 46.0, "grip": 1.1, "fuel_max": 55.0, "drive": "rear", "slots": 12, "cap": 100.0},
	"suv": {"mass": 1800.0, "engine": 9500.0, "top": 40.0, "grip": 1.15, "fuel_max": 65.0, "drive": "all", "slots": 18, "cap": 160.0},
	"pickup": {"mass": 1900.0, "engine": 9800.0, "top": 38.0, "grip": 1.15, "fuel_max": 70.0, "drive": "all", "slots": 24, "cap": 260.0},
	"van": {"mass": 2000.0, "engine": 8800.0, "top": 34.0, "grip": 0.95, "fuel_max": 70.0, "drive": "rear", "slots": 30, "cap": 320.0},
}

var vehicle_id: String = ""
var type: String = "sedan"
var spec: Dictionary = {}
var dims: Dictionary = {}
var paint: Color = Color(0.5, 0.5, 0.5)
var fuel: float = 20.0
var fuel_max: float = 50.0
var engine_cond: float = 1.0      # 0..1 — abaixo de 0.15 não liga
var body_hp: float = 100.0
var battery: bool = true
var needs_repair: Dictionary = {}  # item -> qtd (para veículos quebrados)
var storage: Inventory
var driver: Player = null
var engine_on: bool = false
var lights_on: bool = false
var steer: float = 0.0
var throttle: float = 0.0
var brake: float = 0.0
var handbrake: bool = false
var speed_kmh: float = 0.0
var rpm: float = 0.0
var sim_active: bool = true

var _wheels: Array = []           # [{"pos": Vector3 local, "front": bool, "drive": bool, "node": Node3D, "spin": float, "comp": float}]
var _body_mesh: MeshInstance3D
var _head_l: SpotLight3D
var _head_r: SpotLight3D
var _engine_snd: AudioStreamPlayer3D
var _noise_t: float = 0.0
var _impact_cd: float = 0.0
var _last_vel := Vector3.ZERO
var _idle_t: float = 0.0
var _enter_area: VehicleDoor
var _trunk_area: VehicleTrunk
var _horn_cd: float = 0.0

const REST := 0.42
const SPRING := 3.2     # multiplica massa*g/4
const DAMP := 0.55


func setup(d: Dictionary) -> void:
	vehicle_id = d["id"]
	type = d.get("type", "sedan")
	spec = TYPES.get(type, TYPES["sedan"])
	dims = VehicleMeshBuilder.dims(type)
	paint = d.get("color", Color(0.5, 0.5, 0.5))
	fuel_max = float(spec["fuel_max"])
	fuel = float(d.get("fuel", fuel_max * 0.3))
	engine_cond = float(d.get("engine", 0.8))
	body_hp = float(d.get("hp", 100.0))
	battery = bool(d.get("battery", true))
	needs_repair = d.get("needs", {})
	mass = float(spec["mass"])
	collision_layer = 1 << 4
	collision_mask = 1 | (1 << 1) | (1 << 2) | (1 << 3) | (1 << 4)
	can_sleep = true
	continuous_cd = true
	contact_monitor = true
	max_contacts_reported = 4
	linear_damp = 0.05
	angular_damp = 0.6
	center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	center_of_mass = Vector3(0, float(dims["base"]) + 0.25, 0.0)
	body_entered.connect(_on_body_entered)
	_build()
	storage = Inventory.new("veh_" + vehicle_id, float(spec["cap"]), int(spec["slots"]), "Porta-malas")
	var st: Dictionary = d.get("storage", {})
	if not st.is_empty():
		storage.from_data(st)
	global_position = d["pos"]
	rotation.y = float(d.get("yaw", 0.0))


func _build() -> void:
	var L: float = dims["L"]
	var W: float = dims["W"]
	var wr: float = dims["wr"]
	var wb: float = dims["wb"]
	var base: float = dims["base"]
	var deck: float = dims["deck"]
	var roof: float = dims["roof"]
	# colisão: chassi + cabine
	var cs := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(W, deck - base + 0.1, L)
	cs.shape = box
	cs.position = Vector3(0, (deck + base) * 0.5 + 0.05, 0)
	add_child(cs)
	var cs2 := CollisionShape3D.new()
	var box2 := BoxShape3D.new()
	box2.size = Vector3(W * 0.9, roof - deck, L * 0.45)
	cs2.shape = box2
	cs2.position = Vector3(0, (roof + deck) * 0.5, -float(dims["hood"]) * 0.1)
	add_child(cs2)
	_body_mesh = MeshInstance3D.new()
	_body_mesh.mesh = VehicleMeshBuilder.mesh(type, false, false)
	add_child(_body_mesh)
	var paint_mat := (_body_mesh.mesh.surface_get_material(0) as StandardMaterial3D).duplicate() as StandardMaterial3D
	paint_mat.albedo_color = paint
	_body_mesh.set_surface_override_material(0, paint_mat)
	var hw := W * 0.5
	for wz: float in [-wb * 0.5, wb * 0.5]:
		for sgn: float in [-1.0, 1.0]:
			var wn := Node3D.new()
			add_child(wn)
			var wm := MeshInstance3D.new()
			wm.mesh = VehicleMeshBuilder.wheel_mesh(type)
			wm.scale = Vector3(sgn, 1.0, 1.0)
			wn.add_child(wm)
			var front := wz < 0.0
			var drive_mode: String = spec["drive"]
			var drives := drive_mode == "all" or (drive_mode == "front" and front) or (drive_mode == "rear" and not front)
			var p := Vector3((hw - 0.12) * sgn, wr, wz)
			wn.position = p
			_wheels.append({"pos": p, "front": front, "drive": drives, "node": wn, "spin": 0.0, "comp": 0.0, "side": sgn})
	# faróis
	for sgn: float in [-1.0, 1.0]:
		var sl := SpotLight3D.new()
		sl.spot_range = 38.0
		sl.spot_angle = 32.0
		sl.light_energy = 3.0
		sl.light_color = Color(1.0, 0.95, 0.82)
		sl.position = Vector3(hw * 0.72 * sgn, deck - 0.3, -L * 0.5 - 0.05)
		sl.rotation.x = -0.08
		sl.visible = false
		sl.shadow_enabled = false
		add_child(sl)
		if sgn < 0.0:
			_head_l = sl
		else:
			_head_r = sl
	# interação
	_enter_area = VehicleDoor.new()
	_enter_area.vehicle = self
	add_child(_enter_area)
	_enter_area.add_shape(Vector3(1.2, 1.6, 1.6), Vector3(-hw - 0.4, 0.9, -0.3))
	_trunk_area = VehicleTrunk.new()
	_trunk_area.vehicle = self
	add_child(_trunk_area)
	_trunk_area.add_shape(Vector3(W * 0.8, 1.2, 1.0), Vector3(0, 0.8, L * 0.5 + 0.4))


# ---------------------------------------------------------------------------
# Estado
# ---------------------------------------------------------------------------
func is_broken() -> bool:
	return not needs_repair.is_empty() or engine_cond < 0.15 or not battery


func can_start() -> bool:
	return not is_broken() and fuel > 0.05 and body_hp > 0.0


func seat_position() -> Vector3:
	return global_transform * Vector3(-float(dims["W"]) * 0.22, float(dims["base"]) + 0.05, -0.15)


func exit_position() -> Vector3:
	var side := global_transform.basis.x.normalized()
	var p := global_position - side * (float(dims["W"]) * 0.5 + 0.9)
	var space := get_world_3d().direct_space_state
	var q := PhysicsRayQueryParameters3D.create(p + Vector3(0, 2.0, 0), p + Vector3(0, -3.0, 0), 1)
	var hit := space.intersect_ray(q)
	if not hit.is_empty():
		p = hit["position"]
	# lado bloqueado? sai pelo outro
	var sq := PhysicsShapeQueryParameters3D.new()
	var cap := CapsuleShape3D.new()
	cap.radius = 0.35
	cap.height = 1.7
	sq.shape = cap
	sq.transform = Transform3D(Basis(), p + Vector3(0, 0.95, 0))
	sq.collision_mask = 1 | (1 << 4)
	sq.exclude = [get_rid()]
	if not space.intersect_shape(sq, 1).is_empty():
		p = global_position + side * (float(dims["W"]) * 0.5 + 0.9)
	return p + Vector3(0, 0.05, 0)


func enter(p: Player) -> void:
	driver = p
	sim_active = true
	freeze = false
	sleeping = false
	p.enter_vehicle(self)
	try_start()


func try_start() -> void:
	if engine_on:
		return
	if not can_start():
		AudioManager.play_3d("door_locked", global_position, -4.0, 0.6)
		if fuel <= 0.05:
			EventBus.toast("Sem combustível.", "warn")
		elif not battery:
			EventBus.toast("A bateria está morta.", "warn")
		else:
			EventBus.toast("O motor não pega. Precisa de conserto.", "warn")
		return
	engine_on = true
	AudioManager.play_3d("vehicle_start", global_position, 0.0)
	EventBus.make_noise(global_position, 30.0, self, &"engine")
	if _engine_snd == null:
		_engine_snd = AudioManager.attach_loop("car_engine", self, -6.0, 70.0)
	else:
		_engine_snd.play()


func on_driver_exit() -> void:
	driver = null
	throttle = 0.0
	steer = 0.0
	brake = 1.0
	engine_on = false
	if _engine_snd:
		_engine_snd.stop()
	set_lights(false)


func set_lights(on: bool) -> void:
	lights_on = on
	_head_l.visible = on
	_head_r.visible = on


func refuel_from_can(p: Player) -> bool:
	var s := p.inventory.find("galao_gasolina")
	if s.is_empty():
		return false
	var amount := float((s.get("data", {}) as Dictionary).get("fuel", 10.0))
	var add := minf(amount, fuel_max - fuel)
	if add <= 0.1:
		EventBus.toast("O tanque já está cheio.", "info")
		return false
	fuel += add
	var left := amount - add
	p.inventory.remove("galao_gasolina", 1)
	if left > 0.5:
		p.inventory.add("galao_gasolina", 1, 1.0, {"fuel": left}, true)
	else:
		p.inventory.add("galao_vazio", 1, 1.0, {}, true)
	EventBus.toast("Abastecido: +%d L (%d/%d L)" % [int(add), int(fuel), int(fuel_max)], "good")
	AudioManager.play_3d("drink", global_position, -6.0, 0.6)
	return true


## Conserto: consome as peças exigidas (ou sucata/fita para dano leve).
func repair(p: Player) -> bool:
	if not p.has_tool("wrench"):
		EventBus.toast("Você precisa de uma chave inglesa.", "warn")
		return false
	if not needs_repair.is_empty():
		var missing: Array = []
		for it in needs_repair.keys():
			if p.inventory.count(it) < int(needs_repair[it]):
				missing.append("%s x%d" % [ItemDB.item_name(it), int(needs_repair[it])])
		if not missing.is_empty():
			EventBus.toast("Faltam peças: " + ", ".join(missing), "warn")
			return false
		for it in needs_repair.keys():
			var n := int(needs_repair[it])
			if it == "galao_gasolina":
				for k in n:
					refuel_from_can(p)
			else:
				p.inventory.remove(it, n)
			if it == "bateria_carro":
				battery = true
		needs_repair = {}
		engine_cond = maxf(engine_cond, 0.75)
	else:
		if p.inventory.count("sucata") < 2 or p.inventory.count("fita_adesiva") < 1:
			EventBus.toast("Reparo leve: 2 sucatas e 1 fita adesiva.", "warn")
			return false
		p.inventory.remove("sucata", 2)
		p.inventory.remove("fita_adesiva", 1)
		engine_cond = minf(1.0, engine_cond + 0.3)
		body_hp = minf(100.0, body_hp + 25.0)
	if not battery and p.inventory.has("bateria_carro"):
		p.inventory.remove("bateria_carro", 1)
		battery = true
	p.use_tool("wrench", 0.05)
	AudioManager.play_3d("metal_clang", global_position, -2.0)
	EventBus.make_noise(global_position, 14.0, p, &"repair")
	EventBus.toast("Veículo consertado.", "good")
	EventBus.vehicle_repaired.emit(vehicle_id)
	return true


# ---------------------------------------------------------------------------
# Simulação
# ---------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	_impact_cd = maxf(0.0, _impact_cd - delta)
	_horn_cd = maxf(0.0, _horn_cd - delta)
	var focus := SimScheduler.focus_position
	var dist := global_position.distance_to(focus)
	# LOD de física
	if driver == null:
		var slow := linear_velocity.length() < 0.2
		if slow:
			_idle_t += delta
		else:
			_idle_t = 0.0
		var want_freeze := (dist > 60.0 and slow) or (_idle_t > 3.0 and slow and dist > 12.0)
		if want_freeze != freeze:
			freeze = want_freeze
		if freeze:
			return
	_read_input(delta)
	_simulate(delta)
	_update_visuals(delta)
	_last_vel = linear_velocity


func _read_input(delta: float) -> void:
	if driver == null:
		throttle = 0.0
		steer = move_toward(steer, 0.0, delta * 3.0)
		brake = 0.6
		handbrake = false
		return
	if driver.survival.dead:
		driver.exit_vehicle()
		return
	var fwd := Input.get_action_strength("move_forward")
	var back := Input.get_action_strength("move_back")
	var st := Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	var v_fwd := -global_transform.basis.z.dot(linear_velocity)
	throttle = 0.0
	brake = 0.0
	if fwd > 0.05:
		if v_fwd < -1.0:
			brake = fwd
		else:
			throttle = fwd
	elif back > 0.05:
		if v_fwd > 1.0:
			brake = back
		else:
			throttle = -back * 0.5
	handbrake = Input.is_action_pressed("handbrake")
	var steer_speed := 2.2 if absf(st) > 0.05 else 3.5
	var max_steer := lerpf(0.55, 0.18, clampf(absf(v_fwd) / 30.0, 0.0, 1.0))
	steer = move_toward(steer, st * max_steer, delta * steer_speed)
	if Input.is_action_just_pressed("horn") and _horn_cd <= 0.0:
		_horn_cd = 0.8
		AudioManager.play_3d("car_horn", global_position, 2.0)
		EventBus.make_noise(global_position, 80.0, self, &"horn")
	if Input.is_action_just_pressed("flashlight"):
		set_lights(not lights_on)
	if not engine_on:
		throttle = 0.0
		if Input.is_action_just_pressed("move_forward"):
			try_start()


func _simulate(delta: float) -> void:
	var space := get_world_3d().direct_space_state
	var xf := global_transform
	var up := xf.basis.y.normalized()
	var g := 9.8
	var k := mass * g / 4.0 * SPRING / REST
	var c := 2.0 * sqrt(k * mass / 4.0) * DAMP
	var wr: float = dims["wr"]
	var grounded := 0
	var top := float(spec["top"]) * lerpf(0.55, 1.0, engine_cond)
	var v_fwd := -xf.basis.z.dot(linear_velocity)
	var eng := float(spec["engine"]) * lerpf(0.5, 1.0, engine_cond)
	if absf(v_fwd) > top:
		eng = 0.0
	var n_drive := 0
	for w in _wheels:
		if w["drive"]:
			n_drive += 1
	for w in _wheels:
		var local: Vector3 = w["pos"]
		var mount := xf * (local + Vector3(0, REST, 0))
		var q := PhysicsRayQueryParameters3D.create(mount, mount - up * (REST + wr), 1)
		q.exclude = [get_rid()]
		var hit := space.intersect_ray(q)
		if hit.is_empty():
			w["comp"] = move_toward(float(w["comp"]), 0.0, delta * 4.0)
			continue
		grounded += 1
		var hp: Vector3 = hit["position"]
		var dist := mount.distance_to(hp) - wr
		var comp := clampf(REST - dist, 0.0, REST)
		w["comp"] = comp
		var r := hp - global_position
		var pv := linear_velocity + angular_velocity.cross(r)
		var susp_v := pv.dot(up)
		# pré-carga: com a mola na posição nominal cada roda sustenta 1/4 do peso
		var fz := maxf(0.0, k * comp + mass * g * 0.25 - c * susp_v)
		apply_force(up * fz, r)
		# direções da roda
		var fdir := -xf.basis.z
		var rdir := xf.basis.x
		if w["front"]:
			fdir = fdir.rotated(up, steer)
			rdir = rdir.rotated(up, steer)
		var n: Vector3 = hit["normal"]
		fdir = (fdir - n * fdir.dot(n)).normalized()
		rdir = (rdir - n * rdir.dot(n)).normalized()
		var v_long := pv.dot(fdir)
		var v_lat := pv.dot(rdir)
		var grip := float(spec["grip"]) * (1.0 - WeatherManager.rain * 0.25) * (0.35 if handbrake and not w["front"] else 1.0)
		var mu_max := fz * 1.1 * grip
		# lateral (anti-derrapagem)
		var f_lat := clampf(-v_lat * (mass / 4.0) / delta * 0.35, -mu_max, mu_max)
		# longitudinal: motor, freio, resistência
		var f_long := 0.0
		if w["drive"] and fuel > 0.0:
			f_long += eng * throttle / float(maxi(n_drive, 1))
		var b := brake * 9000.0 / 4.0 + (5500.0 if handbrake and not w["front"] else 0.0)
		if absf(v_long) > 0.05:
			f_long -= signf(v_long) * minf(b, absf(v_long) * mass * 2.0)
		else:
			f_long -= v_long * mass * 0.5
		f_long -= v_long * 18.0
		f_long = clampf(f_long, -mu_max * 1.2, mu_max * 1.2)
		apply_force(fdir * f_long + rdir * f_lat, r)
		w["spin"] = float(w["spin"]) + v_long / maxf(wr, 0.1) * delta
	# consumo e ruído
	speed_kmh = absf(v_fwd) * 3.6
	rpm = clampf(absf(v_fwd) / maxf(top, 1.0), 0.0, 1.0) * 0.8 + absf(throttle) * 0.2
	if engine_on:
		fuel = maxf(0.0, fuel - delta * (0.0015 + absf(throttle) * 0.012) * (1.0 + (1.0 - engine_cond)))
		if fuel <= 0.0:
			engine_on = false
			if _engine_snd:
				_engine_snd.stop()
			EventBus.toast("O combustível acabou.", "warn")
		_noise_t -= delta
		if _noise_t <= 0.0:
			_noise_t = 1.0
			EventBus.make_noise(global_position, 22.0 + rpm * 30.0, self, &"engine")
		if _engine_snd:
			_engine_snd.pitch_scale = 0.7 + rpm * 0.9
	# estabilizador contra capotamento
	if grounded < 2 and up.y < 0.4 and driver != null and linear_velocity.length() < 1.0:
		apply_torque(xf.basis.z * -up.x * mass * 3.0)


func _run_over(inf: Infected, v: float) -> void:
	if not inf.is_alive() or _impact_cd > 0.0:
		return
	_impact_cd = 0.25
	var info := DamageInfo.make(v * 9.0, "heavy", driver if driver else self, linear_velocity)
	info.knockback = v * 0.6
	info.stagger = 1.0
	info.blockable = false
	inf.receive_hit(info)
	body_hp = maxf(0.0, body_hp - v * 0.3)
	AudioManager.play_3d("hit_flesh", inf.global_position + Vector3(0, 1.0, 0), 2.0)


func _on_body_entered(b: Node) -> void:
	var dv := (_last_vel - linear_velocity).length()
	if dv < 3.0 or _impact_cd > 0.0:
		return
	_impact_cd = 0.4
	if b is Infected:
		_run_over(b as Infected, dv)
		return
	if b is SurvivorNPC or b is Player:
		var info := DamageInfo.make(dv * 6.0, "heavy", driver if driver else self, _last_vel)
		info.knockback = dv * 0.5
		info.stagger = 1.0
		info.blockable = false
		b.receive_hit(info)
		return
	var dmg := (dv - 3.0) * 2.2
	body_hp = maxf(0.0, body_hp - dmg)
	engine_cond = maxf(0.0, engine_cond - dmg * 0.004)
	AudioManager.play_3d("car_crash", global_position, clampf(dv * 0.6 - 6.0, -8.0, 6.0))
	EventBus.make_noise(global_position, 20.0 + dv * 4.0, self, &"crash")
	if driver:
		driver.cam_rig.add_shake(clampf(dv * 0.06, 0.1, 0.8))
		if dv > 14.0:
			driver.survival.damage((dv - 14.0) * 2.5, "blunt")
	if body_hp <= 0.0 and engine_on:
		engine_on = false
		engine_cond = 0.0
		EventBus.toast("O motor morreu com a batida.", "warn")


func _update_visuals(delta: float) -> void:
	var wr: float = dims["wr"]
	for w in _wheels:
		var wn: Node3D = w["node"]
		var local: Vector3 = w["pos"]
		wn.position = Vector3(local.x, wr + float(w["comp"]) - 0.02, local.z)
		var yaw_w := steer if w["front"] else 0.0
		wn.basis = Basis(Vector3.UP, yaw_w) * Basis(Vector3.RIGHT, -float(w["spin"]))


func hud_info() -> Dictionary:
	return {"speed": speed_kmh, "fuel": fuel, "fuel_max": fuel_max, "engine": engine_cond, "hp": body_hp, "on": engine_on, "lights": lights_on}


func to_dict() -> Dictionary:
	return {"id": vehicle_id, "type": type, "color": paint, "pos": global_position, "yaw": global_rotation.y, "placed": true,
		"fuel": fuel, "engine": engine_cond, "hp": body_hp, "battery": battery, "needs": needs_repair, "storage": storage.to_data()}
