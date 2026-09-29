class_name Infected
extends CharacterBody3D
## Infectado com IA por estados e percepção (visão/audição/luz/obstáculos).
##
## Custo controlado por tier do SimScheduler:
##   FULL    — física, percepção ~8 Hz, animação por frame (≤25 m) ou 30 Hz
##   SIMPLE  — movimento cinemático sem colisão, ~3 Hz, animação 8 Hz
##   MINIMAL — posição interpolada, sem animação; devolvido ao pool longe
## Nós reciclados em pool pelo AIDirector (sem criar/destruir por spawn).

enum S { DORMANT, IDLE, WANDER, INVESTIGATE, SEARCH, CHASE, ATTACK, STAGGER, DOWN, FLEE, DEAD, SCREAM, CHARGE, SCRIPTED }

const KNOCK_DECEL := 11.0
const MAX_KNOCK := 6.5

var kind: String = "errante"
var def: Dictionary = {}
var body: HumanoidBody
var hp: float = 75.0
var state: int = S.IDLE
var agent: SimScheduler.Agent
var tier: int = 0
var director: Node = null
var world: World = null
var target: Node3D = null
var target_pos: Vector3 = Vector3.INF
var last_seen: float = 0.0
var suspicion: float = 0.0
var home: Vector3 = Vector3.ZERO
var cell: Vector2i = Vector2i.ZERO
var active: bool = false
var scripted: bool = false
var variant: int = 0
var dormant_anim: String = "inf_dormant"
var path := PackedVector3Array()
var path_i: int = 0
var desired_dir := Vector3.ZERO
var move_speed: float = 0.0
var hidden_ambush: bool = false

var _state_t: float = 0.0
var _attack_cd: float = 0.0
var _attack_active: bool = false
var _attack_hit: bool = false
var _attack_name: String = ""
var _voice_t: float = 3.0
var _sprint_t: float = 0.0
var _repath_t: float = 0.0
var _bash_t: float = 0.0
var _charge_cd: float = 4.0
var _charge_dir := Vector3.ZERO
var _spore_t: float = 6.0
var _knock := Vector3.ZERO      # empurrão recebido (m/s), some com atrito
var _move_vel := Vector3.ZERO   # velocidade própria (andar/correr), sem o empurrão
var _lerp_from := Vector3.ZERO
var _lerp_to := Vector3.ZERO
var _lerp_t: float = 1.0
var _ground_t: float = 0.0
var _dead_t: float = 0.0
var _flee_from := Vector3.ZERO
var _separation := Vector3.ZERO
var _yaw: float = 0.0
var _rng := RandomNumberGenerator.new()
var _col: CollisionShape3D


func _init() -> void:
	add_to_group("infected")
	add_to_group("damageable")
	collision_layer = 1 << 3
	collision_mask = 1 | (1 << 1) | (1 << 2) | (1 << 3) | (1 << 4)
	floor_max_angle = deg_to_rad(50.0)
	floor_snap_length = 0.4
	_col = CollisionShape3D.new()
	var cap := CapsuleShape3D.new()
	cap.radius = 0.33
	cap.height = 1.72
	_col.shape = cap
	_col.position = Vector3(0, 0.86, 0)
	add_child(_col)


