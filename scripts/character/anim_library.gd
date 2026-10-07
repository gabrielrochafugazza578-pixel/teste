class_name AnimLibrary
extends RefCounted
## Biblioteca de ações reutilizáveis (poses-chave em graus).
##
## Cada ação: {dur, keys: [[t, pose]], loop?, hold?, events: [[t, nome]], blend_in, blend_out}
## Pose: {osso: Vector3(pitch, yaw, roll)} + "p": deslocamento do quadril (m).
## Ossos AUSENTES numa chave usam a pose de locomoção atual — por isso as
## ações começam/terminam em {} e se misturam sem emendas com andar/correr.
##
## Convenções (personagem olhando para -Z):
##   braço/perna +X = para frente; antebraço +X = flexiona cotovelo;
##   canela -X = flexiona joelho; coluna -X = inclina para frente;
##   cabeça +X = olha para cima; mandíbula -X = abre a boca;
##   +Y = gira para a esquerda; braço direito +Z = abre lateralmente.

const SHORT := {
	"hips": 0, "spine": 1, "chest": 2, "neck": 3, "head": 4, "jaw": 5,
	"ua_l": 6, "fa_l": 7, "hand_l": 8, "ua_r": 9, "fa_r": 10, "hand_r": 11,
	"th_l": 12, "sh_l": 13, "ft_l": 14, "th_r": 15, "sh_r": 16, "ft_r": 17,
}

static var _cache: Dictionary = {}


static func get_action(action_name: String) -> Dictionary:
	if _cache.is_empty():
		_build()
	return _cache.get(action_name, {})


static func has_action(action_name: String) -> bool:
	if _cache.is_empty():
		_build()
	return _cache.has(action_name)


static func names() -> Array:
	if _cache.is_empty():
		_build()
	return _cache.keys()


static func _v(x: float, y: float = 0.0, z: float = 0.0) -> Vector3:
	return Vector3(x, y, z)


## Converte pose com nomes curtos para índices de osso.
static func _p(d: Dictionary) -> Dictionary:
	var out := {}
	for k in d.keys():
		if k == "p" or k == "hr" or k == "hl":
			out[k] = d[k]
		elif SHORT.has(k):
			out[SHORT[k]] = d[k]
	return out


static func _add(action_name: String, dur: float, keys: Array, opts: Dictionary = {}) -> void:
	var conv: Array = []
	for k in keys:
		conv.append([float(k[0]), _p(k[1])])
	var def := {"dur": dur, "keys": conv, "loop": opts.get("loop", false), "hold": opts.get("hold", false),
		"events": opts.get("events", []), "blend_in": opts.get("blend_in", 0.1), "blend_out": opts.get("blend_out", 0.2)}
	_cache[action_name] = def


static func _merge(a: Dictionary, b: Dictionary) -> Dictionary:
	var r := a.duplicate()
	for k in b.keys():
		r[k] = b[k]
	return r


