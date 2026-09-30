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
const EYE_SX := 1.1       # globo ocular mais largo que alto (esclera aparece dos lados)
## Decote em V do jaleco: limiar de sin(ângulo) da camisa aparente por anel.
const LABCOAT_V := {1.26: 0.975, 1.35: 0.93, 1.42: 0.875, 1.47: 0.8, 1.51: 0.72}

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
var tr: Array = []           # anéis do tronco (para o HumanoidDetails colar detalhes)
var _tpl: HeadTemplate
var _hc := Vector3.ZERO     # centro da cabeça no espaço do modelo
var _hsc: float = 1.0       # escala da cabeça


# ---------------------------------------------------------------------------
# API
# ---------------------------------------------------------------------------
static func compute_joints(ap: Dictionary) -> Array:
	if str(ap.get("model", "")) == "caio_glb":
		return CaioModel.joints()
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
	jt[HEAD] = Vector3(0, 1.585, -0.005 + hunch * 0.02)
	jt[JAW] = Vector3(0, 1.63, -0.02 + hunch * 0.02)
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
	if str(ap.get("model", "")) == "caio_glb":
		return CaioModel.build_mesh()
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
	# tons escuros saturam demais no tonemap ACES: puxa levemente para o marrom neutro
	skin_col.g = maxf(skin_col.g, skin_col.r * 0.8)
	skin_col.b = maxf(skin_col.b, skin_col.r * 0.66)
	tear = float(a.get("tear", 0.0))
	var inf := float(a.get("infected", 0.0))
	if inf > 0.0:
		skin_col = skin_col.lerp(Color(0.6, 0.62, 0.58), inf * 0.35)

	_torso()
	HumanoidDetails.new(self).top_details()
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
		cap0: bool, cap1: bool, blend0: float = 0.25, blend1: float = 0.25, clothing: bool = true, uv_off: Vector2 = Vector2.ZERO) -> void:
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
	var nr := rings.size()
	for ri in nr:
		var r: Array = rings[ri]
		var t: float = r[0]
		var rx: float = float(r[1]) * s
		var rz: float = float(r[2]) * s
		var col: Color = r[3]
		var mat: float = r[4]
		var off: float = float(r[5]) * s if r.size() > 5 else 0.0
		var center := pa + axis * (t * length) + fwd * off
		# derivadas ao longo do eixo (diferença central) => normais que acompanham o afunilamento
		var ra: Array = rings[maxi(ri - 1, 0)]
		var rb: Array = rings[mini(ri + 1, nr - 1)]
		var dl := maxf((float(rb[0]) - float(ra[0])) * length, 0.0001)
		var drx := (float(rb[1]) - float(ra[1])) * s
		var drz := (float(rb[2]) - float(ra[2])) * s
		var doff := ((float(rb[5]) if rb.size() > 5 else 0.0) - (float(ra[5]) if ra.size() > 5 else 0.0)) * s
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
			var tg := -side * (st * rx) + fwd * (ct * rz)
			var ta := axis * dl + side * (ct * drx) + fwd * (st * drz + doff)
			var n := tg.cross(ta)
			var radial := side * ct * rx + fwd * st * rz
			if n.dot(radial) < 0.0:
				n = -n
			if n.length_squared() < 0.0000001:
				n = radial
			var vc := col
			var vm := mat
			if clothing and mat > 0.1 and _torn(p):
				vc = skin_col
				vm = M_SKIN
			_v(p, n, tg, axis, Vector2(th * circ, t * length) + uv_off, vc, vm, bone, ws, maxi(child, 0), wc, maxi(parent, 0), wp)
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
		[1.49, 0.128 - (0.011 if fem else 0.0), 0.084, 0.01],
		[1.51, 0.098 - (0.01 if fem else 0.0), 0.078, 0.01],
		[1.5225, 0.085 - (0.009 if fem else 0.0), 0.0715, 0.0075],
		[1.535, 0.07 - (0.008 if fem else 0.0), 0.064, 0.005],
	]
	var waist_y := 1.0
	var hem_y := waist_y
	if top in ["jacket", "hoodie"]:
		hem_y = 0.9
	elif top in ["labcoat", "gown"]:
		hem_y = 0.84
	if top == "labcoat":
		# anel extra logo abaixo da camisa aparente => borda inferior nítida
		prof.insert(5, [1.25, lerpf(float(prof[4][1]), float(prof[5][1]), 0.9), lerpf(float(prof[4][2]), float(prof[5][2]), 0.9), lerpf(float(prof[4][3]), float(prof[5][3]), 0.9)])
	var sides := 24 if lod == 0 else 10
	# ângulos do anel: uniformes + pares colados nas bordas das faixas frontais
	# (camisa sob a jaqueta/jaleco), para a troca de cor ser nítida
	var ths: Array = []
	for k in sides + 1:
		ths.append(TAU * float(k) / float(sides))

	var nth := ths.size()
	var ring_start: Array = []
	var sc := s
	for ri in prof.size():
		var r: Array = prof[ri]
		var y: float = float(r[0]) * sc
		var yy: float = r[0]
		var is_top := yy >= hem_y - 0.001
		var rx: float = float(r[1]) * bw * sc
		var rz: float = float(r[2]) * sc * lerpf(1.0, gi, 0.6)
		if ri == prof.size() - 1:
			# anel do topo fica por dentro do pescoço (que vem do molde da cabeça)
			rx = (0.066 if fem else 0.075) * sc
			rz = (0.061 if fem else 0.069) * sc
		if is_top and yy > 0.95:
			rx += loose * sc
			rz += loose * sc
		var zoff: float = float(r[3]) * sc
		# a queda do trapézio só vale para anéis largos (ombros); o anel do pescoço fica nivelado
		var wk := smoothstep(0.07, 0.15, float(r[1]))
		# decote: a frente do último anel desce (camisetas/camisas/jaleco); jaquetas têm gola própria
		var dip := (0.024 * sc if top in ["tshirt", "longsleeve", "shirt", "labcoat", "gown"] else 0.0) * smoothstep(1.49, 1.54, yy)
		tr.append({"yy": yy, "y": y, "rx": rx, "rz": rz, "zoff": zoff, "wk": wk, "dip": dip})
		# pesos por altura
		var w_h := 1.0 - smoothstep(0.98, 1.12, yy)
		var w_c := smoothstep(1.18, 1.3, yy)
		var w_sp := 1.0 - w_h - w_c
		var w_n := smoothstep(1.49, 1.54, yy) * 0.6
		var start := verts.size()
		ring_start.append(start)
		var circ := (rx + rz) * 0.5
		for k in nth:
			var th: float = ths[k]
			var ct := cos(th)
			var st := sin(th)
			var p := Vector3(ct * rx, y, -st * rz + zoff)
			# trapézio: a linha dos ombros desce do pescoço até o acrômio
			var drop := smoothstep(1.36, 1.515, yy) * pow(absf(ct), 1.5) * 0.052 * sc * (0.85 if fem else 1.0) * wk
			p.y -= drop + dip * smoothstep(0.0, 0.85, st)
			# trapézio sobe pela nuca: a gola de trás fica mais alta que a da frente
			p.y += smoothstep(1.44, 1.51, yy) * maxf(0.0, -st) * 0.026 * sc
			var n := Vector3(ct / maxf(rx, 0.001), 0.0, -st / maxf(rz, 0.001))
			if yy > 1.44:
				n.y += 0.6 + drop * 8.0
			if yy < 0.86:
				n.y -= 0.6
			var tg := Vector3(-st * rx, 0.0, -ct * rz)
			var col := tc if is_top else bc
			var mat := top_mat if is_top else bot_mat

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
		for k in nth - 1:
			_tri(r0 + k, r1 + k, r0 + k + 1)
			_tri(r0 + k + 1, r1 + k, r1 + k + 1)
	# tampa inferior (virilha)
	var bcol := bc
	_cap(ring_start[0], nth - 1, Vector3(0, 0.83 * sc, 0), Vector3.DOWN, bcol, bot_mat, HIPS, HIPS)

	# jaleco / camisola hospitalar: saia até os joelhos que acompanha as coxas
	if top in ["labcoat", "gown"]:
		_coat_skirt(tc, 0.55 if top == "labcoat" else 0.6)
	if bool(a.get("vest", false)):
		_vest(a.get("vest_color", Color(0.1, 0.1, 0.1)))