## Ativa a partir do pool.
func activate(k: String, pos: Vector3, yaw: float, var_seed: int, st: int, w: World, d: Node) -> void:
	kind = k
	def = InfectedTypes.get_type(k)
	world = w
	director = d
	variant = var_seed % 8
	hp = float(def["hp"]) * (1.0 + 0.15 * (Settings.difficulty() - 1))
	_rng.seed = var_seed * 31 + hash(k)
	global_position = pos
	home = pos
	_yaw = yaw
	target = null
	target_pos = Vector3.INF
	suspicion = 0.0
	_state_t = 0.0
	_attack_cd = _rng.randf_range(0.5, 1.5)
	_charge_cd = 4.0
	_spore_t = 6.0
	_dead_t = 0.0
	_knock = Vector3.ZERO
	_move_vel = Vector3.ZERO
	path = PackedVector3Array()
	hidden_ambush = false
	scripted = false
	collision_layer = 1 << 3
	var cap := _col.shape as CapsuleShape3D
	cap.radius = 0.45 if k == "colosso" else 0.33
	cap.height = 2.1 if k == "colosso" else (0.8 if k == "rastejante" else 1.72)
	_col.position = Vector3(0, cap.height * 0.5, 0)
	if body == null or body.appearance.get("id", "") != "infected_" + k or int(body.appearance.get("seed", -1)) != variant:
		if body:
			body.queue_free()
		body = HumanoidBody.new()
		add_child(body)
		body.setup(Appearance.infected(k, variant), 1)
		body.anim_event.connect(_on_anim_event)
		body.animator.twitchiness = float(def.get("twitch", 0.4))
	body.visible = true
	body.frozen = false
	body.stop_action()
	body.animator.stop_immediate()
	body.rotation.y = _yaw
	active = true
	visible = true
	set_state(st)
	if agent == null or not agent.alive:
		agent = SimScheduler.register(self, _think, _on_tier)
	set_physics_process(true)


func deactivate() -> void:
	active = false
	visible = false
	collision_layer = 0
	set_physics_process(false)
	if agent:
		SimScheduler.unregister(agent)
		agent = null
	if body:
		body.frozen = true


# ---------------------------------------------------------------------------
# Estados
# ---------------------------------------------------------------------------
func set_state(s: int) -> void:
	if state == S.DEAD and s != S.DEAD:
		return
	state = s
	_state_t = 0.0
	match s:
		S.DORMANT:
			if kind == "rastejante":
				body.play("lie", 1.0)
				hidden_ambush = true
			else:
				body.play(dormant_anim, 1.0)
		S.IDLE, S.WANDER, S.INVESTIGATE, S.SEARCH, S.CHASE:
			if body.animator.is_playing("inf_dormant") or body.animator.is_playing("lie") or body.animator.is_playing("sit"):
				body.stop_action()
				if kind == "rastejante" and hidden_ambush:
					hidden_ambush = false
		S.SCREAM:
			body.play("scream", 1.0)
			AudioManager.play_3d("infected_scream", global_position, 4.0, _rng.randf_range(0.9, 1.1), 90.0)
		S.STAGGER:
			body.play("stagger", 1.1)
		S.DOWN:
			body.play("knockdown", 0.9)


func is_alive() -> bool:
	return state != S.DEAD


func is_downed() -> bool:
	return state == S.DOWN and _state_t < 1.6


func is_chasing() -> bool:
	return state == S.CHASE or state == S.ATTACK or state == S.CHARGE


func _on_tier(t: int) -> void:
	tier = t
	if not active or body == null:
		return
	var d := global_position.distance_to(SimScheduler.focus_position)
	match t:
		SimScheduler.Tier.FULL:
			body.anim_interval = 0.0 if d < 25.0 else 1.0 / 30.0
			body.frozen = false
			collision_layer = 1 << 3 if state != S.DEAD else 0
			set_physics_process(true)
		SimScheduler.Tier.SIMPLE:
			body.anim_interval = 1.0 / 8.0
			body.frozen = false
			set_physics_process(true)
		_:
			body.frozen = true
			set_physics_process(false)
			_lerp_from = global_position
			_lerp_to = global_position
	if director and director.has_method("on_infected_tier"):
		director.on_infected_tier(self, t)


