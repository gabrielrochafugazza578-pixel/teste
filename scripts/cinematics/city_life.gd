class_name CityLife
extends Node3D
## Vida urbana da cidade ANTES do colapso (usada pela abertura): trânsito na
## avenida (carros, ônibus, táxis), pedestres nas calçadas, multidões em
## pânico e fila no hospital. Tudo cinemático e barato: malhas compartilhadas,
## sem física, animação com LOD — nada disso existe no gameplay.

const AV_HW := 7.0            # meia largura da Avenida Central (x = 0)
const SIDEWALK_X := 8.75
const SPAN := 160.0

var world: World
var anchor: Vector3 = Vector3.ZERO
var mode: String = "normal"   # normal | panic | hospital | off
var cars: Array = []           # [{"node", "lane_x", "dir", "speed", "z"}]
var peds: Array = []           # [{"actor", "dir", "x", "speed"}]
var crowd_target: Vector3 = Vector3.INF
var _rng := RandomNumberGenerator.new()
var _horn_t: float = 3.0
var _car_mats: Dictionary = {}


func setup(w: World) -> void:
	world = w
	_rng.seed = 4242


func clear_all() -> void:
	for c in cars:
		(c["node"] as Node).queue_free()
	cars.clear()
	for p in peds:
		(p["actor"] as Node).queue_free()
	peds.clear()


# ---------------------------------------------------------------------------
# Trânsito
# ---------------------------------------------------------------------------
func set_traffic(on: bool, at: Vector3, panic: bool = false) -> void:
	for c in cars:
		(c["node"] as Node).queue_free()
	cars.clear()
	if not on:
		return
	anchor = at
	var types := ["sedan", "hatch", "compact", "taxi", "suv", "sedan", "van", "pickup", "hatch", "sedan", "bus", "compact", "taxi", "sedan"]
	var n := 16 if not panic else 20
	for i in n:
		var dir := 1.0 if i % 2 == 0 else -1.0
		var lane := (1.75 if _rng.randf() < 0.5 else 5.25) * dir
		var type: String = types[i % types.size()]
		if type == "bus":
			lane = 5.25 * dir
		var mi := MeshInstance3D.new()
		mi.mesh = VehicleMeshBuilder.mesh(type)
		var col := Color.from_hsv(_rng.randf(), _rng.randf_range(0.1, 0.7), _rng.randf_range(0.3, 0.9))
		if type == "taxi":
			col = Color(0.95, 0.8, 0.15)
		elif type == "bus":
			col = Color(0.85, 0.85, 0.82)
		mi.set_surface_override_material(0, _paint(col))
		add_child(mi)
		var z := anchor.z + _rng.randf_range(-SPAN, SPAN)
		var spd := _rng.randf_range(8.0, 13.0) if not panic else _rng.randf_range(12.0, 18.0)
		if type == "bus":
			spd = 7.5
		cars.append({"node": mi, "lane_x": anchor.x + lane, "dir": dir, "speed": spd, "z": z, "type": type, "len": float(VehicleMeshBuilder.dims(type)["L"])})


func _paint(c: Color) -> StandardMaterial3D:
	var key := c.to_html(false)
	if _car_mats.has(key):
		return _car_mats[key]
	var m := StandardMaterial3D.new()
	m.albedo_color = c
	m.metallic = 0.35
	m.roughness = 0.3
	_car_mats[key] = m
	return m


