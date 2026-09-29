class_name Player
extends CharacterBody3D
## Caio — personagem jogável. O MESMO nó é usado na cinemática de abertura
## (controle cinemático: `cinematic_walk_to`) e no gameplay; a transição só
## troca quem fornece a intenção de movimento e qual câmera está ativa.

signal died(cause: String)
signal interact_hold_progress(p: float)

const WALK := 1.45
const RUN := 3.5
const SPRINT := 5.9
const CROUCH := 1.35
const GRAVITY := 18.0
const JUMP_V := 5.2

var body: HumanoidBody
var cam_rig: PlayerCamera
var survival := Survival.new()
var inventory: Inventory
var equipment: Dictionary = {"weapon": {}, "back": {}, "torso": {}, "hands": {}, "head": {}, "feet": {}, "light": {}}
var quick_slots: Array = ["", "", "", ""]
var world: World = null
var control_enabled: bool = true
var cinematic: bool = false
var state: String = "normal"
var crouching: bool = false
var sprinting: bool = false
var blocking: bool = false
var aiming: bool = false
var in_vehicle: Node = null
var flashlight: SpotLight3D
var flash_fill: OmniLight3D
const FLASH_ENERGY := 9.0
const FILL_ENERGY := 1.3
var flashlight_on: bool = false
var interact_area: Area3D
var current_interactable: Node = null
var visibility_level: float = 0.5
var noise_level: float = 0.0
var indoors: bool = false

# cinemática
var cine_target: Vector3 = Vector3.INF
var cine_speed: float = WALK
var cine_face: Vector3 = Vector3.ZERO
var cine_arrived: bool = true

var _yaw: float = 0.0
var _hold_t: float = 0.0
var _hold_target: Node = null
var _scan_t: float = 0.0
var _vis_t: float = 0.0
var _last_phase: float = 0.0
var _attack_active: bool = false
var _attack_hits: Dictionary = {}
var _attack_heavy: bool = false
var _attack_combo: int = 0
var _combo_t: float = 0.0
var _attack_finisher: bool = false   # 3º golpe leve seguido: mais forte
var _queued_attack: int = -1         # golpe apertado durante o anterior (-1 nada, 0 leve, 1 pesado)
var _queued_t: float = 0.0
var _melee_target: Node3D = null     # alvo da mira assistida do golpe atual
var _lunge_t: float = 0.0
var _lunge_stop: float = 1.0         # o passo para quando o alvo entra nesta distância
var _auto_fire: bool = false         # gatilho segurado com arma automática
var _burst: float = 0.0              # tiros seguidos (piora a dispersão)
var _lmb_down_t: float = -1.0
var _block_t: float = -10.0
var _busy_t: float = 0.0
var _dodge_t: float = 0.0
var _dodge_vel := Vector3.ZERO
var _invuln: float = 0.0
var _stagger_t: float = 0.0
var _shove_cd: float = 0.0
var _pending_use: Dictionary = {}
var _throw_stack: Dictionary = {}
var _knockback := Vector3.ZERO
var _knock_last := Vector3.ZERO   # parcela do empurrão somada no quadro anterior
var _climb_tween: Tween
var _air_t: float = 0.0
var _speed_now: float = 0.0
var _weapon_node: Node3D
var _surface: String = "asphalt"
var _rain_exposure: float = 0.0
var _sprint_toggle: bool = false
var _ranged_cd: float = 0.0
var swimming: bool = false
var _swim_noise_t: float = 0.0


func _ready() -> void:
	add_to_group("player")
	collision_layer = 1 << 1
	collision_mask = 1 | (1 << 2) | (1 << 3) | (1 << 4)
	floor_max_angle = deg_to_rad(52.0)
	floor_snap_length = 0.45
	safe_margin = 0.02
	var cs := CollisionShape3D.new()
	var cap := CapsuleShape3D.new()
	cap.radius = 0.34
	cap.height = 1.78
	cs.shape = cap
	cs.position = Vector3(0, 0.89, 0)
	add_child(cs)
	body = HumanoidBody.new()
	body.name = "Body"
	add_child(body)
	body.setup(Appearance.caio(), 0)
	body.anim_event.connect(_on_anim_event)
	cam_rig = PlayerCamera.new()
	cam_rig.name = "CameraRig"
	add_child(cam_rig)
	cam_rig.set_target(self)
	interact_area = Area3D.new()
	interact_area.collision_layer = 0
	interact_area.collision_mask = 1 << 5
	interact_area.monitoring = true
	interact_area.monitorable = false
	var ics := CollisionShape3D.new()
	var sph := SphereShape3D.new()
	sph.radius = 2.3
	ics.shape = sph
	ics.position = Vector3(0, 1.0, 0)
	interact_area.add_child(ics)
	add_child(interact_area)
	# facho longo e largo (queda de distância suave) + um brilho de rebote em volta,
	# senão o cone some atrás do próprio Caio na câmera de ombro
	flashlight = SpotLight3D.new()
	flashlight.spot_range = 34.0
	flashlight.spot_angle = 36.0
	flashlight.spot_angle_attenuation = 0.8
	flashlight.spot_attenuation = 0.55
	flashlight.light_energy = FLASH_ENERGY
	flashlight.light_color = Color(1.0, 0.95, 0.85)
	flashlight.light_specular = 0.4
	flashlight.shadow_enabled = bool(Settings.get_shadow_params()["local_shadows"])
	flashlight.visible = false
	add_child(flashlight)
	flashlight.top_level = true
	flash_fill = OmniLight3D.new()
	flash_fill.omni_range = 6.5
	flash_fill.omni_attenuation = 0.8
	flash_fill.light_energy = FILL_ENERGY
	flash_fill.light_color = Color(0.95, 0.92, 0.85)
	flash_fill.light_specular = 0.0
	flash_fill.shadow_enabled = false
	flash_fill.position = Vector3(0.0, 0.0, -1.6)
	flashlight.add_child(flash_fill)
	inventory = Inventory.new("player", 5.0, 6, "Bolsos")
	survival.died.connect(_on_died)
	survival.symptom.connect(_on_symptom)
	MissionManager.inventory_provider = func() -> Inventory: return inventory
	SimScheduler.set_focus(self)
	EventBus.settings_changed.connect(func() -> void: flashlight.shadow_enabled = bool(Settings.get_shadow_params()["local_shadows"]))
	EventBus.player_spawned.emit(self)


func give_starting_kit() -> void:
	equipment["back"] = Inventory.make_stack("mochila_trilha", 1, 0.8)
	equipment["torso"] = Inventory.make_stack("jaqueta", 1, 0.7)
	equipment["light"] = Inventory.make_stack("lanterna", 1, 0.9, {"battery": 55.0})
	_recalc_capacity()
	inventory.add("agua_garrafa", 1)
	inventory.add("barra_cereal", 2)
	inventory.add("bandagem", 2)
	inventory.add("pilha", 1)
	inventory.add("isqueiro", 1, 0.7)
	quick_slots = ["bandagem", "agua_garrafa", "barra_cereal", ""]


func _recalc_capacity() -> void:
	var w := 5.0
	var slots := 6
	var back: Dictionary = equipment["back"]
	if not back.is_empty():
		var d := ItemDB.get_item(str(back["id"]))
		w += float(d.get("capacity", 0.0))
		slots += int(d.get("slots", 0))
	if not (equipment["torso"] as Dictionary).is_empty():
		w += 2.0
		slots += 2
	inventory.max_weight = w
	inventory.max_slots = slots


func carry_weight() -> float:
	var w := inventory.total_weight()
	for k in equipment.keys():
		var s: Dictionary = equipment[k]
		if not s.is_empty():
			w += ItemDB.weight(str(s["id"])) * 0.5
	return w