# ---------------------------------------------------------------------------
# Pensamento (frequência variável por tier)
# ---------------------------------------------------------------------------
func _think(dt: float, t: int) -> void:
	if not active:
		return
	if state == S.DEAD:
		_dead_t += dt
		return
	_attack_cd -= dt
	_charge_cd -= dt
	_spore_t -= dt
	if not scripted:
		_perceive(dt)
		_decide(dt)
	_plan_move(dt)
	if t >= SimScheduler.Tier.MINIMAL:
		# movimento abstrato: salto entre pontos, interpolado no _process
		_lerp_from = global_position
		_lerp_to = global_position + desired_dir * move_speed * dt
		if world:
			_lerp_to.y = world.ground_y(_lerp_to.x, _lerp_to.z)
		_lerp_t = 0.0
	# vocalizações
	_voice_t -= dt
	if _voice_t <= 0.0 and t == SimScheduler.Tier.FULL:
		_voice_t = _rng.randf_range(4.0, 11.0) * (0.5 if is_chasing() else 1.0)
		var v: String = def.get("voice", "infected_groan")
		if v == "spores":
			v = "infected_groan"
		AudioManager.play_3d(v, global_position + Vector3(0, 1.6, 0), -3.0 if not is_chasing() else 0.0, _rng.randf_range(0.85, 1.15), 45.0)


func _process(delta: float) -> void:
	if tier >= SimScheduler.Tier.MINIMAL and active and state != S.DEAD and _lerp_t < 1.0:
		_lerp_t = minf(1.0, _lerp_t + delta / maxf(SimScheduler.tier_intervals[SimScheduler.Tier.MINIMAL], 0.1))
		global_position = _lerp_from.lerp(_lerp_to, _lerp_t)


func _perceive(dt: float) -> void:
	var p: Node3D = director.player if director else null
	var dormant_f := 0.45 if state == S.DORMANT else 1.0
	var best: Node3D = null
	var best_score := 0.0
	var candidates: Array = []
	if p != null and is_instance_valid(p) and not p.cinematic and not p.survival.dead and p.in_vehicle == null:
		candidates.append(p)
	elif p != null and is_instance_valid(p) and p.in_vehicle != null:
		candidates.append(p.in_vehicle)
	if director and director.has_method("npcs_near"):
		candidates.append_array(director.npcs_near(global_position, def["vision"] * 1.2))
	var fwd := Vector3(-sin(_yaw), 0, -cos(_yaw))
	var fov_cos := cos(deg_to_rad(float(def["fov"]) * 0.5))
	for c in candidates:
		var tn := c as Node3D
		var to := tn.global_position - global_position
		var d := to.length()
		var vis := 0.7
		if tn is Player:
			vis = (tn as Player).visibility_level
		elif tn.has_method("visibility"):
			vis = tn.visibility()
		var eff: float = float(def["vision"]) * (0.3 + 0.7 * vis) * director.vision_mult * dormant_f
		if d < 1.3 * dormant_f + 0.3:
			best = tn
			best_score = 99.0
			break
		if d > eff:
			continue
		if fov_cos > -0.99 and d > 2.5:
			if fwd.dot(Vector3(to.x, 0, to.z).normalized()) < fov_cos:
				continue
		if not _los(tn):
			continue
		var score: float = (eff - d) / eff + 0.2
		if score > best_score:
			best_score = score
			best = tn
	if best != null:
		suspicion += dt * (1.2 + best_score * 3.5) * (1.6 if state == S.INVESTIGATE or state == S.SEARCH else 1.0)
		target_pos = best.global_position
		if suspicion >= 1.0 or best_score > 50.0:
			suspicion = 1.2
			if target != best or not is_chasing():
				target = best
				_start_chase()
			last_seen = SimScheduler.now()
		elif suspicion > 0.3 and state in [S.IDLE, S.WANDER, S.DORMANT]:
			set_state(S.INVESTIGATE)
	else:
		suspicion = maxf(0.0, suspicion - dt * 0.25)
		if is_chasing() and target != null and is_instance_valid(target):
			# ainda "sente" o alvo por perto (cheiro/ruído)
			if global_position.distance_to(target.global_position) < 4.0:
				target_pos = target.global_position
				last_seen = SimScheduler.now()


func _los(tn: Node3D) -> bool:
	var space := get_world_3d().direct_space_state
	var from := global_position + Vector3(0, 1.55, 0)
	var to := tn.global_position + Vector3(0, 1.2, 0)
	var q := PhysicsRayQueryParameters3D.create(from, to, 1)
	q.exclude = [get_rid()]
	return space.intersect_ray(q).is_empty()


