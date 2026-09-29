class_name CaioModel
extends RefCounted
## Caio (protagonista) a partir do modelo "post_apocalyptic_survivor" fornecido em GLB.
##
## O GLB é estático (46 peças, sem esqueleto, sem animação e sem textura). Aqui ele é
## lido direto do arquivo (assets/models/caio_survivor.bin — a extensão não-importável
## garante que vai junto no export), convertido para o sistema de coordenadas do Godot
## (Z-up/frente -Y  ->  Y-up/frente -Z), ganha normais suaves com vincos, cores por
## vértice (o mesmo shader dos demais personagens) e é AMARRADO automaticamente ao
## esqueleto de 18 ossos do jogo por pesos de proximidade. Assim toda a animação
## procedural (andar, correr, IK de pés e mãos, ataques) continua valendo.

const PATH := "res://assets/models/caio_survivor.bin"
## Escala do modelo (ele tem 2,09 m até o cabelo): deixa o Caio com ~1,8 m.
const K := 0.86
const CREASE_DEG := 42.0

const M_SKIN := 0.0
const M_CLOTH := 0.3333
const M_DENIM := 0.6667
const M_LEATHER := 1.0

static var _data: Dictionary = {}
static var _mesh: ArrayMesh = null


## Posição no espaço do jogo a partir do espaço do GLB (rotação própria: det = +1).
static func G(x: float, y: float, z: float) -> Vector3:
	return Vector3(-x, z, y) * K


## Articulações (18, na ordem do HumanoidMeshBuilder). Esquerda = x negativo do jogo.
static func joints() -> Array:
	var j: Array = []
	j.resize(18)
	var HB := HumanoidMeshBuilder
	j[HB.HIPS] = G(0, 0, 0.99)
	j[HB.SPINE] = G(0, 0, 1.15)
	j[HB.CHEST] = G(0, 0, 1.36)
	j[HB.NECK] = G(0, 0, 1.58)
	j[HB.HEAD] = G(0, 0, 1.64)
	j[HB.JAW] = G(0, -0.12, 1.72)
	j[HB.UARM_L] = G(0.34, 0, 1.56)
	j[HB.FARM_L] = G(0.39, 0, 1.14)
	j[HB.HAND_L] = G(0.45, 0, 0.9)
	j[HB.UARM_R] = G(-0.34, 0, 1.56)
	j[HB.FARM_R] = G(-0.39, 0, 1.14)
	j[HB.HAND_R] = G(-0.45, 0, 0.9)
	j[HB.THIGH_L] = G(0.18, 0, 0.96)
	j[HB.SHIN_L] = G(0.18, 0, 0.5)
	j[HB.FOOT_L] = G(0.18, 0.02, 0.15)
	j[HB.THIGH_R] = G(-0.18, 0, 0.96)
	j[HB.SHIN_R] = G(-0.18, 0, 0.5)
	j[HB.FOOT_R] = G(-0.18, 0.02, 0.15)
	return j


## Medidas do pé para o animador: (ponta à frente, calcanhar atrás, altura do tornozelo) em m.
static func foot() -> Vector3:
	return Vector3(0.36 * K, 0.15 * K, 0.15 * K)


# ---------------------------------------------------------------------------
# Leitura do GLB
# ---------------------------------------------------------------------------
static func _load() -> Dictionary:
	if not _data.is_empty():
		return _data
	var bytes := FileAccess.get_file_as_bytes(PATH)
	if bytes.size() < 20:
		push_warning("CaioModel: arquivo do modelo não encontrado: " + PATH)
		return {}
	var off := 12
	var js: Dictionary = {}
	var bin := PackedByteArray()
	while off + 8 <= bytes.size():
		var clen := bytes.decode_u32(off)
		var ctype := bytes.decode_u32(off + 4)
		var start := off + 8
		if ctype == 0x4E4F534A:
			var parsed = JSON.parse_string(bytes.slice(start, start + clen).get_string_from_utf8())
			if parsed is Dictionary:
				js = parsed
		elif ctype == 0x004E4942:
			bin = bytes.slice(start, start + clen)
		off = start + clen
	_data = {"js": js, "bin": bin}
	return _data


