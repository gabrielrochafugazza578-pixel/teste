class_name ProceduralAnimator
extends RefCounted
## Animação procedural de locomoção + ações por poses-chave (AnimLibrary).
##
## Locomoção (andar/correr/agachar/pular): ciclo de passada com IK de pernas.
## O pé de apoio fica no chão e anda para trás exatamente na velocidade do corpo
## (sem deslizar), o quadril sobe e desce com a passada e os joelhos dobram sozinhos.
## Estilos: human, shamble (errante), feral (febril), brute (colosso),
## crawl (rastejante, FK), injured (ferido), panic (fuga).
##
## Ações (AnimLibrary) são poses-chave em FK por cima da locomoção; quando uma ação
## pilota as pernas o IK cede o lugar a ela (peso = peso da ação), senão os pés
## continuam plantados. Um passe final ("assentar no chão") garante que nenhuma parte
## do corpo atravesse o piso em qualquer pose — e deita o corpo no chão nas quedas.
##
## O custo é controlado externamente (LOD): o dono decide com que frequência
## chamar update().

signal event(event_name: String)

const DEG := PI / 180.0
const N := 18
const PARENTS := [-1, 0, 1, 2, 3, 4, 2, 6, 7, 2, 9, 10, 0, 12, 13, 0, 15, 16]

## Parâmetros de marcha por estilo (mesclados sobre "human").
## step_*: passos/s (lento→rápido) · duty_*: fração do ciclo com o pé no chão
## lift_*: altura do pé na oscilação (m) · sag/bob: quadril baixo / sobe-desce (m)
## arm_amp: balanço dos braços (°) · arm_bias/arm_out/elbow_*: pose base dos braços
## lean/spine_bias/head_bias: inclinação do tronco e da cabeça (°)
## lift_r/duty_r_add: perna direita (mancar / arrastar)
const STYLES := {
	"human": {"step_lo": 1.75, "step_hi": 2.9, "duty_lo": 0.62, "duty_hi": 0.38, "lift_lo": 0.075, "lift_hi": 0.27,
		"width": 0.0, "sag_lo": 0.012, "sag_hi": 0.06, "bob_lo": 0.026, "bob_hi": 0.05, "sway": 0.016, "yaw_amp": 5.0,
		"arm_amp_lo": 20.0, "arm_amp_hi": 36.0, "arm_bias": 0.0, "arm_out": 6.0, "elbow_idle": 10.0, "elbow_lo": 8.0,
		"elbow_hi": 78.0, "lean_lo": 1.0, "lean_hi": 9.0, "spine_bias": 0.0, "head_bias": 0.0, "roll_bias": 0.0,
		"lift_r": 1.0, "duty_r_add": 0.0, "toe_out": 6.0},
	"shamble": {"step_lo": 1.25, "step_hi": 1.4, "duty_lo": 0.72, "duty_hi": 0.7, "lift_lo": 0.04, "lift_hi": 0.06,
		"sway": 0.03, "yaw_amp": 9.0, "arm_amp_lo": 5.0, "arm_amp_hi": 6.0, "arm_bias": 36.0, "arm_out": 4.0,
		"elbow_idle": 30.0, "elbow_lo": 0.0, "elbow_hi": 0.0, "lean_lo": 6.0, "spine_bias": 16.0, "head_bias": 24.0,
		"roll_bias": 3.0, "lift_r": 0.3, "duty_r_add": 0.05, "toe_out": 12.0, "sag_lo": 0.025, "sag_hi": 0.03},
	"feral": {"step_lo": 2.3, "step_hi": 3.5, "duty_lo": 0.5, "duty_hi": 0.32, "lift_lo": 0.12, "lift_hi": 0.3,
		"sag_lo": 0.05, "sag_hi": 0.085, "bob_lo": 0.04, "bob_hi": 0.06, "yaw_amp": 8.0, "arm_amp_lo": 30.0,
		"arm_amp_hi": 44.0, "arm_bias": 42.0, "arm_out": 20.0, "elbow_idle": 30.0, "elbow_lo": 10.0, "elbow_hi": 20.0,
		"lean_lo": 8.0, "lean_hi": 16.0, "spine_bias": 20.0, "head_bias": 26.0},
	"brute": {"step_lo": 1.3, "step_hi": 2.0, "duty_lo": 0.72, "duty_hi": 0.5, "lift_lo": 0.06, "lift_hi": 0.16,
		"width": 0.09, "sag_lo": 0.05, "sag_hi": 0.07, "bob_lo": 0.05, "bob_hi": 0.07, "sway": 0.04, "yaw_amp": 8.0,
		"arm_amp_lo": 12.0, "arm_amp_hi": 16.0, "arm_bias": 22.0, "arm_out": 18.0, "elbow_idle": 22.0, "elbow_lo": 0.0,
		"elbow_hi": 10.0, "lean_lo": 4.0, "lean_hi": 8.0, "spine_bias": 14.0, "head_bias": 14.0, "roll_bias": 3.0,
		"toe_out": 10.0},
	"injured": {"step_lo": 1.45, "step_hi": 2.0, "duty_lo": 0.66, "duty_hi": 0.5, "lift_lo": 0.06, "lift_hi": 0.16,
		"sag_lo": 0.02, "sag_hi": 0.04, "sway": 0.03, "yaw_amp": 3.5, "arm_amp_lo": 12.0, "arm_amp_hi": 22.0,
		"elbow_idle": 20.0, "spine_bias": 5.0, "roll_bias": 4.0, "lift_r": 0.55, "duty_r_add": -0.2, "toe_out": 8.0},
	"panic": {"step_lo": 2.3, "step_hi": 3.2, "duty_lo": 0.5, "duty_hi": 0.36, "lift_lo": 0.12, "lift_hi": 0.28,
		"sag_lo": 0.04, "sag_hi": 0.07, "arm_amp_lo": 30.0, "arm_amp_hi": 44.0, "arm_bias": 14.0, "arm_out": 14.0,
		"elbow_idle": 40.0, "elbow_lo": 30.0, "elbow_hi": 60.0, "lean_lo": 6.0, "lean_hi": 12.0, "head_bias": -4.0},
}

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
var _rest_o := PackedVector3Array()
var _flinch := Vector3.ZERO
var _twitch := Vector3.ZERO
var _twitch_timer: float = 1.0
var _rng := RandomNumberGenerator.new()

