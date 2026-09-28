class_name HumanoidMeshBuilder
extends RefCounted
## Gera a malha humanoide (com pesos de ossos) a partir de um dicionário de
## aparência. O corpo é "lofted": cada membro é um tubo com seções elípticas
## variáveis, e as articulações recebem pesos mistos entre ossos vizinhos —
## deformação suave, sem aparência de boneco segmentado.
##
## Uma única superfície por personagem (cor por vértice + id de material no
## alfa) => 1 draw call. Duas resoluções: lod 0 (perto) e lod 1 (multidão).

enum { HIPS, SPINE, CHEST, NECK, HEAD, JAW, UARM_L, FARM_L, HAND_L, UARM_R, FARM_R, HAND_R,
	THIGH_L, SHIN_L, FOOT_L, THIGH_R, SHIN_R, FOOT_R }

const BONE_NAMES := ["hips", "spine", "chest", "neck", "head", "jaw", "upperarm_l", "forearm_l", "hand_l",
	"upperarm_r", "forearm_r", "hand_r", "thigh_l", "shin_l", "foot_l", "thigh_r", "shin_r", "foot_r"]
const PARENTS := [-1, 0, 1, 2, 3, 4, 2, 6, 7, 2, 9, 10, 0, 12, 13, 0, 15, 16]

const M_SKIN := 0.0
const M_CLOTH := 0.3333
const M_DENIM := 0.6667
const M_LEATHER := 1.0

var verts := PackedVector3Array()
var norms := PackedVector3Array()
var tans := PackedFloat32Array()
var cols := PackedColorArray()
var uvs := PackedVector2Array()
var bones := PackedInt32Array()
var weights := PackedFloat32Array()
var indices := PackedInt32Array()

var a: Dictionary
var j: Array = []
var s: float = 1.0
var lod: int = 0
var skin_col: Color
var tear: float = 0.0
var rng := RandomNumberGenerator.new()


# ---------------------------------------------------------------------------
# API
# ---------------------------------------------------------------------------
static func compute_joints(ap: Dictionary) -> Array:
	var sc := float(ap.get("height", 1.75)) / 1.78
	var bw := float(ap.get("build", 1.0))
	var fem: bool = ap.get("female", false)
	var sh := 0.19 * bw * (0.9 if fem else 1.0)
	var hp := 0.095 * bw * (1.06 if fem else 1.0)
	var asym := float(ap.get("asym", 0.0)) * 0.035
	var hunch := float(ap.get("hunch", 0.0))
	var jt: Array = []
	jt.resize(18)
	jt[HIPS] = Vector3(0, 0.98, 0)
	jt[SPINE] = Vector3(0, 1.1, 0.005)
	jt[CHEST] = Vector3(0, 1.3, 0.01 + hunch * 0.02)
	jt[NECK] = Vector3(0, 1.5, 0.0 + hunch * 0.03)
	jt[HEAD] = Vector3(0, 1.595, -0.005 + hunch * 0.02)
	jt[JAW] = Vector3(0, 1.64, -0.02 + hunch * 0.02)
	jt[UARM_L] = Vector3(-sh, 1.455 - asym, 0.0)
	jt[FARM_L] = Vector3(-sh - 0.035 * bw, 1.165 - asym, 0.01)
	jt[HAND_L] = Vector3(-sh - 0.05 * bw, 0.905 - asym, 0.0)
	jt[UARM_R] = Vector3(sh, 1.455 + asym * 0.4, 0.0)
	jt[FARM_R] = Vector3(sh + 0.035 * bw, 1.165 + asym * 0.4, 0.01)
	jt[HAND_R] = Vector3(sh + 0.05 * bw, 0.905 + asym * 0.4, 0.0)
	jt[THIGH_L] = Vector3(-hp, 0.93, 0.0)
	jt[SHIN_L] = Vector3(-hp - 0.005, 0.505, -0.005)
	jt[FOOT_L] = Vector3(-hp - 0.01, 0.085, 0.02)
	jt[THIGH_R] = Vector3(hp, 0.93, 0.0)
	jt[SHIN_R] = Vector3(hp + 0.005, 0.505, -0.005)
	jt[FOOT_R] = Vector3(hp + 0.01, 0.085, 0.02)
	for i in 18:
		jt[i] = jt[i] * sc
	return jt


static func build(ap: Dictionary, lod_level: int = 0) -> ArrayMesh:
	var b := HumanoidMeshBuilder.new()
	return b._build(ap, lod_level)


# ---------------------------------------------------------------------------
# Construção
# ---------------------------------------------------------------------------
func _build(ap: Dictionary, lod_level: int) -> ArrayMesh:
	a = ap
	lod = lod_level
	s = float(a.get("height", 1.75)) / 1.78
	j = compute_joints(a)
	rng.seed = int(a.get("seed", 0)) * 17 + 5
	skin_col = a.get("skin", Color(0.7, 0.55, 0.45))
	tear = float(a.get("tear", 0.0))
	var inf := float(a.get("infected", 0.0))
	if inf > 0.0:
		skin_col = skin_col.lerp(Color(0.6, 0.62, 0.58), inf * 0.35)

	_torso()
	_neck()
	_head()
	_arms()
	_legs()
	_clothing_extras()
	if float(a.get("growths", 0.0)) > 0.0:
		_growths(float(a["growths"]))

	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = norms
	arrays[Mesh.ARRAY_TANGENT] = tans
	arrays[Mesh.ARRAY_COLOR] = cols
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_BONES] = bones
	arrays[Mesh.ARRAY_WEIGHTS] = weights
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh


func _lin(c: Color) -> Color:
	return c.srgb_to_linear()


## Adiciona vértice. Pesos são normalizados; até 3 ossos.
func _v(p: Vector3, n: Vector3, t: Vector3, bdir: Vector3, uv: Vector2, col: Color, mat: float,
		b0: int, w0: float, b1: int = 0, w1: float = 0.0, b2: int = 0, w2: float = 0.0) -> int:
	verts.append(p)
	n = n.normalized()
	norms.append(n)
	var tt := t - n * n.dot(t)
	if tt.length_squared() < 0.000001:
		tt = n.cross(Vector3.UP if absf(n.y) < 0.9 else Vector3.RIGHT)
	tt = tt.normalized()
	var w := -signf(n.cross(tt).dot(bdir))
	if w == 0.0:
		w = 1.0
	tans.append(tt.x)
	tans.append(tt.y)
	tans.append(tt.z)
	tans.append(w)
	var c := _lin(col)
	c.a = mat
	cols.append(c)
	uvs.append(uv)
	w0 = maxf(w0, 0.0)
	w1 = maxf(w1, 0.0)
	w2 = maxf(w2, 0.0)
	var sum := w0 + w1 + w2
	if sum <= 0.0:
		w0 = 1.0
		sum = 1.0
	bones.append(b0)
	bones.append(b1)
	bones.append(b2)
	bones.append(0)
	weights.append(w0 / sum)
	weights.append(w1 / sum)
	weights.append(w2 / sum)
	weights.append(0.0)
	return verts.size() - 1


