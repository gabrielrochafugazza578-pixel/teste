class_name NightCreature
extends Mob
## Criaturas da noite: mais bonitas, brilhantes e espertas que os bichos do dia.
##
##  lobo     - Lobo Sombrio: anda em matilha, cerca o jogador e da botes.
##             Olhos e runas cianas brilhando, rastro de fumaca roxa.
##  gosma    - Gosma Lunar: gelatina brilhante que pula com "squash & stretch".
##             As grandes se dividem em duas pequenas quando derrotadas.
##  espirito - Espirito Vaga-lume: voa em volta do jogador e da rasantes.
##  golem    - Golem de Cristal: gigante de pedra com cristais roxos. Lento,
##             mas o soco no chao faz uma onda de choque. Raro.

var light: OmniLight3D
var trail: CPUParticles3D
var sub_state := 0
var hop_timer := 0.0
var circle_sign := 1.0
var big := true                  # gosma grande (se divide)
var arms: Array[Node3D] = []
var crystals: Array[Node3D] = []
var jaw: Node3D
var core: Node3D
var wings: Array[Node3D] = []
var _slime_mat: ShaderMaterial
var _last_on_floor := true
var _smash_done := false


static func create(kind: String, is_big := true) -> NightCreature:
	var c := NightCreature.new()
	c.species = kind
	c.big = is_big
	return c


func _build() -> void:
	hostile = true
	nocturnal = true
	match species:
		"lobo":
			_build_wolf()
		"gosma":
			_build_slime()
		"espirito":
			_build_wisp()
		"golem":
			_build_golem()
	hp = max_hp


func _add_light(color: Color, energy: float, rng: float, pos: Vector3) -> void:
	light = OmniLight3D.new()
	light.light_color = color
	light.light_energy = energy
	light.omni_range = rng
	light.position = pos
	light.shadow_enabled = false
	add_child(light)


func _add_trail(color: Color, amount: int, size: float, pos: Vector3, rise := 0.6, glow_amt := 2.0) -> void:
	trail = CPUParticles3D.new()
	trail.amount = amount
	trail.lifetime = 1.4
	trail.local_coords = false
	var sm := SphereMesh.new()
	sm.radius = size
	sm.height = size * 2.0
	sm.radial_segments = 6
	sm.rings = 3
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = color
	m.emission_enabled = true
	m.emission = color
	m.emission_energy_multiplier = glow_amt
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.vertex_color_use_as_albedo = true
	sm.material = m
	trail.mesh = sm
	trail.emission_shape = CPUParticles3D.EMISSION_SHAPE_SPHERE
	trail.emission_sphere_radius = 0.35
	trail.direction = Vector3.UP
	trail.spread = 40.0
	trail.gravity = Vector3(0, rise, 0)
	trail.initial_velocity_min = 0.1
	trail.initial_velocity_max = 0.4
	var curve := Curve.new()
	curve.add_point(Vector2(0, 1))
	curve.add_point(Vector2(1, 0))
	trail.scale_amount_curve = curve
	var grad := Gradient.new()
	grad.set_color(0, Color(1, 1, 1, 0.9))
	grad.set_color(1, Color(1, 1, 1, 0.0))
	trail.color_ramp = grad
	trail.position = pos
	add_child(trail)


# ------------------------------------------------------------------ lobo --

