class_name SurvivorNPC
extends CharacterBody3D
## Sobrevivente com necessidades, rotina, memória e reações.
##
## Comportamentos: rotina (vigiar, aquecer-se, cozinhar, dormir...),
## patrulha, coleta (sai da base e volta), proteger (luta contra
## infectados), fugir, trocar, ajudar/acompanhar o jogador, avisar e
## atacar invasores. Custo controlado por tier do SimScheduler (igual aos
## infectados): FULL com física, SIMPLE cinemático, MINIMAL interpolado.

enum S { IDLE, MOVE, FIGHT, FLEE, WARN, TALK, DOWNED, DEAD, FOLLOW, WAIT, SCRIPTED }

const TALK_RANGE := 3.0

var npc_id: String = ""
var display_name: String = "Sobrevivente"
var faction: String = ""
var role: String = "civilian"
var named: bool = false
var essential: bool = false
var trader: bool = false
var can_follow: bool = false
var fighter: bool = false
var weapon: String = ""
var routine: Array = []
var camp: String = ""
var home: Vector3 = Vector3.ZERO
var anchors: Dictionary = {}       # "fire", "post", "sleep" -> Vector3
var hp: float = 100.0
var max_hp: float = 100.0
var state: int = S.IDLE
var activity: String = ""
var body: HumanoidBody
var manager: Node = null
var world: World = null
var agent: SimScheduler.Agent
var tier: int = 0
var trade_inv: Inventory
var talk_area: Interactable

# necessidades (0 = satisfeito, 1 = crítico) e humor
var hunger: float = 0.2
var fatigue: float = 0.2
var fear: float = 0.0

var target: Node3D = null            # alvo de combate
var follow_target: Node3D = null
var move_dest: Vector3 = Vector3.INF
var move_speed: float = 0.0
var desired_dir := Vector3.ZERO
var path := PackedVector3Array()
var path_i: int = 0

var _state_t: float = 0.0
var _yaw: float = 0.0
var _rng := RandomNumberGenerator.new()
var _attack_cd: float = 0.0
var _attack_pending: bool = false
var _bark_cd: float = 0.0
var _warn_t: float = 0.0
var _knock := Vector3.ZERO
var _lerp_from := Vector3.ZERO
var _lerp_to := Vector3.ZERO
var _lerp_t: float = 1.0
var _ground_t: float = 0.0
var _repath_t: float = 0.0
var _hit_rep_t: float = 0.0
var _activity_anim: String = ""
var _flee_from := Vector3.ZERO
var _downed_t: float = 0.0
var _dead_t: float = 0.0
var _scan_t: float = 0.0


func _init() -> void:
	add_to_group("npc")
	add_to_group("damageable")
	collision_layer = 1 << 2
	collision_mask = 1 | (1 << 1) | (1 << 2) | (1 << 3) | (1 << 4)
	floor_max_angle = deg_to_rad(50.0)
	floor_snap_length = 0.4
	var cs := CollisionShape3D.new()
	var cap := CapsuleShape3D.new()
	cap.radius = 0.32
	cap.height = 1.74
	cs.shape = cap
	cs.position = Vector3(0, 0.87, 0)
	add_child(cs)


func setup(d: Dictionary, mgr: Node, w: World) -> void:
	manager = mgr
	world = w
	npc_id = d["id"]
	display_name = d.get("name", "Sobrevivente")
	faction = d.get("faction", "")
	role = d.get("role", "civilian")
	named = bool(d.get("named", false))
	essential = bool(d.get("essential", false))
	trader = bool(d.get("trader", false))
	can_follow = bool(d.get("companion", false))
	weapon = d.get("weapon", "")
	fighter = weapon != "" and role not in ["child", "captive", "family", "scientist", "cook"]
	routine = d.get("routine", [[6, "wander", "wander"], [20, "warm", "fire"], [23, "sleep", "sleep"]])
	camp = d.get("camp", "")
	home = d["pos"]
	anchors = d.get("anchors", {})
	_rng.seed = Util.hash_str(npc_id)
	max_hp = 140.0 if fighter else 90.0
	hp = float(d.get("hp", max_hp))
	_yaw = float(d.get("yaw", _rng.randf() * TAU))
	global_position = home
	body = HumanoidBody.new()
	body.name = "Body"
	add_child(body)
	body.setup(d["appearance"], 1)
	body.anim_event.connect(_on_anim_event)
	body.rotation.y = _yaw
	if weapon != "":
		var mi := MeshInstance3D.new()
		mi.mesh = WeaponMeshes.mesh(weapon)
		body.attach("hand_r", mi, Transform3D(Basis(Vector3.RIGHT, -PI * 0.5), Vector3(0.0, -0.12, -0.02)))
	if trader:
		trade_inv = Inventory.new("trade_" + npc_id, 200.0, 40, display_name)
		_restock()
	talk_area = NPCTalk.new()
	talk_area.npc = self
	add_child(talk_area)
	talk_area.add_shape(Vector3(1.2, 1.8, 1.2), Vector3(0, 0.9, 0))
	agent = SimScheduler.register(self, _think, _on_tier)
	if role == "captive":
		set_state(S.SCRIPTED)
		body.play("sit", 1.0)