func _coat_skirt(col: Color, bottom_y: float) -> void:
	var sides := 18 if lod == 0 else 10
	var bw := float(a.get("build", 1.0))
	var ys := [0.97, 0.9, 0.8, 0.7, bottom_y]
	var ring_start: Array = []
	for ri in ys.size():
		var yy: float = ys[ri]
		var t := float(ri) / float(ys.size() - 1)
		# o anel de cima fica rente ao tronco (0,162 + folga) e depois abre
		var rx := lerpf(0.172, 0.24, smoothstep(0.0, 1.0, t)) * bw * s
		var rz := lerpf(0.11, 0.155, smoothstep(0.0, 1.0, t)) * s
		# largura mínima: cobre o topo das coxas (senão a calça aparece pelos lados)
		var fem_k: bool = a.get("female", false)
		var thigh_out := (0.095 * bw * (1.06 if fem_k else 1.0) + 0.088 * float(a.get("girth", 1.0)) * (1.08 if fem_k else 1.0) * 1.06 + 0.014) * s
		rx = maxf(rx, thigh_out)
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
	# colete/porta-placas: acompanha o contorno do tronco (folga de 1,8 cm) e afina rumo aos ombros
	var det := HumanoidDetails.new(self)
	var ys := [1.02, 1.1, 1.2, 1.3, 1.39, 1.45]
	var sides := 20 if lod == 0 else 10
	var ring_start: Array = []
	for ri in ys.size():
		var yy: float = ys[ri]
		var rr: Dictionary = det._ring_at(yy) if not tr.is_empty() else {"y": yy * s, "rx": 0.16 * s, "rz": 0.1 * s, "zoff": 0.0}
		var taper := 1.0 - 0.28 * smoothstep(1.36, 1.46, yy)
		var rx := (float(rr["rx"]) + 0.018 * s) * taper
		var rz := float(rr["rz"]) + 0.018 * s
		var w_h := 1.0 - smoothstep(0.98, 1.12, yy)
		var w_c := smoothstep(1.18, 1.3, yy)
		var start := verts.size()
		ring_start.append(start)
		for k in sides + 1:
			var th := TAU * float(k) / float(sides)
			var ct := cos(th)
			var st := sin(th)
			# decote do colete: abre um pouco na frente em cima
			var open_v := smoothstep(1.36, 1.46, yy) * smoothstep(0.55, 1.0, st) * 0.03 * s
			var p := Vector3(ct * rx, float(rr["y"]) - open_v, -st * rz + float(rr["zoff"]))
			var n := Vector3(ct / rx, 0.0, -st / rz)
			_v(p, n, Vector3(-st, 0, -ct), Vector3.UP, Vector2(th * rx, yy), col, M_LEATHER, HIPS, w_h, SPINE, 1.0 - w_h - w_c, CHEST, w_c)
	for i in ring_start.size() - 1:
		var r0: int = ring_start[i]
		var r1: int = ring_start[i + 1]
		for k in sides:
			_tri(r0 + k, r1 + k, r0 + k + 1)
			_tri(r0 + k + 1, r1 + k, r1 + k + 1)