# estilo (interpolado ao trocar, sem "pulo" entre errante e corrida)
var _style_name: String = ""
var _sp: Dictionary = {}
# pernas (IK)
var _leg_ov := [0.0, 0.0]            # quanto uma ação pilota cada perna (0..1)
var _ik_air: float = 1.0             # 1 = pés no chão (IK), 0 = no ar (pose de salto)
var _tgt := [Vector3.ZERO, Vector3.ZERO]   # tornozelo alvo (espaço do corpo, sem o quadril)
var _tgt_pitch := [0.0, 0.0]
var _tgt_yaw := [0.0, 0.0]
var _ankle_rest := [Vector3.ZERO, Vector3.ZERO]
var _len1: float = 0.425
var _len2: float = 0.42
var _leg_ik_on: bool = true
var _pts: Array = []                  # pontos de contato com o chão: [osso, offset, raio]
var _fk_legs := PackedVector3Array()   # pose FK das pernas antes de misturar com o IK
var _fk_arms := PackedVector3Array()   # pose FK dos braços antes de misturar com o IK das mãos
var _hand_tgt := [Vector3.ZERO, Vector3.ZERO]   # alvo da mão (espaço do peito), 0 = esquerda
var _arm_ov := [0.0, 0.0]            # quanto uma ação pilota cada mão por IK (0..1)


func _init(skel: Skeleton3D, appearance: Dictionary = {}) -> void:
	skeleton = skel
	_base.resize(N)
	_final.resize(N)
	_rest_o.resize(N)
	height_scale = float(appearance.get("height", 1.75)) / 1.78
	_rng.seed = int(appearance.get("seed", 0)) + 911
	phase = _rng.randf() * TAU
	if skeleton != null and skeleton.get_bone_count() >= N:
		for i in N:
			_rest_o[i] = skeleton.get_bone_rest(i).origin
		_rest_hips = _rest_o[0]
		var th_l := HumanoidMeshBuilder.THIGH_L
		var th_r := HumanoidMeshBuilder.THIGH_R
		_len1 = _rest_o[HumanoidMeshBuilder.SHIN_L].length()
		_len2 = _rest_o[HumanoidMeshBuilder.FOOT_L].length()
		_ankle_rest[0] = _rest_o[0] + _rest_o[th_l] + _rest_o[HumanoidMeshBuilder.SHIN_L] + _rest_o[HumanoidMeshBuilder.FOOT_L]
		_ankle_rest[1] = _rest_o[0] + _rest_o[th_r] + _rest_o[HumanoidMeshBuilder.SHIN_R] + _rest_o[HumanoidMeshBuilder.FOOT_R]
	_build_contact_points()
	_style_name = style
	_sp = _style_params(style)