# ---------------------------------------------------------------------------
# API usada por interativos, missões e UI
# ---------------------------------------------------------------------------
func give_item(id: String, qty: int = 1, cond: float = 1.0, data: Dictionary = {}) -> int:
	var left := inventory.add(id, qty, cond, data)
	if left < qty:
		EventBus.item_picked.emit(id, qty - left)
		AudioManager.play_ui("pickup", -6.0)
	if left > 0:
		# não coube: larga no chão
		_drop_to_world(Inventory.make_stack(id, left, cond, data))
		EventBus.toast("Sem espaço: %s ficou no chão." % ItemDB.item_name(id), "warn")
	return 0


func give_stack(s: Dictionary) -> int:
	var id := str(s["id"])
	var q := int(s["qty"])
	var left := inventory.add(id, q, float(s.get("cond", 1.0)), s.get("data", {}))
	if left < q:
		EventBus.item_picked.emit(id, q - left)
		AudioManager.play_ui("pickup", -6.0)
		if not cinematic:
			body.play("pickup", 1.3)
	return left


func has_key(key: String) -> bool:
	for s in inventory.stacks:
		if str(ItemDB.get_item(str(s["id"])).get("key", "")) == key:
			return true
	return false


func has_tool(tag: String) -> bool:
	if not inventory.find_tool(tag).is_empty():
		return true
	var w: Dictionary = equipment["weapon"]
	if not w.is_empty():
		var d := ItemDB.get_item(str(w["id"]))
		return d.has("tool") and tag in (d["tool"] as Array)
	return false


func use_tool(tag: String, wear: float) -> void:
	var s := inventory.find_tool(tag)
	if not s.is_empty():
		inventory.wear(s, wear)
		return
	var w: Dictionary = equipment["weapon"]
	if not w.is_empty():
		w["cond"] = maxf(0.0, float(w["cond"]) - wear)


func fill_bottles(liquid: String, max_n: int) -> int:
	var n := mini(inventory.count("garrafa_vazia"), max_n)
	if n <= 0:
		EventBus.toast("Você precisa de garrafas vazias.", "warn")
		return 0
	inventory.remove("garrafa_vazia", n)
	inventory.add(liquid, n, 1.0, {}, true)
	EventBus.toast("%d garrafa(s) cheias: %s" % [n, ItemDB.item_name(liquid)], "info")
	return n


func equip_from_inventory(index: int) -> void:
	if index < 0 or index >= inventory.stacks.size():
		return
	var s: Dictionary = inventory.stacks[index]
	var def := ItemDB.get_item(str(s["id"]))
	var slot := ""
	if def.has("weapon") or def.has("ranged"):
		slot = "weapon"
	elif def.has("equip"):
		slot = str(def["equip"])
	if slot == "":
		return
	var taken := inventory.remove_stack_at(index, 1)
	var prev: Dictionary = equipment[slot]
	equipment[slot] = taken
	if not prev.is_empty():
		inventory.add_stack(prev, true)
	_recalc_capacity()
	if slot == "weapon":
		_update_weapon_visual()
	EventBus.equipment_changed.emit(slot, str(taken["id"]))
	AudioManager.play_ui("pickup", -8.0)


func unequip(slot: String) -> void:
	var s: Dictionary = equipment.get(slot, {})
	if s.is_empty():
		return
	if inventory.can_fit(str(s["id"]), 1) <= 0 and slot != "back":
		EventBus.toast("Sem espaço para guardar.", "warn")
		return
	equipment[slot] = {}
	_recalc_capacity()
	inventory.add_stack(s, slot == "back")
	if slot == "weapon":
		_update_weapon_visual()
	if slot == "light" and flashlight_on:
		toggle_flashlight()
	EventBus.equipment_changed.emit(slot, "")


func drop_from_inventory(index: int, qty: int = -1) -> void:
	var s := inventory.remove_stack_at(index, qty)
	if s.is_empty():
		return
	_drop_to_world(s)
	EventBus.item_dropped.emit(str(s["id"]), int(s["qty"]))


func _drop_to_world(s: Dictionary) -> void:
	var p := global_position + (-global_transform.basis.z) * 0.8 + Vector3(0, 0.05, 0)
	var ip := ItemPickup.new()
	ip.uid = "drop_%d" % Time.get_ticks_msec()
	get_parent().add_child(ip)
	ip.setup(s, p, true)
	GameState.add_dropped(p, s)


## Usa (consome) um item do inventário.
func use_item(index: int) -> void:
	if index < 0 or index >= inventory.stacks.size() or _busy_t > 0.0:
		return
	var s: Dictionary = inventory.stacks[index]
	var id := str(s["id"])
	var def := ItemDB.get_item(id)
	if def.has("weapon") or def.has("ranged") or def.has("equip"):
		equip_from_inventory(index)
		return
	if def.has("place"):
		EventBus.toast("Use a aba de fabricação para posicionar estruturas.", "info")
		return
	if def.get("purifier", false):
		if inventory.has("agua_suja"):
			inventory.remove("agua_suja", 1)
			inventory.remove(id, 1)
			inventory.add("agua_fervida", 1, 1.0, {}, true)
			EventBus.toast("Água purificada.", "good")
		else:
			EventBus.toast("Você precisa de água suja para purificar.", "info")
		return
	if id == "pilha":
		var l: Dictionary = equipment["light"]
		if not l.is_empty():
			inventory.remove("pilha", 1)
			var d: Dictionary = l.get("data", {})
			d["battery"] = minf(100.0, float(d.get("battery", 0.0)) + 35.0)
			l["data"] = d
			EventBus.toast("Lanterna recarregada (%d%%)." % int(d["battery"]), "info")
		return
	if not def.has("use"):
		return
	_pending_use = {"id": id, "cond": float(s.get("cond", 1.0))}
	var act: String = def.get("action", "use_eat")
	var t := float(def.get("time", 2.0))
	var anim_def := AnimLibrary.get_action(act)
	var sp := float(anim_def.get("dur", t)) / maxf(t, 0.3)
	body.play(act, sp)
	_busy_t = t
	match act:
		"use_eat": AudioManager.play_3d("eat", global_position, -4.0)
		"use_drink": AudioManager.play_3d("drink", global_position, -4.0)
		"use_bandage", "use_inject": AudioManager.play_3d("bandage", global_position, -4.0)


func _finish_use() -> void:
	if _pending_use.is_empty():
		return
	var id: String = _pending_use["id"]
	var def := ItemDB.get_item(id)
	if inventory.remove(id, 1) > 0:
		survival.consume(def, float(_pending_use["cond"]))
		EventBus.item_used.emit(id)
		var empty: String = def.get("empty", "")
		if empty != "":
			inventory.add(empty, 1, 1.0, {}, true)
	_pending_use = {}


func use_quick_slot(i: int) -> void:
	var id: String = quick_slots[i]
	if id == "":
		return
	for k in inventory.stacks.size():
		if inventory.stacks[k]["id"] == id:
			use_item(k)
			return
	EventBus.toast("Sem %s." % ItemDB.item_name(id), "info")


func quick_heal() -> void:
	var order := ["kit_primeiros_socorros", "kit_sutura", "bandagem", "pano_limpo"] if survival.bleeding > 0.0 else ["bandagem", "kit_primeiros_socorros", "pano_limpo"]
	for id in order:
		for k in inventory.stacks.size():
			if inventory.stacks[k]["id"] == id:
				use_item(k)
				return
	EventBus.toast("Nada para curar.", "warn")


func toggle_flashlight() -> void:
	var l: Dictionary = equipment["light"]
	if l.is_empty():
		EventBus.toast("Você não tem uma lanterna equipada.", "info")
		return
	var bat := float((l.get("data", {}) as Dictionary).get("battery", 0.0))
	if bat <= 0.0 and not flashlight_on:
		EventBus.toast("A lanterna está sem pilha.", "warn")
		return
	flashlight_on = not flashlight_on
	flashlight.visible = flashlight_on
	AudioManager.play_3d("flashlight_click", global_position, -6.0)


