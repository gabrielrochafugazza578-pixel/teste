class_name HumanModels
extends RefCounted
## Personagens fotorrealistas gerados do MakeHuman (tools/make_humans.py +
## tools/pack_humans.gd): uma ArrayMesh pronta por modelo (com LODs automáticos),
## já amarrada aos 18 ossos do jogo, e materiais COMPARTILHADOS por peça (pele,
## roupa, cabelo, olhos). O que muda de pessoa para pessoa (infectado, sujeira,
## sangue, rasgos, cor da roupa e do cabelo) vai em parâmetros de instância.
##
## Aparência: ap["model"] = "mh:<id>" (ex.: "mh:caio").

const DIR := "res://assets/characters"

static var _meshes: Dictionary = {}
static var _mats: Dictionary = {}
static var _tex: Dictionary = {}
static var _table: Dictionary = {}
static var _shaders: Dictionary = {}


const PORES := "res://assets/textures/skin/skin_pores_n.png"

static func is_model(ap: Dictionary) -> bool:
	return str(ap.get("model", "")).begins_with("mh:")


static func model_id(ap: Dictionary) -> String:
	return str(ap.get("model", "")).substr(3)


static func exists(id: String) -> bool:
	return ResourceLoader.exists(DIR + "/" + id + ".res")


static func mesh(id: String) -> ArrayMesh:
	if _meshes.has(id):
		return _meshes[id]
	var m: ArrayMesh = load(DIR + "/" + id + ".res") as ArrayMesh
	_meshes[id] = m
	return m


## Juntas (18, ordem do HumanoidMeshBuilder) na pose de descanso do modelo.
static func joints(id: String) -> Array:
	var m := mesh(id)
	var out: Array = []
	for p: Array in m.get_meta("joints", []):
		out.append(Vector3(p[0], p[1], p[2]))
	return out


## (ponta à frente, calcanhar atrás, altura do tornozelo) em metros.
static func foot(id: String) -> Vector3:
	var f: Array = mesh(id).get_meta("foot", [0.22, 0.07, 0.09])
	return Vector3(f[0], f[1], f[2])


static func _materials_table() -> Dictionary:
	if _table.is_empty():
		var txt := FileAccess.get_file_as_string(DIR + "/materials.json")
		var d = JSON.parse_string(txt)
		_table = d if d is Dictionary else {}
	return _table


static func _shader(path: String) -> Shader:
	if not _shaders.has(path):
		_shaders[path] = load(path)
	return _shaders[path]


## Textura comprimida (BC7) do pack; com --texturas-rgba (testes em GPU por
## software) é descomprimida e reduzida para 1024.
static func texture(name: String) -> Texture2D:
	if _tex.has(name):
		return _tex[name]
	var path := DIR + "/tex/" + name + ".res"
	var t: Texture2D = null
	if ResourceLoader.exists(path):
		var img: Image = load(path) as Image
		if img != null:
			var full := "--texturas-max" in OS.get_cmdline_user_args()
			if "--texturas-rgba" in OS.get_cmdline_user_args() or full:
				img = img.duplicate()
				img.decompress()
				if img.get_width() > 1024 and not full:
					img.clear_mipmaps()
					img.resize(1024, 1024, Image.INTERPOLATE_LANCZOS)
					img.generate_mipmaps()
			t = ImageTexture.create_from_image(img)
	_tex[name] = t
	return t