func _exit_tree() -> void:
	if agent:
		SimScheduler.unregister(agent)
		agent = null


func _restock() -> void:
	trade_inv.clear()
	var ctx := "camp"
	var kind := "stash"
	match faction:
		"guarda":
			ctx = "police"
			kind = "locker"
		"remanescentes":
			ctx = "house"
			kind = "kitchen_cabinet"
	if role == "mechanic":
		ctx = "workshop"
		kind = "toolbox"
	elif role == "cook":
		ctx = "grocery"
		kind = "shelf"
	for i in 3:
		for s in LootTables.roll(ctx, kind, "trade_%s_%d_%d" % [npc_id, TimeManager.day, i], "", 1.4):
			trade_inv.add_stack(s, true)
	if role == "mechanic":
		for it: String in ["fita_adesiva", "parafusos", "chave_inglesa", "mangueira", "pregos"]:
			trade_inv.add(it, 1 + _rng.randi() % 3, 1.0, {}, true)
	if role == "cook":
		for it: String in ["sopa_caseira", "agua_fervida", "arroz_cozido"]:
			trade_inv.add(it, 2, 1.0, {}, true)


func visibility() -> float:
	return 0.3 if activity == "hide" else 0.75


func is_alive() -> bool:
	return state != S.DEAD


func is_hostile_to_player() -> bool:
	if manager == null or faction == "":
		return false
	return manager.is_hostile_to_player(self)


func attitude() -> String:
	if manager == null:
		return "neutral"
	return manager.attitude_of(self)


func set_state(s: int) -> void:
	if state == S.DEAD:
		return
	var prev := state
	state = s
	_state_t = 0.0
	if prev == S.IDLE and s != S.IDLE and _activity_anim != "":
		body.stop_action()
		_activity_anim = ""
	match s:
		S.DOWNED:
			body.play("knockdown", 0.9)
			_downed_t = 0.0
		S.FLEE:
			_bark("flee")


# ---------------------------------------------------------------------------
# LOD
# ---------------------------------------------------------------------------
func _on_tier(t: int) -> void:
	tier = t
	if body == null:
		return
	var d := global_position.distance_to(SimScheduler.focus_position)
	match t:
		SimScheduler.Tier.FULL:
			body.anim_interval = 0.0 if d < 25.0 else 1.0 / 30.0
			body.frozen = false
			body.set_lod(0 if d < 20.0 else 1)
			set_physics_process(true)
		SimScheduler.Tier.SIMPLE:
			body.anim_interval = 1.0 / 8.0
			body.frozen = false
			body.set_lod(1)
			set_physics_process(true)
		_:
			body.frozen = true
			set_physics_process(false)
			_lerp_from = global_position
			_lerp_to = global_position


# ---------------------------------------------------------------------------
# Pensamento
# ---------------------------------------------------------------------------
func _think(dt: float, t: int) -> void:
	if state == S.DEAD:
		_dead_t += dt
		return
	_attack_cd -= dt
	_bark_cd -= dt
	_hit_rep_t -= dt
	var hours := dt * TimeManager.hours_per_second() * TimeManager.time_scale
	hunger = minf(1.0, hunger + hours * 0.02)
	fatigue = clampf(fatigue + hours * (0.03 if activity != "sleep" else -0.12), 0.0, 1.0)
	fear = maxf(0.0, fear - dt * 0.05)
	if state == S.DOWNED:
		_downed_t += dt
		if _downed_t > 18.0:
			hp = max_hp * 0.4
			body.play("get_up", 1.0)
			set_state(S.IDLE)
		return
	if state in [S.SCRIPTED, S.TALK]:
		_plan_move(dt)
		return
	_scan_t -= dt
	if _scan_t <= 0.0:
		_scan_t = 0.4 if t == SimScheduler.Tier.FULL else 1.2
		_perceive()
	_decide(dt)
	_plan_move(dt)
	if t >= SimScheduler.Tier.MINIMAL:
		_lerp_from = global_position
		_lerp_to = global_position + desired_dir * move_speed * dt
		if world:
			_lerp_to.y = world.ground_y(_lerp_to.x, _lerp_to.z)
		_lerp_t = 0.0