# ---------------------------------------------------------------------------
# Entrada
# ---------------------------------------------------------------------------
func _unhandled_input(event: InputEvent) -> void:
	if not control_enabled or survival.dead:
		return
	if in_vehicle != null:
		if event.is_action_pressed("interact"):
			exit_vehicle()
		return
	# cursor liberado (Alt): cliques são para a interface, não golpes
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if swimming and (event.is_action_pressed("attack") or event.is_action_pressed("block") or event.is_action_pressed("throw") or event.is_action_pressed("crouch")):
		return
	if event.is_action_pressed("crouch"):
		if bool(Settings.controls.get("toggle_crouch", true)):
			crouching = not crouching
		else:
			crouching = true
	elif event.is_action_released("crouch") and not bool(Settings.controls.get("toggle_crouch", true)):
		crouching = false
	if event.is_action_pressed("sprint") and bool(Settings.controls.get("toggle_sprint", false)):
		_sprint_toggle = not _sprint_toggle
	if event.is_action_pressed("jump"):
		_try_jump_or_climb()
	if event.is_action_pressed("attack"):
		if _is_ranged():
			if aiming:
				_fire_ranged()
				_auto_fire = bool(ItemDB.get_item(str(equipment["weapon"]["id"]))["ranged"].get("auto", false))
		else:
			_lmb_down_t = Time.get_ticks_msec() / 1000.0
	if event.is_action_released("attack"):
		_auto_fire = false
	if event.is_action_released("attack") and _lmb_down_t > 0.0:
		var held := Time.get_ticks_msec() / 1000.0 - _lmb_down_t
		_lmb_down_t = -1.0
		_attack(held > 0.32)
	if event.is_action_pressed("block"):
		if _is_ranged():
			aiming = true
			cam_rig.aim_target = 1.0
			var wid := str(equipment["weapon"]["id"])
			cam_rig.aim_zoom = float(ItemDB.get_item(wid)["ranged"].get("zoom", 1.0))
			if _busy_t <= 0.0:
				body.play("aim_rifle" if WeaponMeshes.is_long_gun(wid) else "aim_pistol", 1.0)
			if WeaponMeshes.is_long_gun(wid):
				_update_weapon_visual()
		else:
			_start_block()
	if event.is_action_released("block"):
		var was_aiming := aiming
		aiming = false
		if was_aiming:
			body.stop_action()
			if _is_ranged() and WeaponMeshes.is_long_gun(str(equipment["weapon"]["id"])):
				_update_weapon_visual()
		_auto_fire = false
		cam_rig.aim_target = 0.0
		cam_rig.aim_zoom = 1.0
		_end_block()
	if event.is_action_pressed("dodge"):
		_dodge()
	if event.is_action_pressed("shove"):
		_shove()
	if event.is_action_pressed("flashlight"):
		toggle_flashlight()
	if event.is_action_pressed("throw"):
		_throw()
	if event.is_action_pressed("quick_heal"):
		quick_heal()
	for i in 4:
		if event.is_action_pressed("slot_%d" % (i + 1)):
			use_quick_slot(i)
	if event.is_action_pressed("interact"):
		_begin_interact()
	if event.is_action_released("interact"):
		_hold_target = null
		_hold_t = 0.0
		interact_hold_progress.emit(0.0)


# ---------------------------------------------------------------------------
# Movimento
# ---------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if in_vehicle != null:
		_follow_vehicle()
		body.tick(delta)
		return
	if survival.dead:
		velocity.x = move_toward(velocity.x, 0.0, delta * 10.0)
		velocity.z = move_toward(velocity.z, 0.0, delta * 10.0)
		velocity.y -= GRAVITY * delta
		move_and_slide()
		body.tick(delta)
		return
	_timers(delta)
	var wish := Vector3.ZERO
	var want_sprint := false
	if cinematic:
		wish = _cinematic_wish()
	elif control_enabled and state != "climb":
		var ix := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var iz := Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
		var v2 := Vector2(ix, iz)
		if v2.length() > 1.0:
			v2 = v2.normalized()
		wish = cam_rig.flat_right() * v2.x - cam_rig.flat_forward() * v2.y
		want_sprint = (Input.is_action_pressed("sprint") or _sprint_toggle) and v2.length() > 0.3
	var mag := wish.length()
	var wl := _water_level()
	swimming = wl > -100.0 and global_position.y < wl - 1.25
	if swimming:
		crouching = false
		want_sprint = false
		survival.wetness = 1.0
		if blocking:
			_end_block()
	sprinting = want_sprint and not crouching and not blocking and survival.can_sprint() and _busy_t <= 0.0
	var target_speed := RUN
	if cinematic:
		target_speed = cine_speed
	elif crouching:
		target_speed = CROUCH
	elif sprinting:
		target_speed = SPRINT
	elif blocking or aiming:
		target_speed = WALK
	if _busy_t > 0.0 and not cinematic:
		target_speed = minf(target_speed, WALK * 0.8)
	if swimming:
		target_speed = 1.6
	target_speed *= survival.speed_multiplier()
	if _stagger_t > 0.0 or state == "knockdown":
		target_speed = 0.0
	var desired := wish.normalized() * target_speed * clampf(mag, 0.0, 1.0)
	# o empurrão é somado por cima do movimento próprio, sem acumular quadro a quadro
	var hv := Vector3(velocity.x, 0, velocity.z) - _knock_last
	var accel := 14.0 if is_on_floor() else 3.0
	hv = hv.move_toward(desired, accel * delta * maxf(target_speed, 2.0))
	if _dodge_t > 0.0:
		hv = _dodge_vel
	elif _lunge_t > 0.0 and _melee_target != null and is_instance_valid(_melee_target):
		var gap := Vector2(_melee_target.global_position.x - global_position.x, _melee_target.global_position.z - global_position.z).length()
		if gap > _lunge_stop:
			hv = Vector3(-sin(_yaw), 0, -cos(_yaw)) * 3.2
		else:
			_lunge_t = 0.0
	_knock_last = _knockback
	hv += _knockback
	_knockback = _knockback.move_toward(Vector3.ZERO, delta * 14.0)
	velocity.x = hv.x
	velocity.z = hv.z
	if swimming:
		# flutua com a cabeça fora d'água; nadar cansa e faz pouco barulho
		_air_t = 0.0
		velocity.y = move_toward(velocity.y, clampf((wl - 1.3 - global_position.y) * 3.0, -2.0, 2.0), delta * 12.0)
		survival.use_stamina(3.0 * delta * clampf(mag, 0.2, 1.0))
		_swim_noise_t -= delta
		if _swim_noise_t <= 0.0 and mag > 0.2:
			_swim_noise_t = 0.9
			AudioManager.play_3d("step_water", global_position + Vector3(0, 1.2, 0), -4.0, 0.8)
			EventBus.make_noise(global_position, 6.0, self, &"swim")
		if survival.stamina <= 1.0:
			survival.damage(4.0 * delta, "drown")
	elif is_on_floor():
		_air_t = 0.0
		if velocity.y < 0.0:
			velocity.y = -0.5
	else:
		_air_t += delta
		velocity.y -= GRAVITY * delta
	var was_air := _air_t > 0.35
	# dano de queda pela velocidade de impacto (≈10 m de queda livre): tempo no
	# ar não serve — teletransportes (elevador, carregar jogo) não são quedas
	var impact_v := -velocity.y
	move_and_slide()
	if was_air and is_on_floor():
		AudioManager.play_3d("jump_land", global_position, -6.0)
		EventBus.make_noise(global_position, 9.0, self, &"land")
		if impact_v > 19.0:
			survival.damage((impact_v - 19.0) * 4.5, "heavy")
	_step_up(desired, delta)
	# orientação do corpo
	var face_cam := blocking or aiming or _attack_active or (_busy_t > 0.0 and _pending_use.is_empty())
	var fdir := Vector3.ZERO
	if cinematic and cine_face != Vector3.ZERO and hv.length() < 0.3:
		fdir = cine_face
	elif face_cam and not cinematic:
		fdir = cam_rig.flat_forward()
		if _melee_target != null and is_instance_valid(_melee_target) and (_attack_active or _busy_t > 0.0) and not blocking and not aiming:
			var tdir := _melee_target.global_position - global_position
			tdir.y = 0.0
			if tdir.length() > 0.1:
				fdir = tdir.normalized()
	elif hv.length() > 0.2:
		fdir = hv.normalized()
	if fdir != Vector3.ZERO:
		var ty := atan2(-fdir.x, -fdir.z)
		var prev := _yaw
		_yaw = lerp_angle(_yaw, ty, 1.0 - exp(-delta * (14.0 if face_cam else 9.0)))
		body.animator.turn_rate = angle_difference(prev, _yaw) / maxf(delta, 0.001)
	body.rotation.y = _yaw
	# animação
	_speed_now = Vector2(velocity.x, velocity.z).length()
	var anim := body.animator
	anim.speed = _speed_now
	var fwd := Vector3(-sin(_yaw), 0, -cos(_yaw))
	anim.forward_speed = Vector3(velocity.x, 0, velocity.z).dot(fwd)
	anim.grounded = is_on_floor() or _air_t < 0.15
	anim.crouch_target = 1.0 if crouching else 0.0
	anim.injured = 1.0 if survival.fracture > 0.0 else 0.0
	anim.style = "injured" if survival.fracture > 0.0 and not splinted_ok() else "human"
	anim.breathing = 1.0 + (1.0 - survival.stamina / 100.0) * 2.0
	body.tick(delta)
	_footsteps()
	# golpes ativos
	if _attack_active:
		_process_hits()
	# sobrevivência
	var hours := delta * TimeManager.hours_per_second() * TimeManager.time_scale
	survival.activity = 2.0 if sprinting else (1.0 if _speed_now > 0.5 else 0.0)
	survival.weight_ratio = carry_weight() / maxf(inventory.max_weight, 1.0)
	if sprinting:
		survival.use_stamina(12.0 * delta)
	survival.update(delta, hours)
	cam_rig.sprint_fov = lerpf(cam_rig.sprint_fov, 7.0 if sprinting else 0.0, 1.0 - exp(-delta * 4.0))
	cam_rig.crouch_amount = anim.crouch
	cam_rig.bob_amount = clampf(_speed_now / SPRINT, 0.0, 1.0) * (0.0 if cinematic else 1.0)
	cam_rig.bob_phase = anim.phase
	_update_flashlight(delta)