func _start_chase() -> void:
	if def.get("screamer", false) and state != S.CHASE and state != S.SCREAM:
		set_state(S.SCREAM)
		if director:
			director.alert_area(global_position, 55.0, target_pos, self)
		return
	set_state(S.CHASE)
	if director:
		director.alert_area(global_position, 11.0, target_pos, self)
	if kind == "colosso":
		AudioManager.play_3d("brute_roar", global_position, 4.0, 1.0, 80.0)


## Ruído recebido do AIDirector (evento).
func on_noise(pos: Vector3, radius: float, kind_n: StringName, source: Node) -> void:
	if not active or state in [S.DEAD, S.STAGGER, S.DOWN, S.SCREAM, S.SCRIPTED]:
		return
	var eff: float = radius * float(def["hearing"]) * director.hearing_mult * (0.55 if state == S.DORMANT else 1.0)
	var d := global_position.distance_to(pos)
	if d > eff:
		return
	var loud: float = 1.0 - d / eff
	if is_chasing() and target != null and is_instance_valid(target) and SimScheduler.now() - last_seen < 3.0:
		return
	var err: float = d * 0.12 * (1.0 - loud)
	target_pos = pos + Vector3(_rng.randf_range(-err, err), 0, _rng.randf_range(-err, err))
	if source is Player and loud > 0.55 and d < 9.0:
		suspicion = maxf(suspicion, 0.75)
	if def.get("screamer", false) and loud > 0.25 and state != S.CHASE:
		set_state(S.SCREAM)
		director.alert_area(global_position, 55.0, pos, self)
		return
	if state != S.CHASE:
		set_state(S.INVESTIGATE)


## Alerta vindo de outro infectado (grito/manada).
func on_alert(pos: Vector3, by: Node) -> void:
	if not active or state in [S.DEAD, S.STAGGER, S.DOWN, S.SCRIPTED] or is_chasing():
		return
	target_pos = pos
	suspicion = maxf(suspicion, 0.6)
	set_state(S.INVESTIGATE)