func _neck() -> void:
	# O pescoço de pele faz parte do molde da cabeça (HeadTemplate); aqui só a gola
	# (alta e dobrada em jaquetas/moletons; aro canelado nas demais) que esconde o
	# encontro do tecido com a pele.
	var top: String = a.get("top", "tshirt")
	if top == "vest_only":
		return
	var fem: bool = a.get("female", false)
	var gi := float(a.get("girth", 1.0))
	var tc: Color = a.get("top_color", Color.GRAY)
	var sides := 16 if lod == 0 else 8
	if top in ["jacket", "hoodie"]:
		var r := (0.05 if fem else 0.058) * lerpf(1.0, gi, 0.4)
		var base := Vector3(0, j[NECK].y - 0.045 * s, j[NECK].z + 0.004 * s)
		var fold := tc.darkened(0.1)
		var rings := [[0.0, r * 1.6, r * 1.5, tc, M_CLOTH], [0.5, r * 1.42, r * 1.34, tc, M_CLOTH], [0.84, r * 1.32, r * 1.26, tc, M_CLOTH],
			[0.9, r * 1.42, r * 1.34, fold, M_CLOTH], [1.0, r * 1.36, r * 1.29, fold, M_CLOTH]]
		_tube(base, base + Vector3(0, 0.078 * s, -0.004 * s), rings, sides, NECK, -1, CHEST, false, false, 0.5, 0.0)
		return
	return
	var rib := tc.darkened(0.14)
	var b0 := Vector3(0, 1.508 * s, 0.004 * s)
	var rings2 := [[0.0, 0.074 if not fem else 0.066, 0.07 if not fem else 0.062, rib, M_CLOTH], [0.5, 0.07 if not fem else 0.062, 0.066 if not fem else 0.058, rib, M_CLOTH],
		[1.0, 0.067 if not fem else 0.06, 0.063 if not fem else 0.056, rib, M_CLOTH]]
	_tube(b0, b0 + Vector3(0, 0.04 * s, -0.003 * s), rings2, sides, NECK, -1, CHEST, false, false, 0.5, 0.0)


# ---------------------------------------------------------------------------
# Cabeça: molde anatômico (HeadTemplate) + variações individuais
# ---------------------------------------------------------------------------
func _head_center() -> Vector3:
	return j[HEAD] + Vector3(0, 0.069 * s, -0.02 * s)


func _head() -> void:
	var fem: bool = a.get("female", false)
	_tpl = HeadTemplate.get_tpl(fem, lod)
	var tpl := _tpl
	_hsc = s * float(a.get("head_scale", 1.0))
	_hc = _head_center()
	var c := _hc
	var sc := _hsc
	var hr := Util.rng(int(a.get("seed", 0)) * 131 + 7)
	var inf := float(a.get("infected", 0.0))
	var gi := float(a.get("girth", 1.0))
	# traços individuais (mesma semente => mesmo rosto)
	var jaw_k := hr.randf_range(-0.06, 0.08) + (0.03 if not fem and float(a.get("build", 1.0)) > 1.04 else 0.0)
	var nose_k := hr.randf_range(-0.3, 0.35)
	var nosew_k := hr.randf_range(-0.1, 0.18)
	var chin_k := hr.randf_range(-0.25, 0.3)
	var cheek_k := clampf((gi - 1.0) * 1.2, -0.3, 0.6) + hr.randf_range(-0.15, 0.15)
	var face_len := 1.0 + hr.randf_range(-0.03, 0.035)
	var lip_k := hr.randf_range(-0.3, 0.35) + (0.2 if fem else 0.0)
	var brow_k := hr.randf_range(0.0, 0.5) if not fem else 0.0
	var gaunt := inf * 0.7
	var beard := float(a.get("beard", 0.0))
	var hair_col: Color = a.get("hair_color", Color(0.1, 0.08, 0.05))
	var brow_col := hair_col.lerp(Color(0.05, 0.04, 0.03), 0.3) if hair_col.v < 0.6 else hair_col.darkened(0.3)
	var blind: bool = a.get("blind", false)
	var sk := skin_col
	var lip_col := Color(sk.r * 0.86, sk.g * 0.62, sk.b * 0.64).lerp(Color(0.56, 0.3, 0.3), 0.22 if not fem else 0.38)
	if inf > 0.0:
		lip_col = lip_col.lerp(Color(0.35, 0.32, 0.36), inf * 0.7)
	var blush := Color(sk.r * 1.04, sk.g * 0.9, sk.b * 0.88)
	var under_eye := Color(sk.r * 0.85, sk.g * 0.77, sk.b * 0.8)
	var stub := hair_col.lerp(sk * 0.78, 0.5)
	var m_jaw: PackedFloat32Array = tpl.masks[HeadTemplate.MK_JAW]
	var m_lips: PackedFloat32Array = tpl.masks[HeadTemplate.MK_LIPS]
	var m_mouth: PackedFloat32Array = tpl.masks[HeadTemplate.MK_MOUTH]
	var m_brow: PackedFloat32Array = tpl.masks[HeadTemplate.MK_BROW]
	var m_beard: PackedFloat32Array = tpl.masks[HeadTemplate.MK_BEARD]
	var m_nose: PackedFloat32Array = tpl.masks[HeadTemplate.MK_NOSE]
	var m_chin: PackedFloat32Array = tpl.masks[HeadTemplate.MK_CHIN]
	var m_cheek: PackedFloat32Array = tpl.masks[HeadTemplate.MK_CHEEK]
	var m_jawlat: PackedFloat32Array = tpl.masks[HeadTemplate.MK_JAWLAT]
	var m_sock: PackedFloat32Array = tpl.masks[HeadTemplate.MK_SOCKET]
	var m_ear: PackedFloat32Array = tpl.masks[HeadTemplate.MK_EAR]
	var m_neck: PackedFloat32Array = tpl.masks[HeadTemplate.MK_NECK]
	var rows := tpl.lat + 1
	var cn := tpl.lon + 1
	var P := PackedVector3Array()
	P.resize(rows * cn)
	var C := PackedColorArray()
	C.resize(rows * cn)
	var bstub := beard < 0.6
	var bamt := clampf(beard * 1.5, 0.0, 1.0) * (0.55 if bstub else 0.88)
	for idx in rows * cn:
		var p: Vector3 = tpl.pos[idx]
		var n: Vector3 = tpl.nrm[idx]
		p.x *= 1.0 + jaw_k * m_jawlat[idx]
		p.z -= nose_k * 0.008 * m_nose[idx] * smoothstep(-0.09, -0.11, p.z)
		p.x *= 1.0 + nosew_k * m_nose[idx] * 0.7
		p += Vector3(0, -0.35, -1.0) * (chin_k * 0.007 * m_chin[idx])
		p += n * ((cheek_k * 0.006 - gaunt * 0.009) * m_cheek[idx])
		p += n * (lip_k * 0.0018 * m_lips[idx])
		p.z -= brow_k * 0.003 * m_brow[idx]
		p -= n * (gaunt * 0.004 * m_sock[idx])
		p.y += (face_len - 1.0) * clampf(p.y, -0.12, 0.0)
		P[idx] = c + p * sc
		var col := sk
		col = col.lerp(blush, clampf(m_cheek[idx] * 0.45 + m_nose[idx] * 0.3 + m_ear[idx] * 0.4, 0.0, 1.0))
		col = col.lerp(under_eye, m_sock[idx] * 0.45)
		col = col.lerp(lip_col, clampf(m_lips[idx] * 1.1, 0.0, 1.0) * 0.6)
		col = col.darkened(m_mouth[idx] * 0.4)
		if beard > 0.0:
			col = col.lerp(stub if bstub else hair_col, m_beard[idx] * bamt)
		col = col.lerp(brow_col, m_brow[idx] * 0.9)
		if inf > 0.0:
			col = col.lerp(Color(0.3, 0.28, 0.3), m_sock[idx] * inf * 0.6)
		col = col * lerpf(1.0, tpl.ao[idx], 0.6)
		C[idx] = col
	# normais da grade deformada + pesos (cabeça / mandíbula / pescoço / peito)
	var idxs := PackedInt32Array()
	idxs.resize(rows * cn)
	for i in rows:
		for k in cn:
			var idx := i * cn + k
			var kp := (k + 1) % (cn - 1)
			var km := (k - 1 + cn - 1) % (cn - 1)
			var tg := P[i * cn + kp] - P[i * cn + km]
			var bd := P[mini(i + 1, rows - 1) * cn + k] - P[maxi(i - 1, 0) * cn + k]
			var nn := tg.cross(bd)
			var tn: Vector3 = tpl.nrm[idx]
			if nn.length_squared() < 0.00000001:
				nn = tn
			elif nn.dot(tn) < 0.0:
				nn = -nn
			var ry: float = tpl.pos[idx].y
			var wj: float = m_jaw[idx]
			var wn: float = m_neck[idx]
			var wc := smoothstep(-0.2, -0.27, ry)
			var uv := Vector2(tpl.ths[k] * 0.1, tpl.phis[i] * 0.1)
			var vi: int
			if wc > 0.0:
				vi = _v(P[idx], nn, tg, bd, uv, C[idx], M_SKIN, HEAD, 1.0 - wn, NECK, wn * (1.0 - wc), CHEST, wn * wc)
			else:
				var ex := wj + wn
				if ex > 0.95:
					wj *= 0.95 / ex
					wn *= 0.95 / ex
				vi = _v(P[idx], nn, tg, bd, uv, C[idx], M_SKIN, HEAD, 1.0 - wj - wn, JAW, wj, NECK, wn)
			idxs[idx] = vi
	for i in rows - 1:
		for k in cn - 1:
			var i00 := idxs[i * cn + k]
			var i01 := idxs[i * cn + k + 1]
			var i10 := idxs[(i + 1) * cn + k]
			var i11 := idxs[(i + 1) * cn + k + 1]
			_tri(i00, i10, i01)
			_tri(i01, i10, i11)
	# olhos
	if not blind:
		var er := tpl.eye_r * sc
		var iris: Color = [Color(0.42, 0.26, 0.13), Color(0.3, 0.19, 0.1), Color(0.38, 0.48, 0.56), Color(0.4, 0.42, 0.24)][int(a.get("seed", 0)) % 4]
		if inf > 0.5:
			iris = Color(0.75, 0.72, 0.62)
		for sgn: float in [-1.0, 1.0]:
			var ec := c + Vector3(sgn * tpl.eye_c.x, tpl.eye_c.y, tpl.eye_c.z) * sc
			_eye(ec, er, iris)
			_eyelids(ec, er)
	_brows(brow_col, fem)
	_hair()
	if bool(a.get("glasses", false)):
		_glasses()
	var hat: String = a.get("hat", "")
	if hat != "":
		_hat(hat)
	if bool(a.get("mask", false)):
		_mask()


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