## Nível da água sob o jogador (rio/lago) ou -INF.
func _water_level() -> float:
	if world == null:
		return -INF
	var p := global_position
	if not world.layout.is_water(p.x, p.z):
		return -INF
	if ((Vector2(p.x, p.z) - WorldLayout.LAKE_CENTER) / WorldLayout.LAKE_R).length() < 1.0:
		return WorldLayout.LAKE_LEVEL
	return WorldLayout.RIVER_LEVEL


func splinted_ok() -> bool:
	return survival.splinted


func _timers(delta: float) -> void:
	_busy_t = maxf(0.0, _busy_t - delta)
	if _busy_t <= 0.0 and not _pending_use.is_empty() and not body.animator.is_playing():
		_finish_use()
	_dodge_t = maxf(0.0, _dodge_t - delta)
	_invuln = maxf(0.0, _invuln - delta)
	_stagger_t = maxf(0.0, _stagger_t - delta)
	_shove_cd = maxf(0.0, _shove_cd - delta)
	_combo_t = maxf(0.0, _combo_t - delta)
	_lunge_t = maxf(0.0, _lunge_t - delta)
	if _queued_attack >= 0:
		_queued_t -= delta
		if _queued_t <= 0.0:
			_queued_attack = -1
		elif _busy_t <= 0.0 and not _attack_active:
			var h := _queued_attack == 1
			_queued_attack = -1
			_attack(h)
	_ranged_cd = maxf(0.0, _ranged_cd - delta)
	if _auto_fire and aiming and _ranged_cd <= 0.0 and _is_ranged():
		_fire_ranged()
	elif not _auto_fire:
		_burst = maxf(0.0, _burst - delta * 6.0)
	if state == "knockdown" and not body.animator.is_playing("knockdown"):
		state = "normal"
	if _lmb_down_t > 0.0 and Time.get_ticks_msec() / 1000.0 - _lmb_down_t > 0.32 and not _attack_active and _busy_t <= 0.0:
		# feedback de carga do golpe pesado
		cam_rig.add_shake(0.004)


func _step_up(desired: Vector3, _delta: float) -> void:
	if not is_on_floor() or desired.length() < 0.5 or not is_on_wall():
		return
	var dir := desired.normalized()
	var space := get_world_3d().direct_space_state
	var from := global_position + Vector3(0, 0.48, 0)
	var q := PhysicsRayQueryParameters3D.create(from, from + dir * 0.6, 1)
	q.exclude = [get_rid()]
	if not space.intersect_ray(q).is_empty():
		return
	var down := PhysicsRayQueryParameters3D.create(from + dir * 0.5, from + dir * 0.5 + Vector3(0, -0.6, 0), 1)
	down.exclude = [get_rid()]
	var r := space.intersect_ray(down)
	if r.is_empty():
		return
	var h: float = r["position"].y - global_position.y
	if h > 0.02 and h < 0.46:
		global_position.y += h + 0.02


func _try_jump_or_climb() -> void:
	if not is_on_floor() or _busy_t > 0.0 or state == "climb":
		return
	var fwd := -body.global_transform.basis.z
	if Vector3(velocity.x, 0, velocity.z).length() > 0.2:
		fwd = Vector3(velocity.x, 0, velocity.z).normalized()
	var space := get_world_3d().direct_space_state
	# obstáculo à frente?
	var chest := global_position + Vector3(0, 0.75, 0)
	var q := PhysicsRayQueryParameters3D.create(chest, chest + fwd * 1.0, 1 | (1 << 4))
	q.exclude = [get_rid()]
	var hit := space.intersect_ray(q)
	if hit.is_empty():
		var low := PhysicsRayQueryParameters3D.create(global_position + Vector3(0, 0.45, 0), global_position + Vector3(0, 0.45, 0) + fwd * 0.9, 1 | (1 << 4))
		low.exclude = [get_rid()]
		hit = space.intersect_ray(low)
	if not hit.is_empty():
		var wall_p: Vector3 = hit["position"]
		# altura do topo
		var top_from := Vector3(wall_p.x, global_position.y + 2.5, wall_p.z) + fwd * 0.35
		var tq := PhysicsRayQueryParameters3D.create(top_from, top_from + Vector3(0, -2.6, 0), 1 | (1 << 4))
		tq.exclude = [get_rid()]
		var top := space.intersect_ray(tq)
		if not top.is_empty():
			var h: float = top["position"].y - global_position.y
			# espaço livre acima?
			var clear_q := PhysicsRayQueryParameters3D.create(top["position"] + Vector3(0, 0.1, 0), top["position"] + Vector3(0, 1.7, 0), 1)
			var clear := space.intersect_ray(clear_q).is_empty()
			if h > 0.35 and h < 1.25:
				# transpor: atravessa o obstáculo se houver chão do outro lado
				var far := Vector3(wall_p.x, global_position.y, wall_p.z) + fwd * 1.1
				_climb_motion([global_position + Vector3(0, h + 0.15, 0) + fwd * 0.3, far + Vector3(0, 0.05, 0)], "vault", 0.62)
				return
			elif h >= 1.25 and h <= 2.3 and clear:
				var land: Vector3 = top["position"] + fwd * 0.25
				_climb_motion([global_position + Vector3(0, h * 0.7, 0) + fwd * 0.15, land + Vector3(0, 0.02, 0)], "climb", 1.15)
				return
	velocity.y = JUMP_V
	survival.use_stamina(8.0)
	EventBus.make_noise(global_position, 5.0, self, &"jump")


