class_name FarLayer
extends Node3D
## Camada distante, barata e sempre presente: terreno do mapa inteiro em baixa
## resolução (32 m por célula) e a silhueta de todos os prédios (um MultiMesh
## de caixas, 1 draw call). Os dois somem onde o chunk de verdade está
## carregado (máscara 48×48 atualizada pelos sinais de streaming), então só
## preenchem o que fica além da distância de visão: é o que deixa ver a cidade
## do Mirante da Serra, do alto de um prédio ou da estrada rural.
##
## Custo: ~19 mil triângulos de terreno + ~12 por prédio, 2 draw calls.

const STEP := 32.0
const GRID := 96                     # 3072 m / 32 m
const MASK_N := 48                   # chunks por lado (3072 / 64)

var world: World
var layout: WorldLayout
var terrain_mi: MeshInstance3D
var sky_mi: MultiMeshInstance3D
var mask_img: Image
var mask_tex: ImageTexture
var _dirty: bool = false
var _resync_t: float = 0.0
var _terrain_mat: ShaderMaterial
var _sky_mat: ShaderMaterial
var _task: int = -1
var _arrays: Array = []


func setup(w: World) -> void:
	world = w
	layout = w.layout
	mask_img = Image.create_empty(MASK_N, MASK_N, false, Image.FORMAT_R8)
	mask_img.fill(Color(0, 0, 0))
	mask_tex = ImageTexture.create_from_image(mask_img)
	_terrain_mat = ShaderMaterial.new()
	_terrain_mat.shader = load("res://shaders/far_terrain.gdshader")
	Assets.set_terrain_macro(_terrain_mat)
	_sky_mat = ShaderMaterial.new()
	_sky_mat.shader = load("res://shaders/far_skyline.gdshader")
	for m: ShaderMaterial in [_terrain_mat, _sky_mat]:
		m.set_shader_parameter("chunk_mask", mask_tex)
		m.set_shader_parameter("mask_origin", Vector2(-WorldLayout.HALF, -WorldLayout.HALF))
		m.set_shader_parameter("mask_scale", 1.0 / (WorldLayout.CHUNK * MASK_N))
	_build_skyline()
	# o terreno (≈9 mil amostras de altura) é montado numa thread
	_task = WorkerThreadPool.add_task(_build_terrain_arrays, false, "far_terrain")
	EventBus.chunk_loaded.connect(func(c: Vector2i) -> void: _set_chunk(c, true))
	EventBus.chunk_unloaded.connect(func(c: Vector2i) -> void: _set_chunk(c, false))


func _exit_tree() -> void:
	if _task >= 0:
		WorkerThreadPool.wait_for_task_completion(_task)
		_task = -1


# ---------------------------------------------------------------------------
# Máscara de chunks carregados
# ---------------------------------------------------------------------------
func _set_chunk(c: Vector2i, loaded: bool) -> void:
	var x := c.x + MASK_N / 2
	var y := c.y + MASK_N / 2
	if x < 0 or y < 0 or x >= MASK_N or y >= MASK_N:
		return
	mask_img.set_pixel(x, y, Color(1, 0, 0) if loaded else Color(0, 0, 0))
	_dirty = true


func _resync() -> void:
	mask_img.fill(Color(0, 0, 0))
	for c: Vector2i in world.chunks.keys():
		var x := c.x + MASK_N / 2
		var y := c.y + MASK_N / 2
		if x >= 0 and y >= 0 and x < MASK_N and y < MASK_N:
			mask_img.set_pixel(x, y, Color(1, 0, 0))
	_dirty = true


func _process(delta: float) -> void:
	if _task >= 0 and WorkerThreadPool.is_task_completed(_task):
		WorkerThreadPool.wait_for_task_completion(_task)
		_task = -1
		_finish_terrain()
	_resync_t -= delta
	if _resync_t <= 0.0:
		_resync_t = 2.0
		_resync()
	if _dirty:
		_dirty = false
		mask_tex.update(mask_img)


# ---------------------------------------------------------------------------
# Terreno distante
# ---------------------------------------------------------------------------
func _build_terrain_arrays() -> void:
	var n := GRID + 1
	var hs := PackedFloat32Array()
	hs.resize(n * n)
	var cols := PackedColorArray()
	cols.resize(n * n)
	for iz in n:
		for ix in n:
			var x := -WorldLayout.HALF + ix * STEP
			var z := -WorldLayout.HALF + iz * STEP
			var h := layout.height(x, z)
			var col := _biome_color(x, z, h)
			if layout.is_water(x, z):
				h = maxf(h, WorldLayout.RIVER_LEVEL if layout.river_distance(x, z) < WorldLayout.RIVER_HALF + 8.0 else WorldLayout.LAKE_LEVEL)
			hs[iz * n + ix] = h
			cols[iz * n + ix] = col
	var verts := PackedVector3Array()
	var norms := PackedVector3Array()
	verts.resize(n * n)
	norms.resize(n * n)
	for iz in n:
		for ix in n:
			var h := hs[iz * n + ix]
			verts[iz * n + ix] = Vector3(-WorldLayout.HALF + ix * STEP, h, -WorldLayout.HALF + iz * STEP)
			var hl := hs[iz * n + maxi(ix - 1, 0)]
			var hr := hs[iz * n + mini(ix + 1, n - 1)]
			var hd := hs[maxi(iz - 1, 0) * n + ix]
			var hu := hs[mini(iz + 1, n - 1) * n + ix]
			norms[iz * n + ix] = Vector3(hl - hr, 2.0 * STEP, hd - hu).normalized()
	var idx := PackedInt32Array()
	for iz in GRID:
		for ix in GRID:
			var i00 := iz * n + ix
			var i10 := i00 + 1
			var i01 := i00 + n
			var i11 := i01 + 1
			idx.append_array([i00, i10, i01, i10, i11, i01])
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = norms
	arrays[Mesh.ARRAY_COLOR] = cols
	arrays[Mesh.ARRAY_INDEX] = idx
	_arrays = arrays