func _decide(dt: float) -> void:
	var now := SimScheduler.now()
	match state:
		S.DORMANT:
			if hidden_ambush and director and director.player:
				var p: Node3D = director.player
				if p.global_position.distance_to(global_position) < 2.3 and not p.cinematic:
					target = p
					set_state(S.CHASE)
					_try_attack(true)
		S.IDLE:
			if _state_t > _rng.randf_range(6.0, 14.0):
				if director and (director.roam or _rng.randf() < 0.5):
					set_state(S.WANDER)
					target_pos = _wander_point()
				else:
					_state_t = 0.0
					body.play("inf_sniff" if _rng.randf() < 0.5 else "inf_twitch", 1.0)
		S.WANDER:
			if target_pos == Vector3.INF or global_position.distance_to(target_pos) < 1.5 or _state_t > 25.0:
				set_state(S.IDLE)
		S.INVESTIGATE:
			if target_pos == Vector3.INF or global_position.distance_to(target_pos) < 1.8:
				set_state(S.SEARCH)
			elif _state_t > 30.0:
				set_state(S.IDLE)
		S.SEARCH:
			if _state_t > 9.0:
				set_state(S.IDLE)
			elif fmod(_state_t, 3.0) < dt * 1.5:
				target_pos = global_position + Vector3(_rng.randf_range(-6, 6), 0, _rng.randf_range(-6, 6))
		S.SCREAM:
			if _state_t > 1.7:
				set_state(S.CHASE if target != null else S.INVESTIGATE)
		S.CHASE:
			if target == null or not is_instance_valid(target):
				set_state(S.SEARCH)
				return
			if target is Player and ((target as Player).survival.dead or (target as Player).cinematic):
				set_state(S.IDLE)
				target = null
				return
			if now - last_seen > 6.0:
				set_state(S.SEARCH)
				return
			var d := global_position.distance_to(target.global_position)
			# febril: sensível à luz da lanterna
			if def.get("light_sensitive", false) and target is Player and (target as Player).flashlight_on and d < 14.0:
				var pl := target as Player
				var ldir := pl.cam_rig.look_dir()
				var tome := (global_position + Vector3(0, 1.2, 0) - pl.flashlight.global_position).normalized()
				if ldir.dot(tome) > 0.94:
					_flee_from = pl.global_position
					set_state(S.FLEE)
					AudioManager.play_3d("infected_attack", global_position, 0.0, 1.3)
					return
			# colosso: investida
			if def.get("charger", false) and _charge_cd <= 0.0 and d > 6.0 and d < 17.0 and _los(target):
				_charge_cd = 9.0
				_charge_dir = (target.global_position - global_position)
				_charge_dir.y = 0.0
				_charge_dir = _charge_dir.normalized()
				set_state(S.CHARGE)
				body.play("brute_roar", 1.6)
				AudioManager.play_3d("brute_roar", global_position, 6.0, 0.9, 90.0)
				return
			# hospedeiro: esporos
			if def.get("spores", false) and _spore_t <= 0.0 and d < 7.0:
				_spore_t = 11.0
				body.play("spores", 1.0)
				return
			if d < float(def["reach"]) + 0.2:
				_try_attack(false)
		S.ATTACK:
			if not body.animator.is_playing() or _state_t > 2.0:
				set_state(S.CHASE)
		S.STAGGER:
			if _state_t > 1.0:
				set_state(S.CHASE if target else S.SEARCH)
		S.DOWN:
			if _state_t > 2.4:
				set_state(S.CHASE if target else S.SEARCH)
		S.FLEE:
			if _state_t > 1.8:
				set_state(S.CHASE)
		S.CHARGE:
			if _state_t > 3.2:
				set_state(S.CHASE)


func _try_attack(ambush: bool) -> void:
	if _attack_cd > 0.0 and not ambush:
		return
	var atks: Array = def["attacks"]
	var a: String = atks[_rng.randi() % atks.size()]
	if a == "spores":
		a = "inf_swipe"
	_attack_name = a
	_attack_hit = false
	set_state(S.ATTACK)
	body.play(a, 1.0 + (Settings.difficulty() - 1) * 0.08)
	_attack_cd = _rng.randf_range(1.2, 2.2) * (1.4 if kind == "colosso" else 1.0)
	AudioManager.play_3d("infected_attack", global_position + Vector3(0, 1.5, 0), 0.0, _rng.randf_range(0.9, 1.15), 35.0)


func _wander_point() -> Vector3:
	if world == null:
		return home + Vector3(_rng.randf_range(-10, 10), 0, _rng.randf_range(-10, 10))
	return world.layout.random_street_point(_rng, home, 22.0)