## Pálpebras: cascas de pele sobre o globo ocular. A borda de cada pálpebra
## desce até o equador nos cantos, então as duas se encontram e a abertura
## fica amendoada (e não um círculo de "olho de boneco").
func _eyelids(c: Vector3, r: float) -> void:
	var lon := 10 if lod == 0 else 6
	for lid in 2:
		var upper := lid == 0
		var rr := r * (1.12 if upper else 1.06)
		var start := verts.size()
		var lat := 4 if lod == 0 else 3
		for i in lat + 1:
			for k in lon + 1:
				# só a metade da frente (-Z), de lado a lado
				var fk := float(k) / float(lon)
				var th := lerpf(-PI * 0.55, PI * 0.55, fk)
				var edge := lerpf(1.12 if upper else 1.3, 1.64, pow(clampf(absf(th) / (PI * 0.5), 0.0, 1.0), 2.2))
				# canto externo um pouco mais alto que o interno (leve inclinação)
				var a0 := edge * float(i) / float(lat)
				var u := Vector3(sin(a0) * sin(th), cos(a0) * (1.0 if upper else -1.0), -sin(a0) * cos(th))
				u = Vector3(u.x * EYE_SX, u.y, u.z + u.x * u.x * 0.3)
				var col := skin_col * (0.9 if i == lat else 0.97)
				if i == lat and upper:
					col = skin_col * 0.5   # linha dos cílios
				_v(c + u * rr, u, Vector3(cos(th), 0, sin(th)), Vector3.UP, Vector2(float(k) * 0.02, float(i) * 0.02), col, M_SKIN, HEAD, 1.0)
		for i in lat:
			for k in lon:
				var i00 := start + i * (lon + 1) + k
				_tri(i00, i00 + lon + 1, i00 + 1)
				_tri(i00 + 1, i00 + lon + 1, i00 + lon + 2)