func _style_params(name_: String) -> Dictionary:
	var d: Dictionary = (STYLES["human"] as Dictionary).duplicate()
	if STYLES.has(name_):
		var o: Dictionary = STYLES[name_]
		for k in o.keys():
			d[k] = o[k]
	return d


## Pontos do corpo que nunca podem afundar no chão: [osso, offset (m, escala 1), raio].
func _build_contact_points() -> void:
	var s := height_scale
	var HB := HumanoidMeshBuilder
	_pts = [
		[HB.FOOT_L, Vector3(0, -0.085, 0.07) * s, 0.0], [HB.FOOT_L, Vector3(0, -0.085, -0.2) * s, 0.0],
		[HB.FOOT_R, Vector3(0, -0.085, 0.07) * s, 0.0], [HB.FOOT_R, Vector3(0, -0.085, -0.2) * s, 0.0],
		[HB.SHIN_L, Vector3.ZERO, 0.075 * s], [HB.SHIN_R, Vector3.ZERO, 0.075 * s],
		[HB.HIPS, Vector3(0, -0.02, 0) * s, 0.13 * s], [HB.SPINE, Vector3.ZERO, 0.12 * s],
		[HB.CHEST, Vector3.ZERO, 0.15 * s], [HB.CHEST, Vector3(0, 0, 0.2) * s, 0.12 * s],
		[HB.HEAD, Vector3(0, 0.06, 0) * s, 0.1 * s],
		[HB.HAND_L, Vector3.ZERO, 0.05 * s], [HB.HAND_R, Vector3.ZERO, 0.05 * s],
		[HB.FARM_L, Vector3.ZERO, 0.05 * s], [HB.FARM_R, Vector3.ZERO, 0.05 * s],
		[HB.UARM_L, Vector3.ZERO, 0.06 * s], [HB.UARM_R, Vector3.ZERO, 0.06 * s],
	]


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
	_leg_ov = [0.0, 0.0]
	_arm_ov = [0.0, 0.0]
	_locomotion(dt)
	for i in N:
		_final[i] = _base[i]
	_hips_final = _hips_base
	if not action.is_empty():
		_apply_action(dt)
	_additive(dt)
	_finish_arms()
	_finish_legs()
	_settle_on_ground()
	_apply()


# ---------------------------------------------------------------------------
# Locomoção
# ---------------------------------------------------------------------------
## Pé em função da fase do ciclo u (0 = pisa no chão). Retorna (z, altura).
## z > 0 é para trás do quadril (o corpo olha para -Z).
static func _gait_foot(u: float, stance_len: float, duty: float, lift: float, dir_sign: float, run: float) -> Vector2:
	var z: float
	var y := 0.0
	if u < duty:
		z = -stance_len * 0.5 + stance_len * (u / duty)
	else:
		var f := (u - duty) / (1.0 - duty)
		var v := 0.5 * stance_len * (1.0 - duty) / duty
		var f2 := f * f
		var f3 := f2 * f
		z = (2.0 * f3 - 3.0 * f2 + 1.0) * stance_len * 0.5 + (f3 - 2.0 * f2 + f) * v \
			+ (-2.0 * f3 + 3.0 * f2) * -stance_len * 0.5 + (f3 - f2) * v
		# joelho sobe cedo na corrida, pé desce devagar
		var fh := pow(f, lerpf(1.0, 0.75, run))
		y = lift * pow(maxf(sin(PI * fh), 0.0), 0.9)
	return Vector2(z * dir_sign, y)


## Inclinação do pé (°, + = ponta para cima): calcanhar toca, apoia, sai pela ponta.
static func _foot_pitch(u: float, duty: float, gw: float) -> float:
	var p: float
	if u < duty:
		var f := u / duty
		p = lerpf(11.0, 0.0, smoothstep(0.0, 0.3, f)) - 24.0 * smoothstep(0.62, 1.0, f)
	else:
		var f := (u - duty) / (1.0 - duty)
		p = lerpf(-24.0, -4.0, smoothstep(0.0, 0.55, f)) + 15.0 * smoothstep(0.55, 1.0, f)
	return p * gw


