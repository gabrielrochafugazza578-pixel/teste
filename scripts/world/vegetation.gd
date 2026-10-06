class_name Vegetation
extends RefCounted
## Malhas procedurais de vegetação (árvores, palmeiras, pinheiros, arbustos,
## trepadeiras e tufos de grama). Duas superfícies por árvore: tronco
## (material do mundo) + folhas (cartões com recorte alfa e vento).
## Cada tipo tem versão perto (LOD0) e longe (LOD1) para MultiMesh.

const TYPES := ["broadleaf", "broadleaf_big", "pine", "palm", "bush", "dead", "vine"]
## Árvores escaneadas (Poly Haven, CC0; tools/make_trees.py + tools/pack_trees.gd):
## tronco e galhos reais simplificados e copa em tufos com as folhas da espécie.
const SCANNED := {"broadleaf_big": "jacaranda", "broadleaf": "acacia"}
const TREE_DIR := "res://assets/models/trees/"

static var _meshes: Dictionary = {}
static var _bark: Dictionary = {}


static func mesh(kind: String, lod: int) -> ArrayMesh:
	var key := "%s_%d" % [kind, lod]
	if _meshes.has(key):
		return _meshes[key]
	if SCANNED.has(kind) and ResourceLoader.exists(TREE_DIR + "%s_%d.res" % [SCANNED[kind], lod]):
		var sm := _scanned(str(SCANNED[kind]), lod)
		if sm != null:
			_meshes[key] = sm
			return sm
	var trunk := MeshBuf.new()
	var leaves := MeshBuf.new()
	var r := Util.rng(hash(kind) & 0xffff)
	match kind:
		"broadleaf", "broadleaf_big":
			var h := 5.5 if kind == "broadleaf" else 9.0
			var cr := 2.6 if kind == "broadleaf" else 4.2
			_trunk(trunk, h * 0.62, 0.18 if kind == "broadleaf" else 0.3, lod, r)
			if lod == 0:
				_branches(trunk, h * 0.5, h * 0.7, 4, cr * 0.7, r)
			# copa grande tem 2,6x a área da pequena: mais cartões para não ficar rala
			var nc := (38 if kind == "broadleaf" else 60) if lod == 0 else (7 if kind == "broadleaf" else 10)
			_canopy(leaves, Vector3(0, h * 0.72, 0), Vector3(cr, cr * 0.75, cr), nc, 1.5 if lod == 0 else 3.2, r)
			if lod == 0:
				_canopy(leaves, Vector3(cr * 0.4, h * 0.6, -cr * 0.2), Vector3(cr * 0.6, cr * 0.5, cr * 0.6), 12, 1.3, r)
		"pine":
			_trunk(trunk, 9.0, 0.22, lod, r)
			var layers := 6 if lod == 0 else 3
			for i in layers:
				var y := 2.5 + i * (6.5 / layers)
				var rad := lerpf(2.4, 0.6, float(i) / layers)
				_canopy(leaves, Vector3(0, y, 0), Vector3(rad, 0.9, rad), 10 if lod == 0 else 3, 1.4 if lod == 0 else 2.6, r)
		"palm":
			_trunk(trunk, 8.0, 0.2, lod, r, 0.16)
			var fronds := 9 if lod == 0 else 5
			for i in fronds:
				var a := TAU * i / fronds + r.randf() * 0.3
				_frond(leaves, Vector3(0, 8.0, 0), a, 3.2, r)
		"bush":
			_canopy(leaves, Vector3(0, 0.7, 0), Vector3(1.1, 0.75, 1.1), 14 if lod == 0 else 4, 1.1 if lod == 0 else 1.8, r)
		"dead":
			_trunk(trunk, 5.0, 0.2, lod, r)
			_branches(trunk, 2.5, 4.5, 6 if lod == 0 else 3, 2.2, r)
		"vine":
			# trepadeira: cartões verticais encostados numa parede (plano XY, frente -Z)
			for i in (16 if lod == 0 else 5):
				var p := Vector3(r.randf_range(-1.4, 1.4), r.randf_range(0.2, 2.8), -0.05 - r.randf() * 0.1)
				var s := r.randf_range(0.6, 1.1)
				var n := Vector3(0, 0, -1)
				var sway := clampf(p.y / 3.0, 0.1, 1.0)
				var c := Color(sway, r.randf_range(0.5, 1.0), 0, 1)
				leaves.quad(p + Vector3(-s, -s, 0), p + Vector3(s, -s, 0), p + Vector3(s, s, 0), p + Vector3(-s, s, 0), n,
					Vector2(0, 1), Vector2(1, 1), Vector2(1, 0), Vector2(0, 0), 0.0, 0.0, c)
	var m := ArrayMesh.new()
	if not trunk.is_empty():
		m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, trunk.to_arrays())
		m.surface_set_material(m.get_surface_count() - 1, Assets.world_material("props"))
	if not leaves.is_empty():
		m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, leaves.to_arrays())
		var fk := "tree"
		match kind:
			"pine": fk = "pine"
			"bush": fk = "bush"
			"vine": fk = "vine"
			"palm": fk = "dry"
		m.surface_set_material(m.get_surface_count() - 1, Assets.foliage_material(fk))
	_meshes[key] = m
	return m