func _perceive() -> void:
	var dir: Node = manager.director if manager else null
	# infectados próximos
	var threat: Node3D = null
	var best := 99999.0
	if dir != null:
		for inf in dir.infected_near(global_position, 16.0):
			var i := inf as Infected
			if i == null or not i.is_alive() or i.state == Infected.S.DORMANT:
				continue
			var d := i.global_position.distance_to(global_position)
			if d < best and (d < 5.0 or _los(i)):
				best = d
				threat = i
	# jogador hostil
	var pl: Player = manager.player if manager else null
	if pl != null and is_instance_valid(pl) and not pl.cinematic and not pl.survival.dead:
		var dp := pl.global_position.distance_to(global_position)
		if is_hostile_to_player() and dp < 22.0 * (0.4 + pl.visibility_level * 0.6) and _los(pl):
			if dp < best:
				best = dp
				threat = pl
		elif attitude() == "wary" and dp < 7.0 and faction != "" and state != S.WARN and state != S.FIGHT and named == false and role != "child":
			set_state(S.WARN)
			_warn_t = 0.0
			_bark("warn")
	if threat != null:
		if state == S.FOLLOW and not fighter:
			return
		if fighter:
			if target != threat:
				_bark("infected" if threat is Infected else "hostile")
			target = threat
			if state not in [S.FIGHT]:
				set_state(S.FIGHT)
		elif state != S.FLEE:
			_flee_from = threat.global_position
			fear = 1.0
			set_state(S.FLEE)


func _los(tn: Node3D) -> bool:
	var space := get_world_3d().direct_space_state
	var q := PhysicsRayQueryParameters3D.create(global_position + Vector3(0, 1.5, 0), tn.global_position + Vector3(0, 1.2, 0), 1)
	q.exclude = [get_rid()]
	return space.intersect_ray(q).is_empty()


func _decide(dt: float) -> void:
	match state:
		S.IDLE, S.MOVE:
			_routine()
		S.FOLLOW:
			if follow_target == null or not is_instance_valid(follow_target):
				set_state(S.IDLE)
				return
			var d := follow_target.global_position.distance_to(global_position)
			if d > 70.0 and tier >= SimScheduler.Tier.SIMPLE:
				# ficou muito para trás (fora de vista): alcança o jogador
				global_position = follow_target.global_position - Util.angle_to_dir(follow_target.global_rotation.y) * 3.0
			move_dest = follow_target.global_position if d > 3.2 else Vector3.INF
			move_speed = 5.2 if d > 9.0 else (3.4 if d > 5.0 else 1.5)
			# companheiro combatente protege o jogador
			if fighter and manager and manager.director:
				for inf in manager.director.infected_near(follow_target.global_position, 9.0):
					var i := inf as Infected
					if i and i.is_alive() and i.state != Infected.S.DORMANT:
						target = i
						set_state(S.FIGHT)
						return
		S.WAIT:
			move_dest = Vector3.INF
		S.WARN:
			var pl: Player = manager.player
			if pl == null:
				set_state(S.IDLE)
				return
			_face(pl.global_position)
			var d := pl.global_position.distance_to(global_position)
			_warn_t += dt
			if d > 10.0:
				set_state(S.IDLE)
			elif _warn_t > 4.0 and d < 5.0 and fighter:
				manager.set_aggro(faction, 120.0)
				target = pl
				set_state(S.FIGHT)
				_bark("hostile")
		S.FIGHT:
			if target == null or not is_instance_valid(target) or (target is Infected and not (target as Infected).is_alive()) \
					or (target is Player and ((target as Player).survival.dead or not is_hostile_to_player())):
				target = null
				set_state(S.FOLLOW if follow_target != null else S.IDLE)
				return
			var d := target.global_position.distance_to(global_position)
			if d > 30.0:
				target = null
				set_state(S.FOLLOW if follow_target != null else S.IDLE)
				return
			if hp < max_hp * 0.25 and not essential and _rng.randf() < 0.3:
				_flee_from = target.global_position
				set_state(S.FLEE)
				return
			var ranged := ItemDB.get_item(weapon).has("ranged")
			if ranged and d > 3.0 and d < 20.0:
				move_dest = Vector3.INF
				_face(target.global_position)
				if _attack_cd <= 0.0 and _los(target):
					_shoot()
			else:
				var reach := float(Melee.weapon_params(Inventory.make_stack(weapon)).get("reach", 1.2)) if weapon != "" else 1.1
				if d > reach + 0.2:
					move_dest = target.global_position
					move_speed = 4.6
				else:
					move_dest = Vector3.INF
					_face(target.global_position)
					if _attack_cd <= 0.0:
						_melee()
		S.FLEE:
			if _state_t > 9.0:
				set_state(S.IDLE)
				return
			var away := global_position - _flee_from
			away.y = 0.0
			move_dest = global_position + away.normalized() * 10.0
			move_speed = 5.0