## Quanto o tornozelo sobe quando o pé gira sobre a ponta/calcanhar.
func _ankle_rise(pitch_deg: float, ay: float) -> float:
	var a := absf(pitch_deg) * DEG
	var l := (0.2 if pitch_deg < 0.0 else 0.07) * height_scale
	return l * sin(a) + ay * (cos(a) - 1.0)


func _locomotion(dt: float) -> void:
	# estilo atual (suaviza a troca)
	if style != _style_name:
		_style_name = style
	var target := _style_params(_style_name)
	var kk := 1.0 - exp(-dt * 8.0)
	for k in target.keys():
		_sp[k] = lerpf(float(_sp.get(k, target[k])), float(target[k]), kk)
	var P := _sp
	for i in N:
		_base[i] = Vector3.ZERO
	var HB := HumanoidMeshBuilder
	var hs := height_scale
	var spd := speed
	var c := crouch
	var run := smoothstep(2.4, 4.4, spd)
	var sprint := smoothstep(4.8, 6.2, spd)
	var gw := smoothstep(0.03, 0.4, spd)
	var dir_sign := 1.0 if forward_speed >= -0.15 else -1.0
	_leg_ik_on = style != "crawl"

	# cadência, apoio e comprimento de passada (pé de apoio na velocidade do corpo)
	var step_hz := lerpf(float(P["step_lo"]), float(P["step_hi"]), smoothstep(0.6, 4.6, spd)) * (1.0 - 0.15 * c) + sprint * 0.3
	var duty_l := clampf(lerpf(float(P["duty_lo"]), float(P["duty_hi"]), run) - 0.07 * sprint + 0.05 * c, 0.25, 0.86)
	var duty_r := clampf(duty_l + float(P["duty_r_add"]), 0.25, 0.86)
	var cyc := step_hz * 0.5
	var s_max := 0.95 * hs
	cyc = maxf(cyc, spd * maxf(duty_l, duty_r) / s_max)
	if spd > 0.03:
		phase = fmod(phase + TAU * cyc * dt, TAU * 100.0)
	var u_l := fposmod(phase / TAU, 1.0)
	var u_r := fposmod(u_l + 0.5, 1.0)
	var s_l := spd * duty_l / cyc
	var s_r := spd * duty_r / cyc
	var lift := lerpf(float(P["lift_lo"]), float(P["lift_hi"]), run) * hs * (1.0 - 0.5 * c) * gw
	var fl := _gait_foot(u_l, s_l, duty_l, lift, dir_sign, run)
	var fr := _gait_foot(u_r, s_r, duty_r, lift * float(P["lift_r"]), dir_sign, run)
	var wid := float(P["width"]) + 0.04 * c
	var p_l := _foot_pitch(u_l, duty_l, gw)
	var p_r := _foot_pitch(u_r, duty_r, gw)
	var al: Vector3 = _ankle_rest[0]
	var ar: Vector3 = _ankle_rest[1]
	_tgt[0] = Vector3(al.x - wid, al.y + fl.y + _ankle_rise(p_l, al.y) * gw, al.z + fl.x * gw)
	_tgt[1] = Vector3(ar.x + wid, ar.y + fr.y + _ankle_rise(p_r, ar.y) * gw, ar.z + fr.x * gw)
	_tgt_pitch[0] = p_l
	_tgt_pitch[1] = p_r
	var toe := float(P["toe_out"])
	_tgt_yaw[0] = toe
	_tgt_yaw[1] = -toe

	# quadril: baixo na passada dupla (andar) / no apoio (corrida), balança para o lado do apoio
	var v := fposmod(2.0 * u_l, 1.0)
	var v_low := lerpf(0.1, 0.35, run)
	var bobv := 0.5 * (1.0 + cos(TAU * (v - v_low)))
	var sag := (lerpf(float(P["sag_lo"]), float(P["sag_hi"]), run) + sprint * 0.03) * hs
	var bob := lerpf(float(P["bob_lo"]), float(P["bob_hi"]), run) * hs
	var hip_y := -(sag + bob * bobv) * gw - 0.34 * c * hs
	var hip_x := -float(P["sway"]) * hs * sin(TAU * u_l) * gw + sin(t * 0.55) * 0.005 * (1.0 - gw)
	var hip_z := 0.07 * c * hs
	var yaw_amp := float(P["yaw_amp"])
	var hips_yaw := -yaw_amp * cos(TAU * u_l) * gw
	var hips_roll := float(P["roll_bias"]) + 2.5 * sin(TAU * u_l) * gw
	var lean := (lerpf(float(P["lean_lo"]), float(P["lean_hi"]), run) + sprint * 6.0) * gw
	var spine_x := -(lean + float(P["spine_bias"]))
	var head_x := float(P["head_bias"]) + run * 4.0 + sprint * 5.0
	var chest_x := sin(t * 1.7) * 1.4 * breathing * (1.0 - gw * 0.8)

	# braços contra-balançam as pernas
	var amp := lerpf(float(P["arm_amp_lo"]), float(P["arm_amp_hi"]), run) * gw
	var bias := float(P["arm_bias"])
	var out := float(P["arm_out"]) + (1.0 - gw) * sin(t * 0.8)
	var ua_l := bias + amp * cos(TAU * u_r)
	var ua_r := bias + amp * cos(TAU * u_l)
	var elb := float(P["elbow_idle"]) + gw * lerpf(float(P["elbow_lo"]), float(P["elbow_hi"]), run)
	var fa_l := elb + maxf(0.0, ua_l - bias) * 0.3
	var fa_r := elb + maxf(0.0, ua_r - bias) * 0.3

	_base[HB.HIPS] = Vector3(0.0, hips_yaw, hips_roll)
	_base[HB.SPINE] = Vector3(spine_x * 0.5, -hips_yaw * 0.5, -hips_roll * 0.5)
	_base[HB.CHEST] = Vector3(spine_x * 0.5 + chest_x, -hips_yaw * 0.9, -hips_roll * 0.3)
	_base[HB.NECK] = Vector3(head_x * 0.4, hips_yaw * 0.2, 0.0)
	_base[HB.HEAD] = Vector3(head_x * 0.6, hips_yaw * 0.2, 0.0)
	_base[HB.UARM_L] = Vector3(ua_l, 0.0, -out)
	_base[HB.UARM_R] = Vector3(ua_r, 0.0, out)
	_base[HB.FARM_L] = Vector3(fa_l, 0.0, 0.0)
	_base[HB.FARM_R] = Vector3(fa_r, 0.0, 0.0)
	_hips_base = Vector3(hip_x, hip_y, hip_z)

	# agachado: tronco e braços acompanham
	if c > 0.001:
		_addb(HB.SPINE, Vector3(-16.0 * c, 0, 0))
		_addb(HB.CHEST, Vector3(-8.0 * c, 0, 0))
		_addb(HB.HEAD, Vector3(18.0 * c, 0, 0))
		_addb(HB.UARM_L, Vector3(18.0 * c, 0, 0))
		_addb(HB.UARM_R, Vector3(18.0 * c, 0, 0))
		_addb(HB.FARM_L, Vector3(30.0 * c, 0, 0))
		_addb(HB.FARM_R, Vector3(30.0 * c, 0, 0))

	# no ar: pose de salto no lugar do IK (volta suave ao pousar)
	_ik_air = move_toward(_ik_air, 1.0 if (grounded or not _leg_ik_on) else 0.0, dt * (9.0 if grounded else 22.0))
	if _ik_air < 1.0 and style != "crawl":
		var a := 1.0 - _ik_air
		_addb(HB.THIGH_L, Vector3(28.0 * a, 0, 0))
		_addb(HB.THIGH_R, Vector3(14.0 * a, 0, 0))
		_addb(HB.SHIN_L, Vector3(-50.0 * a, 0, 0))
		_addb(HB.SHIN_R, Vector3(-30.0 * a, 0, 0))
		_addb(HB.UARM_L, Vector3(0, 0, -22.0 * a))
		_addb(HB.UARM_R, Vector3(0, 0, 22.0 * a))

	# rastejante: corpo deitado, braços puxam (FK)
	if style == "crawl":
		var sp := sin(phase)
		var cp := cos(phase)
		var walk := clampf(spd / 1.1, 0.0, 1.0)
		_base[HB.HIPS] = Vector3(-82.0, sp * 4.0, sp * 6.0 * walk)
		_hips_base = Vector3(0.0, -0.8 * hs, 0.0)
		_base[HB.SPINE] = Vector3(4.0, -sp * 5.0, 0.0)
		_base[HB.CHEST] = Vector3(6.0, -sp * 6.0, 0.0)
		_base[HB.HEAD] = Vector3(55.0, 0.0, 0.0)
		_base[HB.NECK] = Vector3(15.0, 0.0, 0.0)
		_base[HB.UARM_L] = Vector3(150.0 + sp * 30.0 * walk, 0.0, -18.0)
		_base[HB.UARM_R] = Vector3(150.0 - sp * 30.0 * walk, 0.0, 18.0)
		_base[HB.FARM_L] = Vector3(25.0 + maxf(0.0, cp) * 45.0 * walk, 0.0, 0.0)
		_base[HB.FARM_R] = Vector3(25.0 + maxf(0.0, -cp) * 45.0 * walk, 0.0, 0.0)
		_base[HB.THIGH_L] = Vector3(4.0 + sp * 6.0 * walk, 0.0, -6.0)
		_base[HB.THIGH_R] = Vector3(-2.0, 0.0, 9.0)
		_base[HB.SHIN_L] = Vector3(-12.0, 0.0, 0.0)
		_base[HB.SHIN_R] = Vector3(-35.0, 0.0, 0.0)
		_base[HB.FOOT_L] = Vector3(-45.0, 0.0, 0.0)
		_base[HB.FOOT_R] = Vector3(-45.0, 0.0, 0.0)


