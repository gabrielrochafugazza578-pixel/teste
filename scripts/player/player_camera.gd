class_name PlayerCamera
extends Node3D
## Câmera de terceira pessoa sobre o ombro (SpringArm contra paredes),
## modo veículo, tremor configurável (acessibilidade) e balanço de passos.

var target: Node3D
var yaw: float = 0.0
var pitch: float = -0.12
var spring: SpringArm3D
var cam: Camera3D
var pivot: Node3D
var mode: String = "follow"
var input_enabled: bool = true
var shake: float = 0.0
var aim: float = 0.0
var aim_target: float = 0.0
var sprint_fov: float = 0.0
var aim_zoom: float = 1.0      # zoom extra ao mirar (luneta/mira da arma)
var crouch_amount: float = 0.0
var bob_phase: float = 0.0
var bob_amount: float = 0.0
var height: float = 1.58
var shoulder: float = 0.42
var arm_length: float = 2.65
var _smoothed_pos := Vector3.ZERO
## 1ª pessoa: câmera nos olhos do Caio (corpo visível, cabeça escondida).
var first_person: bool = false
var fp: float = 0.0            # 0 = ombro, 1 = olhos (transição suave)
var assist: float = 1.0        # <1 freia a mira do controle perto de um alvo
var _look_boost: float = 0.0
var _vehicle_idle: float = 0.0
var _noise := FastNoiseLite.new()
var _t: float = 0.0


func _ready() -> void:
	top_level = true
	pivot = Node3D.new()
	add_child(pivot)
	spring = SpringArm3D.new()
	spring.collision_mask = 1 | (1 << 4)
	spring.margin = 0.2
	spring.spring_length = arm_length
	var sh := SphereShape3D.new()
	sh.radius = 0.22
	spring.shape = sh
	pivot.add_child(spring)
	cam = Camera3D.new()
	cam.name = "GameplayCamera"
	cam.near = 0.12
	cam.far = maxf(Settings.get_view_distance() + 300.0, 3400.0)
	cam.fov = Settings.get_fov()
	spring.add_child(cam)
	_noise.frequency = 1.3
	first_person = str(Settings.controls.get("camera_mode", "third")) == "first"
	fp = 1.0 if first_person else 0.0
	_apply_dof()
	EventBus.settings_changed.connect(func() -> void:
		cam.far = maxf(Settings.get_view_distance() + 300.0, 3400.0)
		_apply_dof())


## Profundidade de campo leve no Forward+ (qualidade alta/ultra): o que está a
## mais de ~70 m perde um pouco de nitidez, como numa lente de verdade — separa
## os planos e dá sensação de distância sem atrapalhar o jogo.
func _apply_dof() -> void:
	if not Settings.is_forward_plus() or int(Settings.graphics.get("preset", 1)) < 3:
		cam.attributes = null
		return
	var ca := CameraAttributesPractical.new()
	ca.dof_blur_far_enabled = true
	ca.dof_blur_far_distance = 70.0
	ca.dof_blur_far_transition = 140.0
	ca.dof_blur_amount = 0.025
	cam.attributes = ca


func set_target(t: Node3D) -> void:
	target = t
	spring.add_excluded_object(t.get_rid())
	if t is CollisionObject3D:
		_smoothed_pos = t.global_position + Vector3(0, height, 0)


func _unhandled_input(event: InputEvent) -> void:
	if not input_enabled or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		var sens := float(Settings.controls.get("mouse_sensitivity", 0.22)) * 0.01
		var inv := -1.0 if bool(Settings.controls.get("invert_y", false)) else 1.0
		var mm := event as InputEventMouseMotion
		yaw -= mm.relative.x * sens
		pitch = clampf(pitch - mm.relative.y * sens * inv, -1.25 - fp * 0.15, 0.95 + fp * 0.35)
		_vehicle_idle = 0.0


func toggle_view() -> void:
	set_first_person(not first_person)


func set_first_person(on: bool) -> void:
	first_person = on
	Settings.controls["camera_mode"] = "first" if on else "third"
	Settings.save_settings()
	EventBus.toast("Câmera em 1ª pessoa" if on else "Câmera em 3ª pessoa", "info")


## A câmera está (quase toda) nos olhos: o dono esconde a cabeça.
func fp_active() -> bool:
	return fp > 0.55 and mode == "follow"


func add_shake(amount: float) -> void:
	shake = minf(1.0, shake + amount * float(Settings.accessibility.get("camera_shake", 1.0)))


func look_dir() -> Vector3:
	return -cam.global_transform.basis.z