## Rotina por hora do dia.
func _routine() -> void:
	var h := int(TimeManager.hour)
	var entry: Array = routine[0]
	var best_h := -1
	for e in routine:
		var eh := int(e[0])
		if eh <= h and eh > best_h:
			best_h = eh
			entry = e
	if best_h < 0:
		# antes da primeira entrada: vale a última (rotina circular)
		var last_h := -1
		for e in routine:
			if int(e[0]) > last_h:
				last_h = int(e[0])
				entry = e
	var act: String = entry[1]
	var anchor: String = entry[2]
	if WeatherManager.rain > 0.6 and act in ["wander", "guard"] and role != "leader":
		act = "warm"
		anchor = "fire"
	var dest := home
	match anchor:
		"fire", "post", "sleep":
			dest = anchors.get(anchor, home)
		"wander":
			if activity != "wander" or move_dest == Vector3.INF and _state_t > _rng.randf_range(6.0, 14.0):
				var a := _rng.randf() * TAU
				var r := _rng.randf_range(2.0, 9.0)
				dest = home + Vector3(cos(a) * r, 0, sin(a) * r)
				dest.y = world.ground_y(dest.x, dest.z) if world else home.y
				_state_t = 0.0
			else:
				dest = move_dest if move_dest != Vector3.INF else global_position
	activity = act
	var d := Vector2(dest.x - global_position.x, dest.z - global_position.z).length()
	if d > 1.2:
		move_dest = dest
		move_speed = 1.5 if act != "flee" else 4.0
		if state != S.MOVE:
			set_state(S.MOVE)
	else:
		move_dest = Vector3.INF
		if state != S.IDLE:
			set_state(S.IDLE)
		var anim: String = NPCDB.ACTIVITY_ANIM.get(act, "")
		if act == "wander":
			anim = ""
		if anim != _activity_anim:
			_activity_anim = anim
			if anim != "":
				body.play(anim, 1.0)
			else:
				body.stop_action()
		if anchor == "fire":
			_face(anchors.get("fire_center", dest + Vector3(0, 0, -1)))


func _face(p: Vector3) -> void:
	var to := p - global_position
	to.y = 0.0
	if to.length() > 0.05:
		_yaw = lerp_angle(_yaw, atan2(-to.x, -to.z), 0.35)


func _plan_move(dt: float) -> void:
	if move_dest == Vector3.INF or state in [S.DOWNED, S.DEAD, S.SCRIPTED, S.TALK, S.WAIT]:
		desired_dir = Vector3.ZERO
		return
	var to := move_dest - global_position
	to.y = 0.0
	if to.length() < 0.6:
		desired_dir = Vector3.ZERO
		return
	_repath_t -= dt
	if to.length() > 30.0 and _repath_t <= 0.0 and world != null:
		_repath_t = 3.0
		path = world.layout.find_path(global_position, move_dest)
		path_i = 0
	if not path.is_empty() and to.length() > 20.0:
		while path_i < path.size() - 1 and Vector2(path[path_i].x - global_position.x, path[path_i].z - global_position.z).length() < 3.0:
			path_i += 1
		var pp := path[path_i] - global_position
		pp.y = 0.0
		desired_dir = pp.normalized()
	else:
		desired_dir = to.normalized()


