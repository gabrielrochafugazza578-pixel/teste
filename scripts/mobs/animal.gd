class_name Animal
extends Mob
## Bichos do dia (fofos e pacificos): porco, vaca, ovelha, galinha e coelho.

const SPECIES := ["porco", "vaca", "ovelha", "galinha", "coelho"]

var hops := false
var peck_time := 0.0
var fur := Color(1, 1, 1)


static func create(kind: String) -> Animal:
	var a := Animal.new()
	a.species = kind
	return a


func _build() -> void:
	match species:
		"porco":
			_build_pig()
		"vaca":
			_build_cow()
		"ovelha":
			_build_sheep()
		"galinha":
			_build_chicken()
		_:
			_build_bunny()


func _legs4(color: Color, y: float, dx: float, dz_front: float, dz_back: float, r: float, h: float) -> void:
	for p in [Vector3(-dx, y, dz_front), Vector3(dx, y, dz_front), Vector3(dx, y, dz_back), Vector3(-dx, y, dz_back)]:
		var pv := pivot(model, p)
		part(pv, MeshBuilder.capsule(r, h, 8), color, Vector3(0, -h * 0.4, 0))
		legs.append(pv)


func _build_pig() -> void:
	var pink := Color(1.0, 0.68, 0.72)
	var dark_pink := Color(0.92, 0.5, 0.58)
	max_hp = 6
	walk_speed = 1.8
	run_speed = 5.0
	drops = [Mats.CLAY, 1]
	part(model, MeshBuilder.sphere(0.5, 8, 14), pink, Vector3(0, 0.62, 0), Vector3(0.95, 0.85, 1.25))
	head = pivot(model, Vector3(0, 0.82, 0.55))
	part(head, MeshBuilder.sphere(0.36, 8, 12), pink, Vector3.ZERO)
	part(head, MeshBuilder.cyl(0.16, 0.18, 0.14, 12), dark_pink, Vector3(0, -0.05, 0.33), Vector3.ONE, Vector3(PI / 2, 0, 0))
	for sgn in [-1.0, 1.0]:
		part(head, MeshBuilder.sphere(0.035, 3, 6), Color(0.4, 0.15, 0.2), Vector3(0.06 * sgn, -0.04, 0.41))
		part(head, MeshBuilder.cyl(0.0, 0.12, 0.2, 6), dark_pink, Vector3(0.22 * sgn, 0.3, 0.02), Vector3(1, 1, 0.5), Vector3(-0.3, 0, 0.5 * sgn))
	eyes(head, Vector3(0, 0.1, 0.27), 0.14, 0.085)
	tail = pivot(model, Vector3(0, 0.75, -0.62))
	part(tail, MeshBuilder.sphere(0.08, 4, 6), dark_pink, Vector3(0, 0.05, -0.04))
	_legs4(pink, 0.32, 0.25, 0.3, -0.35, 0.1, 0.34)
	add_shape(_capsule(0.42, 1.0), Vector3(0, 0.55, 0))


func _build_cow() -> void:
	var white := Color(0.97, 0.96, 0.94)
	var black := Color(0.15, 0.13, 0.16)
	max_hp = 10
	walk_speed = 1.5
	run_speed = 4.5
	drops = [Mats.LEAVES, 2]
	part(model, MeshBuilder.sphere(0.6, 8, 14), white, Vector3(0, 0.95, 0), Vector3(0.9, 0.8, 1.35))
	for sp in [Vector3(0.35, 1.1, 0.2), Vector3(-0.3, 0.95, -0.35), Vector3(0.1, 1.35, -0.1), Vector3(-0.42, 1.15, 0.35)]:
		part(model, MeshBuilder.sphere(0.24, 5, 8), black, sp, Vector3(1, 0.7, 1.1))
	head = pivot(model, Vector3(0, 1.2, 0.75))
	part(head, MeshBuilder.sphere(0.36, 8, 12), white, Vector3.ZERO, Vector3(0.9, 0.9, 1.05))
	part(head, MeshBuilder.sphere(0.24, 6, 10), Color(1.0, 0.72, 0.72), Vector3(0, -0.14, 0.3), Vector3(1.2, 0.8, 0.8))
	for sgn in [-1.0, 1.0]:
		part(head, MeshBuilder.sphere(0.035, 3, 6), Color(0.45, 0.2, 0.25), Vector3(0.08 * sgn, -0.13, 0.49))
		part(head, MeshBuilder.cyl(0.02, 0.05, 0.22, 6), Color(0.95, 0.9, 0.75), Vector3(0.25 * sgn, 0.3, -0.02), Vector3.ONE, Vector3(0, 0, -0.6 * sgn))
		part(head, MeshBuilder.sphere(0.1, 4, 7), white, Vector3(0.36 * sgn, 0.12, -0.05), Vector3(1.4, 0.6, 0.8))
	eyes(head, Vector3(0, 0.1, 0.26), 0.15, 0.08)
	tail = pivot(model, Vector3(0, 1.2, -0.8))
	part(tail, MeshBuilder.cyl(0.02, 0.03, 0.5, 5), white, Vector3(0, -0.25, 0))
	part(tail, MeshBuilder.sphere(0.07, 4, 6), black, Vector3(0, -0.5, 0))
	_legs4(white, 0.62, 0.3, 0.45, -0.5, 0.12, 0.62)
	for l in legs:
		part(l, MeshBuilder.sphere(0.13, 4, 7), black, Vector3(0, -0.62, 0), Vector3(1, 0.6, 1))
	add_shape(_capsule(0.55, 1.3), Vector3(0, 0.67, 0))


