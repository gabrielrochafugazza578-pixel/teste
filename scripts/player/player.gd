class_name Player
extends CharacterBody3D
## Jogador em primeira pessoa: andar, correr, pular, nadar e olhar com o mouse.

signal health_changed(hp: int, max_hp: int)
signal died

const WALK_SPEED := 5.0
const SPRINT_SPEED := 8.5
const JUMP_VELOCITY := 7.6
const GRAVITY := 22.0
const MOUSE_SENS := 0.0025
const EYE_HEIGHT := 1.6

var world: World
var head: Node3D
var camera: Camera3D
var yaw := 0.0
var pitch := 0.0
var frozen := true           # espera o chao carregar
var flying := false
var in_water := false
var head_in_water := false
var bob_time := 0.0

var max_hp := 20
var hp := 20
var hurt_cooldown := 0.0


func _ready() -> void:
	var col := CollisionShape3D.new()
	var cap := CapsuleShape3D.new()
	cap.radius = 0.35
	cap.height = 1.75
	col.shape = cap
	col.position.y = 0.875
	add_child(col)
	head = Node3D.new()
	head.position.y = EYE_HEIGHT
	add_child(head)
	camera = Camera3D.new()
	camera.fov = 75.0
	camera.near = 0.05
	camera.far = 420.0
	head.add_child(camera)
	camera.current = true
	floor_max_angle = deg_to_rad(52.0)
	floor_snap_length = 0.45
	collision_layer = 2
	collision_mask = 1


func set_look(yaw_deg: float, pitch_deg: float) -> void:
	yaw = deg_to_rad(yaw_deg)
	pitch = deg_to_rad(pitch_deg)
	rotation.y = yaw
	head.rotation.x = pitch


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * MOUSE_SENS
		pitch = clampf(pitch - event.relative.y * MOUSE_SENS, -1.54, 1.54)
		rotation.y = yaw
		head.rotation.x = pitch
	elif event.is_action_pressed("toggle_fly") and OS.is_debug_build():
		flying = not flying


func _physics_process(delta: float) -> void:
	hurt_cooldown = maxf(0.0, hurt_cooldown - delta)
	if frozen:
		if world and world.is_ready_at(global_position):
			frozen = false
		else:
			return

	var eye_y := global_position.y + EYE_HEIGHT
	in_water = global_position.y + 0.7 < WorldGen.SEA
	head_in_water = eye_y < WorldGen.SEA - 0.2

	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var dir := (transform.basis * Vector3(input.x, 0.0, input.y)).normalized()
	var speed := SPRINT_SPEED if Input.is_action_pressed("sprint") else WALK_SPEED

	if flying:
		var vy := 0.0
		if Input.is_action_pressed("jump"):
			vy += 1.0
		if Input.is_action_pressed("crouch"):
			vy -= 1.0
		velocity = dir * speed * 2.5 + Vector3.UP * vy * speed * 2.0
		move_and_slide()
		return

	if in_water:
		speed *= 0.6
		velocity.y -= GRAVITY * 0.25 * delta
		velocity.y *= 0.92
		if Input.is_action_pressed("jump"):
			velocity.y = minf(velocity.y + 18.0 * delta, 3.2)
	else:
		velocity.y -= GRAVITY * delta
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	var accel := 12.0 if is_on_floor() or in_water else 3.5
	var target := dir * speed
	velocity.x = lerpf(velocity.x, target.x, clampf(accel * delta, 0.0, 1.0))
	velocity.z = lerpf(velocity.z, target.z, clampf(accel * delta, 0.0, 1.0))

	# "auto-pulo" em degraus pequenos do terreno
	if is_on_floor() and is_on_wall() and dir.length() > 0.1 and velocity.y <= 0.0:
		velocity.y = JUMP_VELOCITY * 0.72

	move_and_slide()

	# balanco suave da camera ao andar
	var hspeed := Vector2(velocity.x, velocity.z).length()
	if is_on_floor() and hspeed > 0.5:
		bob_time += delta * hspeed * 1.6
	else:
		bob_time = lerpf(bob_time, roundf(bob_time / PI) * PI, clampf(delta * 6.0, 0.0, 1.0))
	camera.position.y = sin(bob_time) * 0.05

	if global_position.y < -20.0:
		global_position.y = world.height_at(global_position.x, global_position.z) + 3.0
		velocity = Vector3.ZERO


func take_damage(amount: int, from: Vector3 = Vector3.INF) -> void:
	if hurt_cooldown > 0.0 or hp <= 0:
		return
	hp = maxi(0, hp - amount)
	hurt_cooldown = 0.5
	if from != Vector3.INF:
		var push := global_position - from
		push.y = 0.0
		velocity += push.normalized() * 6.0 + Vector3.UP * 4.0
	health_changed.emit(hp, max_hp)
	if hp <= 0:
		died.emit()


func heal(amount: int) -> void:
	hp = mini(max_hp, hp + amount)
	health_changed.emit(hp, max_hp)