# ---------------------------------------------------------------------------
# IK das pernas
# ---------------------------------------------------------------------------
## Cadeia de dois ossos (coxa+canela ou braço+antebraço): devolve as rotações
## mundiais do osso de cima e do de baixo e a posição alcançada da ponta.
## `pole`: direção para onde o joelho/cotovelo aponta.
func _two_bone(root: Vector3, o_mid: Vector3, o_end: Vector3, goal: Vector3, pole: Vector3) -> Array:
	var l1 := o_mid.length()
	var l2 := o_end.length()
	var to := goal - root
	var dist := clampf(to.length(), absf(l1 - l2) + 0.01, (l1 + l2) * 0.998)
	var dir := to.normalized()
	var perp := pole - dir * pole.dot(dir)
	perp = perp.normalized() if perp.length() > 0.001 else Vector3(0, 0, -1)
	var cos_a := clampf((l1 * l1 + dist * dist - l2 * l2) / (2.0 * l1 * dist), -1.0, 1.0)
	var ang := acos(cos_a)
	var mid := root + (dir * cos(ang) + perp * sin(ang)) * l1
	var tip := root + dir * dist
	return [Quaternion(o_mid.normalized(), (mid - root).normalized()), Quaternion(o_end.normalized(), (tip - mid).normalized()), tip]