func _climb_motion(points: Array, anim: String, dur: float) -> void:
	state = "climb"
	var cm := collision_mask
	collision_mask = 0
	velocity = Vector3.ZERO
	body.play(anim, 1.0)
	survival.use_stamina(14.0 if anim == "climb" else 8.0)
	AudioManager.play_3d("vault", global_position, -4.0)
	EventBus.make_noise(global_position, 7.0, self, &"climb")
	if _climb_tween and _climb_tween.is_valid():
		_climb_tween.kill()
	_climb_tween = create_tween()
	var seg := dur / points.size()
	for p in points:
		_climb_tween.tween_property(self, "global_position", p, seg).set_trans(Tween.TRANS_SINE)
	_climb_tween.tween_callback(func() -> void:
		collision_mask = cm
		state = "normal")


func _footsteps() -> void:
	if not is_on_floor() or _speed_now < 0.4:
		return
	var ph := body.animator.phase
	# um passo a cada meia volta da fase
	var a := floorf(_last_phase / PI)
	var b := floorf(ph / PI)
	_last_phase = ph
	if a == b:
		return
	_surface = _detect_surface()
	var base := 6.0
	if crouching:
		base = 2.2
	elif sprinting:
		base = 17.0
	elif _speed_now > 2.5:
		base = 10.5
	var sf := {"grass": 0.75, "gravel": 1.2, "water": 1.35, "metal": 1.4, "wood": 1.1, "asphalt": 1.0}
	var feet: Dictionary = equipment["feet"]
	var boots := 0.85 if not feet.is_empty() else 1.0
	noise_level = base * float(sf.get(_surface, 1.0)) * boots * (1.0 + clampf(survival.weight_ratio - 0.8, 0.0, 0.5))
	EventBus.make_noise(global_position, noise_level, self, &"step")
	AudioManager.footstep(_surface, global_position, clampf(noise_level / 12.0, 0.15, 1.1))


func _detect_surface() -> String:
	if world == null:
		return "asphalt"
	if indoors:
		return "wood"
	var p := global_position
	if WeatherManager.wetness > 0.5 and randf() < 0.35:
		return "water"
	var lay := world.layout
	if WorldLayout.URBAN.has_point(Vector2(p.x, p.z)):
		var bid := lay.block_at(p.x, p.z)
		if bid < 0:
			return "asphalt"
		var blk: Dictionary = lay.blocks[bid]
		var inner := (blk["rect"] as Rect2).grow(-WorldLayout.SIDEWALK)
		if inner.has_point(Vector2(p.x, p.z)) and str(blk["kind"]) in ["houses", "small_houses", "park", "plaza", "family_block", "apartments", "school"]:
			return "grass"
		return "asphalt"
	return "grass" if lay.district_at(p.x, p.z) != "serra" else "gravel"


# ---------------------------------------------------------------------------
# Câmera / interação / lanterna / furtividade (por frame, leves)
# ---------------------------------------------------------------------------
func _process(delta: float) -> void:
	cam_rig.input_enabled = control_enabled and not cinematic
	cam_rig.update_camera(delta)
	if cinematic or survival.dead:
		return
	_scan_t -= delta
	if _scan_t <= 0.0:
		_scan_t = 0.12
		_scan_interactables()
	if _hold_target != null:
		if not is_instance_valid(_hold_target):
			_hold_target = null
		else:
			var ht: float = _hold_target.hold_time(self)
			_hold_t += delta
			interact_hold_progress.emit(clampf(_hold_t / maxf(ht, 0.01), 0.0, 1.0))
			if _hold_t >= ht:
				var t := _hold_target
				_hold_target = null
				_hold_t = 0.0
				interact_hold_progress.emit(0.0)
				t.interact(self)
	_vis_t -= delta
	if _vis_t <= 0.0:
		_vis_t = 0.2
		_update_visibility()


func _scan_interactables() -> void:
	var best: Node = null
	var best_score := INF
	var cf := cam_rig.flat_forward()
	for a in interact_area.get_overlapping_areas():
		if not (a is Interactable) or not a.enabled:
			continue
		var to: Vector3 = a.global_position - global_position
		to.y = 0.0
		var d := to.length()
		var ang := 0.0 if d < 0.01 else acos(clampf(cf.dot(to / d), -1.0, 1.0))
		if ang > 1.3 and d > 1.1:
			continue
		var score := d + ang * 1.6
		if score < best_score:
			best_score = score
			best = a
	var prompt := ""
	if best != null:
		prompt = best.get_prompt(self)
	elif world != null and inventory.has("garrafa_vazia") and _near_water():
		prompt = "Encher garrafas (água suja)"
	if best != current_interactable or prompt != "":
		current_interactable = best
	EventBus.interaction_prompt.emit(prompt)


func _near_water() -> bool:
	var p := global_position
	return world.layout.is_water(p.x + (-sin(_yaw)) * 1.5, p.z + (-cos(_yaw)) * 1.5) and p.y < WorldLayout.RIVER_LEVEL + 2.5


func _begin_interact() -> void:
	if current_interactable == null:
		if world != null and inventory.has("garrafa_vazia") and _near_water():
			body.play("pickup", 1.0)
			fill_bottles("agua_suja", 4)
		return
	var t: float = current_interactable.hold_time(self)
	if t <= 0.0:
		body.play("interact", 1.3)
		current_interactable.interact(self)
	else:
		_hold_target = current_interactable
		_hold_t = 0.0
		body.play("inspect_low" if current_interactable is LootContainer else "interact", 1.0)


func _update_flashlight(delta: float) -> void:
	if not flashlight_on:
		return
	var l: Dictionary = equipment["light"]
	if l.is_empty():
		flashlight_on = false
		flashlight.visible = false
		return
	var d: Dictionary = l.get("data", {})
	var bat := float(d.get("battery", 0.0)) - delta * (100.0 / 900.0)
	d["battery"] = maxf(0.0, bat)
	l["data"] = d
	if bat <= 0.0:
		flashlight_on = false
		flashlight.visible = false
		EventBus.toast("A pilha da lanterna acabou.", "warn")
		return
	var k := clampf(bat / 15.0, 0.25, 1.0) * (0.92 + randf() * 0.08 if bat < 10.0 else 1.0)
	flashlight.light_energy = FLASH_ENERGY * k
	flash_fill.light_energy = FILL_ENERGY * k
	var chest := body.bone_global_position("chest") + Vector3(0, 0.05, 0)
	flashlight.global_position = chest + (-body.global_transform.basis.z) * 0.25 + cam_rig.flat_right() * 0.12
	# mira um pouco abaixo da linha do olhar: o chão à frente fica iluminado
	var target := cam_rig.cam.global_position + cam_rig.look_dir() * 12.0 + Vector3(0, -1.6, 0)
	if flashlight.global_position.distance_to(target) > 0.5:
		flashlight.look_at(target, Vector3.UP)


func _update_visibility() -> void:
	var dl := TimeManager.daylight()
	indoors = world != null and world.is_indoors(global_position)
	var light := dl * (1.0 - WeatherManager.fog * 0.5) * (0.35 if indoors else 1.0)
	if flashlight_on:
		light = maxf(light, 0.85)
	for n in get_tree().get_nodes_in_group("heat_source"):
		if (n as Node3D).global_position.distance_squared_to(global_position) < 36.0:
			light = maxf(light, 0.7)
	var posture := 0.5 if crouching else 1.0
	var motion := 0.65 + clampf(_speed_now / SPRINT, 0.0, 1.0) * 0.55
	visibility_level = clampf((0.12 + light * 0.88) * posture * motion, 0.03, 1.0)
	# exposição à chuva / temperatura
	survival.exposed_to_rain = WeatherManager.rain if not indoors else 0.0
	survival.ambient_temp = WeatherManager.temperature_at(global_position, indoors)
	var warmth := 0.0
	var rain_p := 0.0
	for k in ["torso", "hands", "head", "feet"]:
		var s: Dictionary = equipment[k]
		if not s.is_empty():
			var def := ItemDB.get_item(str(s["id"]))
			warmth += float(def.get("warmth", 0.0))
			rain_p = maxf(rain_p, float(def.get("rain", 0.0)))
	survival.warmth = warmth
	survival.rain_protection = rain_p
	var near_heat := false
	for n in get_tree().get_nodes_in_group("heat_source"):
		if n.has_method("is_heat_source") and n.is_heat_source() and (n as Node3D).global_position.distance_to(global_position) < 4.0:
			near_heat = true
	survival.near_heat = near_heat
	if world != null:
		AudioManager.set_environment(world.acoustic_mode(global_position))


