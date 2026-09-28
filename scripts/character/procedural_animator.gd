class_name ProceduralAnimator
extends RefCounted
## Animação procedural de locomoção + ações por poses-chave (AnimLibrary).
##
## Locomoção (andar/correr/sprint/agachar/pular) é calculada por fase de
## passada — sem deslizar os pés e reutilizável por todos os humanoides.
## Estilos: human, shamble (errante), feral (febril), brute (colosso),
## crawl (rastejante), injured (ferido), panic (fuga).
## O custo é controlado externamente (LOD): o dono decide com que frequência
## chamar update().

signal event(event_name: String)

const DEG := PI / 180.0
const N := 18

var skeleton: Skeleton3D
var style: String = "human"
var speed: float = 0.0
var forward_speed: float = 0.0
var grounded: bool = true
var crouch_target: float = 0.0
var crouch: float = 0.0
var injured: float = 0.0
var look_yaw: float = 0.0
var look_pitch: float = 0.0
var height_scale: float = 1.0
var twitchiness: float = 0.0
var breathing: float = 1.0
var turn_rate: float = 0.0

var phase: float = 0.0
var t: float = 0.0
var action: Dictionary = {}
var action_name: String = ""
var action_time: float = 0.0
var action_speed: float = 1.0
var _fade: float = 1.0
var _fading_out: bool = false
var _event_idx: int = 0
var _prev_time: float = 0.0

var _base := PackedVector3Array()
var _final := PackedVector3Array()
var _hips_base := Vector3.ZERO
var _hips_final := Vector3.ZERO
var _rest_hips := Vector3.ZERO
var _flinch := Vector3.ZERO
var _twitch := Vector3.ZERO
var _twitch_timer: float = 1.0
var _rng := RandomNumberGenerator.new()


func _init(skel: Skeleton3D, appearance: Dictionary = {}) -> void:
	skeleton = skel
	_base.resize(N)
	_final.resize(N)
	height_scale = float(appearance.get("height", 1.75)) / 1.78
	_rng.seed = int(appearance.get("seed", 0)) + 911
	phase = _rng.randf() * TAU
	if skeleton != null and skeleton.get_bone_count() > 0:
		_rest_hips = skeleton.get_bone_rest(0).origin


# ---------------------------------------------------------------------------
# Ações
# ---------------------------------------------------------------------------
func play(name_: String, speed_mult: float = 1.0, restart: bool = true) -> bool:
	if not restart and action_name == name_ and not _fading_out:
		return true
	var def := AnimLibrary.get_action(name_)
	if def.is_empty():
		return false
	action = def
	action_name = name_
	action_time = 0.0
	action_speed = speed_mult
	_fade = 0.0 if float(def["blend_in"]) > 0.0 else 1.0
	_fading_out = false
	_event_idx = 0
	_prev_time = 0.0
	return true


func stop_action() -> void:
	if action.is_empty():
		return
	_fading_out = true


func stop_immediate() -> void:
	action = {}
	action_name = ""
	_fading_out = false


func is_playing(name_: String = "") -> bool:
	if action.is_empty():
		return false
	if name_ == "":
		return true
	return action_name == name_ and not _fading_out


func action_progress() -> float:
	if action.is_empty():
		return 1.0
	return clampf(action_time / float(action["dur"]), 0.0, 1.0)


func flinch(local_dir: Vector3, amount: float) -> void:
	# direção do golpe no espaço local do personagem
	_flinch += Vector3(local_dir.z * 25.0, 0.0, -local_dir.x * 20.0) * amount


# ---------------------------------------------------------------------------
# Atualização
# ---------------------------------------------------------------------------
func update(dt: float) -> void:
	if skeleton == null:
		return
	dt = minf(dt, 0.25)
	t += dt
	crouch = move_toward(crouch, crouch_target, dt * 4.0)
	_locomotion(dt)
	for i in N:
		_final[i] = _base[i]
	_hips_final = _hips_base
	if not action.is_empty():
		_apply_action(dt)
	_additive(dt)
	_apply()