## Triângulo com correção automática de orientação (Godot: frente = horário).
func _tri(i0: int, i1: int, i2: int) -> void:
	var p0 := verts[i0]
	var fn := (verts[i1] - p0).cross(verts[i2] - p0)
	var n := norms[i0] + norms[i1] + norms[i2]
	if fn.dot(n) > 0.0:
		indices.append(i0)
		indices.append(i2)
		indices.append(i1)
	else:
		indices.append(i0)
		indices.append(i1)
		indices.append(i2)


func _torn(p: Vector3) -> bool:
	if tear <= 0.0:
		return false
	var q := Vector3i(floori(p.x * 22.0), floori(p.y * 22.0), floori(p.z * 22.0))
	var h := Util.hash2(q.x * 3 + q.z * 7, q.y, int(a.get("seed", 0)))
	return float(h % 1000) / 1000.0 < tear * 0.45


## Tubo elíptico de `pa` a `pb`.
## rings: [[t, rx, rz, cor, mat, desloc_frente], ...]
func _tube(pa: Vector3, pb: Vector3, rings: Array, sides: int, bone: int, child: int, parent: int,
		cap0: bool, cap1: bool, blend0: float = 0.25, blend1: float = 0.25, clothing: bool = true) -> void:
	var axis := (pb - pa)
	var length := axis.length()
	if length < 0.0001:
		return
	axis /= length
	var side := Vector3.RIGHT - axis * axis.dot(Vector3.RIGHT)
	if side.length_squared() < 0.01:
		side = Vector3.BACK - axis * axis.dot(Vector3.BACK)
	side = side.normalized()
	var fwd := side.cross(axis).normalized()
	var ring_start: Array = []
	for r in rings:
		var t: float = r[0]
		var rx: float = float(r[1]) * s
		var rz: float = float(r[2]) * s
		var col: Color = r[3]
		var mat: float = r[4]
		var off: float = float(r[5]) * s if r.size() > 5 else 0.0
		var center := pa + axis * (t * length) + fwd * off
		var wp := 0.0
		var wc := 0.0
		if parent >= 0 and blend0 > 0.0:
			wp = (1.0 - smoothstep(0.0, blend0, t)) * 0.5
		if child >= 0 and blend1 > 0.0:
			wc = smoothstep(1.0 - blend1, 1.0, t) * 0.5
		var ws := 1.0 - wp - wc
		var start := verts.size()
		ring_start.append(start)
		var circ := (rx + rz) * 0.5
		for k in sides + 1:
			var th := TAU * float(k) / float(sides)
			var ct := cos(th)
			var st := sin(th)
			var p := center + side * (ct * rx) + fwd * (st * rz)
			var n := side * (ct / maxf(rx, 0.001)) + fwd * (st / maxf(rz, 0.001))
			var tg := -side * (st * rx) + fwd * (ct * rz)
			var vc := col
			var vm := mat
			if clothing and mat > 0.1 and _torn(p):
				vc = skin_col
				vm = M_SKIN
			_v(p, n, tg, axis, Vector2(th * circ, t * length), vc, vm, bone, ws, maxi(child, 0), wc, maxi(parent, 0), wp)
	for i in ring_start.size() - 1:
		var r0: int = ring_start[i]
		var r1: int = ring_start[i + 1]
		for k in sides:
			_tri(r0 + k, r1 + k, r0 + k + 1)
			_tri(r0 + k + 1, r1 + k, r1 + k + 1)
	if cap0:
		_cap(ring_start[0], sides, pa + fwd * (float(rings[0][5]) * s if rings[0].size() > 5 else 0.0), -axis, rings[0][3], rings[0][4], bone, parent if parent >= 0 else bone)
	if cap1:
		var last: Array = rings[rings.size() - 1]
		var cend := pa + axis * (float(last[0]) * length) + fwd * (float(last[5]) * s if last.size() > 5 else 0.0)
		_cap(ring_start[ring_start.size() - 1], sides, cend, axis, last[3], last[4], bone, child if child >= 0 else bone)


func _cap(start: int, sides: int, center: Vector3, n: Vector3, col: Color, mat: float, bone: int, bone2: int) -> void:
	var tg := n.cross(Vector3.UP if absf(n.y) < 0.9 else Vector3.RIGHT)
	var ci := _v(center, n, tg, n.cross(tg), Vector2.ZERO, col, mat, bone, 0.8, bone2, 0.2)
	for k in sides:
		_tri(ci, start + k, start + k + 1)