static func material(kind: String, key: String, torn: bool = false) -> ShaderMaterial:
	var ck := kind + "|" + key + ("|t" if torn else "")
	if _mats.has(ck):
		return _mats[ck]
	var rec: Dictionary = _materials_table().get(key, {})
	var params: Dictionary = rec.get("params", {})
	var m := ShaderMaterial.new()
	match kind:
		"body":
			m.shader = _shader("res://shaders/human_skin.gdshader")
			if ResourceLoader.exists(PORES):
				m.set_shader_parameter("pore_tex", load(PORES))
		"eyes":
			m.shader = _shader("res://shaders/human_eye.gdshader")
		"brow":
			m.shader = _shader("res://shaders/human_brow.gdshader")
			# cílios: mais finos e escuros que a sobrancelha
			if key.begins_with("eyelash"):
				m.set_shader_parameter("opacity", 0.8)
				m.set_shader_parameter("density", 1.3)
		"hair", "beard":
			m.shader = _shader("res://shaders/human_hair.gdshader")
			if kind == "hair":
				# recorte mais baixo: fios mais cheios (sem o fundo aparecendo entre
				# as mechas do rabo de cavalo)
				m.set_shader_parameter("cutoff", 0.3)
			elif kind == "beard":
				m.set_shader_parameter("cutoff", 0.36)
				m.set_shader_parameter("aniso", 0.3)
				m.set_shader_parameter("rough_base", 0.5)
		"gear":
			m.shader = _shader("res://shaders/human_gear.gdshader")
		"fungus":
			m.shader = _shader("res://shaders/human_fungus.gdshader")
		_:
			m.shader = _shader("res://shaders/human_cloth_torn.gdshader" if torn else "res://shaders/human_cloth.gdshader")
	if rec.has("albedo"):
		m.set_shader_parameter("albedo_tex", texture(str(rec["albedo"])))
	if rec.has("normal"):
		m.set_shader_parameter("normal_tex", texture(str(rec["normal"])))
	m.set_shader_parameter("detail_tex", texture("human_detail_a"))
	for p: String in params.keys():
		var v = params[p]
		if v is Array:
			# uniforms com source_color recebem Color (convertidos para linear)
			if p.ends_with("color") or v.size() == 4:
				m.set_shader_parameter(p, Color(v[0], v[1], v[2], v[3] if v.size() > 3 else 1.0))
			else:
				m.set_shader_parameter(p, Vector3(v[0], v[1], v[2]))
		else:
			m.set_shader_parameter(p, v)
	_mats[ck] = m
	return m


## Põe a malha do modelo e os materiais de cada superfície no MeshInstance3D e
## aplica os parâmetros da pessoa (aparência).
static func apply(mi: MeshInstance3D, ap: Dictionary) -> void:
	var m := mesh(model_id(ap))
	mi.mesh = m
	mi.material_override = null
	var torn := float(ap.get("tear", 0.0)) > 0.05
	for i in m.get_surface_count():
		var nm := m.surface_get_name(i)
		var parts := nm.split("|")
		var kind := parts[0].get_slice(":", 0)
		var key := parts[1] if parts.size() > 1 else ""
		if kind == "body" and ap.has("skin_tex"):
			key = str(ap["skin_tex"])
		mi.set_surface_override_material(i, material(kind, key, torn and kind == "cloth"))
	set_params(mi, ap)


static func set_params(mi: MeshInstance3D, ap: Dictionary) -> void:
	var inf := float(ap.get("infected", 0.0))
	mi.set_instance_shader_parameter("infection", inf)
	mi.set_instance_shader_parameter("grime", float(ap.get("grime", 0.2)))
	mi.set_instance_shader_parameter("blood", float(ap.get("blood", 0.0)))
	mi.set_instance_shader_parameter("wear", float(ap.get("tear", 0.0)))
	mi.set_instance_shader_parameter("eye_cloud", 1.0 if ap.get("blind", false) else clampf((inf - 0.35) * 1.6, 0.0, 0.85))
	for slot: String in ["tint_top", "tint_bottom", "tint_shoes"]:
		if ap.has(slot):
			mi.set_instance_shader_parameter(slot, ap[slot])
	if ap.has("hair_tint"):
		mi.set_instance_shader_parameter("hair_tint", ap["hair_tint"])


# ---------------------------------------------------------------------------
# Escolha automática: qualquer aparência antiga (civil, NPC nomeado, infectado…)
# vira um modelo fotorrealista parecido — gênero, idade, papel, cor da pele, das
# roupas e do cabelo vêm do dicionário original.
# ---------------------------------------------------------------------------
const CIV_M := ["civ_m1", "civ_m2", "civ_m3", "civ_m4", "civ_m5", "civ_m6", "civ_m7"]
const CIV_F := ["civ_f1", "civ_f2", "civ_f3", "civ_f4", "civ_f5"]
const Z_M := ["z_m1", "z_m2", "z_m3", "z_m4", "z_m5", "z_m6", "z_m7"]
const Z_F := ["z_f1", "z_f2", "z_f3", "z_f4"]


static func _pick(list: Array, seed_v: int) -> String:
	var ok: Array = []
	for id: String in list:
		if exists(id):
			ok.append(id)
	if ok.is_empty():
		return ""
	return ok[absi(hash(str(seed_v) + "|" + list[0])) % ok.size()]


static func _is_old(ap: Dictionary) -> bool:
	var hc: Color = ap.get("hair_color", Color(0.1, 0.08, 0.06))
	return hc.v > 0.42 and hc.s < 0.35