## Resolve uma perna. Retorna [coxa, canela, pé] em graus (espaço local dos ossos).
func _solve_leg(leg: int, hips_pos: Vector3, hips_rot: Basis) -> Array:
	var HB := HumanoidMeshBuilder
	var i_th := HB.THIGH_L if leg == 0 else HB.THIGH_R
	var i_sh := HB.SHIN_L if leg == 0 else HB.SHIN_R
	var i_ft := HB.FOOT_L if leg == 0 else HB.FOOT_R
	var hip := hips_pos + hips_rot * _rest_o[i_th]
	# joelho aponta para a frente do corpo (-Z girado pelo quadril)
	var r := _two_bone(hip, _rest_o[i_sh], _rest_o[i_ft], _tgt[leg], hips_rot * Vector3(0, 0, -1))
	var q_th: Quaternion = r[0]
	var q_sh: Quaternion = r[1]
	var foot_world := Basis(Vector3.UP, float(_tgt_yaw[leg]) * DEG) * Basis(Vector3.RIGHT, float(_tgt_pitch[leg]) * DEG)
	var q_hips := hips_rot.get_rotation_quaternion()
	var l_th := q_hips.inverse() * q_th
	var l_sh := q_th.inverse() * q_sh
	var l_ft := q_sh.inverse() * foot_world.get_rotation_quaternion()
	return [Basis(l_th).get_euler() / DEG, Basis(l_sh).get_euler() / DEG, Basis(l_ft).get_euler() / DEG]


## Transformação do peito no espaço do corpo, com a pose final atual.
func _chest_xf() -> Transform3D:
	var HB := HumanoidMeshBuilder
	var hips := Transform3D(Basis(Quaternion.from_euler(_final[HB.HIPS] * DEG)), _rest_hips + _hips_final)
	var spine := hips * Transform3D(Basis(Quaternion.from_euler(_final[HB.SPINE] * DEG)), _rest_o[HB.SPINE])
	return spine * Transform3D(Basis(Quaternion.from_euler(_final[HB.CHEST] * DEG)), _rest_o[HB.CHEST])


