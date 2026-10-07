class_name CineActor
extends Node3D
## Ator de cinemática: o MESMO HumanoidBody do gameplay, movido de forma
## cinemática sobre o chão do mundo (sem física), com LOD de animação pela
## distância até a câmera da cena.

var body: HumanoidBody
var world: World = null
var target: Vector3 = Vector3.INF
var speed: float = 1.4
var yaw: float = 0.0
var face_dir: Vector3 = Vector3.ZERO
var style: String = "human"
var keep_ground: bool = true
var floor_y: float = INF        # interiores: altura fixa do piso
var _cur_speed: float = 0.0
var _infect_from: float = 0.0
var _infect_to: float = 0.0
var _infect_t: float = 0.0
var _infect_dur: float = 0.0
var _act_after_walk: String = ""
# desvio de obstáculos ao andar (móveis, paredes, carros e os outros atores)
var _steer_dir: Vector3 = Vector3.ZERO
var _probe: PhysicsShapeQueryParameters3D
const STEER_ANGLES := [0.0, 22.0, -22.0, 45.0, -45.0, 70.0, -70.0, 100.0, -100.0, 140.0, -140.0]


func setup(appearance: Dictionary, w: World, lod: int = 0) -> void:
	world = w
	add_to_group("cine_actor")
	body = HumanoidBody.new()
	add_child(body)
	body.setup(appearance, lod)
	_infect_from = float(appearance.get("infected", 0.0))
	_infect_to = _infect_from


func place(p: Vector3, y: float) -> void:
	global_position = p
	yaw = y
	body.rotation.y = y
	target = Vector3.INF
	if absf(p.y - (world.ground_y(p.x, p.z) if world else p.y)) > 1.0:
		floor_y = p.y


func walk_to(p: Vector3, spd: float, then_anim: String = "") -> void:
	target = p
	speed = spd
	_act_after_walk = then_anim
	if body.animator.is_playing() and not body.animator.is_playing("panic"):
		body.stop_action()


func face(p: Vector3) -> void:
	var d := p - global_position
	d.y = 0.0
	if d.length() > 0.01:
		face_dir = d.normalized()


func play(anim: String, spd: float = 1.0) -> void:
	body.play(anim, spd)


func infect(to: float, dur: float) -> void:
	_infect_from = _infect_to if _infect_dur <= 0.0 else lerpf(_infect_from, _infect_to, clampf(_infect_t / _infect_dur, 0.0, 1.0))
	_infect_to = to
	_infect_t = 0.0
	_infect_dur = maxf(dur, 0.01)


## Direção livre mais próxima da desejada: sonda à frente (joelho e peito) em
## leque; afasta-se dos outros atores. Sem isso o ator andava em linha reta
## atravessando bancadas, mesas, carros e as outras pessoas.
func _steer(want: Vector3) -> Vector3:
	if not is_inside_tree():
		return want
	# longe da câmera ninguém repara: economiza as sondagens
	var cam := get_viewport().get_camera_3d()
	if cam and cam.global_position.distance_to(global_position) > 60.0:
		return want
	var space := get_world_3d().direct_space_state
	if _probe == null:
		_probe = PhysicsShapeQueryParameters3D.new()
		var sh := SphereShape3D.new()
		sh.radius = 0.24
		_probe.shape = sh
		_probe.collision_mask = 1 | (1 << 3) | (1 << 4)
	var best := Vector3.ZERO
	var best_cost := INF
	var prev := _steer_dir if _steer_dir != Vector3.ZERO else want
	for ang: float in STEER_ANGLES:
		var d := want.rotated(Vector3.UP, deg_to_rad(ang))
		var free := true
		for dist: float in [0.32, 0.65]:
			for hy: float in [0.45, 1.15]:
				_probe.transform = Transform3D(Basis(), global_position + d * dist + Vector3(0, hy, 0))
				if not space.intersect_shape(_probe, 1).is_empty():
					free = false
					break
			if not free:
				break
		if free:
			var cost := absf(ang) + rad_to_deg(d.angle_to(prev)) * 0.5
			if cost < best_cost:
				best_cost = cost
				best = d
	if best == Vector3.ZERO:
		best = want
	# separação dos outros atores (ninguém atravessa ninguém)
	for o in get_tree().get_nodes_in_group("cine_actor"):
		if o == self or not (o is Node3D):
			continue
		var off := global_position - (o as Node3D).global_position
		off.y = 0.0
		var dd := off.length()
		if dd > 0.01 and dd < 0.85:
			best += off / dd * (0.85 - dd) * 2.2
	best.y = 0.0
	best = best.normalized() if best.length() > 0.01 else want
	_steer_dir = best if _steer_dir == Vector3.ZERO else _steer_dir.slerp(best, 0.35).normalized()
	return _steer_dir


func _process(delta: float) -> void:
	var want := 0.0
	var dir := Vector3.ZERO
	if target != Vector3.INF:
		var to := target - global_position
		to.y = 0.0
		if to.length() < 0.25:
			target = Vector3.INF
			_steer_dir = Vector3.ZERO
			if _act_after_walk != "":
				body.play(_act_after_walk, 1.0)
				_act_after_walk = ""
		else:
			dir = _steer(to.normalized())
			want = speed * clampf(to.length() / 0.8, 0.3, 1.0)
	_cur_speed = move_toward(_cur_speed, want, delta * 6.0)
	if dir != Vector3.ZERO:
		global_position += dir * _cur_speed * delta
		yaw = lerp_angle(yaw, atan2(-dir.x, -dir.z), 1.0 - exp(-delta * 8.0))
		face_dir = Vector3.ZERO
	elif face_dir != Vector3.ZERO:
		yaw = lerp_angle(yaw, atan2(-face_dir.x, -face_dir.z), 1.0 - exp(-delta * 4.0))
	if keep_ground and world:
		if floor_y != INF:
			global_position.y = floor_y
		else:
			global_position.y = world.ground_y(global_position.x, global_position.z)
	body.rotation.y = yaw
	var a := body.animator
	a.speed = _cur_speed
	a.forward_speed = _cur_speed
	a.style = style if _cur_speed < 2.2 or style != "human" else "human"
	if _infect_dur > 0.0:
		_infect_t += delta
		body.set_infection(lerpf(_infect_from, _infect_to, clampf(_infect_t / _infect_dur, 0.0, 1.0)))
	# LOD de animação pela câmera ativa
	var cam := get_viewport().get_camera_3d()
	if cam:
		var d := cam.global_position.distance_to(global_position)
		body.anim_interval = 0.0 if d < 22.0 else (1.0 / 20.0 if d < 50.0 else 1.0 / 8.0)
		body.visible = d < 160.0
	body.tick(delta)