# ---------------------------------------------------------------------------
# Movimento
# ---------------------------------------------------------------------------
func _plan_move(dt: float) -> void:
	var speed := 0.0
	var dest := Vector3.INF
	match state:
		S.WANDER:
			speed = float(def["walk"])
			dest = target_pos
		S.INVESTIGATE, S.SEARCH:
			speed = float(def["walk"]) * 1.3
			dest = target_pos
		S.CHASE:
			speed = float(def["run"])
			if def.has("sprint_limit"):
				_sprint_t += dt
				if _sprint_t > float(def["sprint_limit"]):
					speed = float(def["walk"])
					if _sprint_t > float(def["sprint_limit"]) + 3.0:
						_sprint_t = 0.0
			dest = target.global_position if target != null and is_instance_valid(target) else target_pos
		S.FLEE:
			speed = float(def["run"]) * 0.8
			var away := global_position - _flee_from
			away.y = 0.0
			desired_dir = away.normalized()
			move_speed = speed
			return
		S.CHARGE:
			if _state_t < 1.0:
				speed = 0.0
			else:
				speed = float(def["run"]) * 1.9
				desired_dir = _charge_dir
				move_speed = speed
				return
	move_speed = speed
	if dest == Vector3.INF or speed <= 0.0:
		desired_dir = Vector3.ZERO
		return
	var to := dest - global_position
	to.y = 0.0
	if to.length() < 0.8:
		desired_dir = Vector3.ZERO
		return
	# caminho pela malha viária se longe e sem visão direta
	_repath_t -= dt
	if to.length() > 25.0 and tier <= SimScheduler.Tier.SIMPLE and _repath_t <= 0.0 and world != null:
		_repath_t = 2.5
		path = world.layout.find_path(global_position, dest)
		path_i = 0
	if not path.is_empty() and to.length() > 20.0:
		while path_i < path.size() - 1 and Vector2(path[path_i].x - global_position.x, path[path_i].z - global_position.z).length() < 3.0:
			path_i += 1
		var pp := path[path_i] - global_position
		pp.y = 0.0
		desired_dir = pp.normalized()
	else:
		desired_dir = to.normalized()
	# separação entre infectados (evita empilhar)
	if tier == SimScheduler.Tier.FULL and director:
		var sep := Vector3.ZERO
		for o in director.infected_near(global_position, 1.3):
			if o == self:
				continue
			var d: Vector3 = global_position - (o as Node3D).global_position
			d.y = 0.0
			var l := d.length()
			if l > 0.01:
				sep += d / (l * l)
		desired_dir = (desired_dir + sep * 0.35).normalized()


func _physics_process(delta: float) -> void:
	if not active:
		return
	_state_t += delta
	if state == S.DEAD:
		# o corpo ainda escorrega um pouco com o golpe final
		_knock = _knock.move_toward(Vector3.ZERO, delta * KNOCK_DECEL * 1.5)
		velocity.x = _knock.x
		velocity.z = _knock.z
		if tier == SimScheduler.Tier.FULL:
			velocity.y -= 18.0 * delta
			move_and_slide()
		body.tick(delta)
		return
	var locked := state in [S.ATTACK, S.STAGGER, S.DOWN, S.SCREAM, S.SCRIPTED, S.DORMANT] or (state == S.CHARGE and _state_t < 1.0)
	var wish := Vector3.ZERO if locked else desired_dir * move_speed
	if state == S.ATTACK and target != null and is_instance_valid(target) and _state_t < 0.35:
		var tt := target.global_position - global_position
		tt.y = 0.0
		_yaw = lerp_angle(_yaw, atan2(-tt.x, -tt.z), 1.0 - exp(-delta * 10.0))
		if _attack_name == "inf_lunge":
			wish = tt.normalized() * 2.5
	if tier == SimScheduler.Tier.FULL:
		# movimento próprio e empurrão separados: o empurrão não acumula quadro a quadro
		_move_vel = _move_vel.move_toward(wish, delta * 12.0)
		velocity.x = _move_vel.x + _knock.x
		velocity.z = _move_vel.z + _knock.z
		_knock = _knock.move_toward(Vector3.ZERO, delta * KNOCK_DECEL)
		velocity.y = -0.5 if is_on_floor() else velocity.y - 18.0 * delta
		move_and_slide()
		if state == S.CHARGE and _state_t > 1.0:
			_charge_collisions()
		elif is_chasing() and is_on_wall() and wish.length() > 0.5:
			_try_bash(delta)
	else:
		global_position += wish * delta
		_ground_t -= delta
		if _ground_t <= 0.0 and world:
			_ground_t = 0.35
			global_position.y = world.ground_y(global_position.x, global_position.z)
	if wish.length() > 0.2 and not locked:
		_yaw = lerp_angle(_yaw, atan2(-wish.x, -wish.z), 1.0 - exp(-delta * 7.0))
	body.rotation.y = _yaw
	var sp := Vector2(_move_vel.x, _move_vel.z).length() if tier == SimScheduler.Tier.FULL else wish.length()
	body.animator.speed = sp
	body.animator.forward_speed = sp
	body.animator.style = str(def["run_style"]) if sp > 2.0 else str(def["style"])
	body.tick(delta)
	if _attack_active and not _attack_hit:
		_attack_sweep()