# ---------------------------------------------------------------------------
# Tronco
# ---------------------------------------------------------------------------
func _torso() -> void:
	var fem: bool = a.get("female", false)
	var bw := float(a.get("build", 1.0))
	var gi := float(a.get("girth", 1.0))
	var top: String = a.get("top", "tshirt")
	var bottom: String = a.get("bottom", "jeans")
	var tc: Color = a.get("top_color", Color.GRAY)
	var tc2: Color = a.get("top2_color", Color.GRAY)
	var bc: Color = a.get("bottom_color", Color.DARK_BLUE)
	var top_mat := M_CLOTH
	var bot_mat := M_DENIM if bottom == "jeans" else M_CLOTH
	var loose := 0.0
	if top in ["jacket", "hoodie", "labcoat"]:
		loose = 0.014
	var belly := clampf((gi - 1.0) * 0.08, -0.02, 0.05)
	# [y, rx, rz, z_off]
	var prof := [
		[0.84, 0.12, 0.085, 0.0],
		[0.9, 0.165 + (0.012 if fem else 0.0), 0.105, 0.005],
		[0.98, 0.162 + (0.014 if fem else 0.0), 0.1, 0.0],
		[1.06, 0.145 - (0.02 if fem else 0.0) + belly * 0.5, 0.098 + belly, -belly * 0.5],
		[1.16, 0.15 - (0.015 if fem else 0.0) + belly * 0.3, 0.102 + belly * 0.6, -belly * 0.3],
		[1.26, 0.168 - (0.01 if fem else 0.0), 0.112 + (0.018 if fem else 0.0), -(0.012 if fem else 0.0)],
		[1.35, 0.182 - (0.012 if fem else 0.0), 0.112 + (0.01 if fem else 0.0), 0.0],
		[1.42, 0.185 - (0.015 if fem else 0.0), 0.1, 0.005],
		[1.47, 0.158 - (0.012 if fem else 0.0), 0.09, 0.01],
		[1.51, 0.098 - (0.01 if fem else 0.0), 0.078, 0.01],
		[1.535, 0.07 - (0.008 if fem else 0.0), 0.064, 0.005],
	]
	var waist_y := 1.0
	var hem_y := waist_y
	if top in ["jacket", "hoodie"]:
		hem_y = 0.9
	elif top in ["labcoat", "gown"]:
		hem_y = 0.84
	var sides := 18 if lod == 0 else 10
	var ring_start: Array = []
	var sc := s
	for ri in prof.size():
		var r: Array = prof[ri]
		var y: float = float(r[0]) * sc
		var yy: float = r[0]
		var is_top := yy >= hem_y - 0.001
		var rx: float = float(r[1]) * bw * sc
		var rz: float = float(r[2]) * sc * lerpf(1.0, gi, 0.6)
		if is_top and yy > 0.95:
			rx += loose * sc
			rz += loose * sc
		var zoff: float = float(r[3]) * sc
		# pesos por altura
		var w_h := 1.0 - smoothstep(0.98, 1.12, yy)
		var w_c := smoothstep(1.18, 1.3, yy)
		var w_sp := 1.0 - w_h - w_c
		var w_n := smoothstep(1.49, 1.54, yy) * 0.6
		var start := verts.size()
		ring_start.append(start)
		var circ := (rx + rz) * 0.5
		for k in sides + 1:
			var th := TAU * float(k) / float(sides)
			var ct := cos(th)
			var st := sin(th)
			var p := Vector3(ct * rx, y, -st * rz + zoff)
			# trapézio: a linha dos ombros desce do pescoço até o acrômio
			var drop := smoothstep(1.36, 1.515, yy) * pow(absf(ct), 1.5) * 0.052 * sc * (0.85 if fem else 1.0)
			p.y -= drop
			var n := Vector3(ct / maxf(rx, 0.001), 0.0, -st / maxf(rz, 0.001))
			if yy > 1.44:
				n.y += 0.6 + drop * 8.0
			if yy < 0.86:
				n.y -= 0.6
			var tg := Vector3(-st * rx, 0.0, -ct * rz)
			var col := tc if is_top else bc
			var mat := top_mat if is_top else bot_mat
			# camiseta por dentro / jaqueta aberta mostra a camisa interna na frente
			if top == "jacket" and is_top and st > 0.82 and yy < 1.44:
				col = tc2
				mat = M_CLOTH
			if top == "labcoat" and is_top and st > 0.94 and yy < 1.46 and yy > 1.24:
				col = tc2
			# cinto
			if bottom == "jeans" and absf(yy - 0.98) < 0.001 and not (top in ["jacket", "hoodie", "labcoat", "gown"]):
				col = Color(0.1, 0.07, 0.05)
				mat = M_LEATHER
			if mat > 0.1 and _torn(p):
				col = skin_col
				mat = M_SKIN
			# ombros levemente ligados aos braços
			var shoulder := 0.0
			var arm_bone := UARM_R if ct > 0.0 else UARM_L
			if yy > 1.36:
				shoulder = smoothstep(0.55, 0.95, absf(ct)) * smoothstep(1.36, 1.45, yy) * 0.4
			var wb0 := HIPS
			var wv0 := w_h
			var wb1 := SPINE
			var wv1 := w_sp
			var wb2 := CHEST
			var wv2 := w_c
			if shoulder > 0.0:
				# substitui o menor peso pelo braço
				wb0 = arm_bone
				wv0 = shoulder
				wv2 = w_c * (1.0 - shoulder)
				wb1 = SPINE
			elif w_n > 0.0:
				wb0 = NECK
				wv0 = w_n
				wv2 = w_c * (1.0 - w_n)
			_v(p, n, tg, Vector3.UP, Vector2(th * circ, y), col, mat, wb0, wv0, wb1, wv1, wb2, wv2)
	for i in ring_start.size() - 1:
		var r0: int = ring_start[i]
		var r1: int = ring_start[i + 1]
		for k in sides:
			_tri(r0 + k, r1 + k, r0 + k + 1)
			_tri(r0 + k + 1, r1 + k, r1 + k + 1)
	# tampa inferior (virilha)
	var bcol := bc
	_cap(ring_start[0], sides, Vector3(0, 0.83 * sc, 0), Vector3.DOWN, bcol, bot_mat, HIPS, HIPS)

	# jaleco / camisola hospitalar: saia até os joelhos que acompanha as coxas
	if top in ["labcoat", "gown"]:
		_coat_skirt(tc, 0.55 if top == "labcoat" else 0.6)
	if bool(a.get("vest", false)):
		_vest(a.get("vest_color", Color(0.1, 0.1, 0.1)))


func _coat_skirt(col: Color, bottom_y: float) -> void:
	var sides := 18 if lod == 0 else 10
	var bw := float(a.get("build", 1.0))
	var ys := [0.9, 0.8, 0.7, bottom_y]
	var ring_start: Array = []
	for ri in ys.size():
		var yy: float = ys[ri]
		var t := float(ri) / float(ys.size() - 1)
		var rx := (0.19 + t * 0.05) * bw * s
		var rz := (0.125 + t * 0.03) * s
		var start := verts.size()
		ring_start.append(start)
		for k in sides + 1:
			var th := TAU * float(k) / float(sides)
			var ct := cos(th)
			var st := sin(th)
			# abertura frontal do jaleco
			var open_gap := 0.0
			if st > 0.9:
				open_gap = 0.012 * t
			var p := Vector3(ct * rx, yy * s, -st * (rz + open_gap))
			var n := Vector3(ct / rx, 0.1, -st / rz)
			var leg := THIGH_R if ct > 0.0 else THIGH_L
			var wl := t * 0.55 * smoothstep(0.1, 0.6, absf(ct))
			var c := col
			var m := M_CLOTH
			if _torn(p):
				c = col.darkened(0.4)
			_v(p, n, Vector3(-st, 0, -ct), Vector3.UP, Vector2(th * rx, yy), c, m, HIPS, 1.0 - wl, leg, wl)
	for i in ring_start.size() - 1:
		var r0: int = ring_start[i]
		var r1: int = ring_start[i + 1]
		for k in sides:
			_tri(r0 + k, r1 + k, r0 + k + 1)
			_tri(r0 + k + 1, r1 + k, r1 + k + 1)


func _vest(col: Color) -> void:
	var bw := float(a.get("build", 1.0))
	var ys := [1.08, 1.2, 1.32, 1.43]
	var sides := 16 if lod == 0 else 10
	var ring_start: Array = []
	for yy in ys:
		var rx := (0.182 if yy > 1.25 else 0.168) * bw * s + 0.022 * s
		var rz := 0.122 * s + 0.02 * s
		var start := verts.size()
		ring_start.append(start)
		var w_c := smoothstep(1.18, 1.3, yy)
		for k in sides + 1:
			var th := TAU * float(k) / float(sides)
			var p := Vector3(cos(th) * rx, float(yy) * s, -sin(th) * rz)
			var n := Vector3(cos(th) / rx, 0.0, -sin(th) / rz)
			_v(p, n, Vector3(-sin(th), 0, -cos(th)), Vector3.UP, Vector2(th * rx, yy), col, M_LEATHER, SPINE, 1.0 - w_c, CHEST, w_c)
	for i in ring_start.size() - 1:
		var r0: int = ring_start[i]
		var r1: int = ring_start[i + 1]
		for k in sides:
			_tri(r0 + k, r1 + k, r0 + k + 1)
			_tri(r0 + k + 1, r1 + k, r1 + k + 1)


