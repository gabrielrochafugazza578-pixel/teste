class_name Util
extends RefCounted
## Utilidades estáticas: hashing determinístico, RNG por semente, geometria.


## Hash inteiro estável de coordenadas (independe de plataforma).
static func hash2(x: int, z: int, salt: int = 0) -> int:
	var h: int = (x * 73856093) ^ (z * 19349663) ^ (salt * 83492791)
	h = (h ^ (h >> 13)) * 1274126177
	h = h ^ (h >> 16)
	return h & 0x7fffffff


static func hash_str(s: String) -> int:
	return s.hash() & 0x7fffffff


## Retorna 0..1 determinístico.
static func rand01(seed_value: int) -> float:
	var h := hash2(seed_value, seed_value * 7 + 3, 11)
	return float(h % 100000) / 100000.0


static func rng(seed_value: int) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = seed_value
	return r


## Escolha ponderada. `entries` = [[valor, peso], ...]
static func weighted_pick(entries: Array, r: RandomNumberGenerator) -> Variant:
	var total := 0.0
	for e in entries:
		total += float(e[1])
	if total <= 0.0:
		return null
	var x := r.randf() * total
	for e in entries:
		x -= float(e[1])
		if x <= 0.0:
			return e[0]
	return entries[entries.size() - 1][0]


static func v3(a: Array) -> Vector3:
	if a.size() < 3:
		return Vector3.ZERO
	return Vector3(float(a[0]), float(a[1]), float(a[2]))


static func arr3(v: Vector3) -> Array:
	return [snappedf(v.x, 0.01), snappedf(v.y, 0.01), snappedf(v.z, 0.01)]


## Distância de ponto a segmento no plano XZ.
static func dist_point_segment_2d(p: Vector2, a: Vector2, b: Vector2) -> float:
	var ab := b - a
	var len2 := ab.length_squared()
	if len2 < 0.0001:
		return p.distance_to(a)
	var t := clampf((p - a).dot(ab) / len2, 0.0, 1.0)
	return p.distance_to(a + ab * t)


## Distância a polilinha 2D, retorna [distância, t_global (0..1), ponto_mais_proximo]
static func dist_point_polyline_2d(p: Vector2, pts: PackedVector2Array) -> float:
	var best := INF
	for i in range(pts.size() - 1):
		var d := dist_point_segment_2d(p, pts[i], pts[i + 1])
		if d < best:
			best = d
	return best


static func flat(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z)


static func angle_to_dir(yaw: float) -> Vector3:
	return Vector3(-sin(yaw), 0.0, -cos(yaw))


static func dir_to_yaw(dir: Vector3) -> float:
	return atan2(-dir.x, -dir.z)


static func format_time(hours: float) -> String:
	var h := int(hours) % 24
	var m := int((hours - floorf(hours)) * 60.0)
	return "%02d:%02d" % [h, m]


static func is_headless() -> bool:
	return DisplayServer.get_name() == "headless"


## Suavização exponencial independente de framerate.
static func damp(current: float, target: float, rate: float, delta: float) -> float:
	return lerpf(current, target, 1.0 - exp(-rate * delta))


static func damp_v3(current: Vector3, target: Vector3, rate: float, delta: float) -> Vector3:
	return current.lerp(target, 1.0 - exp(-rate * delta))


static func damp_angle(current: float, target: float, rate: float, delta: float) -> float:
	return lerp_angle(current, target, 1.0 - exp(-rate * delta))