func _biome_color(x: float, z: float, h: float) -> Color:
	var d := layout.district_at(x, z)
	var n := sin(x * 0.011 + z * 0.007) * 0.5 + sin(x * 0.023 - z * 0.017) * 0.5
	var col := Color(0.2, 0.27, 0.13)
	var forest := 0.0
	match d:
		"centro", "centro_sul", "bairro_alto", "acacias", "vila_operaria", "industrial":
			col = Color(0.3, 0.3, 0.3).lerp(Color(0.26, 0.3, 0.2), 0.25 + n * 0.1)
		"parque_norte":
			col = Color(0.17, 0.25, 0.11)
			forest = 0.5
		"floresta":
			col = Color(0.1, 0.17, 0.08)
			forest = 1.0
		"serra":
			col = Color(0.13, 0.2, 0.09).lerp(Color(0.36, 0.34, 0.3), smoothstep(40.0, 70.0, h))
			forest = 0.8 * (1.0 - smoothstep(45.0, 70.0, h))
		"rural":
			# talhões: pasto, plantação, terra
			var f := fposmod(floorf(x / 96.0) * 3.0 + floorf(z / 80.0) * 7.0, 5.0)
			col = [Color(0.24, 0.3, 0.13), Color(0.4, 0.37, 0.2), Color(0.3, 0.24, 0.16), Color(0.2, 0.28, 0.12), Color(0.34, 0.33, 0.16)][int(f)]
			forest = 0.15
		"rio":
			col = Color(0.2, 0.26, 0.14)
		_:
			col = Color(0.22, 0.28, 0.13)
			forest = 0.35
	if layout.is_water(x, z):
		col = Color(0.1, 0.13, 0.15)
		forest = 0.0
	col = col.srgb_to_linear()
	col.a = forest
	return col


func _finish_terrain() -> void:
	if _arrays.is_empty():
		return
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, _arrays)
	_arrays = []
	terrain_mi = MeshInstance3D.new()
	terrain_mi.name = "FarTerrain"
	terrain_mi.mesh = mesh
	terrain_mi.material_override = _terrain_mat
	terrain_mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	terrain_mi.custom_aabb = AABB(Vector3(-WorldLayout.HALF, -20, -WorldLayout.HALF), Vector3(WorldLayout.HALF * 2.0, 160, WorldLayout.HALF * 2.0))
	add_child(terrain_mi)


# ---------------------------------------------------------------------------
# Silhueta dos prédios
# ---------------------------------------------------------------------------
func _build_skyline() -> void:
	var list: Array = []
	for b: Dictionary in layout.buildings:
		var floors := int(b.get("floors", 1))
		var h := float(b.get("gfh", 3.0)) + float(maxi(floors - 1, 0)) * float(b.get("fh", 3.0))
		if str(b.get("roof", "flat")) == "gable":
			h += 1.6
		if h < 2.4:
			continue
		list.append([b, h])
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_colors = true
	var box := BoxMesh.new()
	box.size = Vector3.ONE
	mm.mesh = box
	mm.instance_count = list.size()
	for i in list.size():
		var b: Dictionary = list[i][0]
		var h: float = list[i][1]
		var r: Rect2 = b["rect"]
		var c := r.get_center()
		var xf := Transform3D(Basis.from_scale(Vector3(r.size.x, h, r.size.y)), Vector3(c.x, float(b.get("base", 0.1)) + h * 0.5, c.y))
		mm.set_instance_transform(i, xf)
		var layer := int(b.get("layer", Assets.L_PLASTER))
		var tint: Color = b.get("tint", Color(0.9, 0.9, 0.88))
		var col: Color = Assets.FALLBACK_COLORS[clampi(layer, 0, Assets.FALLBACK_COLORS.size() - 1)]
		col = Color(col.r * tint.r, col.g * tint.g, col.b * tint.b) * 1.1
		mm.set_instance_color(i, col.srgb_to_linear())
	sky_mi = MultiMeshInstance3D.new()
	sky_mi.name = "FarSkyline"
	sky_mi.multimesh = mm
	sky_mi.material_override = _sky_mat
	sky_mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(sky_mi)