static func _build() -> void:
	var guard := {"ua_r": _v(75, 0, -25), "fa_r": _v(105), "ua_l": _v(65, 0, 25), "fa_l": _v(110),
		"chest": _v(0, 10, 0), "spine": _v(-8), "head": _v(-5)}
	var sit := {"p": Vector3(0, -0.46, 0.02), "th_l": _v(90, 0, 3), "th_r": _v(90, 0, -3), "sh_l": _v(-90), "sh_r": _v(-90),
		"ft_l": _v(0), "ft_r": _v(0), "spine": _v(-5), "ua_l": _v(15, 0, -8), "ua_r": _v(15, 0, 8), "fa_l": _v(35), "fa_r": _v(35)}
	var crouch := {"p": Vector3(0, -0.45, 0), "th_l": _v(95), "th_r": _v(80), "sh_l": _v(-120), "sh_r": _v(-110),
		"ft_l": _v(25), "ft_r": _v(30), "spine": _v(-30), "chest": _v(-8), "head": _v(15)}
	var hunched := {"spine": _v(-28), "chest": _v(-10, 0, 8), "head": _v(28, 0, -8), "ua_r": _v(25, 0, 8), "fa_r": _v(25),
		"ua_l": _v(30, 0, -4), "fa_l": _v(40), "th_l": _v(10), "sh_l": _v(-15), "th_r": _v(5), "sh_r": _v(-10), "p": Vector3(0, -0.05, 0)}
	var lying := {"hips": _v(88), "p": Vector3(0, -0.84, 0), "th_l": _v(8, 0, -4), "th_r": _v(12, 0, 5), "sh_l": _v(-8), "sh_r": _v(-15),
		"ua_l": _v(15, 0, -45), "ua_r": _v(25, 0, 55), "fa_l": _v(30), "fa_r": _v(15), "head": _v(-8, 0, 15), "spine": _v(2)}
	var prone := {"hips": _v(-88), "p": Vector3(0, -0.86, 0), "th_l": _v(5), "th_r": _v(-3), "sh_l": _v(-10), "sh_r": _v(-25),
		"ua_l": _v(150, 0, -30), "ua_r": _v(40, 0, 60), "fa_l": _v(40), "fa_r": _v(60), "head": _v(35, 30, 0), "ft_l": _v(-40), "ft_r": _v(-40)}

	# --- Combate do jogador / humanos ---------------------------------------------------
	# "hr"/"hl": onde vai a mão (espaço do peito: +X direita, +Y cima, +Z trás); o cotovelo se resolve por IK.
	_add("attack_light", 0.62, [
		[0.0, {}],
		[0.17, {"hr": _v(0.42, 0.10, 0.22), "hl": _v(-0.12, -0.10, -0.30), "chest": _v(0, -32, 0), "spine": _v(-6, -10, 0), "p": Vector3(0, -0.015, 0.02)}],
		[0.29, {"hr": _v(0.0, -0.02, -0.46), "hl": _v(-0.16, -0.14, -0.26), "chest": _v(0, 34, 0), "spine": _v(-10, 12, 0), "p": Vector3(0, -0.03, -0.05)}],
		[0.43, {"hr": _v(-0.20, -0.08, -0.28), "hl": _v(-0.18, -0.16, -0.22), "chest": _v(0, 44, 0), "spine": _v(-8, 14, 0), "p": Vector3(0, -0.02, -0.04)}],
		[0.62, {}]], {"events": [[0.24, "hit_start"], [0.4, "hit_end"]], "blend_in": 0.06})
	_add("attack_light_2", 0.6, [
		[0.0, {}],
		[0.16, {"hr": _v(-0.22, 0.02, -0.28), "hl": _v(-0.14, -0.10, -0.26), "chest": _v(0, 32, 0), "spine": _v(-6, 10, 0), "p": Vector3(0, -0.015, 0.02)}],
		[0.28, {"hr": _v(0.36, -0.02, -0.40), "hl": _v(-0.14, -0.14, -0.24), "chest": _v(0, -26, 0), "spine": _v(-8, -10, 0), "p": Vector3(0, -0.03, -0.04)}],
		[0.44, {"hr": _v(0.44, -0.08, -0.10), "hl": _v(-0.16, -0.16, -0.20), "chest": _v(0, -40, 0), "spine": _v(-6, -12, 0), "p": Vector3(0, -0.02, -0.03)}],
		[0.6, {}]], {"events": [[0.22, "hit_start"], [0.38, "hit_end"]], "blend_in": 0.05})
	_add("attack_heavy", 1.05, [
		[0.0, {}],
		[0.42, {"hr": _v(0.10, 0.58, 0.12), "hl": _v(-0.06, 0.55, 0.10), "spine": _v(10), "chest": _v(8), "head": _v(-4), "p": Vector3(0, 0.0, 0.05)}],
		[0.58, {"hr": _v(0.10, -0.16, -0.42), "hl": _v(-0.06, -0.18, -0.40), "spine": _v(-30), "chest": _v(-14), "head": _v(12), "p": Vector3(0, -0.15, -0.12)}],
		[0.72, {"hr": _v(0.10, -0.26, -0.34), "hl": _v(-0.06, -0.28, -0.32), "spine": _v(-32), "chest": _v(-10), "p": Vector3(0, -0.14, -0.10)}],
		[1.05, {}]], {"events": [[0.52, "hit_start"], [0.67, "hit_end"]]})
	_add("block", 0.18, [[0.0, {}], [0.18, {"hr": _v(0.15, 0.12, -0.34), "hl": _v(-0.10, 0.06, -0.32), "chest": _v(0, 10, 0), "spine": _v(-8), "head": _v(-5)}]], {"hold": true, "blend_out": 0.15})
	# mira: pistola com os dois braços estendidos; arma longa com a coronha no ombro direito
	_add("aim_pistol", 0.2, [[0.0, {}], [0.2, {"hr": _v(0.1, 0.2, -0.54), "hl": _v(0.03, 0.16, -0.47), "chest": _v(0, 6, 0), "spine": _v(-4), "head": _v(-3, -4, 0)}]],
		{"hold": true, "blend_out": 0.15})
	_add("aim_rifle", 0.22, [[0.0, {}], [0.22, {"hr": _v(0.15, 0.1, -0.2), "hl": _v(0.08, 0.08, -0.5), "spine": _v(-4), "head": _v(-8, 0, 10)}]],
		{"hold": true, "blend_out": 0.15})
	_add("parry", 0.4, [[0.0, {}], [0.1, {"hr": _v(0.06, 0.10, -0.50), "hl": _v(-0.10, 0.06, -0.32), "chest": _v(0, 14, 0), "spine": _v(-12)}], [0.4, {}]])
	_add("dodge", 0.55, [
		[0.0, {}],
		[0.12, {"p": Vector3(0, -0.28, -0.05), "th_l": _v(60), "sh_l": _v(-95), "th_r": _v(-8), "sh_r": _v(-40), "spine": _v(-24), "chest": _v(-8), "hr": _v(0.16, 0.06, -0.36), "hl": _v(-0.16, 0.06, -0.34)}],
		[0.36, {"p": Vector3(0, -0.22, -0.05), "th_l": _v(45), "sh_l": _v(-75), "th_r": _v(6), "sh_r": _v(-50), "spine": _v(-18), "hr": _v(0.18, 0.02, -0.34), "hl": _v(-0.18, 0.02, -0.32)}],
		[0.55, {}]], {"blend_in": 0.04})
	_add("dodge_side", 0.55, [
		[0.0, {}],
		[0.12, {"p": Vector3(0, -0.22, 0), "th_l": _v(40, 0, -20), "sh_l": _v(-80), "th_r": _v(20, 0, 25), "sh_r": _v(-40), "spine": _v(-14, 0, 18), "chest": _v(0, 0, 10), "hr": _v(0.30, 0.0, -0.30), "hl": _v(-0.30, 0.0, -0.30)}],
		[0.36, {"p": Vector3(0, -0.18, 0), "th_l": _v(30, 0, -10), "sh_l": _v(-60), "th_r": _v(15, 0, 10), "sh_r": _v(-40), "spine": _v(-12, 0, 8)}],
		[0.55, {}]], {"blend_in": 0.04})
	_add("shove", 0.6, [
		[0.0, {}],
		[0.12, {"hr": _v(0.16, 0.0, -0.20), "hl": _v(-0.16, 0.0, -0.20), "spine": _v(5), "p": Vector3(0, -0.02, 0.03)}],
		[0.25, {"hr": _v(0.16, 0.03, -0.50), "hl": _v(-0.16, 0.03, -0.50), "spine": _v(-18), "chest": _v(-8), "p": Vector3(0, -0.05, -0.10)}],
		[0.6, {}]], {"events": [[0.18, "hit_start"], [0.32, "hit_end"]]})
	_add("stomp", 0.8, [
		[0.0, {}],
		[0.3, {"th_r": _v(70), "sh_r": _v(-80), "hl": _v(-0.30, -0.10, -0.20), "hr": _v(0.30, -0.10, -0.20), "spine": _v(-10)}],
		[0.45, {"th_r": _v(20), "sh_r": _v(-5), "ft_r": _v(-10), "spine": _v(-25), "head": _v(-25)}],
		[0.8, {}]], {"events": [[0.4, "hit_start"], [0.5, "hit_end"]]})
	_add("stealth_kill", 1.6, [
		[0.0, {}],
		[0.4, {"hr": _v(0.10, 0.08, -0.46), "hl": _v(-0.10, 0.02, -0.42), "spine": _v(-15), "p": Vector3(0, -0.1, 0)}],
		[0.8, {"hr": _v(0.06, -0.06, -0.38), "hl": _v(-0.10, 0.02, -0.40), "spine": _v(-25), "p": Vector3(0, -0.15, -0.05)}],
		[1.25, {"hr": _v(0.12, -0.16, -0.30), "hl": _v(-0.12, -0.12, -0.30), "spine": _v(-15)}],
		[1.6, {}]], {"events": [[0.78, "stealth_hit"]]})
	_add("throw", 0.8, [
		[0.0, {}],
		[0.3, {"hr": _v(0.30, 0.36, 0.22), "hl": _v(-0.30, 0.02, -0.26), "chest": _v(0, -25, 0)}],
		[0.45, {"hr": _v(0.10, 0.26, -0.46), "hl": _v(-0.30, -0.10, -0.20), "chest": _v(0, 20, 0), "spine": _v(-10)}],
		[0.8, {}]], {"events": [[0.42, "release"]]})

	# --- Reações ---------------------------------------------------------------------------
	_add("hit_front", 0.45, [[0.0, {}], [0.08, {"spine": _v(18), "chest": _v(12), "head": _v(20), "ua_r": _v(30, 0, 30), "ua_l": _v(30, 0, -30)}], [0.45, {}]], {"blend_in": 0.02})
	_add("hit_back", 0.45, [[0.0, {}], [0.08, {"spine": _v(-20), "chest": _v(-10), "head": _v(-15)}], [0.45, {}]], {"blend_in": 0.02})
	_add("stagger", 1.0, [
		[0.0, {}],
		[0.15, {"spine": _v(22, 0, 8), "head": _v(25, 0, -10), "p": Vector3(0, -0.08, 0), "th_r": _v(-20), "sh_r": _v(-30), "ua_r": _v(20, 0, 40), "ua_l": _v(25, 0, -35)}],
		[0.5, {"spine": _v(10, 0, -6), "head": _v(10), "th_l": _v(25), "sh_l": _v(-35)}],
		[1.0, {}]], {"blend_in": 0.03})
	_add("knockdown", 2.3, [
		[0.0, {}],
		[0.3, {"hips": _v(55), "p": Vector3(0, -0.4, 0.05), "spine": _v(10), "th_l": _v(70), "th_r": _v(60), "sh_l": _v(-60), "sh_r": _v(-50), "ua_l": _v(40, 0, -40), "ua_r": _v(40, 0, 40)}],
		[0.6, lying],
		[1.5, lying],
		[1.95, {"hips": _v(20), "p": Vector3(0, -0.5, 0.05), "th_l": _v(100), "th_r": _v(80), "sh_l": _v(-130), "sh_r": _v(-110), "spine": _v(-35), "ua_l": _v(30, 0, -20), "ua_r": _v(40, 0, 30), "fa_r": _v(40)}],
		[2.3, {}]], {"blend_in": 0.03})
	_add("death", 1.1, [
		[0.0, {}],
		[0.3, {"hips": _v(35), "p": Vector3(0, -0.35, 0), "th_l": _v(50), "th_r": _v(40), "sh_l": _v(-80), "sh_r": _v(-70), "spine": _v(10), "head": _v(20)}],
		[0.75, lying],
		[1.1, _merge(lying, {"head": _v(-12, 0, 35)})]], {"hold": true, "blend_in": 0.03})
	_add("death_front", 1.2, [
		[0.0, {}],
		[0.16, {"spine": _v(-18), "head": _v(10), "p": Vector3(0, -0.06, 0), "ua_l": _v(30, 0, -12), "ua_r": _v(30, 0, 12)}],
		[0.38, {"hips": _v(-22), "p": Vector3(0, -0.34, -0.08), "th_l": _v(72), "sh_l": _v(-112), "th_r": _v(38), "sh_r": _v(-64), "spine": _v(-30), "head": _v(15), "hr": _v(0.20, -0.02, -0.46), "hl": _v(-0.20, -0.02, -0.46)}],
		[0.66, {"hips": _v(-72), "p": Vector3(0, -0.66, -0.26), "th_l": _v(10), "sh_l": _v(-22), "th_r": _v(6), "sh_r": _v(-10), "spine": _v(-6), "head": _v(28), "ua_l": _v(120, 0, -16), "ua_r": _v(105, 0, 22), "fa_l": _v(25), "fa_r": _v(20)}],
		[0.95, prone],
		[1.2, prone]], {"hold": true, "blend_in": 0.03})

	# --- Interação / uso de itens -----------------------------------------------------
	_add("interact", 0.8, [[0.0, {}], [0.3, {"hr": _v(0.20, -0.10, -0.44), "chest": _v(0, 10, 0), "spine": _v(-10)}],
		[0.55, {"hr": _v(0.20, -0.10, -0.46), "spine": _v(-10)}], [0.8, {}]], {"events": [[0.35, "interact"]]})
	_add("pickup", 1.0, [[0.0, {}], [0.35, _merge(crouch, {"ua_r": _v(55), "fa_r": _v(10), "head": _v(-15), "spine": _v(-40)})],
		[0.6, _merge(crouch, {"ua_r": _v(50), "fa_r": _v(25), "head": _v(-10), "spine": _v(-35)})], [1.0, {}]], {"events": [[0.45, "pickup"]]})
	_add("use_eat", 1.8, [[0.0, {}], [0.35, {"ua_r": _v(45, 0, -20), "fa_r": _v(135), "hand_r": _v(-20), "head": _v(-8)}],
		[0.9, {"ua_r": _v(48, 0, -18), "fa_r": _v(138), "hand_r": _v(-25), "head": _v(-10)}],
		[1.4, {"ua_r": _v(45, 0, -20), "fa_r": _v(132), "head": _v(-6)}], [1.8, {}]], {"events": [[0.9, "consume"]]})
	_add("use_drink", 1.8, [[0.0, {}], [0.35, {"ua_r": _v(70, 0, -25), "fa_r": _v(120), "hand_r": _v(-30), "head": _v(22)}],
		[1.3, {"ua_r": _v(80, 0, -22), "fa_r": _v(115), "hand_r": _v(-40), "head": _v(28)}], [1.8, {}]], {"events": [[0.9, "consume"]]})
	_add("use_bandage", 2.6, [[0.0, {}],
		[0.3, {"ua_l": _v(45, 0, -5), "fa_l": _v(90), "ua_r": _v(50, 0, -35), "fa_r": _v(95), "head": _v(-25), "chest": _v(-10)}],
		[1.2, {"ua_l": _v(45, 0, -5), "fa_l": _v(90), "ua_r": _v(55, 0, -25), "fa_r": _v(80), "head": _v(-25), "chest": _v(-10)}],
		[2.0, {"ua_l": _v(45, 0, -5), "fa_l": _v(92), "ua_r": _v(45, 0, -35), "fa_r": _v(100), "head": _v(-22), "chest": _v(-10)}],
		[2.6, {}]], {"events": [[2.2, "consume"]]})
	_add("use_inject", 1.6, [[0.0, {}], [0.35, {"ua_l": _v(35, 0, -5), "fa_l": _v(70), "ua_r": _v(50, 0, -40), "fa_r": _v(90), "head": _v(-25)}],
		[1.1, {"ua_l": _v(35, 0, -5), "fa_l": _v(70), "ua_r": _v(48, 0, -44), "fa_r": _v(96), "head": _v(-25)}], [1.6, {}]], {"events": [[0.9, "consume"]]})
	_add("open_door", 0.7, [[0.0, {}], [0.25, {"hr": _v(0.18, -0.12, -0.46), "spine": _v(-10)}], [0.7, {}]], {"events": [[0.25, "interact"]]})
	_add("climb", 1.2, [[0.0, {}],
		[0.2, {"ua_r": _v(170, 0, 15), "ua_l": _v(170, 0, -15), "fa_r": _v(20), "fa_l": _v(20), "th_l": _v(60), "sh_l": _v(-70)}],
		[0.6, {"ua_r": _v(90), "ua_l": _v(90), "fa_r": _v(90), "fa_l": _v(90), "spine": _v(-30), "th_l": _v(100), "sh_l": _v(-120), "th_r": _v(40), "sh_r": _v(-40)}],
		[0.95, {"ua_r": _v(40), "ua_l": _v(40), "fa_r": _v(20), "fa_l": _v(20), "th_r": _v(80), "sh_r": _v(-100), "spine": _v(-20)}],
		[1.2, {}]], {"blend_in": 0.05})
	_add("vault", 0.7, [[0.0, {}],
		[0.2, {"ua_l": _v(60, 0, -20), "fa_l": _v(10), "th_l": _v(80), "sh_l": _v(-110), "th_r": _v(90), "sh_r": _v(-100), "spine": _v(-20), "p": Vector3(0, 0.1, 0)}],
		[0.45, {"ua_l": _v(30, 0, -30), "th_l": _v(50), "sh_l": _v(-60), "th_r": _v(40), "sh_r": _v(-70), "spine": _v(-10)}],
		[0.7, {}]], {"blend_in": 0.04})

	# --- Narrativa / cinemática (reutilizadas também no gameplay por NPCs) --------------
	_add("look_around", 3.2, [[0.0, {}], [0.8, {"head": _v(0, -55, 0), "neck": _v(0, -15, 0), "chest": _v(0, -15, 0)}],
		[1.6, {"head": _v(5, 0, 0)}], [2.4, {"head": _v(0, 55, 0), "neck": _v(0, 15, 0), "chest": _v(0, 15, 0)}], [3.2, {}]], {"blend_in": 0.3})
	_add("gaze", 1.2, [[0.0, {}], [1.2, {"head": _v(6, 0, 0), "chest": _v(4), "ua_l": _v(4, 0, -6), "ua_r": _v(4, 0, 6), "fa_l": _v(12), "fa_r": _v(12)}]], {"hold": true, "blend_in": 0.4, "blend_out": 0.6})
	_add("adjust_backpack", 1.6, [[0.0, {}],
		[0.35, {"ua_r": _v(35, 0, -12), "fa_r": _v(140), "ua_l": _v(35, 0, 12), "fa_l": _v(140), "hand_r": _v(-20), "hand_l": _v(-20)}],
		[0.8, {"ua_r": _v(38, 0, -12), "fa_r": _v(145), "ua_l": _v(38, 0, 12), "fa_l": _v(145), "chest": _v(6), "p": Vector3(0, 0.02, 0)}],
		[1.2, {"ua_r": _v(35, 0, -12), "fa_r": _v(140), "ua_l": _v(35, 0, 12), "fa_l": _v(140)}],
		[1.6, {}]], {"blend_in": 0.2})
	_add("typing", 1.2, [
		[0.0, {"ua_r": _v(40, 0, -12), "fa_r": _v(65), "hand_r": _v(-15), "ua_l": _v(40, 0, 12), "fa_l": _v(65), "hand_l": _v(-15), "head": _v(-18), "spine": _v(-12)}],
		[0.3, {"ua_r": _v(40, 0, -12), "fa_r": _v(67), "hand_r": _v(-25), "ua_l": _v(40, 0, 12), "fa_l": _v(64), "hand_l": _v(-10), "head": _v(-18), "spine": _v(-12)}],
		[0.6, {"ua_r": _v(41, 0, -12), "fa_r": _v(64), "hand_r": _v(-12), "ua_l": _v(40, 0, 12), "fa_l": _v(67), "hand_l": _v(-25), "head": _v(-16), "spine": _v(-12)}],
		[0.9, {"ua_r": _v(40, 0, -12), "fa_r": _v(66), "hand_r": _v(-22), "ua_l": _v(41, 0, 12), "fa_l": _v(65), "hand_l": _v(-14), "head": _v(-18), "spine": _v(-12)}],
		[1.2, {"ua_r": _v(40, 0, -12), "fa_r": _v(65), "hand_r": _v(-15), "ua_l": _v(40, 0, 12), "fa_l": _v(65), "hand_l": _v(-15), "head": _v(-18), "spine": _v(-12)}]],
		{"loop": true, "blend_in": 0.4})
	_add("sit", 0.6, [[0.0, {}], [0.6, sit]], {"hold": true, "blend_in": 0.2, "blend_out": 0.5})
	# sentado no chão encostado na parede (menu): joelhos para cima, braços
	# apoiados nos joelhos, respiração lenta; a cabeça vira para a janela
	var floor_sit := {"p": Vector3(0, -1.2, 0.12), "th_l": _v(140, 0, 10), "th_r": _v(126, 0, -8), "sh_l": _v(-122), "sh_r": _v(-108),
		"ft_l": _v(-20), "ft_r": _v(-16), "spine": _v(12), "chest": _v(-10), "neck": _v(-2), "head": _v(-6, -38, 0),
		"ua_l": _v(10, 0, 0), "fa_l": _v(80), "hand_l": _v(-25), "ua_r": _v(20, 0, 0), "fa_r": _v(40), "hand_r": _v(-35)}
	_add("sit_floor", 7.0, [[0.0, floor_sit], [3.5, _merge(floor_sit, {"chest": _v(-5), "spine": _v(11), "head": _v(-1, -42, 2)})], [7.0, floor_sit]],
		{"loop": true, "blend_in": 0.0})
	_add("sit_twitch", 1.4, [[0.0, sit], [0.2, _merge(sit, {"head": _v(0, 0, 15), "ua_r": _v(25, 0, 20)})],
		[0.32, _merge(sit, {"head": _v(-5, 0, -10)})], [0.9, _merge(sit, {"head": _v(-20, 0, 5), "spine": _v(-15)})], [1.4, sit]], {"loop": true, "blend_in": 0.2})
	_add("head_tilt", 2.4, [[0.0, {}], [2.4, {"head": _v(-10, 0, 32), "neck": _v(0, 0, 10), "jaw": _v(-10)}]], {"hold": true, "blend_in": 0.5})
	_add("stand_hunched", 0.8, [[0.0, {}], [0.8, hunched]], {"hold": true, "blend_in": 0.3})
	_add("hand_on_glass", 0.9, [[0.0, {}], [0.9, {"ua_r": _v(88, 0, -5), "fa_r": _v(15), "hand_r": _v(-70), "head": _v(15, 0, 10), "spine": _v(-10), "chest": _v(-5), "jaw": _v(-12)}]], {"hold": true, "blend_in": 0.3})
	_add("scream", 1.8, [[0.0, {}],
		[0.4, {"head": _v(35), "jaw": _v(-28), "chest": _v(18), "ua_r": _v(-25, 0, 40), "ua_l": _v(-25, 0, -40), "fa_r": _v(30), "fa_l": _v(30)}],
		[1.3, {"head": _v(38, 0, 5), "jaw": _v(-30), "chest": _v(20), "ua_r": _v(-25, 0, 42), "ua_l": _v(-25, 0, -42), "fa_r": _v(30), "fa_l": _v(30)}],
		[1.8, {}]], {"events": [[0.45, "scream"]]})
	_add("cough", 1.3, [[0.0, {}], [0.25, {"spine": _v(-25), "head": _v(-25), "ua_r": _v(55, 0, -35), "fa_r": _v(130), "hand_r": _v(-10)}],
		[0.5, {"spine": _v(-15), "head": _v(-15), "ua_r": _v(55, 0, -35), "fa_r": _v(130)}],
		[0.7, {"spine": _v(-28), "head": _v(-22), "ua_r": _v(55, 0, -35), "fa_r": _v(130)}], [1.3, {}]], {"events": [[0.25, "cough"], [0.7, "cough"]]})
	_add("carry_box", 0.4, [[0.0, {}], [0.4, {"ua_r": _v(45, 0, -8), "fa_r": _v(70), "ua_l": _v(45, 0, 8), "fa_l": _v(70), "hand_r": _v(-25), "hand_l": _v(-25), "spine": _v(8)}]], {"hold": true})
	_add("phone", 0.5, [[0.0, {}], [0.5, {"ua_r": _v(40, 0, -35), "fa_r": _v(145), "head": _v(-5, 0, -10)}]], {"hold": true})
	_add("wave", 1.0, [[0.0, {"ua_r": _v(20, 0, 150), "fa_r": _v(30)}], [0.5, {"ua_r": _v(20, 0, 130), "fa_r": _v(55)}], [1.0, {"ua_r": _v(20, 0, 150), "fa_r": _v(30)}]], {"loop": true, "blend_in": 0.25})
	_add("point", 0.5, [[0.0, {}], [0.5, {"ua_r": _v(90, 0, -5), "fa_r": _v(5)}]], {"hold": true})
	_add("lie", 0.8, [[0.0, {}], [0.8, lying]], {"hold": true})
	_add("warm_hands", 0.8, [[0.0, {}], [0.8, _merge(crouch, {"ua_r": _v(55, 0, 8), "ua_l": _v(55, 0, -8), "fa_r": _v(60), "fa_l": _v(60), "hand_r": _v(-40), "hand_l": _v(-40), "spine": _v(-25)})]], {"hold": true, "blend_in": 0.4})
	_add("panic", 0.4, [[0.0, {}], [0.4, {"ua_r": _v(140, 0, 25), "ua_l": _v(140, 0, -25), "fa_r": _v(150), "fa_l": _v(150), "head": _v(-10)}]], {"hold": true})
	_add("guard_idle", 0.5, [[0.0, {}], [0.5, {"ua_r": _v(20, 0, -10), "fa_r": _v(60), "ua_l": _v(25, 0, 15), "fa_l": _v(70)}]], {"hold": true})
	_add("drive", 0.5, [[0.0, {}], [0.5, _merge(sit, {"ua_r": _v(55, 0, -10), "ua_l": _v(55, 0, 10), "fa_r": _v(55), "fa_l": _v(55), "p": Vector3(0, -0.42, 0.05)})]], {"hold": true})
	_add("crouch_hide", 0.5, [[0.0, {}], [0.5, _merge(crouch, {"ua_r": _v(30, 0, 5), "ua_l": _v(30, 0, -5), "fa_r": _v(70), "fa_l": _v(70)})]], {"hold": true})
	_add("inspect_low", 1.8, [[0.0, {}], [0.5, _merge(crouch, {"ua_r": _v(45), "fa_r": _v(20), "head": _v(-25)})], [1.3, _merge(crouch, {"ua_r": _v(48), "fa_r": _v(25), "head": _v(-20, 15, 0)})], [1.8, {}]])
	_add("run_scared", 0.3, [[0.0, {}], [0.3, {"ua_r": _v(60, 0, 20), "ua_l": _v(60, 0, -20), "fa_r": _v(100), "fa_l": _v(100), "head": _v(-5, 25, 0)}]], {"hold": true})

	# --- Infectados -----------------------------------------------------------------------
	_add("inf_lunge", 0.95, [[0.0, {}],
		[0.35, {"spine": _v(8), "chest": _v(12), "head": _v(20), "hr": _v(0.36, 0.06, 0.14), "hl": _v(-0.36, 0.06, 0.14), "p": Vector3(0, -0.1, 0.04)}],
		[0.52, {"spine": _v(-38), "chest": _v(-10), "head": _v(30), "hr": _v(0.14, 0.04, -0.50), "hl": _v(-0.14, 0.04, -0.50), "jaw": _v(-25), "p": Vector3(0, -0.14, -0.22)}],
		[0.75, {"spine": _v(-30), "head": _v(25), "hr": _v(0.14, -0.02, -0.46), "hl": _v(-0.14, -0.02, -0.46), "jaw": _v(-18), "p": Vector3(0, -0.10, -0.15)}],
		[0.95, {}]], {"events": [[0.46, "hit_start"], [0.64, "hit_end"]]})
	_add("inf_swipe", 0.85, [[0.0, {}],
		[0.3, {"hr": _v(0.48, 0.22, 0.08), "chest": _v(0, -30, 0), "spine": _v(-10)}],
		[0.48, {"hr": _v(-0.10, -0.02, -0.40), "chest": _v(0, 35, 0), "spine": _v(-25), "jaw": _v(-15)}],
		[0.85, {}]], {"events": [[0.38, "hit_start"], [0.55, "hit_end"]]})
	_add("inf_grab", 1.4, [[0.0, {}],
		[0.4, {"hr": _v(0.16, 0.02, -0.50), "hl": _v(-0.16, 0.02, -0.50), "spine": _v(-30), "jaw": _v(-20)}],
		[1.0, {"hr": _v(0.14, -0.02, -0.46), "hl": _v(-0.14, -0.02, -0.46), "spine": _v(-32), "jaw": _v(-28), "head": _v(15)}],
		[1.4, {}]], {"events": [[0.42, "hit_start"], [0.62, "hit_end"]]})
	_add("brute_roar", 1.6, [[0.0, {}],
		[0.5, {"ua_r": _v(20, 0, 80), "ua_l": _v(20, 0, -80), "fa_r": _v(60), "fa_l": _v(60), "chest": _v(20), "head": _v(30), "jaw": _v(-30)}],
		[1.2, {"ua_r": _v(22, 0, 82), "ua_l": _v(22, 0, -82), "fa_r": _v(62), "fa_l": _v(62), "chest": _v(22), "head": _v(32), "jaw": _v(-32)}],
		[1.6, {}]], {"events": [[0.5, "scream"]]})
	_add("brute_slam", 1.5, [[0.0, {}],
		[0.55, {"hr": _v(0.18, 0.62, 0.06), "hl": _v(-0.18, 0.62, 0.06), "spine": _v(15), "chest": _v(10), "p": Vector3(0, 0.05, 0.05)}],
		[0.8, {"hr": _v(0.18, -0.22, -0.44), "hl": _v(-0.18, -0.22, -0.44), "spine": _v(-40), "p": Vector3(0, -0.28, -0.14)}],
		[1.1, {"hr": _v(0.18, -0.26, -0.40), "hl": _v(-0.18, -0.26, -0.40), "spine": _v(-38), "p": Vector3(0, -0.24, -0.12)}],
		[1.5, {}]], {"events": [[0.72, "hit_start"], [0.86, "slam"], [0.9, "hit_end"]]})
	_add("brute_charge", 0.4, [[0.0, {}], [0.4, {"spine": _v(-35), "head": _v(30), "ua_r": _v(10, 0, 25), "ua_l": _v(10, 0, -25), "fa_r": _v(30), "fa_l": _v(30)}]], {"hold": true, "blend_in": 0.1})
	_add("inf_twitch", 0.6, [[0.0, {}], [0.1, {"head": _v(10, 0, 25), "neck": _v(0, 0, 10), "ua_r": _v(15, 0, 20)}], [0.3, {"head": _v(-10, 20, -10)}], [0.6, {}]], {"blend_in": 0.02})
	_add("inf_sniff", 2.4, [[0.0, {}], [0.5, {"head": _v(30, -25, 0), "neck": _v(10)}], [1.2, {"head": _v(25, 30, 0), "neck": _v(10)}], [1.8, {"head": _v(35, 0, 10)}], [2.4, {}]], {"blend_in": 0.3})
	_add("inf_dormant", 1.0, [[0.0, {}], [1.0, _merge(hunched, {"head": _v(-35, 0, 12), "spine": _v(-35), "ua_r": _v(5, 0, 5), "ua_l": _v(5, 0, -5), "fa_r": _v(10), "fa_l": _v(10)})]], {"hold": true, "blend_in": 0.5, "blend_out": 0.25})
	_add("crawler_claw", 1.1, [[0.0, {}], [0.4, {"ua_r": _v(170, 0, 20), "fa_r": _v(10)}], [0.7, {"ua_r": _v(120, 0, 10), "fa_r": _v(40)}], [1.1, {}]], {"events": [[0.42, "hit_start"], [0.65, "hit_end"]]})
	_add("spores", 2.2, [[0.0, {}],
		[0.8, {"ua_r": _v(30, 0, 70), "ua_l": _v(30, 0, -70), "chest": _v(22), "head": _v(25), "jaw": _v(-20)}],
		[1.6, {"ua_r": _v(32, 0, 72), "ua_l": _v(32, 0, -72), "chest": _v(25), "head": _v(28), "jaw": _v(-24)}],
		[2.2, {}]], {"events": [[1.0, "spores"]]})
	_add("get_up", 1.2, [[0.0, lying], [0.5, {"hips": _v(20), "p": Vector3(0, -0.5, 0.05), "th_l": _v(100), "th_r": _v(80), "sh_l": _v(-130), "sh_r": _v(-110), "spine": _v(-35)}], [1.2, {}]], {"blend_in": 0.02})