func _eye(c: Vector3, r: float, iris: Color) -> void:
	var lon := 12 if lod == 0 else 6
	# anéis explícitos nas bordas da pupila e da íris (bordas nítidas, pupila pequena)
	var rings: Array = [0.0, 0.155, 0.175, 0.3, 0.465, 0.485, 0.7, 1.0, 1.3, 1.7, 2.4, PI] if lod == 0 else [0.0, 0.18, 0.48, 0.9, 1.6, PI]
	var iris_d := iris.darkened(0.35)
	var start := verts.size()
	for i in rings.size():
		var phi: float = rings[i]
		for k in lon + 1:
			var th := TAU * float(k) / float(lon)
			# eixo do olho aponta para -Z
			var u := Vector3(sin(phi) * cos(th), sin(phi) * sin(th), -cos(phi))
			var sx := lerpf(1.0, EYE_SX, smoothstep(0.45, 1.3, phi))
			# as laterais recuam (curva do rosto): nada de esclera saltando no perfil
			var p := c + Vector3(u.x * sx, u.y, u.z + u.x * u.x * 0.3) * r
			var col := Color(0.8, 0.77, 0.72).lerp(Color(0.62, 0.5, 0.48), smoothstep(1.2, 1.57, phi))
			if phi < 0.475:
				col = iris.lerp(iris_d, smoothstep(0.25, 0.45, phi))   # borda da íris mais escura
			if phi < 0.165:
				col = Color(0.02, 0.02, 0.02)
			_v(p, Vector3(u.x / sx, u.y, u.z), Vector3(-sin(th), cos(th), 0), Vector3.UP, Vector2(0, 20), col, M_SKIN, HEAD, 1.0)
	for i in rings.size() - 1:
		for k in lon:
			var i00 := start + i * (lon + 1) + k
			_tri(i00, i00 + lon + 1, i00 + 1)
			_tri(i00 + 1, i00 + lon + 1, i00 + lon + 2)


## Linha do cabelo: phi máximo (a partir do topo) por ângulo em relação à
## frente (0 = testa, ~1,35 = costeleta, ~1,7 = orelha, PI = nuca).
const HAIRLINE := [[0.0, 0.93], [0.5, 0.98], [0.95, 1.12], [1.2, 1.3], [1.32, 1.62], [1.42, 1.6], [1.48, 1.22],
	[1.95, 1.2], [2.08, 1.7], [2.5, 2.15], [PI, 2.3]]


static func _pw(tbl: Array, x: float) -> float:
	for i in tbl.size() - 1:
		var a0: Array = tbl[i]
		var a1: Array = tbl[i + 1]
		if x <= float(a1[0]):
			return lerpf(float(a0[1]), float(a1[1]), smoothstep(float(a0[0]), float(a1[0]), x))
	return float((tbl[tbl.size() - 1] as Array)[1])


## Casca que acompanha a pele do molde: para cada ângulo, phi vai de lo(ang)
## a hi(ang); deslocada `thick(ang, v, k, i)` ao longo da normal da pele.
func _shell(th0: float, th1: float, cols_n: int, rows_n: int, lo: Callable, hi: Callable, thick: Callable, col: Callable,
		mat: float, jaw_follow: float = 0.0, uv_flag: float = 0.0) -> void:
	var grid: Array = []
	for i in rows_n + 1:
		var row: Array = []
		var v := float(i) / float(rows_n)
		for k in cols_n + 1:
			var th := lerpf(th0, th1, float(k) / float(cols_n))
			var ang := absf(angle_difference(th, HeadTemplate.TH_FRONT))
			var phi := lerpf(float(lo.call(ang)), float(hi.call(ang)), v)
			var smp := _tpl.sample(phi, th)
			var p: Vector3 = smp[0]
			var n: Vector3 = smp[1]
			var t: float = thick.call(ang, v, k, i)
			var cc: Color = col.call(k, i, v)
			row.append([_hc + (p + n * t) * _hsc, cc, mat, float(smp[2]) * jaw_follow, 0.0, Vector2(th * 0.1, phi * 0.1 + uv_flag)])
		grid.append(row)
	_emit_grid(grid, _hc, HEAD, JAW, NECK)


## Sobrancelhas: fitas finas de pelo sobre o arco superciliar, seguindo a superfície do
## molde (raio a partir do centro da cabeça), mais grossas no início e afinando na ponta.
func _brows(brow_col: Color, fem: bool) -> void:
	if lod != 0 or _tpl == null:
		return
	var inf := float(a.get("infected", 0.0))
	var col := brow_col.lerp(Color(0.32, 0.3, 0.3), inf * 0.7)
	for sgn: float in [-1.0, 1.0]:
		var pts: Array = []
		for k in 6:
			var t := float(k) / 5.0
			var ax := lerpf(0.012, 0.055, t)
			var xb := clampf((ax - 0.034) / 0.022, -1.0, 1.0)
			var yb := 0.0265 + 0.0055 * (1.0 - xb * xb) + (0.003 if fem else 0.0) - 0.006 * t * t
			var surf := _tpl._raycast(Vector3(sgn * ax, yb, -0.25).normalized())
			pts.append(_hc + (surf + Vector3(0, 0.0007, -0.0011)) * _hsc)
		for k in 5:
			var t0 := float(k) / 5.0
			var w0 := lerpf(1.0, 0.45, t0)
			var w1 := lerpf(1.0, 0.45, float(k + 1) / 5.0)
			var thick := 0.0052 if not fem else 0.0038
			_tube(pts[k], pts[k + 1], [[0.0, 0.0022, thick * w0, col, M_SKIN], [1.0, 0.0022, thick * w1, col, M_SKIN]], 4, HEAD, -1, -1, k == 0, k == 4, 0.0, 0.0, false)