## Braços por IK: a ação diz onde a mão vai (espaço do peito); o cotovelo se resolve.
func _finish_arms() -> void:
	if float(_arm_ov[0]) <= 0.001 and float(_arm_ov[1]) <= 0.001:
		return
	var HB := HumanoidMeshBuilder
	var cx := _chest_xf()
	for side in 2:
		var w: float = _arm_ov[side]
		if w <= 0.001:
			continue
		var i_ua := HB.UARM_L if side == 0 else HB.UARM_R
		var i_fa := HB.FARM_L if side == 0 else HB.FARM_R
		var i_hd := HB.HAND_L if side == 0 else HB.HAND_R
		var shoulder := cx * _rest_o[i_ua]
		var goal := cx * (_hand_tgt[side] as Vector3)
		var out := -1.0 if side == 0 else 1.0
		var pole := cx.basis * Vector3(out * 0.5, -0.7, 0.55)
		var r := _two_bone(shoulder, _rest_o[i_fa], _rest_o[i_hd], goal, pole)
		var q_ua: Quaternion = r[0]
		var q_fa: Quaternion = r[1]
		var l_ua := cx.basis.get_rotation_quaternion().inverse() * q_ua
		var l_fa := q_ua.inverse() * q_fa
		_final[i_ua] = _final[i_ua].lerp(Basis(l_ua).get_euler() / DEG, w)
		_final[i_fa] = _final[i_fa].lerp(Basis(l_fa).get_euler() / DEG, w)


func _hips_pose() -> Array:
	var rot := Basis(Quaternion.from_euler(_final[HumanoidMeshBuilder.HIPS] * DEG))
	return [_rest_hips + _hips_final, rot]


func _finish_legs() -> void:
	_fk_legs = PackedVector3Array()
	for b in range(HumanoidMeshBuilder.THIGH_L, N):
		_fk_legs.append(_final[b])
	_blend_legs()


## Pernas = FK (ação/pose de salto) misturado com o IK pelo peso de cada perna.
func _blend_legs() -> void:
	if not _leg_ik_on or _fk_legs.size() != 6:
		return
	var hp := _hips_pose()
	for leg in 2:
		var w := (1.0 - float(_leg_ov[leg])) * _ik_air
		var o := leg * 3
		var b0 := HumanoidMeshBuilder.THIGH_L + o
		if w <= 0.001:
			for k in 3:
				_final[b0 + k] = _fk_legs[o + k]
			continue
		var e := _solve_leg(leg, hp[0], hp[1])
		for k in 3:
			_final[b0 + k] = _fk_legs[o + k].lerp(e[k], w)


# ---------------------------------------------------------------------------
# Assentar no chão: nada atravessa o piso; quedas deitam o corpo nele
# ---------------------------------------------------------------------------
func _lowest_point() -> float:
	var xf: Array[Transform3D] = []
	xf.resize(N)
	for i in N:
		var pos: Vector3 = _rest_o[i]
		if i == 0:
			pos = _rest_hips + _hips_final
		var local := Transform3D(Basis(Quaternion.from_euler(_final[i] * DEG)), pos)
		var par: int = PARENTS[i]
		xf[i] = local if par < 0 else xf[par] * local
	var low := 9.0
	for pt in _pts:
		var y: float = (xf[pt[0]] * (pt[1] as Vector3)).y - float(pt[2])
		low = minf(low, y)
	return low


func _settle_on_ground() -> void:
	var low := _lowest_point()
	if low < -0.001:
		_hips_final.y -= low
		# o quadril subiu: refaz o IK para os pés não ficarem pendurados
		_blend_legs()
	else:
		# deitado (quadril girado): desce até encostar, sem flutuar
		var lying := smoothstep(28.0, 62.0, absf(_final[HumanoidMeshBuilder.HIPS].x))
		if lying > 0.0 and low > 0.002:
			_hips_final.y -= low * lying