func _build_wolf() -> void:
	var fur := Color(0.20, 0.16, 0.36)
	var fur2 := Color(0.30, 0.24, 0.50)
	var rune := Color(0.35, 0.95, 1.0)
	max_hp = 10
	damage = 3
	walk_speed = 3.2
	run_speed = 6.8
	attack_range = 1.9
	sight = 26.0
	drops = [Mats.CRYSTAL, 1]
	circle_sign = 1.0 if randf() < 0.5 else -1.0
	# corpo
	part(model, MeshBuilder.sphere(0.45, 8, 14), fur, Vector3(0, 0.82, -0.1), Vector3(0.8, 0.75, 1.55))
	part(model, MeshBuilder.sphere(0.42, 8, 14), fur2, Vector3(0, 0.9, 0.42), Vector3(0.95, 0.95, 0.9))
	# juba espetada
	for k in 7:
		var a := -1.2 + k * 0.4
		part(model, MeshBuilder.cyl(0.0, 0.12, 0.42, 5), fur, Vector3(sin(a) * 0.32, 1.12 + cos(a) * 0.08, 0.3 - absf(a) * 0.05), Vector3.ONE, Vector3(-0.9, 0, -a * 0.8))
	# runas brilhantes nas costas
	for k in 3:
		part(model, MeshBuilder.sphere(0.2, 4, 8), rune, Vector3(0, 1.12 - k * 0.03, -0.05 - k * 0.3), Vector3(1.3, 0.25, 0.35), Vector3.ZERO, 3.5)
	# cabeca
	head = pivot(model, Vector3(0, 1.08, 0.78))
	part(head, MeshBuilder.sphere(0.3, 8, 12), fur2, Vector3.ZERO, Vector3(0.95, 0.9, 1.0))
	part(head, MeshBuilder.capsule(0.13, 0.5, 8), fur, Vector3(0, -0.07, 0.3), Vector3.ONE, Vector3(PI / 2, 0, 0))
	part(head, MeshBuilder.sphere(0.06, 4, 6), Color(0.05, 0.03, 0.08), Vector3(0, -0.02, 0.55))
	jaw = pivot(head, Vector3(0, -0.14, 0.12))
	part(jaw, MeshBuilder.capsule(0.09, 0.38, 6), fur, Vector3(0, 0, 0.15), Vector3(1, 0.7, 1), Vector3(PI / 2, 0, 0))
	for sgn in [-1.0, 1.0]:
		part(jaw, MeshBuilder.cyl(0.0, 0.025, 0.08, 4), Color(0.95, 0.95, 0.9), Vector3(0.06 * sgn, 0.06, 0.3), Vector3.ONE, Vector3(PI, 0, 0))
		part(head, MeshBuilder.cyl(0.0, 0.1, 0.3, 5), fur, Vector3(0.16 * sgn, 0.3, -0.05), Vector3(1, 1, 0.6), Vector3(-0.2, 0, 0.25 * sgn))
		part(head, MeshBuilder.cyl(0.0, 0.05, 0.18, 5), rune, Vector3(0.16 * sgn, 0.28, -0.02), Vector3(1, 1, 0.5), Vector3(-0.2, 0, 0.25 * sgn), 2.0)
	glow_eyes(head, Vector3(0, 0.08, 0.24), 0.12, 0.07, rune, 6.0)
	# cauda
	tail = pivot(model, Vector3(0, 0.95, -0.78))
	part(tail, MeshBuilder.cyl(0.05, 0.16, 0.7, 7), fur2, Vector3(0, -0.05, -0.32), Vector3.ONE, Vector3(-1.9, 0, 0))
	part(tail, MeshBuilder.sphere(0.1, 4, 7), rune, Vector3(0, -0.2, -0.66), Vector3.ONE, Vector3.ZERO, 4.0)
	# pernas
	for p in [Vector3(-0.2, 0.62, 0.45), Vector3(0.2, 0.62, 0.45), Vector3(0.2, 0.62, -0.5), Vector3(-0.2, 0.62, -0.5)]:
		var pv := pivot(model, p)
		part(pv, MeshBuilder.capsule(0.08, 0.66, 7), fur, Vector3(0, -0.3, 0))
		part(pv, MeshBuilder.sphere(0.09, 4, 6), fur2, Vector3(0, -0.6, 0.04), Vector3(1, 0.6, 1.3))
		legs.append(pv)
	add_shape(_capsule(0.42, 1.1), Vector3(0, 0.6, 0))
	_add_light(rune, 0.7, 3.5, Vector3(0, 1.1, 0.6))
	_add_trail(Color(0.5, 0.35, 1.0), 16, 0.07, Vector3(0, 0.9, -0.3), 0.8)