func _neck() -> void:
	var gi := float(a.get("girth", 1.0))
	var fem: bool = a.get("female", false)
	var r := (0.057 if fem else 0.067) * lerpf(1.0, gi, 0.5)
	var col := skin_col
	var top: String = a.get("top", "tshirt")
	var rings := [[0.0, r * 1.1, r, col, M_SKIN], [0.6, r, r * 0.95, col, M_SKIN], [1.0, r * 0.92, r * 0.9, col, M_SKIN]]
	if top in ["jacket", "hoodie"]:
		var tc: Color = a.get("top_color", Color.GRAY)
		rings = [[0.0, r * 1.5, r * 1.4, tc, M_CLOTH], [0.35, r * 1.35, r * 1.3, tc, M_CLOTH], [0.36, r, r * 0.95, col, M_SKIN], [1.0, r * 0.92, r * 0.9, col, M_SKIN]]
	_tube(Vector3(0, j[NECK].y - 0.045 * s, j[NECK].z + 0.004 * s), j[HEAD] + Vector3(0, 0.035 * s, -0.004 * s), rings, 12 if lod == 0 else 8, NECK, HEAD, CHEST, false, false, 0.3, 0.35)


# ---------------------------------------------------------------------------
# Cabeça (elipsoide deformado: mandíbula, nariz, sobrancelhas, olhos, orelhas)
# ---------------------------------------------------------------------------
func _head() -> void:
	var fem: bool = a.get("female", false)
	var hs := 0.95 if fem else 1.0
	var c: Vector3 = j[HEAD] + Vector3(0, 0.1 * s, -0.012 * s)
	var R := Vector3(0.09, 0.115, 0.104) * s * hs
	var LAT := 16 if lod == 0 else 9
	var LON := 20 if lod == 0 else 12
	var beard := float(a.get("beard", 0.0))
	var hair_col: Color = a.get("hair_color", Color(0.1, 0.08, 0.05))
	var blind: bool = a.get("blind", false)
	var inf := float(a.get("infected", 0.0))
	var grid: Array = []
	for i in LAT + 1:
		var row: Array = []
		var phi := PI * float(i) / float(LAT)
		for k in LON + 1:
			var th := TAU * float(k) / float(LON)
			var ux := sin(phi) * cos(th)
			var uy := cos(phi)
			var uz := sin(phi) * sin(th)
			var front := maxf(-uz, 0.0)
			var p := Vector3(ux * R.x, uy * R.y, uz * R.z)
			if uy < 0.0:
				# estreita até o queixo, mas mantém o ângulo da mandíbula (rosto menos "V")
				var jaw_keep := exp(-pow(uy + 0.55, 2.0) / 0.03) * 0.12 * (0.7 if fem else 1.0)
				p.x *= 1.0 - (0.2 * (-uy) - jaw_keep) * (1.0 if fem else 0.9)
				p.z *= 1.0 - 0.08 * (-uy)
			if uz > 0.0 and uy > -0.3:
				p.z *= 1.07
			# queixo
			var chin := exp(-(ux * ux) / 0.05 - pow(uy + 0.82, 2.0) / 0.02) * front
			p.z -= chin * 0.014 * s
			p.y -= chin * 0.006 * s
			# nariz
			var nose := exp(-(ux * ux) / 0.01 - pow(uy + 0.08, 2.0) / 0.035) * front
			p.z -= nose * 0.024 * s * hs
			# sobrancelha
			var brow := exp(-pow(uy - 0.27, 2.0) / 0.006) * front * smoothstep(0.75, 0.2, absf(ux))
			p.z -= brow * 0.008 * s
			# órbitas
			var eye_l := exp(-pow(ux + 0.36, 2.0) / 0.014 - pow(uy - 0.13, 2.0) / 0.009) * front
			var eye_r := exp(-pow(ux - 0.36, 2.0) / 0.014 - pow(uy - 0.13, 2.0) / 0.009) * front
			p.z += (eye_l + eye_r) * 0.009 * s
			if blind:
				p.z -= (eye_l + eye_r) * 0.012 * s
			# maçãs do rosto
			var cheek := exp(-pow(absf(ux) - 0.55, 2.0) / 0.02 - pow(uy + 0.05, 2.0) / 0.012) * front
			p.x *= 1.0 + cheek * 0.04
			# boca
			var mouth := exp(-(ux * ux) / 0.03 - pow(uy + 0.42, 2.0) / 0.0025) * front
			p.z += mouth * 0.004 * s
			var lips := exp(-(ux * ux) / 0.04 - pow(uy + 0.42, 2.0) / 0.01) * front
			# orelhas
			var ear := exp(-(uz * uz) / 0.02 - pow(uy - 0.02, 2.0) / 0.025) * smoothstep(0.75, 0.95, absf(ux))
			p.x += signf(ux) * ear * 0.016 * s
			var col := skin_col
			var mat := M_SKIN
			col = col.lerp(Color(0.62, 0.35, 0.33), lips * 0.45 * (1.0 - inf * 0.7))
			col = col.lerp(hair_col, brow * 0.6)
			if beard > 0.0 and uy < -0.05 and front > 0.25 and lips < 0.35:
				col = col.lerp(hair_col, clampf(beard, 0.0, 1.0) * smoothstep(-0.05, -0.35, uy) * 0.75)
			if inf > 0.0:
				col = col.lerp(Color(0.32, 0.3, 0.32), (eye_l + eye_r) * inf * 0.6)
			var jaw_w := smoothstep(-0.3, -0.6, uy) * smoothstep(-0.25, 0.3, -uz)
			var neck_w := smoothstep(-0.8, -0.98, uy) * 0.4
			row.append([c + p, col, mat, jaw_w, neck_w, Vector2(th * 0.1, phi * 0.1)])
		grid.append(row)
	var starts := _emit_grid(grid, c, HEAD, JAW, NECK)
	# boca (interior escuro, visível quando a mandíbula abre)
	_ellipsoid(c + Vector3(0, -0.045 * s, -0.06 * s), Vector3(0.028, 0.012, 0.03) * s, Color(0.12, 0.04, 0.04), M_SKIN, HEAD, 0.5, JAW, 0.5, 6, 4)
	# olhos
	if not blind:
		var er := 0.0112 * s * hs
		var iris: Color = [Color(0.25, 0.15, 0.08), Color(0.12, 0.08, 0.05), Color(0.2, 0.3, 0.4), Color(0.25, 0.3, 0.18)][int(a.get("seed", 0)) % 4]
		if inf > 0.5:
			iris = Color(0.75, 0.72, 0.62)
		for sgn: float in [-1.0, 1.0]:
			var ec := c + Vector3(sgn * 0.034 * s * hs, 0.016 * s, -R.z * 0.8)
			_eye(ec, er, iris)
			_eyelids(ec, er)
	_hair(c, R)
	if bool(a.get("glasses", false)):
		_glasses(c, R)
	var hat: String = a.get("hat", "")
	if hat != "":
		_hat(c, R, hat)
	if bool(a.get("mask", false)):
		_mask(c, R)