func _locomotion(dt: float) -> void:
	for i in N:
		_base[i] = Vector3.ZERO
	var hs := height_scale
	var spd := speed
	var walk := clampf(spd / 1.1, 0.0, 1.0)
	var run := smoothstep(2.4, 4.4, spd)
	var sprint := smoothstep(4.8, 6.2, spd)
	var stride := lerpf(0.68, 1.15, run) * hs
	match style:
		"shamble": stride *= 0.7
		"brute": stride *= 0.85
		"crawl": stride *= 0.5
		"injured": stride *= 0.75
	var dir := 1.0 if forward_speed >= -0.15 else -1.0
	phase = fmod(phase + dir * (spd / maxf(stride, 0.1)) * PI * dt, TAU * 100.0)
	var sp := sin(phase)
	var cp := cos(phase)
	var c := crouch

	var amp_th := lerpf(24.0, 40.0, run) * walk * (1.0 - c * 0.45)
	var knee_amp := lerpf(48.0, 92.0, run)
	var th_l := sp * amp_th
	var th_r := -sp * amp_th
	var sh_l := -(maxf(0.0, cp) * knee_amp + 5.0) * walk
	var sh_r := -(maxf(0.0, -cp) * knee_amp + 5.0) * walk
	var amp_arm := lerpf(16.0, 48.0, run) * walk
	var ua_l := -sp * amp_arm
	var ua_r := sp * amp_arm
	var fa := lerpf(10.0, 80.0, run) * walk + 8.0
	var bob := -absf(sp) * lerpf(0.03, 0.055, run) * walk * hs
	var hips_yaw := sp * 7.0 * walk
	var hips_roll := cp * 3.0 * walk
	var spine_x := -(run * 7.0 + sprint * 9.0)
	var head_x := run * 4.0 + sprint * 5.0
	var chest_x := sin(t * 1.7) * 1.4 * breathing * (1.0 - walk * 0.8)
	var ua_z := 6.0 + (1.0 - walk) * sin(t * 0.8) * 1.0

	match style:
		"shamble":
			th_r *= 0.55
			sh_r *= 0.35
			hips_roll += cp * 7.0 * walk + 3.0
			spine_x -= 22.0
			head_x += 26.0
			ua_l = 38.0 + sin(phase + 0.6) * 9.0 * walk
			ua_r = 32.0 - sin(phase) * 7.0 * walk
			fa = 28.0
			ua_z = 4.0
			chest_x += sin(phase * 0.5) * 3.0
		"feral":
			spine_x -= 28.0
			head_x += 30.0
			ua_l = 50.0 - sp * 45.0 * walk
			ua_r = 50.0 + sp * 45.0 * walk
			ua_z = 22.0
			fa = 35.0
			sh_l *= 1.1
			sh_r *= 1.1
		"brute":
			bob *= 1.7
			spine_x -= 18.0
			head_x += 16.0
			hips_roll += cp * 6.0 * walk
			ua_l = 24.0 - sp * 12.0 * walk
			ua_r = 24.0 + sp * 12.0 * walk
			ua_z = 18.0
			fa = 22.0
		"injured":
			th_r *= 0.6
			sh_r *= 0.4
			hips_roll += 5.0 + cp * 5.0 * walk
			spine_x -= 6.0
			ua_r = 12.0
			fa = 20.0
		"panic":
			ua_l = 60.0 - sp * 40.0 * walk
			ua_r = 60.0 + sp * 40.0 * walk
			ua_z = 14.0
			fa = 90.0
			head_x -= 4.0

	# pés tendem a ficar paralelos ao chão
	var ft_l := -(th_l + sh_l) * 0.65 + maxf(0.0, cp) * 8.0 * walk
	var ft_r := -(th_r + sh_r) * 0.65 + maxf(0.0, -cp) * 8.0 * walk

	_base[HumanoidMeshBuilder.HIPS] = Vector3(0.0, hips_yaw, hips_roll)
	_base[HumanoidMeshBuilder.SPINE] = Vector3(spine_x * 0.5, -hips_yaw * 0.5, -hips_roll * 0.5)
	_base[HumanoidMeshBuilder.CHEST] = Vector3(spine_x * 0.5 + chest_x, -hips_yaw * 0.9, -hips_roll * 0.3)
	_base[HumanoidMeshBuilder.NECK] = Vector3(head_x * 0.4, hips_yaw * 0.2, 0.0)
	_base[HumanoidMeshBuilder.HEAD] = Vector3(head_x * 0.6, hips_yaw * 0.2, 0.0)
	_base[HumanoidMeshBuilder.UARM_L] = Vector3(ua_l, 0.0, -ua_z)
	_base[HumanoidMeshBuilder.UARM_R] = Vector3(ua_r, 0.0, ua_z)
	_base[HumanoidMeshBuilder.FARM_L] = Vector3(fa + maxf(0.0, ua_l) * 0.3, 0.0, 0.0)
	_base[HumanoidMeshBuilder.FARM_R] = Vector3(fa + maxf(0.0, ua_r) * 0.3, 0.0, 0.0)
	_base[HumanoidMeshBuilder.THIGH_L] = Vector3(th_l, 0.0, -1.5)
	_base[HumanoidMeshBuilder.THIGH_R] = Vector3(th_r, 0.0, 1.5)
	_base[HumanoidMeshBuilder.SHIN_L] = Vector3(sh_l, 0.0, 0.0)
	_base[HumanoidMeshBuilder.SHIN_R] = Vector3(sh_r, 0.0, 0.0)
	_base[HumanoidMeshBuilder.FOOT_L] = Vector3(ft_l, 0.0, 0.0)
	_base[HumanoidMeshBuilder.FOOT_R] = Vector3(ft_r, 0.0, 0.0)
	_hips_base = Vector3(0.0, bob, 0.0)

	if style == "brute":
		_addb(HumanoidMeshBuilder.THIGH_L, Vector3(0, 0, -7.0))
		_addb(HumanoidMeshBuilder.THIGH_R, Vector3(0, 0, 7.0))

	# agachamento
	if c > 0.001:
		_hips_base.y -= 0.36 * c * hs
		_addb(HumanoidMeshBuilder.THIGH_L, Vector3(72.0 * c, 0, 0))
		_addb(HumanoidMeshBuilder.THIGH_R, Vector3(72.0 * c, 0, 0))
		_addb(HumanoidMeshBuilder.SHIN_L, Vector3(-100.0 * c, 0, 0))
		_addb(HumanoidMeshBuilder.SHIN_R, Vector3(-100.0 * c, 0, 0))
		_addb(HumanoidMeshBuilder.FOOT_L, Vector3(30.0 * c, 0, 0))
		_addb(HumanoidMeshBuilder.FOOT_R, Vector3(30.0 * c, 0, 0))
		_addb(HumanoidMeshBuilder.SPINE, Vector3(-16.0 * c, 0, 0))
		_addb(HumanoidMeshBuilder.CHEST, Vector3(-8.0 * c, 0, 0))
		_addb(HumanoidMeshBuilder.HEAD, Vector3(18.0 * c, 0, 0))
		_addb(HumanoidMeshBuilder.UARM_L, Vector3(18.0 * c, 0, 0))
		_addb(HumanoidMeshBuilder.UARM_R, Vector3(18.0 * c, 0, 0))
		_addb(HumanoidMeshBuilder.FARM_L, Vector3(30.0 * c, 0, 0))
		_addb(HumanoidMeshBuilder.FARM_R, Vector3(30.0 * c, 0, 0))

	# no ar
	if not grounded and style != "crawl":
		_addb(HumanoidMeshBuilder.THIGH_L, Vector3(28.0, 0, 0))
		_addb(HumanoidMeshBuilder.THIGH_R, Vector3(14.0, 0, 0))
		_addb(HumanoidMeshBuilder.SHIN_L, Vector3(-50.0, 0, 0))
		_addb(HumanoidMeshBuilder.SHIN_R, Vector3(-30.0, 0, 0))
		_addb(HumanoidMeshBuilder.UARM_L, Vector3(0, 0, -22.0))
		_addb(HumanoidMeshBuilder.UARM_R, Vector3(0, 0, 22.0))

	# rastejante: corpo deitado, braços puxam
	if style == "crawl":
		_base[HumanoidMeshBuilder.HIPS] = Vector3(-82.0, sp * 4.0, sp * 6.0 * walk)
		_hips_base = Vector3(0.0, -0.8 * hs, 0.0)
		_base[HumanoidMeshBuilder.SPINE] = Vector3(4.0, -sp * 5.0, 0.0)
		_base[HumanoidMeshBuilder.CHEST] = Vector3(6.0, -sp * 6.0, 0.0)
		_base[HumanoidMeshBuilder.HEAD] = Vector3(55.0, 0.0, 0.0)
		_base[HumanoidMeshBuilder.NECK] = Vector3(15.0, 0.0, 0.0)
		_base[HumanoidMeshBuilder.UARM_L] = Vector3(150.0 + sp * 30.0 * walk, 0.0, -18.0)
		_base[HumanoidMeshBuilder.UARM_R] = Vector3(150.0 - sp * 30.0 * walk, 0.0, 18.0)
		_base[HumanoidMeshBuilder.FARM_L] = Vector3(25.0 + maxf(0.0, cp) * 45.0 * walk, 0.0, 0.0)
		_base[HumanoidMeshBuilder.FARM_R] = Vector3(25.0 + maxf(0.0, -cp) * 45.0 * walk, 0.0, 0.0)
		_base[HumanoidMeshBuilder.THIGH_L] = Vector3(4.0 + sp * 6.0 * walk, 0.0, -6.0)
		_base[HumanoidMeshBuilder.THIGH_R] = Vector3(-2.0, 0.0, 9.0)
		_base[HumanoidMeshBuilder.SHIN_L] = Vector3(-12.0, 0.0, 0.0)
		_base[HumanoidMeshBuilder.SHIN_R] = Vector3(-35.0, 0.0, 0.0)
		_base[HumanoidMeshBuilder.FOOT_L] = Vector3(-45.0, 0.0, 0.0)
		_base[HumanoidMeshBuilder.FOOT_R] = Vector3(-45.0, 0.0, 0.0)


