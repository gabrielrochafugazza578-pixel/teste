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


func setup(appearance: Dictionary, w: World, lod: int = 0) -> void:
	world = w
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


func _process(delta: float) -> void:
	var want := 0.0
	var dir := Vector3.ZERO
	if target != Vector3.INF:
		var to := target - global_position
		to.y = 0.0
		if to.length() < 0.25:
			target = Vector3.INF
			if _act_after_walk != "":
				body.play(_act_after_walk, 1.0)
				_act_after_walk = ""
		else:
			dir = to.normalized()
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