func _build_sheep() -> void:
	var wool := Color(0.98, 0.97, 0.95)
	var face := Color(0.32, 0.28, 0.3)
	max_hp = 8
	walk_speed = 1.6
	run_speed = 4.6
	drops = [Mats.SNOW, 2]
	for p in [Vector3(0, 0.8, 0), Vector3(0.22, 0.95, 0.25), Vector3(-0.24, 0.93, 0.2), Vector3(0.2, 0.9, -0.3), Vector3(-0.22, 0.88, -0.28), Vector3(0, 1.08, 0), Vector3(0, 0.78, 0.4), Vector3(0, 0.8, -0.45)]:
		part(model, MeshBuilder.sphere(0.36, 6, 10), wool, p)
	head = pivot(model, Vector3(0, 0.98, 0.62))
	part(head, MeshBuilder.sphere(0.26, 7, 11), face, Vector3.ZERO, Vector3(0.9, 1.0, 1.1))
	part(head, MeshBuilder.sphere(0.2, 5, 9), wool, Vector3(0, 0.22, -0.05))
	for sgn in [-1.0, 1.0]:
		part(head, MeshBuilder.sphere(0.1, 4, 7), face, Vector3(0.26 * sgn, 0.05, -0.05), Vector3(1.5, 0.55, 0.8))
	eyes(head, Vector3(0, 0.05, 0.2), 0.11, 0.075)
	_legs4(face, 0.45, 0.22, 0.3, -0.3, 0.08, 0.45)
	add_shape(_capsule(0.5, 1.1), Vector3(0, 0.57, 0))


func _build_chicken() -> void:
	var white := Color(1, 0.99, 0.95)
	var orange := Color(1.0, 0.62, 0.15)
	max_hp = 4
	walk_speed = 1.7
	run_speed = 5.5
	drops = [Mats.LEAVES, 1]
	part(model, MeshBuilder.sphere(0.3, 7, 12), white, Vector3(0, 0.5, 0), Vector3(0.9, 0.9, 1.15))
	part(model, MeshBuilder.cyl(0.0, 0.14, 0.3, 6), white, Vector3(0, 0.62, -0.32), Vector3(1, 1, 0.5), Vector3(-0.9, 0, 0))
	for sgn in [-1.0, 1.0]:
		part(model, MeshBuilder.sphere(0.17, 5, 8), Color(0.95, 0.93, 0.88), Vector3(0.27 * sgn, 0.52, -0.02), Vector3(0.4, 0.8, 1.2))
	head = pivot(model, Vector3(0, 0.82, 0.22))
	part(head, MeshBuilder.sphere(0.17, 7, 10), white, Vector3.ZERO)
	part(head, MeshBuilder.cyl(0.0, 0.06, 0.14, 6), orange, Vector3(0, -0.02, 0.2), Vector3.ONE, Vector3(PI / 2, 0, 0))
	part(head, MeshBuilder.sphere(0.06, 4, 7), Color(0.95, 0.2, 0.2), Vector3(0, 0.18, 0.02), Vector3(0.6, 1.2, 1.4))
	part(head, MeshBuilder.sphere(0.04, 4, 6), Color(0.95, 0.2, 0.2), Vector3(0, -0.1, 0.14), Vector3(0.6, 1.3, 0.6))
	eyes(head, Vector3(0, 0.04, 0.1), 0.1, 0.05)
	for sgn in [-1.0, 1.0]:
		var pv := pivot(model, Vector3(0.1 * sgn, 0.3, 0.0))
		part(pv, MeshBuilder.cyl(0.02, 0.025, 0.3, 5), orange, Vector3(0, -0.15, 0))
		part(pv, MeshBuilder.sphere(0.06, 3, 6), orange, Vector3(0, -0.3, 0.04), Vector3(1, 0.3, 1.4))
		legs.append(pv)
	add_shape(_capsule(0.28, 0.8), Vector3(0, 0.42, 0))