func _hair() -> void:
	var style: String = a.get("hair_style", "short")
	if style == "bald":
		return
	var fem: bool = a.get("female", false)
	var hc: Color = a.get("hair_color", Color(0.1, 0.08, 0.05))
	var thick := 0.008
	var bump := 0.003
	var tbl: Array = HAIRLINE.duplicate(true)
	match style:
		"buzz":
			thick = 0.0028
			bump = 0.0
			hc = hc.lerp(skin_col, 0.35)
		"messy":
			thick = 0.012
			bump = 0.008
			tbl[0] = [0.0, 1.03]
			tbl[1] = [0.5, 1.06]
		"long":
			thick = 0.01
			tbl = [[0.0, 0.9], [0.5, 0.96], [0.95, 1.15], [1.3, 1.62], [1.9, 1.85], [2.5, 2.3], [PI, 2.45]]
		"ponytail", "bun":
			thick = 0.0055
			bump = 0.001
	if fem and style in ["short", "ponytail", "bun"]:
		tbl[0] = [0.0, 0.9]
	var seed_v := int(a.get("seed", 0)) + 77
	var hn := 48 if lod == 0 else 16
	var hl := 10 if lod == 0 else 5
	var lo_f := func(_ang: float) -> float: return 0.0
	var hi_f := func(ang: float) -> float: return _pw(tbl, ang)
	# volume: mais alto na coroa, mais baixo (degradê) nas laterais e na nuca, borda que afina
	var vol_top := 1.55 if style in ["short", "messy", "long", "bun", "ponytail"] else 1.0
	var th_f := func(ang: float, v: float, k: int, i: int) -> float:
		var nz := float(Util.hash2(i, k % hn, seed_v) % 1000) / 1000.0 if i > 0 else 0.5
		var crown := lerpf(vol_top, 1.0, smoothstep(0.0, 0.65, v))
		var side := lerpf(1.0, 0.6, smoothstep(0.9, 1.5, ang) * (1.0 - smoothstep(2.2, 2.7, ang)))
		if style == "long":
			side = 1.0
		return (thick + (nz - 0.5) * bump) * crown * side * lerpf(1.0, 0.2, smoothstep(0.7, 1.0, v))
	var col_f := func(k: int, _i: int, v: float) -> Color:
		# listras finas de mechas no sentido do penteado
		var st := float(Util.hash2(k % hn, 3, seed_v) % 1000) / 1000.0
		return hc * (0.8 + st * 0.32) * lerpf(1.0, 0.9, v)
	# UV.y + 10 marca "cabelo" para o shader (fios finos em vez de textura de tecido)
	_shell(HeadTemplate.TH_START, HeadTemplate.TH_START + TAU, hn, hl, lo_f, hi_f, th_f, col_f, M_CLOTH, 0.0, 10.0)
	var c := _hc
	var sc := _hsc
	match style:
		"long":
			var top := c + Vector3(0, -0.01, 0.085) * sc
			var bot := Vector3(0, j[NECK].y - 0.12 * s, j[NECK].z + 0.1 * s)
			_tube(top, bot, [[0.0, 0.07, 0.035, hc, M_CLOTH], [0.35, 0.085, 0.04, hc, M_CLOTH], [1.0, 0.07, 0.022, hc * 0.9, M_CLOTH]], 10 if lod == 0 else 6, HEAD, CHEST, -1, false, true, 0.0, 0.8, false, Vector2(0, 10))
		"ponytail":
			var top := c + Vector3(0, 0.0, 0.1) * sc
			var bot := c + Vector3(0, -0.2, 0.14) * sc
			_tube(top, bot, [[0.0, 0.022, 0.022, hc, M_CLOTH], [0.3, 0.028, 0.028, hc, M_CLOTH], [1.0, 0.01, 0.01, hc, M_CLOTH]], 8 if lod == 0 else 5, HEAD, NECK, -1, true, true, 0.0, 0.5, false, Vector2(0, 10))
		"bun":
			_ellipsoid(c + Vector3(0, 0.055, 0.095) * sc, Vector3(0.042, 0.037, 0.037) * sc, hc, M_CLOTH, HEAD, 1.0)


func _glasses() -> void:
	var col := Color(0.08, 0.08, 0.09)
	var e := _tpl.eye_c
	var sc := _hsc
	for sgn: float in [-1.0, 1.0]:
		var ec := _hc + Vector3(sgn * e.x, e.y + 0.001, e.z - 0.024) * sc
		var segs := 12 if lod == 0 else 6
		var prev := -1
		for k in segs + 1:
			var th := TAU * float(k) / float(segs)
			var p := ec + Vector3(cos(th) * 0.021, sin(th) * 0.0145, 0) * sc
			var p2 := p + Vector3(0, 0, 0.004 * sc)
			var i0 := _v(p, Vector3(0, 0, -1), Vector3.RIGHT, Vector3.UP, Vector2.ZERO, col, M_LEATHER, HEAD, 1.0)
			var i1 := _v(p2 + (p - ec).normalized() * 0.003 * sc, (p - ec).normalized(), Vector3.RIGHT, Vector3.UP, Vector2.ZERO, col, M_LEATHER, HEAD, 1.0)
			if prev >= 0:
				_tri(prev, i0, prev + 1)
				_tri(prev + 1, i0, i1)
			prev = i0
		# haste até o topo da orelha
		var hinge := ec + Vector3(sgn * 0.021, 0.002, 0.003) * sc
		var ear := _hc + Vector3(sgn * 0.075, 0.018, 0.004) * sc
		_tube(hinge, ear, [[0.0, 0.002, 0.003, col, M_LEATHER], [1.0, 0.002, 0.003, col, M_LEATHER]], 4, HEAD, -1, -1, false, false, 0.0, 0.0, false)
	# ponte sobre o nariz
	var b0 := _hc + Vector3(-e.x + 0.019, e.y + 0.004, e.z - 0.024) * sc
	var b1 := _hc + Vector3(e.x - 0.019, e.y + 0.004, e.z - 0.024) * sc
	_tube(b0, b1, [[0.0, 0.0018, 0.0018, col, M_LEATHER], [1.0, 0.0018, 0.0018, col, M_LEATHER]], 4, HEAD, -1, -1, false, false, 0.0, 0.0, false)