static func _scanned(id: String, lod: int) -> ArrayMesh:
	var src := load(TREE_DIR + "%s_%d.res" % [id, lod]) as ArrayMesh
	if src == null:
		return null
	var m := src.duplicate() as ArrayMesh
	var tex: Dictionary = src.get_meta("tex", {})
	for i in m.get_surface_count():
		var sname := m.surface_get_name(i)
		if sname == "leaves":
			m.surface_set_material(i, Assets.foliage_material(id))
		else:
			m.surface_set_material(i, _bark_material(id, sname, tex.get(sname, {})))
	return m


## Casca em foto do próprio escaneamento (cor, normal, AO/rugosidade).
static func _bark_material(id: String, part: String, t: Dictionary) -> StandardMaterial3D:
	var key := id + "/" + part
	if _bark.has(key):
		return _bark[key]
	var mat := StandardMaterial3D.new()
	var dir := TREE_DIR + id + "/"
	if t.has("albedo"):
		mat.albedo_texture = load(dir + str(t["albedo"]))
	if t.has("normal"):
		mat.normal_enabled = true
		mat.normal_texture = load(dir + str(t["normal"]))
	if t.has("arm"):
		var arm: Texture2D = load(dir + str(t["arm"]))
		mat.roughness_texture = arm
		mat.roughness_texture_channel = BaseMaterial3D.TEXTURE_CHANNEL_GREEN
		mat.roughness = 1.0
		mat.ao_enabled = true
		mat.ao_texture = arm
		mat.ao_texture_channel = BaseMaterial3D.TEXTURE_CHANNEL_RED
		mat.ao_light_affect = 0.4
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	_bark[key] = mat
	return mat


static func _trunk(b: MeshBuf, h: float, r0: float, lod: int, r: RandomNumberGenerator, r1: float = -1.0) -> void:
	var code := Assets.uv2_code(Assets.L_BARK)
	var sides := 7 if lod == 0 else 4
	var segs := 3 if lod == 0 else 1
	var prev := Vector3.ZERO
	var rad := r0
	for i in segs:
		var seg_h := h / segs
		var top_r := r0 * (1.0 - float(i + 1) / segs * 0.55) if r1 < 0.0 else lerpf(r0, r1, float(i + 1) / segs)
		var lean := Vector3(r.randf_range(-0.12, 0.12), 0, r.randf_range(-0.12, 0.12)) * (i + 1)
		var xf := Transform3D(Basis.IDENTITY, prev)
		b.cylinder(xf, rad, seg_h, sides, code, 0.0, Color(1, 1, 1), false, top_r)
		prev = prev + Vector3(0, seg_h, 0) + lean * 0.2
		rad = top_r


static func _branches(b: MeshBuf, y0: float, y1: float, n: int, length: float, r: RandomNumberGenerator) -> void:
	var code := Assets.uv2_code(Assets.L_BARK)
	for i in n:
		var a := TAU * i / n + r.randf() * 0.6
		var y := r.randf_range(y0, y1)
		var dir := Vector3(cos(a), r.randf_range(0.35, 0.8), sin(a)).normalized()
		var basis := Basis.looking_at(-dir, Vector3.UP if absf(dir.y) < 0.95 else Vector3.RIGHT) * Basis(Vector3.RIGHT, -PI * 0.5)
		b.cylinder(Transform3D(basis, Vector3(0, y, 0)), 0.07, length * r.randf_range(0.6, 1.0), 4, code, 0.0, Color(0.9, 0.9, 0.9), false, 0.025)