func _ai_wolf(delta: float) -> void:
	var d := dist_to_player()
	if player == null or player.dead or d > sight:
		wander_ai()
		return
	match state:
		State.IDLE, State.WANDER, State.FLEE:
			set_state(State.CHASE)
		State.CHASE:
			move_dir = dir_to_player()
			if d < 7.5:
				set_state(State.CIRCLE)
		State.CIRCLE:
			# rodeia o jogador antes do bote
			var to := dir_to_player()
			var side := Vector3(-to.z, 0, to.x) * circle_sign
			var keep := (d - 6.0) * 0.4
			move_dir = (side + to * keep).normalized()
			if state_time > state_len * 0.7:
				set_state(State.SPECIAL)
				velocity.y = 4.5
		State.SPECIAL:
			# bote!
			move_dir = dir_to_player()
			if try_attack() or state_time > 1.2:
				set_state(State.ATTACK)
		State.ATTACK:
			# recua um pouco depois de atacar
			move_dir = -dir_to_player()
			if state_time > 0.9:
				circle_sign = -circle_sign
				set_state(State.CHASE)
	try_attack()


# ----------------------------------------------------------------- gosma --

func _build_slime() -> void:
	var s := 1.0 if big else 0.55
	max_hp = 10 if big else 4
	damage = 2 if big else 1
	walk_speed = 3.0
	run_speed = 3.6
	attack_range = 1.4 * s + 0.4
	drops = [Mats.CRYSTAL, 1] if big else []
	var tints := [Color(0.3, 0.95, 0.8), Color(0.55, 0.6, 1.0), Color(0.95, 0.45, 0.9)]
	var tint: Color = tints[randi() % tints.size()]
	_slime_mat = ShaderMaterial.new()
	_slime_mat.shader = load("res://shaders/slime.gdshader")
	_slime_mat.set_shader_parameter("albedo", tint)
	_slime_mat.set_shader_parameter("glow_color", tint)
	_slime_mat.set_shader_parameter("glow", 1.3)
	core = pivot(model, Vector3(0, 0.55 * s, 0))
	var body := MeshInstance3D.new()
	body.mesh = MeshBuilder.sphere(0.6 * s, 10, 16)
	body.material_override = _slime_mat
	body.scale = Vector3(1.1, 0.9, 1.1)
	core.add_child(body)
	part(core, MeshBuilder.sphere(0.25 * s, 6, 10), tint.lightened(0.5), Vector3(0, -0.05 * s, 0), Vector3.ONE, Vector3.ZERO, 3.0)
	# rostinho
	for sgn in [-1.0, 1.0]:
		part(core, MeshBuilder.sphere(0.09 * s, 5, 8), Color(0.05, 0.05, 0.1), Vector3(0.2 * s * sgn, 0.12 * s, 0.48 * s), Vector3(1, 1.3, 0.6))
		part(core, MeshBuilder.sphere(0.03 * s, 3, 6), Color(1, 1, 1), Vector3(0.2 * s * sgn + 0.03 * s, 0.17 * s, 0.53 * s), Vector3.ONE, Vector3.ZERO, 2.0)
	part(core, MeshBuilder.sphere(0.07 * s, 4, 8), Color(0.05, 0.05, 0.1), Vector3(0, -0.06 * s, 0.52 * s), Vector3(1.6, 0.5, 0.5))
	add_shape(_sphere(0.55 * s), Vector3(0, 0.5 * s, 0))
	_add_light(tint, 0.9 if big else 0.5, 4.0 * s, Vector3(0, 0.6 * s, 0))
	_add_trail(tint, 8, 0.05, Vector3(0, 0.3, 0), 1.2, 3.0)


func _ai_slime(delta: float) -> void:
	var d := dist_to_player()
	var chasing := player != null and not player.dead and d < sight
	hop_timer -= delta
	if is_on_floor():
		move_dir = Vector3.ZERO
		if hop_timer <= 0.0:
			hop_timer = randf_range(0.9, 1.6)
			var dir := dir_to_player() if chasing else Vector3(randf() - 0.5, 0, randf() - 0.5).normalized()
			move_dir = dir
			velocity.y = 7.0 if chasing else 5.0
			state = State.CHASE if chasing else State.WANDER
	else:
		if move_dir == Vector3.ZERO and chasing:
			move_dir = dir_to_player()
	if chasing:
		try_attack()


# ------------------------------------------------------------- espirito --

