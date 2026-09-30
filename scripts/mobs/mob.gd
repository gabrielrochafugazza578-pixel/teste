class_name Mob
extends CharacterBody3D
## Base de todas as criaturas: fisica, vida, dano, IA simples e animacao.
## Os modelos sao montados por codigo com formas simples (visual cartoon).

signal died(mob: Mob)

enum State { IDLE, WANDER, FLEE, CHASE, ATTACK, CIRCLE, SPECIAL }

const GRAVITY := 22.0

var world: World
var player: Player
var species := "bicho"
var hostile := false
var nocturnal := false
var max_hp := 6
var hp := 6
var walk_speed := 2.0
var run_speed := 4.5
var damage := 2
var attack_range := 1.6
var attack_cooldown := 1.2
var sight := 22.0
var flying := false
var drops: Array = []            # [material, quantidade]

var state := State.IDLE
var state_time := 0.0
var state_len := 2.0             # duracao sorteada do estado atual
var move_dir := Vector3.ZERO
var face_yaw := 0.0
var anim_time := 0.0
var attack_timer := 0.0
var flash := 0.0
var fade := 0.0                  # 0 = invisivel, 1 = visivel
var fading_out := false
var knock := Vector3.ZERO

var model: Node3D                # raiz do modelo (gira para a direcao do movimento)
var legs: Array[Node3D] = []     # pernas (balancam ao andar)
var head: Node3D
var tail: Node3D
var _geoms: Array[GeometryInstance3D] = []


func _ready() -> void:
	add_to_group("mobs")
	collision_layer = 4
	collision_mask = 1
	floor_max_angle = deg_to_rad(55.0)
	model = Node3D.new()
	add_child(model)
	_build()
	_collect_geoms(model)
	face_yaw = randf() * TAU
	_set_instance_param("fade", 0.0)


## Monta o modelo e a colisao (cada especie implementa).
func _build() -> void:
	pass


func add_shape(shape: Shape3D, pos: Vector3) -> void:
	var cs := CollisionShape3D.new()
	cs.shape = shape
	cs.position = pos
	add_child(cs)


## Adiciona uma parte do modelo. Retorna o MeshInstance3D criado.
func part(parent: Node3D, mesh: Mesh, color: Color, pos: Vector3, scale := Vector3.ONE, rot := Vector3.ZERO, glow := 0.0, glow_color := Color(0, 0, 0)) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	var gc := glow_color if glow_color != Color(0, 0, 0) else color
	mi.material_override = ToonMat.get_mat(color, gc if glow > 0.0 else Color(0, 0, 0), glow)
	mi.position = pos
	mi.scale = scale
	mi.rotation = rot
	parent.add_child(mi)
	return mi


func pivot(parent: Node3D, pos: Vector3) -> Node3D:
	var n := Node3D.new()
	n.position = pos
	parent.add_child(n)
	return n


## Olhos de desenho animado (branco + pupila + brilho).
func eyes(parent: Node3D, center: Vector3, spread: float, size: float, forward := Vector3(0, 0, 1), pupil := Color(0.08, 0.06, 0.1)) -> void:
	for sgn in [-1.0, 1.0]:
		var p := center + Vector3(spread * sgn, 0, 0)
		part(parent, MeshBuilder.sphere(size, 6, 10), Color(1, 1, 1), p)
		part(parent, MeshBuilder.sphere(size * 0.55, 5, 8), pupil, p + forward * size * 0.62)
		part(parent, MeshBuilder.sphere(size * 0.18, 3, 6), Color(1, 1, 1), p + forward * size * 0.95 + Vector3(size * 0.2, size * 0.25, 0))


## Olhos que brilham (criaturas da noite).
func glow_eyes(parent: Node3D, center: Vector3, spread: float, size: float, color: Color, strength := 4.0) -> void:
	for sgn in [-1.0, 1.0]:
		part(parent, MeshBuilder.sphere(size, 5, 8), color, center + Vector3(spread * sgn, 0, 0), Vector3(1, 0.7, 0.6), Vector3.ZERO, strength)


func _collect_geoms(n: Node) -> void:
	for c in n.get_children():
		if c is MeshInstance3D:
			_geoms.append(c)
		_collect_geoms(c)


func _set_instance_param(pname: String, v: float) -> void:
	for g in _geoms:
		g.set_instance_shader_parameter(pname, v)


# ------------------------------------------------------------- fisica --

func _physics_process(delta: float) -> void:
	if world == null or not world.is_ready_at(global_position):
		return  # chao ainda sem colisao: espera
	state_time += delta
	attack_timer = maxf(0.0, attack_timer - delta)
	_ai(delta)

	var target_v := move_dir * _current_speed()
	if flying:
		velocity = velocity.lerp(target_v, clampf(delta * 3.0, 0.0, 1.0)) + knock
	else:
		velocity.x = lerpf(velocity.x, target_v.x, clampf(delta * 8.0, 0.0, 1.0)) + knock.x
		velocity.z = lerpf(velocity.z, target_v.z, clampf(delta * 8.0, 0.0, 1.0)) + knock.z
		var water := global_position.y < WorldGen.SEA - 0.3
		if water:
			velocity.y = lerpf(velocity.y, 2.0, clampf(delta * 3.0, 0.0, 1.0))
		else:
			velocity.y -= GRAVITY * delta
		velocity.y += knock.y
		# pula obstaculos
		if is_on_floor() and is_on_wall() and move_dir.length() > 0.1:
			velocity.y = 6.5
	knock = knock.lerp(Vector3.ZERO, clampf(delta * 10.0, 0.0, 1.0)) if knock.length() > 0.05 else Vector3.ZERO
	move_and_slide()
	if global_position.y < -10.0:
		queue_free()