func _charge_collisions() -> void:
	if target != null and is_instance_valid(target) and target.global_position.distance_to(global_position) < 1.8:
		var info := DamageInfo.make(float(def["damage"]) * 1.2, "heavy", self, _charge_dir)
		info.knockback = 9.0
		info.stagger = 1.0
		info.blockable = false
		target.receive_hit(info)
		set_state(S.CHASE)
		return
	if is_on_wall():
		# bateu na parede: atordoado e vulnerável
		AudioManager.play_3d("door_bash", global_position, 4.0, 0.7)
		EventBus.make_noise(global_position, 20.0, self, &"crash")
		if director and director.player:
			director.player.cam_rig.add_shake(0.3)
		set_state(S.STAGGER)
		_state_t = -1.6


func _try_bash(delta: float) -> void:
	_bash_t -= delta
	if _bash_t > 0.0:
		return
	_bash_t = 1.3
	var space := get_world_3d().direct_space_state
	var from := global_position + Vector3(0, 1.1, 0)
	var q := PhysicsRayQueryParameters3D.create(from, from + desired_dir * 1.2, 1)
	q.exclude = [get_rid()]
	var r := space.intersect_ray(q)
	if r.is_empty():
		return
	var col: Object = r["collider"]
	var n: Node = col as Node
	while n != null and not (n is Door):
		n = n.get_parent()
	if n is Door:
		body.play("inf_swipe", 1.0)
		(n as Door).bash(float(def["damage"]) * (3.0 if kind == "colosso" else 1.0), self)


func _on_anim_event(e: String) -> void:
	match e:
		"hit_start":
			_attack_active = true
		"hit_end":
			_attack_active = false
		"slam":
			_slam()
		"spores":
			_release_spores()
		"scream":
			pass


func _attack_sweep() -> void:
	var fwd := Vector3(-sin(_yaw), 0, -cos(_yaw))
	var hits := Melee.sweep(self, global_position + Vector3(0, 1.1 if kind != "rastejante" else 0.3, 0), fwd, float(def["reach"]), 0.4, 60.0, [get_rid()])
	for h in hits:
		if h is Infected:
			continue
		_attack_hit = true
		var kind_d := "scratch" if _attack_name == "inf_swipe" else "bite"
		var info := DamageInfo.make(float(def["damage"]) * _rng.randf_range(0.85, 1.15), kind_d, self, (h as Node3D).global_position - global_position)
		info.infection_chance = float(def["bite"]) * (1.0 if kind_d == "bite" else 0.35)
		info.knockback = 1.5
		info.stagger = 0.3
		h.receive_hit(info)
		return


func _slam() -> void:
	EventBus.make_noise(global_position, 30.0, self, &"slam")
	AudioManager.play_3d("body_fall", global_position, 6.0, 0.6, 60.0)
	if director and director.player:
		var p: Player = director.player
		var d := p.global_position.distance_to(global_position + Vector3(-sin(_yaw), 0, -cos(_yaw)) * 1.5)
		p.cam_rig.add_shake(clampf(1.0 - d / 12.0, 0.0, 0.8))
		if d < 2.4:
			var info := DamageInfo.make(float(def["damage"]), "heavy", self, p.global_position - global_position)
			info.knockback = 7.0
			info.stagger = 1.0
			p.receive_hit(info)


func _release_spores() -> void:
	var sc := SporeCloud.new()
	get_parent().add_child(sc)
	sc.global_position = global_position + Vector3(0, 1.0, 0)
	AudioManager.play_3d("spores", global_position, 2.0, 1.0, 40.0)


