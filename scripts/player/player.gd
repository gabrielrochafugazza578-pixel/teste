class_name Player
extends CharacterBody3D
## Jogador em primeira pessoa: andar, correr, pular, nadar, olhar com o mouse,
## cavar/construir o terreno, cortar arvores e bater nos bichos.

signal health_changed(hp: int, max_hp: int)
signal died

const WALK_SPEED := 5.0
const SPRINT_SPEED := 8.5
const JUMP_VELOCITY := 7.6
const GRAVITY := 22.0
const MOUSE_SENS := 0.0025
const EYE_HEIGHT := 1.6
const REACH := 5.5
const DIG_RADIUS := 1.3
const PLACE_RADIUS := 1.15
const ATTACK_DAMAGE := 3

var world: World
var hud: Hud
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
var regen_timer := 0.0
var last_hurt_time := -100.0
var dead := false

var inventory := Inventory.new()
var hand: Node3D
var held: MeshInstance3D
var swing := 0.0
var action_cooldown := 0.0
var marker: MeshInstance3D
var deco_hits: Dictionary = {}
var _time := 0.0


func _ready() -> void:
	add_to_group("player")
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
	_build_hand()
	_build_marker()
	inventory.changed.connect(_update_held)


func set_look(yaw_deg: float, pitch_deg: float) -> void:
	yaw = deg_to_rad(yaw_deg)
	pitch = deg_to_rad(pitch_deg)
	rotation.y = yaw
	head.rotation.x = pitch


# ------------------------------------------------------------- visual --

func _build_hand() -> void:
	hand = Node3D.new()
	hand.position = Vector3(0.36, -0.34, -0.5)
	camera.add_child(hand)
	var sleeve := MeshInstance3D.new()
	sleeve.mesh = MeshBuilder.capsule(0.075, 0.42)
	sleeve.material_override = ToonMat.get_mat(Color(0.25, 0.55, 0.95))
	sleeve.rotation = Vector3(-1.25, 0.25, 0.0)
	sleeve.position = Vector3(0.04, -0.08, 0.14)
	hand.add_child(sleeve)
	var fist := MeshInstance3D.new()
	fist.mesh = MeshBuilder.sphere(0.075, 6, 10)
	fist.material_override = ToonMat.get_mat(Color(1.0, 0.78, 0.6))
	fist.position = Vector3(0.0, 0.0, -0.06)
	hand.add_child(fist)
	held = MeshInstance3D.new()
	held.mesh = MeshBuilder.sphere(0.085, 6, 10)
	held.position = Vector3(-0.03, 0.07, -0.12)
	hand.add_child(held)
	for n in [sleeve, fist, held]:
		n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_update_held()


func _update_held() -> void:
	if held:
		held.material_override = ToonMat.get_mat(Mats.COLORS[inventory.selected_material()])
		held.visible = inventory.can_place()


func _build_marker() -> void:
	marker = MeshInstance3D.new()
	var tm := TorusMesh.new()
	tm.inner_radius = 0.42
	tm.outer_radius = 0.52
	tm.rings = 24
	tm.ring_segments = 6
	marker.mesh = tm
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = Color(1, 1, 1, 0.8)
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.no_depth_test = true
	m.render_priority = 10
	marker.material_override = m
	marker.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	marker.top_level = true
	marker.visible = false
	add_child(marker)


# ------------------------------------------------------------- entrada --

func _unhandled_input(event: InputEvent) -> void:
	if dead:
		return
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * MOUSE_SENS
		pitch = clampf(pitch - event.relative.y * MOUSE_SENS, -1.54, 1.54)
		rotation.y = yaw
		head.rotation.x = pitch
	elif event.is_action_pressed("toggle_fly") and OS.is_debug_build():
		flying = not flying
		if hud:
			hud.show_message("Voo: " + ("ligado" if flying else "desligado"), 1.5)
	elif event.is_action_pressed("toggle_creative"):
		inventory.creative = not inventory.creative
		inventory.changed.emit()
		if hud:
			hud.show_message("Modo criativo: " + ("ligado" if inventory.creative else "desligado"), 2.0)
	elif event.is_action_pressed("next_slot"):
		inventory.select(inventory.selected + 1)
	elif event.is_action_pressed("prev_slot"):
		inventory.select(inventory.selected - 1)
	else:
		for i in range(1, 10):
			if event.is_action_pressed("slot_%d" % i):
				inventory.select(i - 1)
		if event.is_action_pressed("slot_0"):
			inventory.select(9)


# ----------------------------------------------------------- movimento --

func _physics_process(delta: float) -> void:
	hurt_cooldown = maxf(0.0, hurt_cooldown - delta)
	if frozen:
		if world and world.is_ready_at(global_position):
			frozen = false
		else:
			return
	if dead:
		velocity.x = 0.0
		velocity.z = 0.0
		velocity.y -= GRAVITY * delta
		move_and_slide()
		return

	var eye_y := global_position.y + EYE_HEIGHT
	in_water = global_position.y + 0.7 < WorldGen.SEA
	head_in_water = eye_y < WorldGen.SEA - 0.2

	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		input = Vector2.ZERO
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

	var vy_before := velocity.y
	move_and_slide()

	# dano de queda
	if is_on_floor() and vy_before < -17.0 and not in_water:
		take_damage(int((-vy_before - 15.0) / 2.5))

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


# ------------------------------------------------------------ acoes --