static func _read_vec3(js: Dictionary, bin: PackedByteArray, ai: int) -> PackedVector3Array:
	var a: Dictionary = js["accessors"][ai]
	var v: Dictionary = js["bufferViews"][int(a["bufferView"])]
	var start := int(v.get("byteOffset", 0)) + int(a.get("byteOffset", 0))
	var out := PackedVector3Array()
	var n := int(a["count"])
	out.resize(n)
	for i in n:
		var o := start + i * 12
		out[i] = Vector3(bin.decode_float(o), bin.decode_float(o + 4), bin.decode_float(o + 8))
	return out


static func _read_indices(js: Dictionary, bin: PackedByteArray, ai: int) -> PackedInt32Array:
	var a: Dictionary = js["accessors"][ai]
	var v: Dictionary = js["bufferViews"][int(a["bufferView"])]
	var start := int(v.get("byteOffset", 0)) + int(a.get("byteOffset", 0))
	var n := int(a["count"])
	var out := PackedInt32Array()
	out.resize(n)
	var ct := int(a["componentType"])
	for i in n:
		if ct == 5125:
			out[i] = bin.decode_u32(start + i * 4)
		elif ct == 5123:
			out[i] = bin.decode_u16(start + i * 2)
		else:
			out[i] = bin.decode_u8(start + i)
	return out


# ---------------------------------------------------------------------------
# Regras de amarração: qual osso puxa cada peça
# ---------------------------------------------------------------------------
static func _rule(name_: String) -> String:
	if name_.begins_with("cargo_"):
		return "leg"
	if name_.begins_with("boot") or name_.begins_with("sole"):
		return "foot"
	if name_ in ["torso_shirt", "weathered_jacket"] or name_.begins_with("jacket_"):
		return "torso"
	if name_ == "neck":
		return "neck"
	if name_ in ["head", "hair", "nose", "cap", "cap_visor"] or name_.begins_with("eye_"):
		return "head"
	if name_.begins_with("upper_arm"):
		return "uarm"
	if name_.begins_with("forearm"):
		return "farm"
	if name_.begins_with("glove"):
		return "hand"
	if name_.begins_with("backpack") or name_.begins_with("shoulder_strap"):
		return "pack"
	if name_.begins_with("waist_") or name_ in ["canteen", "flashlight"]:
		return "hips"
	if name_.begins_with("radio"):
		return "ribs"
	return "torso"