static func _canopy(b: MeshBuf, c: Vector3, rad: Vector3, cards: int, size: float, r: RandomNumberGenerator) -> void:
	for i in cards:
		# ponto dentro do elipsoide (mais denso na casca)
		var u := Vector3(r.randf_range(-1, 1), r.randf_range(-1, 1), r.randf_range(-1, 1))
		if u.length() > 1.0:
			u = u.normalized()
		u = u.normalized() * pow(r.randf_range(0.35, 1.0), 0.5)
		var p := c + Vector3(u.x * rad.x, u.y * rad.y, u.z * rad.z)
		var n := (p - c).normalized()
		if n.length_squared() < 0.01:
			n = Vector3.UP
		var basis := Basis.from_euler(Vector3(r.randf_range(-1.2, 1.2), r.randf() * TAU, r.randf_range(-0.6, 0.6)))
		var ax := basis.x * size * 0.5
		var ay := basis.y * size * 0.5
		var sway := clampf((p.y - c.y + rad.y) / (rad.y * 2.0), 0.2, 1.0)
		var shade := clampf(0.45 + (u.y * 0.5 + 0.5) * 0.35 + u.length() * 0.25, 0.3, 1.0)
		var col := Color(sway, shade, 0, 1)
		b.quad(p - ax - ay, p + ax - ay, p + ax + ay, p - ax + ay, n, Vector2(0, 1), Vector2(1, 1), Vector2(1, 0), Vector2(0, 0), 0.0, 0.0, col)


static func _frond(b: MeshBuf, top: Vector3, a: float, length: float, r: RandomNumberGenerator) -> void:
	var dir := Vector3(cos(a), 0.0, sin(a))
	var side := Vector3(-dir.z, 0, dir.x)
	var segs := 4
	for i in segs:
		var t0 := float(i) / segs
		var t1 := float(i + 1) / segs
		var p0 := top + dir * (length * t0) + Vector3(0, 0.4 - t0 * t0 * 1.6, 0)
		var p1 := top + dir * (length * t1) + Vector3(0, 0.4 - t1 * t1 * 1.6, 0)
		var w0 := 0.55 * (1.0 - t0 * 0.6)
		var w1 := 0.55 * (1.0 - t1 * 0.6)
		var col := Color(0.3 + t1 * 0.7, 0.8, 0, 1)
		b.quad(p0 - side * w0, p1 - side * w1, p1 + side * w1, p0 + side * w0, Vector3.UP, Vector2(0, t0), Vector2(0, t1), Vector2(1, t1), Vector2(1, t0), 0.0, 0.0, col)


## Moita de grama texturizada: 3 planos cruzados a 60° com a textura
## `grass_bush.png` (SimpleGrassTextured, MIT). Altura do plano = GRASS_H.
const GRASS_H := 0.62


static func grass_mesh() -> ArrayMesh:
	if _meshes.has("grass"):
		return _meshes["grass"]
	var verts := PackedVector3Array()
	var norms := PackedVector3Array()
	var uvs := PackedVector2Array()
	var idx := PackedInt32Array()
	var hw := 0.46
	for i in 3:
		var a := PI / 3.0 * i + 0.3
		var d := Vector3(cos(a), 0.0, sin(a)) * hw
		var n := Vector3(-sin(a), 0.0, cos(a))
		var base := verts.size()
		verts.append_array(PackedVector3Array([-d, d, d + Vector3(0, GRASS_H, 0), -d + Vector3(0, GRASS_H, 0)]))
		for k in 4:
			norms.append(n)
		uvs.append_array(PackedVector2Array([Vector2(0, 1), Vector2(1, 1), Vector2(1, 0), Vector2(0, 0)]))
		idx.append_array(PackedInt32Array([base, base + 1, base + 2, base, base + 2, base + 3]))
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = norms
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = idx
	var m := ArrayMesh.new()
	m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	m.surface_set_material(0, Assets.grass_material())
	_meshes["grass"] = m
	return m