## Emite uma grade lat/long com normais calculadas da geometria final.
func _emit_grid(grid: Array, center: Vector3, bone: int, jaw_bone: int, neck_bone: int) -> Array:
	var rows := grid.size()
	var cols_n: int = grid[0].size()
	var idx_grid: Array = []
	for i in rows:
		var row_idx: Array = []
		for k in cols_n:
			var e: Array = grid[i][k]
			var p: Vector3 = e[0]
			var pu: Vector3 = grid[i][(k + 1) % (cols_n - 1)][0]
			var pd: Vector3 = grid[i][(k - 1 + cols_n - 1) % (cols_n - 1)][0]
			var pn: Vector3 = grid[mini(i + 1, rows - 1)][k][0]
			var pp: Vector3 = grid[maxi(i - 1, 0)][k][0]
			var n := (pu - pd).cross(pn - pp)
			var out := p - center
			if n.length_squared() < 0.0000001:
				n = out
			if n.dot(out) < 0.0:
				n = -n
			var tg := pu - pd
			var bdir := pn - pp
			var jw: float = e[3]
			var nw: float = e[4]
			# pesos de mandíbula + pescoço nunca passam de 1 (evita peso negativo na cabeça)
			var extra := jw + nw
			if extra > 0.95:
				jw *= 0.95 / extra
				nw *= 0.95 / extra
			var vi := _v(p, n, tg, bdir, e[5], e[1], e[2], bone, 1.0 - jw - nw, jaw_bone, jw, neck_bone, nw)
			row_idx.append(vi)
		idx_grid.append(row_idx)
	for i in rows - 1:
		for k in cols_n - 1:
			var i00: int = idx_grid[i][k]
			var i01: int = idx_grid[i][k + 1]
			var i10: int = idx_grid[i + 1][k]
			var i11: int = idx_grid[i + 1][k + 1]
			_tri(i00, i10, i01)
			_tri(i01, i10, i11)
	return idx_grid


func _ellipsoid(c: Vector3, r: Vector3, col: Color, mat: float, b0: int, w0: float, b1: int = 0, w1: float = 0.0, lon: int = 8, lat: int = 6) -> void:
	var start := verts.size()
	for i in lat + 1:
		var phi := PI * float(i) / float(lat)
		for k in lon + 1:
			var th := TAU * float(k) / float(lon)
			var u := Vector3(sin(phi) * cos(th), cos(phi), sin(phi) * sin(th))
			var p := c + Vector3(u.x * r.x, u.y * r.y, u.z * r.z)
			var n := Vector3(u.x / maxf(r.x, 0.0001), u.y / maxf(r.y, 0.0001), u.z / maxf(r.z, 0.0001))
			_v(p, n, Vector3(-sin(th), 0, cos(th)), Vector3.DOWN, Vector2(float(k) / lon, float(i) / lat) * 0.1, col, mat, b0, w0, b1, w1)
	for i in lat:
		for k in lon:
			var i00 := start + i * (lon + 1) + k
			var i01 := i00 + 1
			var i10 := i00 + lon + 1
			var i11 := i10 + 1
			_tri(i00, i10, i01)
			_tri(i01, i10, i11)


## Pálpebras: casca de pele cobrindo o topo (e um pouco a base) do olho —
## tira o "olhar de boneco" dos olhos esféricos expostos.
func _eyelids(c: Vector3, r: float) -> void:
	var lon := 8 if lod == 0 else 5
	for lid in 2:
		var upper := lid == 0
		var rr := r * (1.16 if upper else 1.1)
		var start := verts.size()
		var lat := 3
		for i in lat + 1:
			# ângulo a partir do eixo vertical (cima ou baixo)
			var a0 := lerpf(0.0, 1.05 if upper else 0.55, float(i) / float(lat))
			for k in lon + 1:
				# só a metade da frente (-Z), de lado a lado
				var th := lerpf(-PI * 0.55, PI * 0.55, float(k) / float(lon))
				var u := Vector3(sin(a0) * sin(th), cos(a0) * (1.0 if upper else -1.0), -sin(a0) * cos(th))
				var col := skin_col * (0.92 if i == lat else 1.0)
				if i == lat and upper:
					col = skin_col * 0.55   # linha dos cílios
				_v(c + u * rr, u, Vector3(cos(th), 0, sin(th)), Vector3.UP, Vector2(float(k) * 0.02, float(i) * 0.02), col, M_SKIN, HEAD, 1.0)
		for i in lat:
			for k in lon:
				var i00 := start + i * (lon + 1) + k
				_tri(i00, i00 + lon + 1, i00 + 1)
				_tri(i00 + 1, i00 + lon + 1, i00 + lon + 2)


func _eye(c: Vector3, r: float, iris: Color) -> void:
	var lon := 10 if lod == 0 else 6
	var lat := 7 if lod == 0 else 4
	var start := verts.size()
	for i in lat + 1:
		var phi := PI * float(i) / float(lat)
		for k in lon + 1:
			var th := TAU * float(k) / float(lon)
			# eixo do olho aponta para -Z
			var u := Vector3(sin(phi) * cos(th), sin(phi) * sin(th), -cos(phi))
			var p := c + u * r
			var col := Color(0.9, 0.88, 0.84)
			if phi < 0.55:
				col = iris
			if phi < 0.22:
				col = Color(0.02, 0.02, 0.02)
			_v(p, u, Vector3(-sin(th), cos(th), 0), Vector3.UP, Vector2.ZERO, col, M_SKIN, HEAD, 1.0)
	for i in lat:
		for k in lon:
			var i00 := start + i * (lon + 1) + k
			_tri(i00, i00 + lon + 1, i00 + 1)
			_tri(i00 + 1, i00 + lon + 1, i00 + lon + 2)


func _hair(c: Vector3, R: Vector3) -> void:
	var style: String = a.get("hair_style", "short")
	if style == "bald":
		return
	var hc: Color = a.get("hair_color", Color(0.1, 0.08, 0.05))
	var scale := 1.06
	var back_phi := 2.05
	var front_phi := 1.02
	var bump := 0.02
	match style:
		"buzz":
			scale = 1.025
			bump = 0.005
			hc = hc.lerp(skin_col, 0.35)
		"messy":
			scale = 1.08
			bump = 0.07
		"long":
			back_phi = 2.35
			scale = 1.07
		"ponytail", "bun":
			scale = 1.05
			front_phi = 0.95
	var LAT := 8 if lod == 0 else 5
	var LON := 20 if lod == 0 else 12
	var grid: Array = []
	for i in LAT + 1:
		var row: Array = []
		for k in LON + 1:
			var th := TAU * float(k) / float(LON)
			var frontness := -sin(th)
			var side := absf(cos(th))
			var phimax := lerpf(back_phi, front_phi, (frontness + 1.0) * 0.5)
			phimax = lerpf(phimax, 1.45, side * 0.6 * (1.0 if frontness < 0.3 else 0.3))
			var phi := phimax * float(i) / float(LAT)
			var n := Util.hash2(i, k % LON, int(a.get("seed", 0)) + 77)
			var bumpv := 1.0 + (float(n % 1000) / 1000.0 - 0.5) * bump
			var sc := scale * bumpv
			if i == LAT:
				sc = 1.005
			var ux := sin(phi) * cos(th)
			var uy := cos(phi)
			var uz := sin(phi) * sin(th)
			var p := Vector3(ux * R.x, uy * R.y, uz * R.z * (1.07 if uz > 0.0 else 1.0)) * sc
			if uy < 0.0:
				p.x *= 1.0 - 0.2 * (-uy)
			var col := hc * (0.9 + float(n % 100) / 500.0)
			row.append([c + p, col, M_CLOTH, 0.0, 0.0, Vector2(th * 0.05, phi * 0.2)])
		grid.append(row)
	_emit_grid(grid, c, HEAD, JAW, NECK)
	match style:
		"long":
			var top := c + Vector3(0, -0.02 * s, 0.075 * s)
			var bot := Vector3(0, j[NECK].y - 0.1 * s, 0.1 * s)
			_tube(top, bot, [[0.0, 0.085, 0.045, hc, M_CLOTH], [0.6, 0.09, 0.04, hc, M_CLOTH], [1.0, 0.07, 0.025, hc, M_CLOTH]], 10 if lod == 0 else 6, HEAD, CHEST, -1, false, true, 0.0, 0.8, false)
		"ponytail":
			var top := c + Vector3(0, 0.02 * s, 0.1 * s)
			var bot := c + Vector3(0, -0.2 * s, 0.14 * s)
			_tube(top, bot, [[0.0, 0.025, 0.025, hc, M_CLOTH], [0.3, 0.03, 0.03, hc, M_CLOTH], [1.0, 0.012, 0.012, hc, M_CLOTH]], 8 if lod == 0 else 5, HEAD, NECK, -1, true, true, 0.0, 0.5, false)
		"bun":
			_ellipsoid(c + Vector3(0, 0.05 * s, 0.1 * s), Vector3(0.045, 0.04, 0.04) * s, hc, M_CLOTH, HEAD, 1.0)