static func choose_model(ap: Dictionary) -> String:
	var id := str(ap.get("id", "generic"))
	var fem: bool = ap.get("female", false)
	var seed_v := int(ap.get("seed", 0))
	var h := float(ap.get("height", 1.75))
	if id.begins_with("infected_"):
		match id.substr(9):
			"colosso":
				return _pick(["z_brute"], seed_v)
			"hospedeiro", "sentinela":
				return _pick(["z_host"], seed_v)
			"rastejante":
				return _pick(["z_crawler"], seed_v)
		if str(ap.get("top", "")) == "gown":
			return _pick(["z_m5"], seed_v)
		if str(ap.get("top", "")) == "labcoat":
			return _pick(["z_f3"], seed_v)
		return _pick(Z_F if fem else Z_M, seed_v)
	match id:
		"caio", "helena":
			return _pick([id], 0)
		"patient_zero":
			return _pick(["patient"], 0)
		"police":
			return _pick(["police"], 0)
		"researcher":
			return _pick(["researcher_f" if fem else "researcher_m"], 0)
		"survivor":
			return _pick(["survivor_f" if fem else "survivor_m"], 0)
	if h < 1.48:
		return _pick(["child_f" if fem else "child_m"], 0)
	if str(ap.get("top", "")) == "labcoat":
		return _pick(["researcher_f" if fem else "researcher_m"], 0)
	if ap.get("backpack", false) and str(ap.get("top", "")) in ["hoodie", "jacket"]:
		return _pick(["survivor_f" if fem else "survivor_m"], 0)
	if _is_old(ap):
		return _pick(["civ_f5" if fem else "civ_m3"], 0)
	return _pick(CIV_F if fem else CIV_M, seed_v)


## Pele da lista (mesmo gênero) mais próxima do tom pedido.
static func choose_skin(ap: Dictionary, model: String) -> String:
	var skins: Dictionary = _materials_table().get("_skins", {})
	var fem: bool = ap.get("female", false) if not model.begins_with("civ_m") else false
	if model.ends_with("_f") or model.begins_with("civ_f") or model.begins_with("z_f") or model == "helena" or model.begins_with("child_f"):
		fem = true
	elif model.begins_with("civ_m") or model.begins_with("z_m") or model in ["caio", "patient", "police", "researcher_m", "survivor_m", "child_m", "z_brute", "z_host"]:
		fem = false
	var pool: Array = skins.get("female" if fem else "male", [])
	if pool.is_empty():
		return ""
	var c: Color = ap.get("skin", Color(0.76, 0.57, 0.44))
	var lum := c.r * 0.3 + c.g * 0.59 + c.b * 0.11
	var old := _is_old(ap)
	var cand: Array = []
	for k: String in pool:
		var dark := k.contains("african")
		var asian := k.contains("asian")
		var aged := k.contains("old_") or k.contains("middleage")
		var tone_ok := (dark and lum < 0.45) or (not dark and lum >= 0.45 and (not asian or lum < 0.68))
		if tone_ok and (aged == old or not old):
			cand.append(k)
	if cand.is_empty():
		cand = pool
	return cand[absi(hash("pele" + str(ap.get("seed", 0)))) % cand.size()]


## Copia a aparência acrescentando o modelo fotorrealista (se houver um adequado).
static func photo(ap: Dictionary) -> Dictionary:
	if is_model(ap) or ap.get("procedural", false):
		return ap
	var m := choose_model(ap)
	if m == "":
		return ap
	var a := ap.duplicate()
	a["model"] = "mh:" + m
	a["height"] = float(mesh(m).get_meta("height", a.get("height", 1.75)))
	if not m in ["caio", "helena"]:
		var sk := choose_skin(ap, m)
		if sk != "":
			a["skin_tex"] = sk
	a["tint_top"] = _tint(ap.get("top_color", Color.WHITE))
	a["tint_bottom"] = _tint(ap.get("bottom_color", Color.WHITE))
	a["tint_shoes"] = _tint(ap.get("shoes_color", Color.WHITE))
	var hc: Color = ap.get("hair_color", Color(0.16, 0.1, 0.06))
	a["hair_tint"] = Color(hc.r, hc.g, hc.b, 0.55)
	var inf := float(ap.get("infected", 0.0))
	if inf > 0.0:
		a["blood"] = clampf(0.3 + inf * 0.45, 0.0, 1.0)
	return a


static func _tint(c: Color) -> Color:
	# a peça da foto já é clara (~0,8): a cor da pessoa multiplica um pouco acima de 1
	return Color(minf(c.r * 1.3, 1.0), minf(c.g * 1.3, 1.0), minf(c.b * 1.3, 1.0))