func _build_wisp() -> void:
	flying = true
	max_hp = 4
	damage = 2
	walk_speed = 4.0
	run_speed = 9.0
	attack_range = 1.3
	drops = [Mats.CRYSTAL, 1]
	var gold := Color(1.0, 0.92, 0.45)
	core = pivot(model, Vector3.ZERO)
	part(core, MeshBuilder.sphere(0.22, 6, 10), gold, Vector3.ZERO, Vector3.ONE, Vector3.ZERO, 5.0)
	var aura := MeshInstance3D.new()
	aura.mesh = MeshBuilder.sphere(0.42, 8, 12)
	_slime_mat = ShaderMaterial.new()
	_slime_mat.shader = load("res://shaders/slime.gdshader")
	_slime_mat.set_shader_parameter("albedo", Color(1.0, 0.85, 0.4))
	_slime_mat.set_shader_parameter("glow_color", Color(1.0, 0.8, 0.3))
	_slime_mat.set_shader_parameter("opacity", 0.25)
	_slime_mat.set_shader_parameter("glow", 1.5)
	aura.material_override = _slime_mat
	core.add_child(aura)
	# olhinhos
	for sgn in [-1.0, 1.0]:
		part(core, MeshBuilder.sphere(0.045, 4, 6), Color(0.15, 0.08, 0.02), Vector3(0.08 * sgn, 0.04, 0.2))
	# asas translucidas
	for sgn in [-1.0, 1.0]:
		var w := pivot(core, Vector3(0.18 * sgn, 0.1, -0.05))
		var wm := MeshInstance3D.new()
		wm.mesh = MeshBuilder.sphere(0.25, 5, 8)
		wm.material_override = _slime_mat
		wm.scale = Vector3(1.4, 0.12, 0.7)
		wm.position = Vector3(0.28 * sgn, 0.05, 0)
		w.add_child(wm)
		wings.append(w)
	add_shape(_sphere(0.35), Vector3.ZERO)
	_add_light(gold, 1.4, 6.0, Vector3.ZERO)
	_add_trail(gold, 20, 0.04, Vector3.ZERO, -0.3, 4.0)
	trail.emission_sphere_radius = 0.15


func _ai_wisp(delta: float) -> void:
	if player == null or player.dead:
		move_dir = Vector3(sin(anim_time * 0.3), 0, cos(anim_time * 0.3))
		return
	var target := player.global_position + Vector3(0, 1.4, 0)
	var to := target - global_position
	var d := to.length()
	match state:
		State.SPECIAL:
			# rasante no jogador
			move_dir = to.normalized()
			if try_attack() or state_time > 2.0:
				set_state(State.ATTACK)
		State.ATTACK:
			move_dir = (-to.normalized() + Vector3.UP).normalized()
			if state_time > 1.0:
				set_state(State.CIRCLE)
		_:
			if state != State.CIRCLE:
				set_state(State.CIRCLE)
			var ang := anim_time * 0.8 * circle_sign
			var orbit := player.global_position + Vector3(cos(ang) * 6.0, 3.0 + sin(anim_time * 1.7) * 0.8, sin(ang) * 6.0)
			var t2 := orbit - global_position
			move_dir = t2.normalized() * clampf(t2.length() / 2.0, 0.2, 1.0)
			if state_time > state_len + 2.5 and d < 14.0:
				set_state(State.SPECIAL)


# ---------------------------------------------------------------- golem --