func flat_forward() -> Vector3:
	return Vector3(-sin(yaw), 0, -cos(yaw))


func flat_right() -> Vector3:
	return Vector3(cos(yaw), 0, -sin(yaw))


## Alinha a câmera com uma transformação (usado na transição da cinemática).
func align_to(xf: Transform3D) -> void:
	var f := -xf.basis.z
	yaw = atan2(-f.x, -f.z)
	pitch = clampf(asin(clampf(f.y, -1.0, 1.0)), -1.2, 0.9)


func update_camera(delta: float) -> void:
	if target == null:
		return
	_t += delta
	# controle: zona morta radial, curva de resposta, aceleração quando o
	# analógico fica no fim do curso, menos sensível mirando
	if input_enabled:
		var gv := Vector2(Input.get_joy_axis(Pad.device, JOY_AXIS_RIGHT_X), Input.get_joy_axis(Pad.device, JOY_AXIS_RIGHT_Y))
		var dz := float(Settings.controls.get("pad_deadzone", 0.15))
		var m := gv.length()
		if m > dz:
			var k := clampf((m - dz) / (1.0 - dz), 0.0, 1.0)
			k = k * k * 0.55 + k * 0.45
			gv = gv / m * k
			_look_boost = move_toward(_look_boost, 1.0 if m > 0.93 else 0.0, delta * (1.6 if m > 0.93 else 6.0))
			var gs := float(Settings.controls.get("gamepad_sensitivity", 2.6)) * (1.0 + _look_boost * 0.7) * lerpf(1.0, 0.5, aim) * assist
			var inv := -1.0 if bool(Settings.controls.get("pad_invert_y", false)) else 1.0
			yaw -= gv.x * gs * delta
			pitch = clampf(pitch - gv.y * gs * delta * 0.72 * inv, -1.25 - fp * 0.15, 0.95 + fp * 0.35)
			_vehicle_idle = 0.0
		else:
			_look_boost = 0.0
	var tp := target.global_position
	var h := height - crouch_amount * 0.45
	var length := arm_length
	var sh := shoulder
	fp = move_toward(fp, 1.0 if first_person and mode == "follow" else 0.0, delta * 4.0)
	if mode == "vehicle":
		h = 2.1
		length = 6.2
		sh = 0.0
		_vehicle_idle += delta
		if _vehicle_idle > 1.6 and target is Node3D:
			var vf := -target.global_transform.basis.z
			var vy := atan2(-vf.x, -vf.z)
			yaw = lerp_angle(yaw, vy, 1.0 - exp(-delta * 2.0))
			pitch = lerpf(pitch, -0.2, 1.0 - exp(-delta * 1.5))
	aim = move_toward(aim, aim_target, delta * 5.0)
	length = lerpf(length, 1.4, aim)
	sh = lerpf(sh, 0.62, aim)
	var desired := tp + Vector3(0, h, 0)
	if fp > 0.0 and target.has_method("eye_position"):
		desired = desired.lerp(target.eye_position(flat_forward()), fp)
		length = lerpf(length, 0.0, fp)
		sh = lerpf(sh, 0.0, fp)
	_smoothed_pos = _smoothed_pos.lerp(desired, 1.0 - exp(-delta * (18.0 + fp * 22.0 if mode == "follow" else 8.0)))
	# balanço da cabeça (acessibilidade: head_bob)
	var hb := float(Settings.accessibility.get("head_bob", 1.0)) * bob_amount * (1.0 - fp * 0.6)
	var bob := Vector3(0, sin(bob_phase * 2.0) * 0.025, 0) * hb
	global_position = _smoothed_pos + bob
	cam.near = lerpf(0.12, 0.05, fp)   # plano próximo maior = mais precisão no depth (menos z-fighting)
	pivot.rotation = Vector3(pitch, yaw, 0)
	spring.spring_length = length
	spring.position = Vector3(sh, 0, 0)
	# tremor
	shake = maxf(0.0, shake - delta * 1.8)
	var s := shake * shake
	cam.rotation = Vector3(_noise.get_noise_2d(_t * 25.0, 1.0) * 0.05 * s, _noise.get_noise_2d(_t * 25.0, 7.0) * 0.05 * s, _noise.get_noise_2d(_t * 25.0, 13.0) * 0.04 * s)
	var fov_target := Settings.get_fov() + sprint_fov - aim * 12.0
	if aim_zoom > 1.0:
		fov_target = lerpf(fov_target, Settings.get_fov() / aim_zoom, aim)
	cam.fov = lerpf(cam.fov, fov_target, 1.0 - exp(-delta * 6.0))