# ---------------------------------------------------------------------------
# Combate
# ---------------------------------------------------------------------------
func _weapon() -> Dictionary:
	return Melee.weapon_params(equipment["weapon"])


func _is_ranged() -> bool:
	var w: Dictionary = equipment["weapon"]
	return not w.is_empty() and ItemDB.get_item(str(w["id"])).has("ranged")


func _update_weapon_visual() -> void:
	body.clear_attachment("hand_r")
	body.clear_attachment("chest")
	var w: Dictionary = equipment["weapon"]
	if w.is_empty():
		return
	var mi := MeshInstance3D.new()
	mi.mesh = WeaponMeshes.mesh(str(w["id"]))
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	if aiming and WeaponMeshes.is_long_gun(str(w["id"])):
		# arma longa na mira: coronha no ombro direito, cano para a frente
		body.attach("chest", mi, Transform3D(Basis.IDENTITY, Vector3(0.15, 0.16, -0.27)))
	else:
		body.attach("hand_r", mi, Transform3D(Basis(Vector3.RIGHT, -PI * 0.5), Vector3(0.0, -0.12, -0.02)))


func _attack(heavy: bool) -> void:
	if state != "normal" or cinematic:
		return
	if _busy_t > 0.0:
		# guarda o clique para encadear o combo assim que o golpe atual terminar
		if _busy_t < 0.45 and _pending_use.is_empty():
			_queued_attack = 1 if heavy else 0
			_queued_t = 0.5
		return
	var w := _weapon()
	var target := _stealth_target()
	if target != null:
		_stealth_kill(target)
		return
	var downed := _downed_target()
	if downed != null:
		body.play("stomp", 1.1)
		_attack_heavy = true
		_busy_t = 0.7
		_attack_hits = {}
		return
	var cost := float(w["stamina"]) * (1.7 if heavy else 1.0)
	if not survival.use_stamina(cost):
		EventBus.toast("Sem fôlego!", "warn")
		return
	_attack_heavy = heavy
	_attack_hits = {}
	_aim_at_target(float(w["reach"]))
	var sp := float(w["speed"]) * lerpf(0.75, 1.0, survival.stamina / 100.0)
	if _combo_t <= 0.0:
		_attack_combo = 0
	_attack_finisher = false
	if heavy:
		body.play("attack_heavy", sp * 0.95)
		_busy_t = 1.0 / sp
		_attack_combo = 0
		AudioManager.play_3d("swing_heavy", global_position, -2.0)
	else:
		# leve, leve, e o 3º golpe seguido vira um golpe de finalização (mais lento e forte)
		_attack_finisher = _attack_combo % 3 == 2
		var anim := "attack_light" if _attack_combo % 2 == 0 else "attack_light_2"
		if _attack_finisher:
			anim = "attack_heavy"
			sp *= 1.25
		_attack_combo += 1
		_combo_t = 1.0
		body.play(anim, sp)
		_busy_t = (0.8 if _attack_finisher else 0.5) / sp
		AudioManager.play_3d("swing_heavy" if _attack_finisher else "swing", global_position, -3.0 if _attack_finisher else -4.0)


## Mira assistida: vira para o infectado mais próximo à frente (câmera) e dá um
## passo curto se ele estiver um pouco fora do alcance.
func _aim_at_target(reach: float) -> void:
	_melee_target = null
	var cf := cam_rig.flat_forward()
	var best := INF
	for n in get_tree().get_nodes_in_group("infected"):
		var inf := n as Node3D
		if inf == null or not inf.visible or (n.has_method("is_alive") and not n.is_alive()):
			continue
		var to := inf.global_position - global_position
		to.y = 0.0
		var d := to.length()
		if d > reach + 1.6 or d < 0.05 or absf(inf.global_position.y - global_position.y) > 1.6:
			continue
		var ang := rad_to_deg(cf.angle_to(to / d))
		if ang > 65.0:
			continue
		var score := d + ang * 0.03
		if score < best:
			best = score
			_melee_target = inf
	if _melee_target == null:
		return
	var tt := _melee_target.global_position - global_position
	tt.y = 0.0
	_yaw = lerp_angle(_yaw, atan2(-tt.x, -tt.z), 0.7)
	body.rotation.y = _yaw
	if tt.length() > reach * 0.85:
		_lunge_t = 0.16
		_lunge_stop = reach * 0.7


func _on_anim_event(e: String) -> void:
	match e:
		"hit_start":
			_attack_active = true
		"hit_end":
			_attack_active = false
		"consume":
			_finish_use()
		"release":
			_release_throw()
		"stealth_hit":
			_apply_stealth_hit()


func _process_hits() -> void:
	var w := _weapon()
	var fwd := -body.global_transform.basis.z
	var origin := global_position + Vector3(0, 1.2, 0)
	var reach := float(w["reach"]) + (0.2 if _attack_heavy else 0.0)
	var targets := Melee.sweep(self, origin, fwd, reach, 0.35, 70.0 if not _attack_heavy else 45.0, [get_rid()])
	for t in targets:
		var id: int = t.get_instance_id()
		if _attack_hits.has(id):
			continue
		_attack_hits[id] = true
		var strong := _attack_heavy or _attack_finisher
		var dmg := float(w["dmg"]) * (1.8 if _attack_heavy else (1.35 if _attack_finisher else 1.0)) * (1.0 - survival.pain * 0.002)
		var info := DamageInfo.make(dmg, str(w["kind"]), self, (t as Node3D).global_position - global_position)
		# empurrão em m/s (o alvo desliza v²/2a): soco ~0,3 m, taco ~0,6 m, marreta pesada ~2 m
		info.knockback = 1.6 + float(w["knock"]) * 3.0 * (1.6 if strong else 1.0)
		info.stagger = float(w["knock"]) * (1.4 if _attack_heavy else 0.7) + (0.35 if _attack_finisher else 0.0)
		info.heavy = strong
		info.bleed = float(w.get("bleed", 0.0))
		info.point = (t as Node3D).global_position + Vector3(0, 1.3, 0)
		t.receive_hit(info)
		var snd := "hit_sharp" if w["kind"] == "sharp" else "hit_blunt"
		AudioManager.play_3d(snd, info.point, 0.0)
		HitFx.spawn(get_parent(), info.point, info.direction, strong, t is Infected)
		cam_rig.add_shake(0.25 if strong else 0.12)
		EventBus.combat_hit.emit(self, t, dmg)
		EventBus.make_noise(global_position, 11.0, self, &"combat")
		var ws: Dictionary = equipment["weapon"]
		if not ws.is_empty():
			ws["cond"] = maxf(0.0, float(ws["cond"]) - float(w["wear"]))
			if float(ws["cond"]) <= 0.0:
				EventBus.toast("%s quebrou!" % w["name"], "warn")
				equipment["weapon"] = {}
				_update_weapon_visual()
		# micro "hit-stop" para peso do impacto
		Engine.time_scale = 0.35 if strong else 0.6
		get_tree().create_timer(0.05, true, false, true).timeout.connect(func() -> void: Engine.time_scale = 1.0)