func _process(delta: float) -> void:
	if tier >= SimScheduler.Tier.MINIMAL and state != S.DEAD and _lerp_t < 1.0:
		_lerp_t = minf(1.0, _lerp_t + delta / maxf(SimScheduler.tier_intervals[SimScheduler.Tier.MINIMAL], 0.1))
		global_position = _lerp_from.lerp(_lerp_to, _lerp_t)


func _physics_process(delta: float) -> void:
	_state_t += delta
	if body == null:
		return
	if state == S.DEAD:
		body.tick(delta)
		return
	var locked := state in [S.DOWNED, S.SCRIPTED] or _attack_pending
	var wish := Vector3.ZERO if locked else desired_dir * move_speed
	if tier == SimScheduler.Tier.FULL:
		var hv := Vector3(velocity.x, 0, velocity.z).move_toward(wish, delta * 10.0) + _knock
		_knock = _knock.move_toward(Vector3.ZERO, delta * 10.0)
		velocity.x = hv.x
		velocity.z = hv.z
		velocity.y = -0.5 if is_on_floor() else velocity.y - 18.0 * delta
		move_and_slide()
	else:
		global_position += wish * delta
		_ground_t -= delta
		if _ground_t <= 0.0 and world:
			_ground_t = 0.35
			global_position.y = world.ground_y(global_position.x, global_position.z)
	if wish.length() > 0.2:
		_yaw = lerp_angle(_yaw, atan2(-wish.x, -wish.z), 1.0 - exp(-delta * 8.0))
	elif state == S.TALK and manager and manager.player:
		var to: Vector3 = manager.player.global_position - global_position
		_yaw = lerp_angle(_yaw, atan2(-to.x, -to.z), 1.0 - exp(-delta * 5.0))
	body.rotation.y = _yaw
	var sp := Vector2(velocity.x, velocity.z).length() if tier == SimScheduler.Tier.FULL else wish.length()
	body.animator.speed = sp
	body.animator.forward_speed = sp
	body.animator.crouch_target = 1.0 if activity == "hide" and sp < 0.3 else 0.0
	body.animator.style = "injured" if hp < max_hp * 0.3 else "human"
	body.tick(delta)


# ---------------------------------------------------------------------------
# Combate
# ---------------------------------------------------------------------------
func _melee() -> void:
	_attack_cd = _rng.randf_range(1.1, 1.8)
	_attack_pending = true
	body.play("attack_light" if _rng.randf() < 0.6 else "attack_light_2", 1.0)
	AudioManager.play_3d("swing", global_position + Vector3(0, 1.3, 0), -6.0)


func _on_anim_event(e: String) -> void:
	if e == "hit_start" and _attack_pending:
		_attack_pending = false
		if target == null or not is_instance_valid(target):
			return
		var to := target.global_position - global_position
		var reach := float(Melee.weapon_params(Inventory.make_stack(weapon)).get("reach", 1.2)) if weapon != "" else 1.1
		if to.length() > reach + 0.6:
			return
		var wp := Melee.weapon_params(Inventory.make_stack(weapon)) if weapon != "" else Melee.weapon_params({})
		var info := DamageInfo.make(float(wp["dmg"]) * 0.8, str(wp.get("kind", "blunt")), self, to)
		info.knockback = 2.0
		info.stagger = 0.4
		target.receive_hit(info)
		AudioManager.play_3d("hit_blunt" if info.kind == "blunt" else "hit_sharp", target.global_position + Vector3(0, 1.2, 0), -3.0)
	elif e == "hit_end":
		_attack_pending = false


func _shoot() -> void:
	_attack_cd = _rng.randf_range(1.2, 2.2)
	var r: Dictionary = ItemDB.get_item(weapon)["ranged"]
	AudioManager.play_3d("gun_shot", global_position + Vector3(0, 1.4, 0), 0.0)
	EventBus.make_noise(global_position, float(r.get("noise", 70.0)), self, &"gunshot")
	var d := target.global_position.distance_to(global_position)
	var chance := clampf(0.8 - d * 0.025, 0.25, 0.8)
	if target is Player:
		chance *= 0.3 + 0.7 * (target as Player).visibility_level
		if (target as Player).crouching:
			chance *= 0.75
	if _rng.randf() < chance:
		var info := DamageInfo.make(float(r["dmg"]) * (0.45 if target is Player else 1.0), "bullet", self, target.global_position - global_position)
		info.blockable = false
		info.stagger = 0.5
		target.receive_hit(info)