# ---------------------------------------------------------------------------
# Dano
# ---------------------------------------------------------------------------
## Empurrão de um golpe: velocidade inicial em m/s (com atrito KNOCK_DECEL anda
## v²/2a: soco ~0,3 m, taco ~0,6 m, marreta pesada ~2 m). Colosso quase não se mexe.
func knock_vector(info: DamageInfo) -> Vector3:
	var v := minf(info.knockback, MAX_KNOCK) * (0.2 if kind == "colosso" else 1.0)
	var d := Vector3(info.direction.x, 0, info.direction.z)
	return d.normalized() * v if d.length_squared() > 0.0001 else Vector3.ZERO


func receive_hit(info: DamageInfo) -> void:
	if state == S.DEAD or not active:
		return
	var dmg := info.amount
	if info.stealth:
		dmg = 9999.0
	match info.kind:
		"blunt", "heavy":
			dmg *= float(def.get("resist_blunt", 1.0))
		"sharp":
			dmg *= float(def.get("resist_sharp", 1.0))
	if state == S.STAGGER and kind == "colosso":
		dmg *= 1.6
	if state == S.DOWN:
		dmg *= 2.0
	hp -= dmg
	if info.source is Node3D and not info.stealth:
		target = info.source as Node3D
		target_pos = target.global_position
		last_seen = SimScheduler.now()
		suspicion = 1.5
	if hp <= 0.0:
		die(info)
		return
	var local := body.global_transform.basis.inverse() * info.direction
	body.animator.flinch(local, clampf(dmg / 20.0, 0.4, 1.6))
	_knock = knock_vector(info)
	var poise := float(def["poise"])
	var st := info.stagger * 40.0 + dmg * 0.5
	if info.kind == "push" and kind == "colosso":
		st = 0.0
	if st > poise * 2.2 and kind != "colosso" and (info.heavy or info.kind == "push"):
		set_state(S.DOWN)
	elif st > poise:
		set_state(S.STAGGER)
	elif not is_chasing() and state != S.SCRIPTED:
		_start_chase()
	if info.bleed > 0.0:
		hp -= info.bleed * 10.0


func on_parried(_by: Node) -> void:
	if state == S.DEAD:
		return
	set_state(S.STAGGER)
	_state_t = -0.5
	_attack_active = false


func can_be_stealth_killed(p: Node) -> bool:
	if state in [S.DEAD, S.CHASE, S.ATTACK, S.CHARGE, S.SCREAM, S.SCRIPTED] or kind == "colosso":
		return false
	if suspicion > 0.85:
		return false
	var fwd := Vector3(-sin(_yaw), 0, -cos(_yaw))
	var to := ((p as Node3D).global_position - global_position)
	to.y = 0.0
	return fwd.dot(to.normalized()) < 0.0 or state == S.DORMANT


func begin_stealth_death(_p: Node) -> void:
	scripted = true
	set_state(S.SCRIPTED)
	body.play("hit_back", 0.6)


func die(info: DamageInfo = null) -> void:
	if state == S.DEAD:
		return
	state = S.DEAD
	_state_t = 0.0
	_dead_t = 0.0
	_attack_active = false
	collision_layer = 0
	_move_vel = Vector3.ZERO
	_knock = knock_vector(info) * 0.7 if info else Vector3.ZERO
	body.play("death" if _rng.randf() < 0.5 else "death_front", 1.0)
	AudioManager.play_3d("body_fall", global_position, -2.0, _rng.randf_range(0.8, 1.1), 30.0)
	var killer: Node = info.source if info else null
	GameState.add_stat("infected_killed")
	EventBus.enemy_killed.emit(kind, global_position, killer)
	if director:
		director.on_infected_died(self)
	# alguns carregam pertences de quando eram gente
	if _rng.randf() < 0.3 and killer is Player:
		var lc := LootContainer.new()
		add_child(lc)
		lc.setup({"uid": "corpse_%d" % Time.get_ticks_usec(), "kind": "body", "context": "camp", "pos": Vector3(0, 0.3, 0), "size": Vector3(1.2, 0.5, 1.8)})
		lc.position = Vector3(0, 0.3, 0)


func dead_time() -> float:
	return _dead_t if state == S.DEAD else 0.0