## Pesos [b0, w0, b1, w1, b2, w2] de um vértice (coordenadas do GLB; x > 0 = lado esquerdo).
static func _weights(rule: String, p: Vector3) -> Array:
	var HB := HumanoidMeshBuilder
	var left := p.x > 0.0
	var z := p.z
	match rule:
		"head":
			return [HB.HEAD, 1.0, 0, 0.0, 0, 0.0]
		"neck":
			var wn := smoothstep(1.54, 1.62, z)
			return [HB.NECK, 0.55 + 0.45 * wn, HB.CHEST, 0.45 * (1.0 - wn), 0, 0.0]
		"torso":
			var w_h := 1.0 - smoothstep(0.95, 1.17, z)
			var w_c := smoothstep(1.2, 1.42, z)
			var w_s := 1.0 - w_h - w_c
			# ombros: o tecido de cima acompanha o braço (sem fresta ao levantá-lo)
			var sh := smoothstep(0.17, 0.3, absf(p.x)) * smoothstep(1.38, 1.6, z) * 0.55
			var arm: int = HB.UARM_L if left else HB.UARM_R
			var pairs := [[HB.HIPS, w_h * (1.0 - sh)], [HB.SPINE, w_s * (1.0 - sh)], [HB.CHEST, w_c * (1.0 - sh)]]
			pairs.sort_custom(func(a, b): return a[1] > b[1])
			return [pairs[0][0], pairs[0][1], pairs[1][0], pairs[1][1], arm, sh]
		"pack":
			var wc := smoothstep(1.02, 1.3, z)
			return [HB.CHEST, 0.45 + 0.55 * wc, HB.SPINE, 0.55 - 0.55 * wc, 0, 0.0]
		"hips":
			return [HB.HIPS, 0.65, HB.SPINE, 0.35, 0, 0.0]
		"ribs":
			return [HB.SPINE, 0.4, HB.CHEST, 0.6, 0, 0.0]
		"uarm":
			var arm_u: int = HB.UARM_L if left else HB.UARM_R
			var fa_u: int = HB.FARM_L if left else HB.FARM_R
			var wf := smoothstep(1.2, 1.02, z) * 0.55
			var wt := smoothstep(1.46, 1.62, z) * 0.6
			return [arm_u, 1.0 - wf - wt, fa_u, wf, HB.CHEST, wt]
		"farm":
			var arm_f: int = HB.UARM_L if left else HB.UARM_R
			var fa_f: int = HB.FARM_L if left else HB.FARM_R
			var hd_f: int = HB.HAND_L if left else HB.HAND_R
			var wu := smoothstep(1.06, 1.24, z) * 0.55
			var wh := smoothstep(0.92, 0.8, z) * 0.5
			return [fa_f, 1.0 - wu - wh, arm_f, wu, hd_f, wh]
		"hand":
			var fa_h: int = HB.FARM_L if left else HB.FARM_R
			var hd_h: int = HB.HAND_L if left else HB.HAND_R
			var wf2 := smoothstep(0.85, 0.96, z) * 0.6
			return [hd_h, 1.0 - wf2, fa_h, wf2, 0, 0.0]
		"leg":
			var th: int = HB.THIGH_L if left else HB.THIGH_R
			var sh_b: int = HB.SHIN_L if left else HB.SHIN_R
			var wsh := smoothstep(0.6, 0.4, z)
			var whp := smoothstep(0.82, 1.0, z) * 0.5
			return [th, (1.0 - wsh) * (1.0 - whp), sh_b, wsh, HB.HIPS, whp * (1.0 - wsh)]
		"foot":
			var ft: int = HB.FOOT_L if left else HB.FOOT_R
			var sh_f: int = HB.SHIN_L if left else HB.SHIN_R
			var ws := smoothstep(0.12, 0.2, z) * 0.55
			return [ft, 1.0 - ws, sh_f, ws, 0, 0.0]
	return [HB.CHEST, 1.0, 0, 0.0, 0, 0.0]