func _stealth_target() -> Node:
	if not crouching:
		return null
	var fwd := -body.global_transform.basis.z
	for n in get_tree().get_nodes_in_group("infected"):
		var inf := n as Node3D
		if inf == null or not n.has_method("can_be_stealth_killed"):
			continue
		var to := inf.global_position - global_position
		if to.length() > 1.6 or fwd.dot(to.normalized()) < 0.6:
			continue
		if n.can_be_stealth_killed(self):
			return n
	return null


var _stealth_victim: Node = null


func _stealth_kill(target: Node) -> void:
	_stealth_victim = target
	_busy_t = 1.6
	state = "normal"
	body.play("stealth_kill", 1.0)
	target.begin_stealth_death(self)
	var to: Vector3 = (target as Node3D).global_position - global_position
	_yaw = atan2(-to.x, -to.z)


func _apply_stealth_hit() -> void:
	if _stealth_victim != null and is_instance_valid(_stealth_victim):
		var info := DamageInfo.make(999.0, "sharp", self, (_stealth_victim as Node3D).global_position - global_position)
		info.stealth = true
		info.blockable = false
		_stealth_victim.receive_hit(info)
		GameState.add_stat("stealth_kills")
		AudioManager.play_3d("hit_flesh", (_stealth_victim as Node3D).global_position, -6.0)
		EventBus.make_noise(global_position, 3.0, self, &"stealth")
	_stealth_victim = null


func _downed_target() -> Node:
	for n in get_tree().get_nodes_in_group("infected"):
		var inf := n as Node3D
		if inf != null and n.has_method("is_downed") and n.is_downed() and inf.global_position.distance_to(global_position) < 1.7:
			return n
	return null


func _start_block() -> void:
	if _busy_t > 0.2 or cinematic:
		return
	blocking = true
	_block_t = Time.get_ticks_msec() / 1000.0
	body.play("block", 1.4)


func _end_block() -> void:
	if blocking:
		blocking = false
		body.stop_action()


func _dodge() -> void:
	if _dodge_t > 0.0 or not is_on_floor() or cinematic or state != "normal":
		return
	if not survival.use_stamina(18.0):
		return
	var ix := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var iz := Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	var dir := cam_rig.flat_right() * ix - cam_rig.flat_forward() * iz
	if dir.length() < 0.2:
		dir = cam_rig.flat_forward() * -1.0
	dir = dir.normalized()
	_dodge_vel = dir * 7.2
	_dodge_t = 0.28
	_invuln = 0.34
	_end_block()
	var side := absf(dir.dot(cam_rig.flat_right())) > 0.6
	body.play("dodge_side" if side else "dodge", 1.2)
	AudioManager.play_3d("shove", global_position, -8.0)
	EventBus.make_noise(global_position, 5.0, self, &"dodge")


func _shove() -> void:
	if _shove_cd > 0.0 or _busy_t > 0.1 or cinematic:
		return
	if not survival.use_stamina(10.0):
		return
	_shove_cd = 0.8
	_busy_t = 0.45
	body.play("shove", 1.2)
	AudioManager.play_3d("shove", global_position, -2.0)
	var fwd := -body.global_transform.basis.z
	var targets := Melee.sweep(self, global_position + Vector3(0, 1.1, 0), fwd, 1.6, 0.45, 90.0, [get_rid()])
	for t in targets:
		var info := DamageInfo.make(2.0, "push", self, (t as Node3D).global_position - global_position)
		info.knockback = 4.5
		info.stagger = 0.75
		info.blockable = false
		t.receive_hit(info)
	EventBus.make_noise(global_position, 7.0, self, &"shove")


func _throw() -> void:
	if _busy_t > 0.0 or cinematic:
		return
	for id in ["garrafa_vazia", "lata_vazia", "pedra", "rojao", "coquetel"]:
		if inventory.has(id):
			_throw_stack = {"id": id}
			body.play("throw", 1.1)
			_busy_t = 0.7
			return
	EventBus.toast("Nada para arremessar (garrafa, lata, pedra…).", "info")


func _release_throw() -> void:
	if _throw_stack.is_empty():
		return
	var id: String = _throw_stack["id"]
	_throw_stack = {}
	if inventory.remove(id, 1) <= 0:
		return
	var p := Projectile.new()
	get_parent().add_child(p)
	var from := global_position + Vector3(0, 1.6, 0) + cam_rig.flat_right() * 0.25
	var dir := cam_rig.look_dir()
	dir.y += 0.18
	p.launch(id, from, dir.normalized() * 15.0, self)


func _fire_ranged() -> void:
	if _ranged_cd > 0.0:
		return
	var ws: Dictionary = equipment["weapon"]
	var def := ItemDB.get_item(str(ws["id"]))
	var r: Dictionary = def["ranged"]
	var ammo: String = r["ammo"]
	if not inventory.has(ammo):
		AudioManager.play_3d("door_locked", global_position, -10.0)
		EventBus.toast("Sem munição (%s)." % ItemDB.item_name(ammo), "warn")
		_auto_fire = false
		return
	inventory.remove(ammo, 1)
	_ranged_cd = float(r["rate"])
	var cam := cam_rig.cam
	var from := cam.global_position
	var silent := bool(r.get("silent", false))
	var pellets := int(r.get("pellets", 1))
	# dispersão: dor, cansaço e rajada contínua pioram a mira
	var spread := float(r["spread"]) * (1.0 + survival.pain * 0.01 + (1.0 - survival.stamina / 100.0)) * (1.0 + _burst * 0.25)
	_burst = minf(_burst + (1.0 if bool(r.get("auto", false)) else 0.0), 6.0)
	var space := get_world_3d().direct_space_state
	var hit_once := {}
	for k in pellets:
		var dir := (cam_rig.look_dir() + Vector3(randf_range(-spread, spread), randf_range(-spread, spread), randf_range(-spread, spread))).normalized()
		var q := PhysicsRayQueryParameters3D.create(from, from + dir * float(r["range"]), 1 | (1 << 2) | (1 << 3) | (1 << 4))
		q.exclude = [get_rid()]
		var hit := space.intersect_ray(q)
		if hit.is_empty():
			continue
		var col: Object = hit["collider"]
		var hp: Vector3 = hit["position"]
		if col is Node and (col as Node).has_method("receive_hit"):
			# queda de dano com a distância (chumbo perde força rápido)
			var dist := from.distance_to(hp)
			var fall := clampf(1.0 - dist / float(r["range"]) * (0.8 if pellets > 1 else 0.35), 0.2, 1.0)
			var info := DamageInfo.make(float(r["dmg"]) * fall, "bullet" if not silent else "sharp", self, dir)
			info.point = hp
			info.headshot = hp.y - (col as Node3D).global_position.y > 1.45
			if info.headshot:
				info.amount *= 2.5
			info.stagger = 0.6 if pellets == 1 else 0.35
			info.knockback = 1.2 if pellets == 1 else 0.5
			info.blockable = false
			col.receive_hit(info)
			HitFx.spawn(get_parent(), hp, -dir, info.headshot, col is Infected)
			if not hit_once.has(col.get_instance_id()):
				hit_once[col.get_instance_id()] = true
				EventBus.combat_hit.emit(self, col, info.amount)
		else:
			HitFx.spawn(get_parent(), hp + (hit["normal"] as Vector3) * 0.02, hit["normal"], false, false)
			if silent and randf() < float(r.get("recover", 0.0)):
				var ip := ItemPickup.new()
				get_parent().add_child(ip)
				ip.setup(Inventory.make_stack(ammo, 1), hp - dir * 0.2, true)
	var pitch := float(r.get("pitch", 1.0)) * randf_range(0.95, 1.05)
	AudioManager.play_3d("bow_shot" if silent else "gun_shot", global_position, (-4.0 if silent else (2.0 if pellets > 1 else 0.0)), pitch)
	EventBus.make_noise(global_position, float(r["noise"]), self, &"gunshot" if not silent else &"bow")
	cam_rig.add_shake((0.1 if silent else 0.3) * float(r.get("kick", 1.0)))
	cam_rig.pitch = clampf(cam_rig.pitch + (0.0 if silent else 0.012 * float(r.get("kick", 1.0))), -1.3, 1.3)
	if not silent:
		_muzzle_flash()