func _apply_action(dt: float) -> void:
	var dur: float = action["dur"]
	var keys: Array = action["keys"]
	var loop: bool = action["loop"]
	var hold: bool = action["hold"]
	_prev_time = action_time
	action_time += dt * action_speed
	# eventos
	var evs: Array = action["events"]
	while _event_idx < evs.size() and action_time >= float(evs[_event_idx][0]):
		event.emit(str(evs[_event_idx][1]))
		_event_idx += 1
	var at := action_time
	if loop:
		if action_time >= dur:
			action_time = fmod(action_time, dur)
			_event_idx = 0
		at = action_time
	elif action_time >= dur:
		if hold:
			at = dur
		else:
			action = {}
			action_name = ""
			return
	# pesos de mistura
	var bi: float = action["blend_in"]
	if _fade < 1.0 and not _fading_out:
		_fade = minf(1.0, _fade + dt / maxf(bi, 0.001))
	if _fading_out:
		var bo: float = action["blend_out"]
		_fade -= dt / maxf(bo, 0.001)
		if _fade <= 0.0:
			action = {}
			action_name = ""
			_fading_out = false
			return
	# amostra as chaves
	var k0 := 0
	for i in range(keys.size() - 1):
		if at >= float(keys[i][0]):
			k0 = i
	var k1 := mini(k0 + 1, keys.size() - 1)
	var t0: float = keys[k0][0]
	var t1: float = keys[k1][0]
	var f := 0.0 if t1 <= t0 else clampf((at - t0) / (t1 - t0), 0.0, 1.0)
	f = f * f * (3.0 - 2.0 * f)
	var p0: Dictionary = keys[k0][1]
	var p1: Dictionary = keys[k1][1]
	var w := _fade * _fade * (3.0 - 2.0 * _fade)
	for b in N:
		if p0.has(b) or p1.has(b):
			var v0: Vector3 = p0.get(b, _base[b])
			var v1: Vector3 = p1.get(b, _base[b])
			_final[b] = _base[b].lerp(v0.lerp(v1, f), w)
	if p0.has("p") or p1.has("p"):
		var h0: Vector3 = p0.get("p", _hips_base)
		var h1: Vector3 = p1.get("p", _hips_base)
		_hips_final = _hips_base.lerp(h0.lerp(h1, f) * height_scale, w)