func receive_hit(info: DamageInfo) -> void:
	if state == S.DEAD:
		return
	var from_player := info.source is Player
	var dmg := info.amount
	if info.stealth:
		dmg = 9999.0
	if state == S.DOWNED and from_player:
		dmg *= 2.0
	hp -= dmg
	var local := body.global_transform.basis.inverse() * info.direction
	body.animator.flinch(local, clampf(dmg / 20.0, 0.4, 1.6))
	_knock = Vector3(info.direction.x, 0, info.direction.z).normalized() * info.knockback
	if _bark_cd <= 0.0 and hp > 0.0:
		_bark("hurt")
	if info.source is Infected and info.infection_chance > 0.0 and _rng.randf() < info.infection_chance * 0.5 and not essential:
		manager.mark_infected(self)
	if from_player:
		if manager:
			manager.on_player_attacked(self, _hit_rep_t <= 0.0)
		_hit_rep_t = 6.0
		if info.source is Node3D:
			if fighter:
				target = info.source as Node3D
				set_state(S.FIGHT)
			else:
				_flee_from = (info.source as Node3D).global_position
				set_state(S.FLEE)
	elif info.source is Infected and state != S.FIGHT and fighter:
		target = info.source as Node3D
		set_state(S.FIGHT)
	if hp <= 0.0:
		if essential:
			hp = 1.0
			set_state(S.DOWNED)
			if manager:
				manager.on_downed(self)
		else:
			die(info)


func die(info: DamageInfo = null) -> void:
	if state == S.DEAD:
		return
	state = S.DEAD
	_dead_t = 0.0
	collision_layer = 0
	talk_area.enabled = false
	body.play("death" if _rng.randf() < 0.5 else "death_front", 1.0)
	AudioManager.play_3d("body_fall", global_position, -2.0)
	var killer: Node = info.source if info else null
	EventBus.npc_killed.emit(npc_id, faction, killer)
	if manager:
		manager.on_npc_died(self, killer)
	var lc := LootContainer.new()
	add_child(lc)
	lc.setup({"uid": "npcbody_" + npc_id, "kind": "body", "context": "camp", "pos": Vector3(0, 0.3, 0), "size": Vector3(1.2, 0.5, 1.8)})
	lc.position = Vector3(0, 0.3, 0)
	if weapon != "" and lc.inv:
		lc.inv.add(weapon, 1, _rng.randf_range(0.4, 0.8), {}, true)


# ---------------------------------------------------------------------------
# Interação
# ---------------------------------------------------------------------------
func can_talk() -> bool:
	return state not in [S.DEAD, S.DOWNED, S.FIGHT, S.FLEE] and not is_hostile_to_player()


func begin_talk() -> void:
	if state == S.FOLLOW:
		_resume_follow = true
	set_state(S.TALK)
	move_dest = Vector3.INF
	desired_dir = Vector3.ZERO
	body.stop_action()
	_activity_anim = ""


var _resume_follow: bool = false


func end_talk() -> void:
	if state != S.TALK:
		return
	if _resume_follow and follow_target != null:
		set_state(S.FOLLOW)
	else:
		set_state(S.IDLE)
	_resume_follow = false


func start_follow(t: Node3D) -> void:
	follow_target = t
	_resume_follow = true
	set_state(S.FOLLOW)
	_bark("follow")


func stop_follow() -> void:
	follow_target = null
	_resume_follow = false
	home = global_position
	set_state(S.WAIT)
	_bark("wait")


func relocate(pos: Vector3) -> void:
	follow_target = null
	_resume_follow = false
	home = pos
	anchors = {}
	set_state(S.IDLE)


func _bark(kind: String) -> void:
	if _bark_cd > 0.0 or manager == null or manager.player == null:
		return
	if global_position.distance_to(manager.player.global_position) > 14.0:
		return
	var t := NPCDB.bark(kind, _rng)
	if t == "":
		return
	_bark_cd = 6.0
	EventBus.subtitle.emit(t, display_name, 2.6)


func to_dict() -> Dictionary:
	return {"pos": Util.arr3(global_position), "home": Util.arr3(home), "hp": hp, "alive": state != S.DEAD,
		"follow": follow_target != null or (state == S.TALK and _resume_follow)}