func _current_speed() -> float:
	match state:
		State.FLEE, State.CHASE:
			return run_speed
		State.WANDER, State.CIRCLE:
			return walk_speed
	return 0.0


func _process(delta: float) -> void:
	anim_time += delta
	# aparecer / sumir
	if fading_out:
		fade -= delta * 1.2
		if fade <= 0.0:
			queue_free()
			return
	elif fade < 1.0:
		fade = minf(1.0, fade + delta * 1.2)
	_set_instance_param("fade", fade)
	if flash > 0.0:
		flash = maxf(0.0, flash - delta * 4.0)
		_set_instance_param("flash", flash)
	# vira suavemente para onde anda
	var hv := Vector2(velocity.x, velocity.z)
	if move_dir.length() > 0.1 and hv.length() > 0.3:
		face_yaw = lerp_angle(face_yaw, atan2(move_dir.x, move_dir.z), clampf(delta * 8.0, 0.0, 1.0))
	model.rotation.y = face_yaw
	_animate(delta, hv.length())


## Animacao padrao: pernas balancam, corpo sacode.
func _animate(_delta: float, speed: float) -> void:
	var sw := sin(anim_time * (4.0 + speed * 2.5)) * clampf(speed / 2.0, 0.0, 1.0) * 0.7
	for i in legs.size():
		legs[i].rotation.x = sw * (1.0 if i % 2 == 0 else -1.0) * (1.0 if i < 2 else -1.0)
	model.position.y = absf(sw) * 0.06


# ------------------------------------------------------------------ IA --

func _ai(_delta: float) -> void:
	pass


func dist_to_player() -> float:
	if player == null:
		return 1.0e9
	return global_position.distance_to(player.global_position)


func dir_to_player() -> Vector3:
	var d := player.global_position - global_position
	d.y = 0.0
	return d.normalized()


func set_state(s: State) -> void:
	state = s
	state_time = 0.0
	state_len = randf_range(1.5, 4.5)


## Passeia e para de vez em quando.
func wander_ai() -> void:
	match state:
		State.IDLE:
			move_dir = Vector3.ZERO
			if state_time > state_len:
				var a := randf() * TAU
				move_dir = Vector3(cos(a), 0, sin(a))
				set_state(State.WANDER)
		State.WANDER:
			if state_time > state_len + 1.0:
				set_state(State.IDLE)
			# evita a agua
			var ahead := global_position + move_dir * 2.0
			if world and world.height_at(ahead.x, ahead.z) < WorldGen.SEA - 0.5:
				move_dir = -move_dir
		State.FLEE:
			if player:
				move_dir = -dir_to_player()
			if state_time > 5.0:
				set_state(State.IDLE)
		_:
			set_state(State.IDLE)


# ---------------------------------------------------------- dano e morte --

func hit(amount: int, from: Vector3) -> void:
	if hp <= 0 or fading_out:
		return
	hp -= amount
	flash = 1.0
	var push := global_position - from
	push.y = 0.0
	knock = push.normalized() * 6.0 + Vector3.UP * 3.0
	Effects.poof(get_parent(), global_position + Vector3(0, 0.8, 0), Color(1, 1, 1), 6, 2.0)
	_on_hurt()
	if hp <= 0:
		die()


func _on_hurt() -> void:
	if not hostile:
		set_state(State.FLEE)
	else:
		set_state(State.CHASE)


func die() -> void:
	Effects.poof(get_parent(), global_position + Vector3(0, 0.6, 0), _death_color(), 22, 4.0, 0.12, 2.0 if nocturnal else 0.0)
	if player and drops.size() == 2:
		player.inventory.add(drops[0], drops[1])
		if player.hud:
			player.hud.show_message("+%d %s" % [drops[1], Mats.NAMES[drops[0]]], 1.5)
	died.emit(self)
	queue_free()


func _death_color() -> Color:
	return Color(1, 1, 1)


## Some aos poucos (ex.: criaturas da noite quando amanhece).
func dissolve() -> void:
	if fading_out:
		return
	fading_out = true
	Effects.poof(get_parent(), global_position + Vector3(0, 0.6, 0), _death_color(), 16, 2.0, 0.08, 2.5)


func try_attack() -> bool:
	if attack_timer > 0.0 or player == null or player.dead:
		return false
	if dist_to_player() <= attack_range:
		attack_timer = attack_cooldown
		player.take_damage(damage, global_position)
		return true
	return false