func _additive(dt: float) -> void:
	# olhar (cabeça + pescoço)
	var ly := clampf(look_yaw, -1.2, 1.2) / DEG
	var lp := clampf(look_pitch, -0.7, 0.6) / DEG
	_addf(HumanoidMeshBuilder.NECK, Vector3(lp * 0.35, ly * 0.4, 0.0))
	_addf(HumanoidMeshBuilder.HEAD, Vector3(lp * 0.65, ly * 0.6, 0.0))
	# reação a golpes
	if _flinch.length_squared() > 0.01:
		_addf(HumanoidMeshBuilder.SPINE, _flinch * 0.6)
		_addf(HumanoidMeshBuilder.CHEST, _flinch * 0.4)
		_addf(HumanoidMeshBuilder.HEAD, _flinch * 0.5)
		_flinch = _flinch.lerp(Vector3.ZERO, 1.0 - exp(-8.0 * dt))
	# espasmos (infectados)
	if twitchiness > 0.0:
		_twitch_timer -= dt
		if _twitch_timer <= 0.0:
			_twitch_timer = _rng.randf_range(0.6, 3.0) / (0.3 + twitchiness)
			_twitch = Vector3(_rng.randf_range(-14, 14), _rng.randf_range(-20, 20), _rng.randf_range(-22, 22)) * twitchiness
		_addf(HumanoidMeshBuilder.HEAD, _twitch)
		_addf(HumanoidMeshBuilder.NECK, _twitch * 0.3)
		_addf(HumanoidMeshBuilder.UARM_R, Vector3(0, 0, _twitch.z * 0.4))
		_twitch = _twitch.lerp(Vector3.ZERO, 1.0 - exp(-6.0 * dt))
	# inclinação em curvas
	_addf(HumanoidMeshBuilder.SPINE, Vector3(0, 0, clampf(-turn_rate * 4.0, -8.0, 8.0) * clampf(speed / 3.0, 0.0, 1.0)))


func _addb(i: int, v: Vector3) -> void:
	_base[i] = _base[i] + v


func _addf(i: int, v: Vector3) -> void:
	_final[i] = _final[i] + v


func _apply() -> void:
	for i in N:
		var e: Vector3 = _final[i] * DEG
		skeleton.set_bone_pose_rotation(i, Quaternion.from_euler(e))
	skeleton.set_bone_pose_position(0, _rest_hips + _hips_final)