# ---------------------------------------------------------------------------
# Pedestres
# ---------------------------------------------------------------------------
func set_crowd(m: String, at: Vector3, frame: Transform3D = Transform3D.IDENTITY) -> void:
	for p in peds:
		(p["actor"] as Node).queue_free()
	peds.clear()
	mode = m
	anchor = at
	if m == "off":
		return
	var n := 26 if m != "hospital" else 18
	for i in n:
		var a := CineActor.new()
		add_child(a)
		var seed_v := 500 + i * 7
		var ap := Appearance.civilian(seed_v)
		if m == "hospital" and i % 6 == 0:
			ap = Appearance.paramedic(seed_v)
		a.setup(ap, world, 1)
		var side := -1.0 if i % 2 == 0 else 1.0
		var x := anchor.x + side * (SIDEWALK_X + _rng.randf_range(-1.2, 1.2))
		var z := anchor.z + _rng.randf_range(-70.0, 70.0)
		var dir := 1.0 if _rng.randf() < 0.5 else -1.0
		var spd := _rng.randf_range(1.1, 1.6)
		match m:
			"panic":
				dir = 1.0 if _rng.randf() < 0.8 else -1.0
				spd = _rng.randf_range(3.8, 5.6)
				a.style = "human"
				x = anchor.x + _rng.randf_range(-AV_HW - 3.0, AV_HW + 3.0)
			"hospital":
				var off := Vector3(_rng.randf_range(-9.0, 9.0), 0, _rng.randf_range(3.0, 12.0))
				var p := frame * off
				x = p.x
				z = p.z
				spd = _rng.randf_range(0.8, 1.2)
		a.place(Vector3(x, 0, z), 0.0 if dir < 0.0 else PI)
		var still := m == "normal" and _rng.randf() < 0.25
		if still:
			a.play(["phone", "gaze", "look_around"][_rng.randi() % 3])
		elif m == "panic" and _rng.randf() < 0.3:
			a.play("run_scared")
		var target := Vector3.INF
		if m == "hospital":
			target = frame * Vector3(_rng.randf_range(-1.5, 1.5), 0, 0.6)
		peds.append({"actor": a, "dir": dir, "x": x, "speed": spd, "still": still, "target": target})
		if target != Vector3.INF:
			a.walk_to(target, spd)


## Pessoas saindo de uma porta carregando caixas (saque do mercado).
func crowd_at(frame: Transform3D, anim: String, n: int) -> Array:
	var out: Array = []
	for i in n:
		var a := CineActor.new()
		add_child(a)
		a.setup(Appearance.civilian(900 + i * 13), world, 1)
		var start := frame * Vector3(_rng.randf_range(-1.0, 1.0), 0, -0.5 - i * 0.8)
		a.place(start, 0.0)
		var dest := frame * Vector3(_rng.randf_range(-10.0, 10.0), 0, _rng.randf_range(8.0, 14.0))
		a.walk_to(dest, _rng.randf_range(2.2, 3.4))
		if anim == "carry":
			a.play("carry_box")
		out.append(a)
	return out


func anim_crowd(anim: String) -> void:
	var k := 0
	for p in peds:
		k += 1
		if k % 3 == 0:
			(p["actor"] as CineActor).play(anim)


func _process(delta: float) -> void:
	var cam := get_viewport().get_camera_3d()
	var cp := cam.global_position if cam else anchor
	for c in cars:
		var z: float = float(c["z"]) + float(c["dir"]) * float(c["speed"]) * delta
		if z > anchor.z + SPAN:
			z -= SPAN * 2.0
		elif z < anchor.z - SPAN:
			z += SPAN * 2.0
		c["z"] = z
		var mi: MeshInstance3D = c["node"]
		var x: float = c["lane_x"]
		var y := world.ground_y(x, z) if world else 0.0
		mi.global_position = Vector3(x, y, z)
		mi.rotation.y = 0.0 if float(c["dir"]) < 0.0 else PI
		mi.visible = cp.distance_to(mi.global_position) < 240.0
	_horn_t -= delta
	if _horn_t <= 0.0 and not cars.is_empty():
		_horn_t = _rng.randf_range(2.0, 6.0) if mode != "panic" else _rng.randf_range(0.6, 1.8)
		var c: Dictionary = cars[_rng.randi() % cars.size()]
		AudioManager.play_3d("car_horn", (c["node"] as Node3D).global_position, -10.0 if mode != "panic" else -4.0, _rng.randf_range(0.9, 1.1), 80.0)
	for p in peds:
		var a: CineActor = p["actor"]
		if bool(p["still"]) or p["target"] != Vector3.INF:
			continue
		if a.target == Vector3.INF:
			var z := a.global_position.z + float(p["dir"]) * 40.0
			if absf(z - anchor.z) > 75.0:
				p["dir"] = -float(p["dir"])
				z = a.global_position.z + float(p["dir"]) * 40.0
			a.walk_to(Vector3(float(p["x"]), 0, z), float(p["speed"]))