func _process(delta: float) -> void:
	_time += delta
	action_cooldown -= delta
	swing = maxf(0.0, swing - delta * 3.5)
	# animacao da mao: balanco ao andar + golpe
	var walk := sin(bob_time) * 0.02
	hand.position = Vector3(0.36, -0.34 + walk, -0.5)
	hand.rotation = Vector3(-sin(swing * PI) * 1.1, sin(swing * PI) * 0.3, 0.0)

	# vida volta aos poucos
	if not dead and hp < max_hp and _time - last_hurt_time > 6.0:
		regen_timer += delta
		if regen_timer > 2.5:
			regen_timer = 0.0
			heal(1)

	if frozen or dead:
		marker.visible = false
		return
	var hit := _raycast()
	_update_marker(hit)
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if Input.is_action_pressed("attack") and action_cooldown <= 0.0:
		action_cooldown = 0.3
		_do_attack(hit)
	elif Input.is_action_pressed("use") and action_cooldown <= 0.0:
		action_cooldown = 0.25
		_do_place(hit)


func _raycast() -> Dictionary:
	var from := camera.global_position
	var to := from - camera.global_transform.basis.z * REACH
	var q := PhysicsRayQueryParameters3D.create(from, to, 1 | 4)
	q.exclude = [get_rid()]
	return get_world_3d().direct_space_state.intersect_ray(q)


func _update_marker(hit: Dictionary) -> void:
	if hit.is_empty():
		marker.visible = false
		return
	marker.visible = true
	var n: Vector3 = hit.normal
	var up := Vector3.UP if absf(n.dot(Vector3.UP)) < 0.95 else Vector3.RIGHT
	var b := Basis.looking_at(n, up) * Basis(Vector3.RIGHT, PI / 2)
	marker.global_transform = Transform3D(b, hit.position + n * 0.04)
	var col: Object = hit.collider
	var m: StandardMaterial3D = marker.material_override
	if col.is_in_group("mobs"):
		m.albedo_color = Color(1, 0.3, 0.3, 0.9)
	elif col.has_meta("chunk"):
		m.albedo_color = Color(1, 0.85, 0.3, 0.9)
	else:
		m.albedo_color = Color(1, 1, 1, 0.75)


func _do_attack(hit: Dictionary) -> void:
	swing = 1.0
	if hit.is_empty():
		return
	var col: Object = hit.collider
	if col.is_in_group("mobs") and col.has_method("hit"):
		col.hit(ATTACK_DAMAGE, global_position)
		return
	# decoracao (arvore, pedra...)
	if col is StaticBody3D and col.has_meta("chunk"):
		var ch: Chunk = col.get_meta("chunk")
		var owner_id: int = col.shape_find_owner(hit.shape)
		var cs: Node = col.shape_owner_get_owner(owner_id)
		var i: int = cs.get_meta("deco_index", -1)
		if i < 0:
			return
		var t := ch.deco_type(i)
		var key := "%s:%d" % [ch.key, i]
		deco_hits[key] = deco_hits.get(key, 0) + 1
		var needed := 3 if t <= Deco.TREE_PALM or t == Deco.MUSHROOM_GIANT else 2
		var pcol := Color(0.55, 0.4, 0.25) if t <= Deco.TREE_PALM else Color(0.7, 0.7, 0.75)
		Effects.poof(world, hit.position, pcol, 8, 2.5)
		if deco_hits[key] >= needed:
			deco_hits.erase(key)
			world.break_deco(ch, i, self)
		return
	# terreno
	var mat := world.edit_sphere(hit.position - hit.normal * 0.35, DIG_RADIUS, false, 0)
	world.remove_small_decos(hit.position, DIG_RADIUS + 0.6)
	if mat > 0:
		inventory.add(mat)
		Effects.poof(world, hit.position, Mats.COLORS[mat], 14, 3.5)


func _do_place(hit: Dictionary) -> void:
	if hit.is_empty():
		return
	var col: Object = hit.collider
	if col.is_in_group("mobs"):
		return
	if not inventory.can_place():
		if hud:
			hud.show_message("Sem %s! Cave para conseguir mais." % Mats.NAMES[inventory.selected_material()], 1.8)
		return
	var pos: Vector3 = hit.position + hit.normal * 0.55
	# nao construir em cima de si mesmo
	var feet := global_position + Vector3(0, 0.35, 0)
	var top := global_position + Vector3(0, 1.45, 0)
	var closest := Geometry3D.get_closest_point_to_segment(pos, feet, top)
	if closest.distance_to(pos) < PLACE_RADIUS + 0.3:
		return
	swing = 1.0
	var mat := inventory.selected_material()
	world.edit_sphere(pos, PLACE_RADIUS, true, mat)
	world.remove_small_decos(pos, PLACE_RADIUS + 0.3)
	inventory.consume_selected()
	Effects.poof(world, pos, Mats.COLORS[mat], 8, 2.0)


# --------------------------------------------------------------- vida --

func take_damage(amount: int, from: Vector3 = Vector3.INF) -> void:
	if hurt_cooldown > 0.0 or hp <= 0 or amount <= 0:
		return
	hp = maxi(0, hp - amount)
	hurt_cooldown = 0.5
	last_hurt_time = _time
	if from != Vector3.INF:
		var push := global_position - from
		push.y = 0.0
		velocity += push.normalized() * 7.0 + Vector3.UP * 4.5
	health_changed.emit(hp, max_hp)
	if hp <= 0:
		dead = true
		died.emit()


func heal(amount: int) -> void:
	hp = mini(max_hp, hp + amount)
	health_changed.emit(hp, max_hp)


func respawn(pos: Vector3) -> void:
	global_position = pos
	velocity = Vector3.ZERO
	hp = max_hp
	dead = false
	frozen = true
	health_changed.emit(hp, max_hp)