func _build_golem() -> void:
	var stone := Color(0.40, 0.42, 0.52)
	var stone2 := Color(0.33, 0.35, 0.45)
	var moss := Color(0.30, 0.55, 0.30)
	var crystal := Color(0.72, 0.45, 1.0)
	max_hp = 40
	damage = 6
	walk_speed = 1.6
	run_speed = 2.4
	attack_range = 3.4
	attack_cooldown = 2.6
	sight = 30.0
	drops = [Mats.CRYSTAL, 6]
	part(model, _boulder(0.9), stone, Vector3(0, 1.75, 0), Vector3(1.15, 1.0, 0.9))
	part(model, _boulder(0.7), stone2, Vector3(0, 1.05, 0.05), Vector3(1.0, 0.8, 0.85))
	part(model, _boulder(0.5), moss, Vector3(0, 2.45, -0.1), Vector3(1.4, 0.35, 1.1))
	head = pivot(model, Vector3(0, 2.5, 0.45))
	part(head, _boulder(0.42), stone, Vector3.ZERO, Vector3(1.1, 0.85, 1.0))
	part(head, MeshBuilder.box(Vector3(0.6, 0.1, 0.15)), stone2, Vector3(0, 0.12, 0.33))
	glow_eyes(head, Vector3(0, 0.02, 0.36), 0.15, 0.08, crystal, 7.0)
	for sgn in [-1.0, 1.0]:
		var arm := pivot(model, Vector3(1.15 * sgn, 2.05, 0.05))
		part(arm, _boulder(0.42), stone2, Vector3(0.1 * sgn, 0, 0))
		part(arm, _boulder(0.36), stone, Vector3(0.12 * sgn, -0.7, 0.05), Vector3(0.9, 1.2, 0.9))
		part(arm, _boulder(0.46), stone2, Vector3(0.14 * sgn, -1.35, 0.1))
		arms.append(arm)
		var leg := pivot(model, Vector3(0.45 * sgn, 0.75, 0))
		part(leg, _boulder(0.4), stone2, Vector3(0, -0.35, 0), Vector3(1, 1.1, 1))
		legs.append(leg)
	# cristais nas costas e ombros
	var cps := [[Vector3(0.4, 2.45, -0.5), Vector3(-0.5, 0, 0.4)], [Vector3(-0.35, 2.5, -0.45), Vector3(-0.6, 0, -0.35)],
		[Vector3(0, 2.2, -0.75), Vector3(-1.0, 0, 0)], [Vector3(1.2, 2.45, -0.1), Vector3(-0.2, 0, -0.6)],
		[Vector3(-1.2, 2.45, -0.1), Vector3(-0.2, 0, 0.6)], [Vector3(0.1, 1.6, -0.8), Vector3(-1.3, 0, 0.2)]]
	for cp in cps:
		var c := part(model, MeshBuilder.cyl(0.0, 0.2, 0.8, 5), crystal, cp[0], Vector3(1, 1, 1), cp[1], 3.0)
		crystals.append(c)
	add_shape(_capsule(0.95, 2.9), Vector3(0, 1.45, 0))
	_add_light(crystal, 1.3, 7.0, Vector3(0, 2.4, -0.3))
	_add_trail(crystal, 10, 0.06, Vector3(0, 2.3, -0.5), 1.0, 3.0)


func _ai_golem(delta: float) -> void:
	var d := dist_to_player()
	if player == null or player.dead or d > sight:
		wander_ai()
		return
	match state:
		State.SPECIAL:
			# levanta os bracos e soca o chao
			move_dir = Vector3.ZERO
			if state_time > 0.9 and not _smash_done:
				_smash_done = true
				_smash()
			if state_time > 1.6:
				set_state(State.CHASE)
		_:
			if state != State.CHASE:
				set_state(State.CHASE)
			move_dir = dir_to_player()
			if d < attack_range and attack_timer <= 0.0:
				attack_timer = attack_cooldown
				_smash_done = false
				set_state(State.SPECIAL)


func _smash() -> void:
	var p := global_position + model.global_transform.basis.z * 1.2
	for i in 3:
		var a := i * TAU / 3.0
		Effects.poof(get_parent(), p + Vector3(cos(a), 0.2, sin(a)), Color(0.6, 0.6, 0.7), 12, 5.0, 0.12)
	Effects.poof(get_parent(), p + Vector3(0, 0.3, 0), Color(0.75, 0.5, 1.0), 20, 6.0, 0.08, 3.0)
	if player and player.global_position.distance_to(p) < 3.8:
		player.take_damage(damage, p)


# ---------------------------------------------------------------- comum --

func _boulder(r: float) -> ArrayMesh:
	var b := MeshBuilder.new()
	b.add(MeshBuilder.sphere(r, 5, 8), Transform3D.IDENTITY, Color(1, 1, 1), r * 0.14)
	return b.commit()


func _capsule(r: float, h: float) -> CapsuleShape3D:
	var c := CapsuleShape3D.new()
	c.radius = r
	c.height = maxf(h, r * 2.0)
	return c


func _sphere(r: float) -> SphereShape3D:
	var s := SphereShape3D.new()
	s.radius = r
	return s


func _ai(delta: float) -> void:
	match species:
		"lobo":
			_ai_wolf(delta)
		"gosma":
			_ai_slime(delta)
		"espirito":
			_ai_wisp(delta)
		"golem":
			_ai_golem(delta)