func _hat(kind: String) -> void:
	var col: Color = a.get("hat_color", Color(0.1, 0.1, 0.1))
	var mat := M_CLOTH
	var thick := 0.02
	var tbl: Array
	match kind:
		"helmet":
			mat = M_LEATHER
			thick = 0.03
			tbl = [[0.0, 1.05], [1.3, 1.4], [1.8, 1.5], [PI, 1.72]]
		"beanie":
			tbl = [[0.0, 1.1], [1.3, 1.3], [1.7, 1.38], [2.4, 1.7], [PI, 1.78]]
		_:
			tbl = [[0.0, 1.2], [1.2, 1.25], [1.6, 1.3], [2.2, 1.55], [PI, 1.62]]
	var hn := 28 if lod == 0 else 12
	var hl := 6 if lod == 0 else 3
	var lo_f := func(_ang: float) -> float: return 0.0
	var hi_f := func(ang: float) -> float: return _pw(tbl, ang)
	var th_f := func(_ang: float, v: float, _k: int, _i: int) -> float: return thick * lerpf(1.0, 0.85, v)
	var col_f := func(_k: int, _i: int, v: float) -> Color: return col * lerpf(1.0, 0.92, v)
	_shell(HeadTemplate.TH_START, HeadTemplate.TH_START + TAU, hn, hl, lo_f, hi_f, th_f, col_f, mat)
	if kind == "cap":
		# aba: leque à frente, levemente inclinado para baixo
		var segs := 10 if lod == 0 else 6
		for layer in 2:
			var up := 1.0 if layer == 0 else -1.0
			var inner: Array = []
			var outer: Array = []
			for k in segs + 1:
				var f := float(k) / float(segs)
				var th := HeadTemplate.TH_FRONT + lerpf(-0.95, 0.95, f)
				var ang := absf(angle_difference(th, HeadTemplate.TH_FRONT))
				var smp := _tpl.sample(_pw(tbl, ang), th)
				var pe: Vector3 = (smp[0] as Vector3) + (smp[1] as Vector3) * thick
				var reach := 0.068 * sqrt(maxf(0.0, 1.0 - pow(2.0 * f - 1.0, 2.0) * 0.85))
				var po := pe + Vector3(0, -0.012, -reach)
				var off := Vector3(0, 0.0015 * up, 0)
				inner.append(_v(_hc + (pe + off) * _hsc, Vector3.UP * up, Vector3.RIGHT, Vector3.BACK, Vector2.ZERO, col, mat, HEAD, 1.0))
				outer.append(_v(_hc + (po + off) * _hsc, Vector3.UP * up, Vector3.RIGHT, Vector3.BACK, Vector2.ZERO, col * 0.95, mat, HEAD, 1.0))
			for k in segs:
				_tri(inner[k], outer[k], inner[k + 1])
				_tri(inner[k + 1], outer[k], outer[k + 1])