func _build_bunny() -> void:
	fur = [Color(0.85, 0.7, 0.55), Color(0.97, 0.97, 0.97), Color(0.6, 0.5, 0.45)][randi() % 3]
	hops = true
	max_hp = 4
	walk_speed = 2.2
	run_speed = 6.0
	drops = [Mats.LEAVES, 1]
	part(model, MeshBuilder.sphere(0.28, 7, 12), fur, Vector3(0, 0.34, -0.05), Vector3(1, 0.95, 1.2))
	head = pivot(model, Vector3(0, 0.55, 0.22))
	part(head, MeshBuilder.sphere(0.2, 7, 11), fur, Vector3.ZERO)
	for sgn in [-1.0, 1.0]:
		part(head, MeshBuilder.capsule(0.06, 0.42, 8), fur, Vector3(0.08 * sgn, 0.3, -0.04), Vector3(1, 1, 0.6), Vector3(-0.25, 0, 0.18 * sgn))
		part(head, MeshBuilder.capsule(0.035, 0.3, 6), Color(1.0, 0.7, 0.75), Vector3(0.08 * sgn, 0.3, -0.005), Vector3(1, 1, 0.4), Vector3(-0.25, 0, 0.18 * sgn))
	part(head, MeshBuilder.sphere(0.04, 3, 6), Color(1.0, 0.5, 0.6), Vector3(0, -0.02, 0.2))
	eyes(head, Vector3(0, 0.05, 0.13), 0.1, 0.055)
	tail = pivot(model, Vector3(0, 0.38, -0.36))
	part(tail, MeshBuilder.sphere(0.1, 5, 8), Color(1, 1, 1), Vector3.ZERO)
	for sgn in [-1.0, 1.0]:
		var pv := pivot(model, Vector3(0.14 * sgn, 0.14, -0.1))
		part(pv, MeshBuilder.sphere(0.1, 5, 8), fur, Vector3(0, -0.05, 0.04), Vector3(0.8, 0.6, 1.6))
		legs.append(pv)
	add_shape(_capsule(0.26, 0.7), Vector3(0, 0.36, 0))


func _capsule(r: float, h: float) -> CapsuleShape3D:
	var c := CapsuleShape3D.new()
	c.radius = r
	c.height = maxf(h, r * 2.0)
	return c


func _ready() -> void:
	super._ready()
	hp = max_hp


func _ai(delta: float) -> void:
	wander_ai()
	# coelhos pulam ao andar
	if hops and is_on_floor() and move_dir.length() > 0.1:
		velocity.y = 4.2
	# ciscar / comer grama parado
	if state == State.IDLE:
		peck_time += delta
	else:
		peck_time = 0.0


func _animate(delta: float, speed: float) -> void:
	super._animate(delta, speed)
	if head:
		var look := 0.0
		if state == State.IDLE and peck_time > 0.8 and (species == "galinha" or species == "ovelha" or species == "vaca"):
			look = (0.5 + 0.5 * sin(anim_time * (9.0 if species == "galinha" else 2.5))) * 0.7
		head.rotation.x = lerpf(head.rotation.x, look, clampf(delta * 8.0, 0.0, 1.0))
		# olha para o jogador quando ele chega perto
		if player and dist_to_player() < 5.0 and state != State.FLEE:
			var to := player.global_position - global_position
			var local_yaw := wrapf(atan2(to.x, to.z) - face_yaw, -PI, PI)
			head.rotation.y = lerpf(head.rotation.y, clampf(local_yaw, -0.9, 0.9), clampf(delta * 5.0, 0.0, 1.0))
		else:
			head.rotation.y = lerpf(head.rotation.y, 0.0, clampf(delta * 3.0, 0.0, 1.0))
	if tail:
		tail.rotation.z = sin(anim_time * 6.0) * 0.4
	if hops:
		model.position.y = 0.0
		var up := clampf(velocity.y / 4.2, -1.0, 1.0)
		model.rotation.x = -up * 0.25
	if species == "galinha" and not is_on_floor():
		model.rotation.z = sin(anim_time * 30.0) * 0.05