func _glasses(c: Vector3, R: Vector3) -> void:
	var col := Color(0.08, 0.08, 0.09)
	for sgn: float in [-1.0, 1.0]:
		var ec := c + Vector3(sgn * 0.034 * s, 0.016 * s, -R.z * 1.02)
		var segs := 10 if lod == 0 else 6
		var prev := -1
		var first := -1
		for k in segs + 1:
			var th := TAU * float(k) / float(segs)
			var p := ec + Vector3(cos(th) * 0.022 * s, sin(th) * 0.015 * s, 0)
			var p2 := p + Vector3(0, 0, 0.004 * s)
			var i0 := _v(p, Vector3(0, 0, -1), Vector3.RIGHT, Vector3.UP, Vector2.ZERO, col, M_LEATHER, HEAD, 1.0)
			var i1 := _v(p2 + (p - ec).normalized() * 0.003 * s, (p - ec).normalized(), Vector3.RIGHT, Vector3.UP, Vector2.ZERO, col, M_LEATHER, HEAD, 1.0)
			if prev >= 0:
				_tri(prev, i0, prev + 1)
				_tri(prev + 1, i0, i1)
			prev = i0
		# haste
		var hinge := ec + Vector3(sgn * 0.022 * s, 0, 0)
		var ear := c + Vector3(sgn * R.x * 1.02, 0.005 * s, 0.01 * s)
		_tube(hinge, ear, [[0.0, 0.002, 0.003, col, M_LEATHER], [1.0, 0.002, 0.003, col, M_LEATHER]], 4, HEAD, -1, -1, false, false, 0.0, 0.0, false)


func _hat(c: Vector3, R: Vector3, kind: String) -> void:
	var col: Color = a.get("hat_color", Color(0.1, 0.1, 0.1))
	var scale := 1.13
	var mat := M_CLOTH
	if kind == "helmet":
		scale = 1.2
		mat = M_LEATHER
	var LAT := 5
	var LON := 16 if lod == 0 else 10
	var grid: Array = []
	for i in LAT + 1:
		var row: Array = []
		var phi := 1.5 * float(i) / float(LAT)
		for k in LON + 1:
			var th := TAU * float(k) / float(LON)
			var p := Vector3(sin(phi) * cos(th) * R.x, cos(phi) * R.y, sin(phi) * sin(th) * R.z * 1.05) * scale
			row.append([c + p + Vector3(0, 0.012 * s, 0.005 * s), col, mat, 0.0, 0.0, Vector2(th * 0.1, phi * 0.1)])
		grid.append(row)
	_emit_grid(grid, c, HEAD, JAW, NECK)
	if kind == "cap":
		# aba
		var y := c.y + cos(1.5) * R.y * scale + 0.012 * s
		var segs := 8
		var base_i := -1
		var ctr := _v(Vector3(0, y, c.z - R.z * 1.18), Vector3.UP, Vector3.RIGHT, Vector3.BACK, Vector2.ZERO, col, mat, HEAD, 1.0)
		for k in segs + 1:
			var th := PI + PI * float(k) / float(segs)
			var p := Vector3(cos(th) * R.x * 1.15, y, c.z + sin(th) * R.z * 1.65)
			var vi := _v(p, Vector3.UP, Vector3.RIGHT, Vector3.BACK, Vector2.ZERO, col, mat, HEAD, 1.0)
			if base_i >= 0:
				_tri(ctr, base_i, vi)
			base_i = vi


func _mask(c: Vector3, R: Vector3) -> void:
	var col := Color(0.62, 0.78, 0.86)
	var LAT := 4
	var LON := 10
	var grid: Array = []
	for i in LAT + 1:
		var row: Array = []
		var phi := lerpf(1.55, 2.55, float(i) / float(LAT))
		for k in LON + 1:
			var th := lerpf(PI * 1.12, PI * 1.88, float(k) / float(LON))
			var ux := sin(phi) * cos(th)
			var uy := cos(phi)
			var uz := sin(phi) * sin(th)
			var p := Vector3(ux * R.x * (1.0 - 0.25 * (-uy)), uy * R.y, uz * R.z) * 1.06
			p.z -= 0.012 * s
			row.append([c + p, col, M_CLOTH, smoothstep(-0.3, -0.6, uy) * 0.7, 0.0, Vector2(th * 0.1, phi * 0.1)])
		grid.append(row)
	_emit_grid(grid, c, HEAD, JAW, NECK)