func _mask() -> void:
	var col := Color(0.62, 0.78, 0.86)
	var hn := 12 if lod == 0 else 8
	var hl := 6 if lod == 0 else 4
	var lo_f := func(ang: float) -> float: return 1.56 + ang * 0.1
	var hi_f := func(ang: float) -> float: return 2.5 - ang * 0.45
	var th_f := func(_ang: float, _v2: float, _k: int, _i: int) -> float: return 0.006
	var col_f := func(_k: int, _i: int, v: float) -> Color: return col * lerpf(1.0, 0.94, absf(v - 0.5) * 2.0)
	_shell(HeadTemplate.TH_FRONT - 1.2, HeadTemplate.TH_FRONT + 1.2, hn, hl, lo_f, hi_f, th_f, col_f, M_CLOTH, 0.8)


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
	var sides := 14 if lod == 0 else 7
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
				upper_rings = [[0.0, 0.062 * g, 0.058 * g, tc, M_CLOTH], [0.14, 0.065 * g, 0.06 * g, tc, M_CLOTH], [0.3, 0.059 * g, 0.055 * g, tc, M_CLOTH], [0.45, 0.056 * g, 0.052 * g, tc, M_CLOTH],
					[0.46, 0.047 * g, 0.045 * g, sk, M_SKIN], [0.62, 0.046 * g, 0.044 * g, sk, M_SKIN], [0.82, 0.042 * g, 0.041 * g, sk, M_SKIN], [1.0, 0.039 * g, 0.038 * g, sk, M_SKIN]]
				fore_rings = [[0.0, 0.039 * g, 0.038 * g, sk, M_SKIN], [0.16, 0.043 * g, 0.039 * g, sk, M_SKIN], [0.45, 0.035 * g, 0.03 * g, sk, M_SKIN], [0.85, 0.026 * g, 0.021 * g, sk, M_SKIN], [1.0, 0.025 * g, 0.02 * g, sk, M_SKIN]]
			"vest_only":
				upper_rings = [[0.0, 0.05 * g, 0.048 * g, sk, M_SKIN], [0.14, 0.055 * g, 0.05 * g, sk, M_SKIN], [0.5, 0.046 * g, 0.044 * g, sk, M_SKIN], [1.0, 0.039 * g, 0.038 * g, sk, M_SKIN]]
				fore_rings = [[0.0, 0.039 * g, 0.038 * g, sk, M_SKIN], [0.16, 0.043 * g, 0.039 * g, sk, M_SKIN], [0.45, 0.035 * g, 0.03 * g, sk, M_SKIN], [1.0, 0.025 * g, 0.02 * g, sk, M_SKIN]]
			_:
				var l := loose
				upper_rings = [[0.0, 0.06 * g + l, 0.057 * g + l, tc, M_CLOTH], [0.14, 0.064 * g + l, 0.06 * g + l, tc, M_CLOTH], [0.35, 0.057 * g + l, 0.054 * g + l, tc, M_CLOTH],
					[0.65, 0.05 * g + l, 0.048 * g + l, tc, M_CLOTH], [0.88, 0.046 * g + l, 0.044 * g + l, tc, M_CLOTH], [1.0, 0.045 * g + l * 1.3, 0.043 * g + l * 1.3, tc, M_CLOTH]]
				fore_rings = [[0.0, 0.045 * g + l * 1.3, 0.043 * g + l * 1.3, tc, M_CLOTH], [0.16, 0.046 * g + l, 0.042 * g + l, tc, M_CLOTH], [0.5, 0.038 * g + l, 0.034 * g + l, tc, M_CLOTH],
					[0.86, 0.033 * g + l, 0.029 * g + l, tc, M_CLOTH], [0.9, 0.034 * g + l * 1.4, 0.03 * g + l * 1.4, tc.darkened(0.12), M_CLOTH], [0.91, 0.026 * g, 0.022 * g, sk, M_SKIN], [1.0, 0.025 * g, 0.021 * g, sk, M_SKIN]]
		# deltoide: o braço nasce dentro do ombro e engrossa logo abaixo dele
		var inward := Vector3(0.018 * s if side == 0 else -0.018 * s, 0.0, 0.0)
		var ur2: Array = []
		# cúpula do ombro: anéis acima do início do tubo, fechando em arco
		var r0: Array = upper_rings[0]
		for dome: Array in [[-0.085, 0.2], [-0.06, 0.62], [-0.035, 0.86], [-0.012, 0.97]]:
			var rgd: Array = r0.duplicate()
			rgd[0] = dome[0]
			rgd[1] = float(r0[1]) * float(dome[1])
			rgd[2] = float(r0[2]) * float(dome[1])
			ur2.append(rgd)
		for rg in upper_rings:
			var rgd: Array = (rg as Array).duplicate()
			var tt: float = rgd[0]
			var bulge := 1.0 + 0.04 * exp(-pow((tt - 0.12) / 0.12, 2.0))
			rgd[1] = float(rgd[1]) * bulge
			rgd[2] = float(rgd[2]) * (1.0 + (bulge - 1.0) * 0.6)
			ur2.append(rgd)
		# o tubo do braço passa um pouco do cotovelo: sem fresta quando dobra
		var el_over := el + (el - sh).normalized() * 0.022 * s
		_tube(sh + inward + Vector3(0, -0.026 * s, 0), el_over, ur2, sides, ua, fa, CHEST, true, false, 0.3, 0.3)
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
	var sides := 14 if lod == 0 else 7
	var g := gi
	for side: int in [0, 1]:
		var th_b := THIGH_L if side == 0 else THIGH_R
		var sh_b := SHIN_L if side == 0 else SHIN_R
		var ft_b := FOOT_L if side == 0 else FOOT_R
		var hip: Vector3 = j[th_b]
		var knee: Vector3 = j[sh_b]
		var ankle: Vector3 = j[ft_b]
		var thr := 0.088 * g * (1.08 if fem else 1.0)
		var thigh_rings := [[0.0, thr, thr, bc, bm], [0.16, thr * 1.04, thr * 1.05, bc, bm], [0.5, thr * 0.88, thr * 0.92, bc, bm], [0.82, 0.064 * g, 0.066 * g, bc, bm], [1.0, 0.055 * g, 0.057 * g, bc, bm]]
		var shin_rings: Array
		if bottom == "shorts":
			thigh_rings = [[0.0, thr, thr, bc, bm], [0.45, thr * 0.88, thr * 0.9, bc, bm], [0.46, thr * 0.8, thr * 0.82, sk, M_SKIN], [1.0, 0.05 * g, 0.052 * g, sk, M_SKIN]]
			shin_rings = [[0.0, 0.05 * g, 0.052 * g, sk, M_SKIN], [0.3, 0.052 * g, 0.06 * g, sk, M_SKIN, 0.01], [1.0, 0.03 * g, 0.032 * g, sk, M_SKIN]]
		else:
			var flare := 0.004 if bottom == "jeans" else 0.0
			shin_rings = [[0.0, 0.056 * g, 0.058 * g, bc, bm], [0.26, 0.059 * g, 0.066 * g, bc, bm, 0.009], [0.55, 0.05 * g, 0.054 * g, bc, bm, 0.004], [0.86, 0.041 * g + flare, 0.043 * g + flare, bc, bm], [1.0, 0.044 * g + flare * 1.6, 0.046 * g + flare * 1.6, bc, bm]]
		var knee_over := knee + (knee - hip).normalized() * 0.025 * s
		_tube(hip + Vector3(0, 0.05 * s, 0), knee_over, thigh_rings, sides, th_b, sh_b, HIPS, false, false, 0.25, 0.3)
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
	if shoes != "barefoot" and lod == 0:
		# solado de borracha (bota escura / tênis claro) e detalhes
		var sole := Color(0.07, 0.07, 0.08) if shoes == "boots" else Color(0.86, 0.86, 0.84)
		var hl := Vector3(ankle.x, 0.016 * s, ankle.z + 0.052 * s)
		var tp := Vector3(ankle.x, 0.014 * s, ankle.z - 0.182 * s)
		var srings := [[0.0, w * 0.82, 0.017, sole, M_LEATHER], [0.15, w * 1.04, 0.02, sole, M_LEATHER], [0.85, w * 1.06, 0.02, sole, M_LEATHER], [1.0, w * 0.8, 0.016, sole, M_LEATHER]]
		_tube(hl, tp, srings, 10, bone, -1, parent, true, true, 0.3, 0.0, false)
		var det := HumanoidDetails.new(self)
		if shoes == "boots":
			var lace := Color(0.13, 0.11, 0.09)
			for t: float in [0.3, 0.42, 0.54, 0.66, 0.78]:
				var zt := (ankle.z + 0.045 * s) + t * ((ankle.z - 0.17 * s) - (ankle.z + 0.045 * s))
				var yt := lerpf(0.108, 0.061, (t - 0.25) / 0.75) * s
				det.box(Vector3(ankle.x / s, yt / s, zt / s), Vector3(w * 0.55, 0.0032, 0.0035), lace, M_LEATHER, bone)
			# cano: faixa superior mais escura e presilha
			_tube(ankle + Vector3(0, 0.088 * s, 0.0), ankle + Vector3(0, 0.106 * s, 0.0), [[0.0, 0.052, 0.057, col.darkened(0.2), mat], [1.0, 0.05, 0.055, col.darkened(0.2), mat]], sides, bone, parent, -1, false, false, 0.0, 0.5, false)
		else:
			# bico do tênis
			_ellipsoid(Vector3(ankle.x, 0.038 * s, ankle.z - 0.165 * s), Vector3(w * 0.78, 0.024, 0.034) * s, sole, M_LEATHER, bone, 1.0, 0, 0.0, 8, 5)


# ---------------------------------------------------------------------------
# Extras: mochila, colchonete, crescimentos fúngicos
# ---------------------------------------------------------------------------
func _clothing_extras() -> void:
	if bool(a.get("backpack", false)) and lod == 0:
		HumanoidDetails.new(self).backpack()
	elif bool(a.get("backpack", false)):
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
			c = _hc + Vector3(rng.randf_range(-0.06, 0.06), rng.randf_range(-0.01, 0.09), rng.randf_range(-0.01, 0.09)) * s
			bone = HEAD
		else:
			c = Vector3(rng.randf_range(-0.12, 0.12), rng.randf_range(1.0, 1.1), 0.1) * s
			bone = SPINE
		var gc := col.lerp(Color(0.35, 0.28, 0.22), rng.randf())
		_ellipsoid(c, Vector3(r, r * rng.randf_range(0.7, 1.2), r * 0.8), gc, M_LEATHER, bone, 1.0, 0, 0.0, 6 if lod == 0 else 5, 4)