# ---------------------------------------------------------------------------
# Ações (poses-chave)
# ---------------------------------------------------------------------------
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
	# amostra as chaves (Hermite com tangentes dos vizinhos: movimento contínuo entre as poses)
	var k0 := 0
	for i in range(keys.size() - 1):
		if at >= float(keys[i][0]):
			k0 = i
	var k1 := mini(k0 + 1, keys.size() - 1)
	var km := maxi(k0 - 1, 0)
	var kn := mini(k1 + 1, keys.size() - 1)
	var t0: float = keys[k0][0]
	var t1: float = keys[k1][0]
	var seg := t1 - t0
	var seg_prev: float = t0 - float(keys[km][0])
	var seg_next: float = float(keys[kn][0]) - t1
	var f := 0.0 if seg <= 0.0 else clampf((at - t0) / seg, 0.0, 1.0)
	var p0: Dictionary = keys[k0][1]
	var p1: Dictionary = keys[k1][1]
	var pm: Dictionary = keys[km][1]
	var pn: Dictionary = keys[kn][1]
	var w := _fade * _fade * (3.0 - 2.0 * _fade)
	for b in N:
		var in0 := p0.has(b)
		var in1 := p1.has(b)
		if not (in0 or in1):
			continue
		if b >= HumanoidMeshBuilder.THIGH_L:
			# perna: a ação entra no lugar do IK (mistura feita em _blend_legs)
			var v0: Vector3 = p0[b] if in0 else p1[b]
			var v1: Vector3 = p1[b] if in1 else p0[b]
			var vm: Vector3 = pm.get(b, v0)
			var vn: Vector3 = pn.get(b, v1)
			_final[b] = _spline(vm, v0, v1, vn, f, seg, seg_prev, seg_next)
			var leg := 0 if b <= HumanoidMeshBuilder.FOOT_L else 1
			var pres := 1.0 if (in0 and in1) else ((1.0 - f) if in0 else f)
			_leg_ov[leg] = maxf(float(_leg_ov[leg]), w * pres)
		else:
			var v0: Vector3 = p0.get(b, _base[b])
			var v1: Vector3 = p1.get(b, _base[b])
			var vm: Vector3 = pm.get(b, v0)
			var vn: Vector3 = pn.get(b, v1)
			_final[b] = _base[b].lerp(_spline(vm, v0, v1, vn, f, seg, seg_prev, seg_next), w)
	for side in 2:
		var hk := "hl" if side == 0 else "hr"
		var hin0 := p0.has(hk)
		var hin1 := p1.has(hk)
		if not (hin0 or hin1):
			continue
		var g0: Vector3 = p0[hk] if hin0 else p1[hk]
		var g1: Vector3 = p1[hk] if hin1 else p0[hk]
		var gm: Vector3 = pm.get(hk, g0)
		var gn: Vector3 = pn.get(hk, g1)
		_hand_tgt[side] = _spline(gm, g0, g1, gn, f, seg, seg_prev, seg_next) * height_scale
		var hpres := 1.0 if (hin0 and hin1) else ((1.0 - f) if hin0 else f)
		_arm_ov[side] = maxf(float(_arm_ov[side]), w * hpres)
	if p0.has("p") or p1.has("p"):
		var h0: Vector3 = p0.get("p", _hips_base)
		var h1: Vector3 = p1.get("p", _hips_base)
		var hm: Vector3 = pm.get("p", h0)
		var hn: Vector3 = pn.get("p", h1)
		_hips_final = _hips_base.lerp(_spline(hm, h0, h1, hn, f, seg, seg_prev, seg_next) * height_scale, w)


## Hermite entre v0 e v1 (f em 0..1 no trecho de duração seg). As tangentes vêm dos
## vizinhos, corrigidas pela duração de cada trecho e limitadas para nunca passar
## do valor de destino nem voltar (sem "vai e volta" entre poses parecidas).
static func _spline(vm: Vector3, v0: Vector3, v1: Vector3, vn: Vector3, f: float, seg: float, seg_prev: float, seg_next: float) -> Vector3:
	if seg <= 0.0001:
		return v1
	var d := v1 - v0
	var m0 := d if seg_prev <= 0.0001 else (v1 - vm) * (seg / (seg + seg_prev))
	var m1 := d if seg_next <= 0.0001 else (vn - v0) * (seg / (seg + seg_next))
	m0 = _limit_tangent(m0, d)
	m1 = _limit_tangent(m1, d)
	var f2 := f * f
	var f3 := f2 * f
	return (2.0 * f3 - 3.0 * f2 + 1.0) * v0 + (f3 - 2.0 * f2 + f) * m0 + (-2.0 * f3 + 3.0 * f2) * v1 + (f3 - f2) * m1


static func _limit_tangent(m: Vector3, d: Vector3) -> Vector3:
	var r := m
	for i in 3:
		if m[i] * d[i] <= 0.0:
			r[i] = 0.0
		else:
			r[i] = clampf(m[i], -3.0 * absf(d[i]), 3.0 * absf(d[i])) if d[i] > 0.0 else clampf(m[i], -3.0 * absf(d[i]), 3.0 * absf(d[i]))
	return r


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