func _current_speed() -> float:
	if species == "gosma":
		return 0.0 if is_on_floor() else run_speed
	if species == "lobo" and state == State.SPECIAL:
		return 10.0
	if species == "espirito" and state == State.SPECIAL:
		return 11.0
	return super._current_speed()


func _process(delta: float) -> void:
	super._process(delta)
	if light:
		light.light_energy = _base_light() * fade
	match species:
		"lobo":
			if jaw:
				var open := 0.5 if state == State.SPECIAL else 0.08 + 0.06 * sin(anim_time * 3.0)
				jaw.rotation.x = lerpf(jaw.rotation.x, open, clampf(delta * 10.0, 0.0, 1.0))
			if tail:
				tail.rotation.y = sin(anim_time * 7.0) * 0.35
			if head:
				head.rotation.x = lerpf(head.rotation.x, 0.25 if state == State.CIRCLE else 0.0, clampf(delta * 4.0, 0.0, 1.0))
		"gosma":
			# squash & stretch
			var target := Vector3.ONE
			if not is_on_floor():
				target = Vector3(0.85, 1.25, 0.85) if velocity.y > 0.0 else Vector3(1.05, 0.95, 1.05)
			elif hop_timer < 0.25:
				target = Vector3(1.3, 0.7, 1.3)
			else:
				target = Vector3(1.0 + sin(anim_time * 6.0) * 0.04, 1.0 - sin(anim_time * 6.0) * 0.04, 1.0 + sin(anim_time * 6.0) * 0.04)
			if is_on_floor() and not _last_on_floor:
				target = Vector3(1.4, 0.6, 1.4)
				core.scale = target
			_last_on_floor = is_on_floor()
			core.scale = core.scale.lerp(target, clampf(delta * 12.0, 0.0, 1.0))
		"espirito":
			for i in wings.size():
				wings[i].rotation.z = sin(anim_time * 22.0) * 0.6 * (1.0 if i == 0 else -1.0)
			core.position.y = sin(anim_time * 2.5) * 0.15
			if player:
				var to := player.global_position - global_position
				face_yaw = atan2(to.x, to.z)
		"golem":
			var raise := 0.0
			if state == State.SPECIAL:
				raise = -2.6 if state_time < 0.9 else lerpf(-2.6, 0.3, clampf((state_time - 0.9) * 6.0, 0.0, 1.0))
			for a in arms:
				a.rotation.x = lerpf(a.rotation.x, raise + sin(anim_time * 3.0) * 0.1 * clampf(velocity.length(), 0.0, 1.0), clampf(delta * 8.0, 0.0, 1.0))
			for i in crystals.size():
				var c: Node3D = crystals[i]
				c.scale = Vector3.ONE * (1.0 + sin(anim_time * 2.0 + i) * 0.08)


func _base_light() -> float:
	match species:
		"lobo":
			return 0.7
		"gosma":
			return 0.9 if big else 0.5
		"espirito":
			return 1.4
		"golem":
			return 1.3
	return 0.5


func _animate(delta: float, speed: float) -> void:
	if species == "gosma" or species == "espirito":
		return
	super._animate(delta, speed * (0.6 if species == "golem" else 1.0))


func _death_color() -> Color:
	match species:
		"lobo":
			return Color(0.45, 0.9, 1.0)
		"gosma":
			return _slime_mat.get_shader_parameter("albedo") if _slime_mat else Color(0.3, 1, 0.8)
		"espirito":
			return Color(1.0, 0.9, 0.4)
	return Color(0.75, 0.5, 1.0)


func die() -> void:
	# gosma grande vira duas pequenas
	if species == "gosma" and big:
		var mgr := get_parent()
		if mgr is MobManager:
			for sgn in [-1.0, 1.0]:
				var small := NightCreature.create("gosma", false)
				mgr.spawn(small, global_position + Vector3(0.6 * sgn, 0.5, 0))
				small.fade = 1.0
				small.velocity = Vector3(3.0 * sgn, 5.0, 0)
	super.die()


func _on_hurt() -> void:
	if species == "lobo":
		set_state(State.ATTACK)  # recua
	elif species == "espirito":
		set_state(State.ATTACK)
	elif species != "golem":
		set_state(State.CHASE)