## Clarão do disparo: luz curta na boca do cano.
func _muzzle_flash() -> void:
	var l := OmniLight3D.new()
	l.light_color = Color(1.0, 0.8, 0.45)
	l.light_energy = 3.5
	l.omni_range = 5.0
	l.shadow_enabled = false
	get_parent().add_child(l)
	l.global_position = body.bone_global_position("hand_r") + cam_rig.look_dir() * 0.5
	get_tree().create_timer(0.05, false).timeout.connect(l.queue_free)


## Recebe golpe de infectado/NPC.
func receive_hit(info: DamageInfo) -> void:
	if survival.dead or _invuln > 0.0 or cinematic:
		return
	var attacker := info.source as Node3D
	var now := Time.get_ticks_msec() / 1000.0
	var facing := true
	if attacker != null:
		var to := (attacker.global_position - global_position)
		to.y = 0
		facing = (-body.global_transform.basis.z).dot(to.normalized()) > 0.25
	if blocking and info.blockable and facing:
		if now - _block_t < 0.22:
			AudioManager.play_3d("parry", global_position)
			cam_rig.add_shake(0.2)
			if attacker != null and attacker.has_method("on_parried"):
				attacker.on_parried(self)
			body.play("parry", 1.2)
			return
		var wb := float(ItemDB.get_item(str((equipment["weapon"] as Dictionary).get("id", ""))).get("weapon", {}).get("block_bonus", 0.0))
		survival.stamina = maxf(0.0, survival.stamina - info.amount * (1.2 - wb))
		AudioManager.play_3d("block", global_position)
		cam_rig.add_shake(0.15)
		if survival.stamina <= 0.0:
			_end_block()
			_stagger(0.9)
			return
		info.amount *= 0.25 - wb * 0.3
		info.infection_chance *= 0.2
	var armor := 0.0
	for k in ["torso", "hands", "head"]:
		var s: Dictionary = equipment[k]
		if not s.is_empty():
			armor += float(ItemDB.get_item(str(s["id"])).get("armor", 0.0))
			s["cond"] = maxf(0.0, float(s.get("cond", 1.0)) - 0.01)
	armor = clampf(armor, 0.0, 0.6)
	var dmg := info.amount * (1.0 - armor) * Settings.damage_taken_multiplier()
	survival.damage(dmg, info.kind, info.infection_chance * (1.0 - armor * 0.8))
	EventBus.player_damaged.emit(dmg, attacker)
	cam_rig.add_shake(clampf(dmg / 25.0, 0.1, 0.7))
	AudioManager.play_3d("hit_flesh", global_position, -2.0)
	var local := body.global_transform.basis.inverse() * info.direction
	body.animator.flinch(local, clampf(dmg / 15.0, 0.3, 1.5))
	_knockback = Vector3(info.direction.x, 0, info.direction.z).normalized() * info.knockback
	if info.stagger > 0.85:
		state = "knockdown"
		body.play("knockdown", 1.0)
		_stagger_t = 2.0
	elif info.stagger > 0.45:
		_stagger(0.5)


func _stagger(t: float) -> void:
	_stagger_t = t
	body.play("stagger", 1.3)


func _on_symptom(kind: String) -> void:
	match kind:
		"cough":
			AudioManager.play_3d("cough", global_position, 0.0)
			EventBus.make_noise(global_position, 14.0, self, &"cough")
			body.play("cough", 1.0, false)
		"vomit":
			AudioManager.play_3d("cough", global_position, -2.0, 0.7)
			EventBus.make_noise(global_position, 10.0, self, &"cough")
		"hallucination":
			AudioManager.play_2d(["infected_groan", "distant_scream", "heartbeat"][randi() % 3], -12.0, 0.8)


func _on_died(cause: String) -> void:
	state = "dead"
	flashlight.visible = false
	body.play("death", 1.0)
	GameState.add_stat("deaths")
	died.emit(cause)
	EventBus.player_died.emit(cause)


# ---------------------------------------------------------------------------
# Veículos
# ---------------------------------------------------------------------------
func enter_vehicle(v: Node3D) -> void:
	in_vehicle = v
	collision_layer = 0
	collision_mask = 0
	velocity = Vector3.ZERO
	cam_rig.mode = "vehicle"
	cam_rig.set_target(v)
	body.play("drive", 1.0)
	EventBus.vehicle_entered.emit(v)


func exit_vehicle() -> void:
	if in_vehicle == null:
		return
	var v: Node3D = in_vehicle
	var exit_pos: Vector3 = v.exit_position() if v.has_method("exit_position") else v.global_position + Vector3(2, 0, 0)
	if v.has_method("on_driver_exit"):
		v.on_driver_exit()
	in_vehicle = null
	teleport(exit_pos)
	collision_layer = 1 << 1
	collision_mask = 1 | (1 << 2) | (1 << 3) | (1 << 4)
	cam_rig.mode = "follow"
	cam_rig.set_target(self)
	body.stop_action()
	visible = true
	EventBus.vehicle_exited.emit(v)


func _follow_vehicle() -> void:
	var v: Node3D = in_vehicle
	if not is_instance_valid(v):
		in_vehicle = null
		return
	var seat: Vector3 = v.seat_position() if v.has_method("seat_position") else v.global_position
	global_position = seat
	_yaw = v.global_rotation.y
	body.rotation.y = _yaw
	body.animator.speed = 0.0


# ---------------------------------------------------------------------------
# Controle cinemático (abertura)
# ---------------------------------------------------------------------------
func set_cinematic(on: bool) -> void:
	cinematic = on
	control_enabled = not on
	if on:
		crouching = false
		_end_block()


func cinematic_walk_to(p: Vector3, speed: float = WALK) -> void:
	cine_target = p
	cine_speed = speed
	cine_arrived = false


func cinematic_face(dir: Vector3) -> void:
	cine_face = Vector3(dir.x, 0, dir.z).normalized()


func _cinematic_wish() -> Vector3:
	if cine_target == Vector3.INF:
		return Vector3.ZERO
	var to := cine_target - global_position
	to.y = 0.0
	if to.length() < 0.35:
		cine_arrived = true
		cine_target = Vector3.INF
		return Vector3.ZERO
	return to.normalized() * clampf(to.length() / 1.2, 0.35, 1.0)


## Move o Caio instantaneamente (elevador, carregar jogo, testes) sem contar
## como queda nem herdar velocidade.
func teleport(pos: Vector3) -> void:
	global_position = pos
	velocity = Vector3.ZERO
	_air_t = 0.0
	_knockback = Vector3.ZERO
	_knock_last = Vector3.ZERO


func set_yaw(y: float) -> void:
	_yaw = y
	body.rotation.y = y


# ---------------------------------------------------------------------------
# Save
# ---------------------------------------------------------------------------
func to_dict() -> Dictionary:
	return {"pos": global_position, "yaw": _yaw, "cam_yaw": cam_rig.yaw, "survival": survival.to_dict(),
		"inventory": inventory.to_data(), "equipment": equipment.duplicate(true), "quick": quick_slots.duplicate(),
		"flashlight": flashlight_on, "crouch": crouching}


func from_dict(d: Dictionary) -> void:
	if d.has("pos"):
		global_position = d["pos"]
	set_yaw(float(d.get("yaw", 0.0)))
	cam_rig.yaw = float(d.get("cam_yaw", 0.0))
	survival.from_dict(d.get("survival", {}))
	var eq: Dictionary = d.get("equipment", {})
	for k in equipment.keys():
		equipment[k] = eq.get(k, {})
	_recalc_capacity()
	inventory.from_data(d.get("inventory", {}))
	_recalc_capacity()
	quick_slots = d.get("quick", ["", "", "", ""])
	_update_weapon_visual()
	crouching = bool(d.get("crouch", false))
	if bool(d.get("flashlight", false)):
		toggle_flashlight()