# ---------------------------------------------------------------------------
# Malha
# ---------------------------------------------------------------------------
static func build_mesh() -> ArrayMesh:
	if _mesh != null:
		return _mesh
	var d := _load()
	if d.is_empty():
		_mesh = ArrayMesh.new()
		return _mesh
	var js: Dictionary = d["js"]
	var bin: PackedByteArray = d["bin"]
	var verts := PackedVector3Array()
	var norms := PackedVector3Array()
	var tans := PackedFloat32Array()
	var cols := PackedColorArray()
	var uvs := PackedVector2Array()
	var bones := PackedInt32Array()
	var weights := PackedFloat32Array()
	var indices := PackedInt32Array()
	var crease := cos(deg_to_rad(CREASE_DEG))
	for node: Dictionary in js["nodes"]:
		if not node.has("mesh"):
			continue
		var nm := str(node.get("name", ""))
		var mesh_def: Dictionary = js["meshes"][int(node["mesh"])]
		for prim: Dictionary in mesh_def["primitives"]:
			var pos := _read_vec3(js, bin, int(prim["attributes"]["POSITION"]))
			var idx := PackedInt32Array()
			if prim.has("indices"):
				idx = _read_indices(js, bin, int(prim["indices"]))
			else:
				idx.resize(pos.size())
				for i in pos.size():
					idx[i] = i
			var mat: Dictionary = js["materials"][int(prim.get("material", 0))]
			var mname := str(mat.get("name", ""))
			var bcf: Array = (mat.get("pbrMetallicRoughness", {}) as Dictionary).get("baseColorFactor", [0.5, 0.5, 0.5, 1.0])
			var mid := _mat_id(mname)
			# o shader eleva os tons escuros (x^0.74 roupa, x^0.82 pele); o pré-ajuste deixa o resultado em
			# x^0.8 / x^0.88: a paleta do modelo, um pouco mais legível sob o céu nublado
			var lift := 0.8 / 0.74 if mid > 0.1 else (0.88 / 0.82 if mname == "Skin" else 1.0)
			var col := Color(pow(float(bcf[0]), lift), pow(float(bcf[1]), lift), pow(float(bcf[2]), lift), mid)
			var rule := _rule(nm)
			var uv_add := 10.0 if mname == "Hair" else (20.0 if mname == "Eyes" else 0.0)
			# normais por canto de triângulo, suaves dentro do ângulo de vinco
			var ntri := idx.size() / 3
			var fnorm := PackedVector3Array()
			fnorm.resize(ntri)
			var by_pos := {}
			for t in ntri:
				var a := pos[idx[t * 3]]
				var b := pos[idx[t * 3 + 1]]
				var c := pos[idx[t * 3 + 2]]
				fnorm[t] = (b - a).cross(c - a)   # o módulo já carrega a área
				for k in 3:
					var key := _key(pos[idx[t * 3 + k]])
					if not by_pos.has(key):
						by_pos[key] = []
					(by_pos[key] as Array).append(t)
			for t in ntri:
				var fn_t := fnorm[t]
				if fn_t.length_squared() < 1e-14:
					continue
				var fdir := fn_t.normalized()
				var corner_p: Array = []
				var corner_n: Array = []
				for k in 3:
					var pv := pos[idx[t * 3 + k]]
					var acc := Vector3.ZERO
					for t2: int in by_pos[_key(pv)]:
						var f2 := fnorm[t2]
						if f2.length_squared() > 1e-14 and f2.normalized().dot(fdir) >= crease:
							acc += f2
					corner_p.append(pv)
					corner_n.append(acc.normalized() if acc.length_squared() > 1e-14 else fdir)
				for k: int in [0, 2, 1]:   # glTF é anti-horário, o Godot é horário
					var pv: Vector3 = corner_p[k]
					var nv: Vector3 = corner_n[k]
					var gp := G(pv.x, pv.y, pv.z)
					var gn := Vector3(-nv.x, nv.z, nv.y).normalized()
					var w := _weights(rule, pv)
					verts.append(gp)
					norms.append(gn)
					var uv := _uv(gp, gn)
					uv.y += uv_add
					uvs.append(uv)
					var tg := _tangent(gn)
					tans.append(tg.x)
					tans.append(tg.y)
					tans.append(tg.z)
					tans.append(1.0)
					cols.append(col)
					var tot: float = float(w[1]) + float(w[3]) + float(w[5])
					if tot <= 0.0:
						tot = 1.0
					bones.append(int(w[0]))
					bones.append(int(w[2]))
					bones.append(int(w[4]))
					bones.append(0)
					weights.append(float(w[1]) / tot)
					weights.append(float(w[3]) / tot)
					weights.append(float(w[5]) / tot)
					weights.append(0.0)
					indices.append(verts.size() - 1)
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
	_mesh = ArrayMesh.new()
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return _mesh


static func _key(p: Vector3) -> Vector3i:
	return Vector3i(roundi(p.x * 2000.0), roundi(p.y * 2000.0), roundi(p.z * 2000.0))


static func _mat_id(mname: String) -> float:
	match mname:
		"Cargo Pants":
			return M_DENIM
		"Boot Leather", "Rubber", "Worn Metal", "Equipment Accent":
			return M_LEATHER
		"Skin", "Eyes":
			return M_SKIN
	return M_CLOTH


## UV planar pelo eixo dominante da normal (em metros): serve ao detalhe de tecido do shader.
static func _uv(p: Vector3, n: Vector3) -> Vector2:
	var an := n.abs()
	if an.y >= an.x and an.y >= an.z:
		return Vector2(p.x, p.z)
	if an.x >= an.z:
		return Vector2(p.z, p.y)
	return Vector2(p.x, p.y)


static func _tangent(n: Vector3) -> Vector3:
	var an := n.abs()
	var ref := Vector3.BACK if (an.x > an.y and an.x > an.z) else Vector3.RIGHT
	var t := ref - n * n.dot(ref)
	return t.normalized() if t.length_squared() > 1e-8 else Vector3.RIGHT