# ---------------------------------------------------------------------------
# Braços e mãos
# ---------------------------------------------------------------------------
func _arms() -> void:
	var gi := float(a.get("girth", 1.0))
	var fem: bool = a.get("female", false)
	var g := gi * (0.86 if fem else 1.0)
	var top: String = a.get("top", "tshirt")
	var tc: Color = a.get("top_color", Color.GRAY)
	var sk := skin_col
	var sides := 10 if lod == 0 else 6
	var loose := 0.012 if top in ["jacket", "hoodie", "labcoat"] else 0.0
	for side: int in [0, 1]:
		var ua := UARM_L if side == 0 else UARM_R
		var fa := FARM_L if side == 0 else FARM_R
		var hd := HAND_L if side == 0 else HAND_R
		var sh: Vector3 = j[ua]
		var el: Vector3 = j[fa]
		var wr: Vector3 = j[hd]
		var upper_rings: Array
		var fore_rings: Array
		match top:
			"tshirt", "gown":
				upper_rings = [[0.0, 0.062 * g, 0.058 * g, tc, M_CLOTH], [0.45, 0.056 * g, 0.052 * g, tc, M_CLOTH],
					[0.46, 0.047 * g, 0.045 * g, sk, M_SKIN], [0.8, 0.043 * g, 0.041 * g, sk, M_SKIN], [1.0, 0.039 * g, 0.038 * g, sk, M_SKIN]]
				fore_rings = [[0.0, 0.039 * g, 0.038 * g, sk, M_SKIN], [0.25, 0.041 * g, 0.037 * g, sk, M_SKIN], [1.0, 0.026 * g, 0.021 * g, sk, M_SKIN]]
			"vest_only":
				upper_rings = [[0.0, 0.05 * g, 0.048 * g, sk, M_SKIN], [1.0, 0.039 * g, 0.038 * g, sk, M_SKIN]]
				fore_rings = [[0.0, 0.039 * g, 0.038 * g, sk, M_SKIN], [1.0, 0.026 * g, 0.021 * g, sk, M_SKIN]]
			_:
				var l := loose
				upper_rings = [[0.0, 0.06 * g + l, 0.057 * g + l, tc, M_CLOTH], [0.5, 0.052 * g + l, 0.05 * g + l, tc, M_CLOTH], [1.0, 0.044 * g + l, 0.043 * g + l, tc, M_CLOTH]]
				fore_rings = [[0.0, 0.044 * g + l, 0.043 * g + l, tc, M_CLOTH], [0.3, 0.043 * g + l, 0.04 * g + l, tc, M_CLOTH],
					[0.9, 0.032 * g + l, 0.028 * g + l, tc, M_CLOTH], [0.91, 0.026 * g, 0.022 * g, sk, M_SKIN], [1.0, 0.026 * g, 0.021 * g, sk, M_SKIN]]
		# deltoide: o braço nasce dentro do ombro e engrossa logo abaixo dele
		var inward := Vector3(0.018 * s if side == 0 else -0.018 * s, 0.0, 0.0)
		var ur2: Array = []
		for rg in upper_rings:
			var rgd: Array = (rg as Array).duplicate()
			var tt: float = rgd[0]
			var bulge := 1.0 + 0.12 * exp(-pow((tt - 0.16) / 0.12, 2.0))
			if tt < 0.001:
				bulge = 0.72   # topo arredondado, escondido dentro do ombro
			rgd[1] = float(rgd[1]) * bulge
			rgd[2] = float(rgd[2]) * (1.0 + (bulge - 1.0) * 0.6)
			ur2.append(rgd)
		_tube(sh + inward + Vector3(0, -0.012 * s, 0), el, ur2, sides, ua, fa, CHEST, true, false, 0.3, 0.3)
		_tube(el, wr, fore_rings, sides, fa, hd, ua, false, false, 0.25, 0.3)
		_hand(wr, hd, side == 0)


func _hand(wr: Vector3, bone: int, left: bool) -> void:
	var gloves: bool = a.get("gloves", false)
	var col := Color(0.12, 0.12, 0.12) if gloves else skin_col
	var mat := M_LEATHER if gloves else M_SKIN
	var dir := Vector3(0.12 if not left else -0.12, -1.0, 0.0).normalized()
	var end := wr + dir * 0.18 * s
	var fem: bool = a.get("female", false)
	var hs := 0.9 if fem else 1.0
	var sides := 8 if lod == 0 else 5
	if lod == 0:
		# palma + quatro dedos levemente curvados
		var palm_end := wr + dir * 0.1 * s
		_tube(wr, palm_end, [[0.0, 0.021 * hs, 0.027 * hs, col, mat], [0.4, 0.019 * hs, 0.043 * hs, col, mat], [1.0, 0.016 * hs, 0.044 * hs, col, mat]],
			sides, bone, -1, -1, false, true, 0.0, 0.0, false)
		for f in 4:
			var zf := (-0.027 + float(f) * 0.018) * s * hs
			var base := palm_end + Vector3(0, 0.004 * s, zf)
			var flen: float = [0.07, 0.078, 0.074, 0.06][f] * s * hs
			var mid := base + dir * flen * 0.55 + Vector3((0.004 if not left else -0.004), 0, 0)
			var tip := mid + (dir + Vector3((0.25 if not left else -0.25), 0, 0)).normalized() * flen * 0.45
			_tube(base, mid, [[0.0, 0.0085 * hs, 0.0085 * hs, col, mat], [1.0, 0.0075 * hs, 0.0075 * hs, col, mat]], 5, bone, -1, -1, false, false, 0.0, 0.0, false)
			_tube(mid, tip, [[0.0, 0.0075 * hs, 0.0075 * hs, col, mat], [1.0, 0.006 * hs, 0.006 * hs, col, mat]], 5, bone, -1, -1, false, true, 0.0, 0.0, false)
	else:
		_tube(wr, end, [[0.0, 0.021 * hs, 0.027 * hs, col, mat], [0.3, 0.019 * hs, 0.044 * hs, col, mat], [0.55, 0.017 * hs, 0.045 * hs, col, mat],
			[0.85, 0.013 * hs, 0.038 * hs, col, mat], [1.0, 0.009 * hs, 0.028 * hs, col, mat]], sides, bone, -1, -1, false, true, 0.0, 0.0, false)
	# polegar
	var tb := wr + dir * 0.05 * s + Vector3(0, 0, -0.025 * s)
	var tt := tb + Vector3(0.01 if not left else -0.01, -0.04, -0.035).normalized() * 0.055 * s
	_tube(tb, tt, [[0.0, 0.012 * hs, 0.012 * hs, col, mat], [1.0, 0.008 * hs, 0.008 * hs, col, mat]], 5 if lod == 0 else 4, bone, -1, -1, false, true, 0.0, 0.0, false)


# ---------------------------------------------------------------------------
# Pernas e calçados
# ---------------------------------------------------------------------------
func _legs() -> void:
	var gi := float(a.get("girth", 1.0))
	var fem: bool = a.get("female", false)
	var bottom: String = a.get("bottom", "jeans")
	var bc: Color = a.get("bottom_color", Color.DARK_BLUE)
	var bm := M_DENIM if bottom == "jeans" else M_CLOTH
	var sk := skin_col
	var sides := 10 if lod == 0 else 6
	var g := gi
	for side: int in [0, 1]:
		var th_b := THIGH_L if side == 0 else THIGH_R
		var sh_b := SHIN_L if side == 0 else SHIN_R
		var ft_b := FOOT_L if side == 0 else FOOT_R
		var hip: Vector3 = j[th_b]
		var knee: Vector3 = j[sh_b]
		var ankle: Vector3 = j[ft_b]
		var thr := 0.088 * g * (1.08 if fem else 1.0)
		var thigh_rings := [[0.0, thr, thr, bc, bm], [0.3, thr * 0.9, thr * 0.94, bc, bm], [0.7, 0.064 * g, 0.066 * g, bc, bm], [1.0, 0.054 * g, 0.056 * g, bc, bm]]
		var shin_rings: Array
		if bottom == "shorts":
			thigh_rings = [[0.0, thr, thr, bc, bm], [0.45, thr * 0.88, thr * 0.9, bc, bm], [0.46, thr * 0.8, thr * 0.82, sk, M_SKIN], [1.0, 0.05 * g, 0.052 * g, sk, M_SKIN]]
			shin_rings = [[0.0, 0.05 * g, 0.052 * g, sk, M_SKIN], [0.3, 0.052 * g, 0.06 * g, sk, M_SKIN, 0.01], [1.0, 0.03 * g, 0.032 * g, sk, M_SKIN]]
		else:
			var flare := 0.004 if bottom == "jeans" else 0.0
			shin_rings = [[0.0, 0.055 * g, 0.057 * g, bc, bm], [0.3, 0.056 * g, 0.061 * g, bc, bm, 0.006], [0.85, 0.043 * g + flare, 0.045 * g + flare, bc, bm], [1.0, 0.044 * g + flare, 0.046 * g + flare, bc, bm]]
		_tube(hip + Vector3(0, 0.05 * s, 0), knee, thigh_rings, sides, th_b, sh_b, HIPS, false, false, 0.25, 0.3)
		_tube(knee, ankle + Vector3(0, 0.01 * s, 0), shin_rings, sides, sh_b, ft_b, th_b, false, false, 0.3, 0.3)
		_foot(ankle, ft_b, sh_b)


func _foot(ankle: Vector3, bone: int, parent: int) -> void:
	var shoes: String = a.get("shoes", "sneakers")
	var col: Color = a.get("shoes_color", Color(0.2, 0.2, 0.2))
	var mat := M_LEATHER
	if shoes == "barefoot":
		col = skin_col
		mat = M_SKIN
	var heel := Vector3(ankle.x, 0.055 * s, ankle.z + 0.045 * s)
	var toe := Vector3(ankle.x, 0.035 * s, ankle.z - 0.17 * s)
	var h := 0.058 if shoes == "boots" else 0.048
	var w := 0.047 if shoes != "barefoot" else 0.04
	var sides := 10 if lod == 0 else 6
	# loft ao longo de -Z; "frente" do anel aponta para cima
	var rings := [[0.0, w * 0.75, h * 0.9, col, mat], [0.25, w * 0.9, h, col, mat], [0.65, w, h * 0.7, col, mat], [1.0, w * 0.7, h * 0.45, col, mat]]
	_tube(heel, toe, rings, sides, bone, -1, parent, true, true, 0.3, 0.0, false)
	if shoes == "boots":
		_tube(ankle + Vector3(0, -0.03 * s, 0.005 * s), ankle + Vector3(0, 0.1 * s, 0.0), [[0.0, 0.05, 0.055, col, mat], [1.0, 0.047, 0.05, col, mat]], sides, bone, parent, -1, false, false, 0.0, 0.5, false)


# ---------------------------------------------------------------------------
# Extras: mochila, colchonete, crescimentos fúngicos
# ---------------------------------------------------------------------------
func _clothing_extras() -> void:
	if bool(a.get("backpack", false)):
		var bc: Color = a.get("backpack_color", Color(0.2, 0.2, 0.2))
		var bw := float(a.get("build", 1.0))
		var zb := 0.115 * s * lerpf(1.0, float(a.get("girth", 1.0)), 0.6) + 0.07 * s
		var top := Vector3(0, 1.47 * s, zb)
		var bot := Vector3(0, 1.02 * s, zb + 0.01 * s)
		var sides := 12 if lod == 0 else 8
		_tube(top, bot, [[0.0, 0.1 * bw, 0.05, bc, M_CLOTH], [0.08, 0.14 * bw, 0.07, bc, M_CLOTH], [0.5, 0.15 * bw, 0.085, bc, M_CLOTH],
			[0.92, 0.14 * bw, 0.075, bc, M_CLOTH], [1.0, 0.1 * bw, 0.05, bc, M_CLOTH]], sides, CHEST, -1, SPINE, true, true, 0.0, 0.0, false)
		# bolso frontal
		_tube(Vector3(0, 1.26 * s, zb + 0.08 * s), Vector3(0, 1.1 * s, zb + 0.085 * s), [[0.0, 0.09 * bw, 0.025, bc.darkened(0.15), M_CLOTH],
			[0.5, 0.1 * bw, 0.035, bc.darkened(0.15), M_CLOTH], [1.0, 0.09 * bw, 0.025, bc.darkened(0.15), M_CLOTH]], sides, CHEST, -1, -1, true, true, 0.0, 0.0, false)
		# alças
		var strap := Color(0.08, 0.08, 0.08)
		for sgn: float in [-1.0, 1.0]:
			var p0 := Vector3(sgn * 0.08 * bw * s, 1.45 * s, zb - 0.02 * s)
			var p1 := Vector3(sgn * 0.11 * bw * s, 1.49 * s, 0.0)
			var p2 := Vector3(sgn * 0.12 * bw * s, 1.36 * s, -0.12 * s)
			var p3 := Vector3(sgn * 0.13 * bw * s, 1.15 * s, -0.1 * s)
			_tube(p0, p1, [[0.0, 0.022, 0.006, strap, M_LEATHER], [1.0, 0.022, 0.006, strap, M_LEATHER]], 4, CHEST, -1, -1, false, false, 0.0, 0.0, false)
			_tube(p1, p2, [[0.0, 0.022, 0.006, strap, M_LEATHER], [1.0, 0.022, 0.006, strap, M_LEATHER]], 4, CHEST, -1, -1, false, false, 0.0, 0.0, false)
			_tube(p2, p3, [[0.0, 0.022, 0.006, strap, M_LEATHER], [1.0, 0.022, 0.006, strap, M_LEATHER]], 4, CHEST, -1, SPINE, false, false, 0.0, 0.0, false)
		if bool(a.get("bedroll", false)):
			var rc := Color(0.35, 0.3, 0.2)
			_tube(Vector3(-0.17 * s, 1.52 * s, zb), Vector3(0.17 * s, 1.52 * s, zb), [[0.0, 0.055, 0.055, rc, M_CLOTH], [0.1, 0.06, 0.06, rc, M_CLOTH],
				[0.9, 0.06, 0.06, rc, M_CLOTH], [1.0, 0.055, 0.055, rc, M_CLOTH]], 10 if lod == 0 else 6, CHEST, -1, -1, true, true, 0.0, 0.0, false)


func _growths(amount: float) -> void:
	var count := int(4 + amount * 14)
	var col := Color(0.55, 0.5, 0.36)
	for i in count:
		var pick := rng.randf()
		var c: Vector3
		var bone: int
		var r := rng.randf_range(0.02, 0.055) * s * (0.6 + amount * 0.6)
		if pick < 0.45:
			c = Vector3(rng.randf_range(-0.14, 0.14), rng.randf_range(1.15, 1.45), 0.11) * s
			bone = CHEST
		elif pick < 0.7:
			var sgn := -1.0 if rng.randf() < 0.5 else 1.0
			c = Vector3(sgn * rng.randf_range(0.15, 0.22), rng.randf_range(1.38, 1.5), rng.randf_range(-0.04, 0.06)) * s
			bone = UARM_L if sgn < 0.0 else UARM_R
		elif pick < 0.9:
			var hc: Vector3 = j[HEAD]
			c = hc + Vector3(rng.randf_range(-0.07, 0.07), rng.randf_range(0.1, 0.2), rng.randf_range(-0.02, 0.1)) * s
			bone = HEAD
		else:
			c = Vector3(rng.randf_range(-0.12, 0.12), rng.randf_range(1.0, 1.1), 0.1) * s
			bone = SPINE
		var gc := col.lerp(Color(0.35, 0.28, 0.22), rng.randf())
		_ellipsoid(c, Vector3(r, r * rng.randf_range(0.7, 1.2), r * 0.8), gc, M_LEATHER, bone, 1.0, 0, 0.0, 6 if lod == 0 else 5, 4)
