extends Node
## Assets — biblioteca central de texturas, materiais e malhas compartilhadas.
##
## Todas as texturas são geradas na GPU uma única vez (shaders/bake_surface)
## e empacotadas em Texture2DArray: 16 camadas PBR em apenas 2 texturas,
## permitindo que prédios, ruas e props de um chunk inteiro usem o MESMO
## material (menos trocas de estado e menos draw calls no renderer GL).
##
## Orçamento de VRAM (sem compressão em runtime):
##   512px  -> 16 camadas × 2 mapas × 1,33 (mips) × 1 MB  ≈ 45 MB  (BAIXO)
##   1024px ->                                         ≈ 180 MB (MÉDIO/ALTO)
##   2048px ->                                         ≈ 720 MB (ULTRA, GPUs modernas)

signal bake_progress(p: float, label: String)
signal bake_finished

enum { L_ASPHALT, L_CONCRETE, L_BRICK, L_PLASTER, L_ROOF, L_METAL, L_WOOD, L_GRASS,
	L_DIRT, L_ROCK, L_TILES, L_PANELS, L_GRAVEL, L_BARK, L_FABRIC, L_LINOLEUM }
enum { WM_NONE, WM_RES, WM_OFFICE, WM_SHOP }

const LAYER_COUNT := 16
const LAYER_SCALES := [0.34, 0.5, 1.0, 0.5, 1.0, 1.0, 1.0, 0.5, 0.5, 0.25, 1.0, 0.34, 1.0, 1.0, 2.0, 0.5]
const LAYER_NAMES := ["asfalto", "concreto", "tijolo", "reboco", "telha", "metal", "madeira", "grama",
	"terra", "rocha", "piso", "painel", "cascalho", "casca", "tecido", "linóleo"]
## Cores de reserva (modo headless/servidor ou falha de GPU).
const FALLBACK_COLORS := [Color(0.14, 0.14, 0.15), Color(0.5, 0.5, 0.48), Color(0.5, 0.25, 0.17),
	Color(0.8, 0.8, 0.78), Color(0.55, 0.25, 0.15), Color(0.38, 0.42, 0.45), Color(0.4, 0.27, 0.16),
	Color(0.16, 0.24, 0.08), Color(0.3, 0.22, 0.15), Color(0.4, 0.38, 0.35), Color(0.66, 0.62, 0.55),
	Color(0.58, 0.57, 0.55), Color(0.42, 0.4, 0.36), Color(0.22, 0.17, 0.12), Color(0.8, 0.8, 0.8),
	Color(0.56, 0.6, 0.57)]
const FALLBACK_ROUGH := [0.85, 0.9, 0.85, 0.85, 0.7, 0.5, 0.75, 0.95, 0.95, 0.85, 0.3, 0.78, 0.93, 0.9, 0.95, 0.32]

const SPR_SMOKE := 0
const SPR_PAPER := 1
const SPR_SPARK := 2
const SPR_RAIN := 3
const SPR_LEAF := 4

var surface_a: Texture2DArray
var surface_b: Texture2DArray
var char_a: Texture2DArray
var weapon_a: Texture2DArray
var weapon_b: Texture2DArray
var char_b: Texture2DArray
var leaf_tex: Texture2D
var noise_tex: Texture2D
var sprites: Array = []
var baked_size: int = 0
var is_baked: bool = false
var is_baking: bool = false

var _mats: Dictionary = {}
var _tex_users: Array = []   # materiais que recebem as texturas (atualizados no rebake)
var _mesh_cache: Dictionary = {}
var _shaders: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	EventBus.settings_changed.connect(_on_settings_changed)


func _on_settings_changed() -> void:
	if is_baked and not is_baking and Settings.get_texture_size() != baked_size and not Util.is_headless():
		bake_all()


func shader(path: String) -> Shader:
	if not _shaders.has(path):
		_shaders[path] = load(path)
	return _shaders[path]


static func uv2_code(layer: int, wmode: int = 0) -> float:
	return float(layer + 16 * wmode)


# ---------------------------------------------------------------------------
# Geração de texturas
# ---------------------------------------------------------------------------
func bake_all() -> void:
	if is_baking:
		await bake_finished
		return
	is_baking = true
	var size := Settings.get_texture_size()
	if Util.is_headless():
		_make_fallback(8)
	else:
		await _bake_gpu(size)
	baked_size = size
	is_baked = true
	is_baking = false
	_refresh_materials()
	bake_finished.emit()


func _bake_gpu(size: int) -> void:
	var vp := SubViewport.new()
	vp.size = Vector2i(size, size)
	vp.transparent_bg = true
	vp.disable_3d = true
	vp.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	var rect := ColorRect.new()
	rect.size = Vector2(size, size)
	rect.position = Vector2.ZERO
	var mat := ShaderMaterial.new()
	mat.shader = shader("res://shaders/bake_surface.gdshader")
	rect.material = mat
	vp.add_child(rect)
	add_child(vp)
	await RenderingServer.frame_post_draw

	var jobs_total := LAYER_COUNT * 2 + 2 + 1 + 5 + 1
	var done := 0
	var imgs_a: Array[Image] = []
	var imgs_b: Array[Image] = []
	_load_photo_scales()
	# fotos 2K já comprimidas (BC7 + mipmaps): na qualidade menor só descarta os
	# níveis de cima. Qualidade das camadas um degrau acima da das demais texturas
	# (comprimidas, 2K custam o mesmo que 1K em RGBA).
	var photo_size := clampi(size * 2, 512, 2048)
	var all_photo := photo_scales.size() == LAYER_COUNT
	for layer in LAYER_COUNT:
		for ch in 2:
			# foto CC0 (assets/materials) quando existe; senão a textura procedural
			var img := _photo_layer(layer, ch, photo_size if all_photo else size)
			if img == null:
				img = await _render(vp, mat, 0, layer, ch, size)
			if not img.is_compressed():
				# sem "renormalizar": o canal azul de B é a oclusão (o shader refaz o z da normal)
				img.generate_mipmaps(false)
			if ch == 0:
				imgs_a.append(img)
			else:
				imgs_b.append(img)
			done += 1
			bake_progress.emit(float(done) / jobs_total, "Materiais: " + LAYER_NAMES[layer])
	surface_a = Texture2DArray.new()
	surface_a.create_from_images(imgs_a)
	surface_b = Texture2DArray.new()
	surface_b.create_from_images(imgs_b)

	var ca := await _render(vp, mat, 1, 0, 0, size)
	char_a = _atlas_to_array(ca, false, "a")
	var cb := await _render(vp, mat, 1, 0, 1, size)
	char_b = _atlas_to_array(cb, true, "b")
	var wa := await _render(vp, mat, 5, 0, 0, size)
	weapon_a = _atlas_to_array(wa, false)
	var wb := await _render(vp, mat, 5, 0, 1, size)
	weapon_b = _atlas_to_array(wb, true)
	done += 2
	bake_progress.emit(float(done) / jobs_total, "Personagens")

	# folhas / sprites / ruído em resolução menor
	var small := clampi(size / 2, 128, 512)
	vp.size = Vector2i(small, small)
	rect.size = Vector2(small, small)
	var lf := await _render(vp, mat, 2, 0, 0, small)
	lf.generate_mipmaps()
	leaf_tex = ImageTexture.create_from_image(lf)
	done += 1
	sprites.clear()
	var sprite_size := 128
	vp.size = Vector2i(sprite_size, sprite_size)
	rect.size = Vector2(sprite_size, sprite_size)
	for i in 5:
		var sp := await _render(vp, mat, 3, i, 0, sprite_size)
		sp.generate_mipmaps()
		sprites.append(ImageTexture.create_from_image(sp))
		done += 1
	bake_progress.emit(float(done) / jobs_total, "Partículas")
	vp.size = Vector2i(256, 256)
	rect.size = Vector2(256, 256)
	var nz := await _render(vp, mat, 4, 0, 0, 256)
	nz.generate_mipmaps()
	noise_tex = ImageTexture.create_from_image(nz)
	done += 1
	bake_progress.emit(1.0, "Pronto")
	vp.queue_free()


func _render(vp: SubViewport, mat: ShaderMaterial, mode: int, layer: int, ch: int, size: int) -> Image:
	mat.set_shader_parameter("mode", mode)
	mat.set_shader_parameter("layer", layer)
	mat.set_shader_parameter("channel", ch)
	mat.set_shader_parameter("px", 1.0 / float(size))
	# dois frames: garante que a imagem lida corresponde aos parâmetros atuais
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var img := vp.get_texture().get_image()
	if img == null or img.is_empty():
		img = Image.create_empty(size, size, false, Image.FORMAT_RGBA8)
		img.fill(Color(0.5, 0.5, 0.5, 0.8))
	if img.get_format() != Image.FORMAT_RGBA8:
		img.convert(Image.FORMAT_RGBA8)
	if img.get_width() != size or img.get_height() != size:
		img.resize(size, size, Image.INTERPOLATE_BILINEAR)
	return img


func _make_fallback(s: int) -> void:
	var imgs_a: Array[Image] = []
	var imgs_b: Array[Image] = []
	for i in LAYER_COUNT:
		var a := Image.create_empty(s, s, false, Image.FORMAT_RGBA8)
		var c: Color = FALLBACK_COLORS[i]
		c.a = FALLBACK_ROUGH[i]
		a.fill(c)
		a.generate_mipmaps()
		imgs_a.append(a)
		var b := Image.create_empty(s, s, false, Image.FORMAT_RGBA8)
		b.fill(Color(0.5, 0.5, 1.0, 0.0))
		b.generate_mipmaps()
		imgs_b.append(b)
	surface_a = Texture2DArray.new()
	surface_a.create_from_images(imgs_a)
	surface_b = Texture2DArray.new()
	surface_b.create_from_images(imgs_b)
	var ca := Image.create_empty(s, s, false, Image.FORMAT_RGBA8)
	ca.fill(Color(0.9, 0.9, 0.9, 0.7))
	char_a = _atlas_to_array(ca, false)
	var cb := Image.create_empty(s, s, false, Image.FORMAT_RGBA8)
	cb.fill(Color(0.5, 0.5, 1.0, 0.0))
	char_b = _atlas_to_array(cb, true)
	var wa := Image.create_empty(s, s, false, Image.FORMAT_RGBA8)
	wa.fill(Color(0.5, 0.5, 0.5, 0.5))
	weapon_a = _atlas_to_array(wa, false)
	weapon_b = _atlas_to_array(cb, true)
	var lf := Image.create_empty(s, s, false, Image.FORMAT_RGBA8)
	lf.fill(Color(0.2, 0.3, 0.1, 1.0))
	leaf_tex = ImageTexture.create_from_image(lf)
	sprites.clear()
	for i in 5:
		var sp := Image.create_empty(s, s, false, Image.FORMAT_RGBA8)
		sp.fill(Color(0.8, 0.8, 0.8, 0.5))
		sprites.append(ImageTexture.create_from_image(sp))
	var nz := Image.create_empty(s, s, false, Image.FORMAT_RGBA8)
	nz.fill(Color(0.5, 0.5, 0.5, 0.5))
	noise_tex = ImageTexture.create_from_image(nz)


# ---------------------------------------------------------------------------
# Texturas fotográficas (Poly Haven, CC0) — tools/fetch_textures.py
# ---------------------------------------------------------------------------
const PHOTO_DIR := "res://assets/materials/"
const FOLIAGE_DIR := "res://assets/textures/foliage/"
## escala real (repetições por metro) das camadas que têm foto
var photo_scales: Dictionary = {}


## repetições por metro de cada camada do detalhe de personagem (pele, malha, brim, couro)
var char_rep := Vector4(2.2, 2.2, 2.2, 2.2)


func _load_photo_scales() -> void:
	photo_scales.clear()
	var txt := FileAccess.get_file_as_string(PHOTO_DIR + "escala.json")
	var d = JSON.parse_string(txt) if txt != "" else null
	if typeof(d) == TYPE_DICTIONARY and d.has("escala_roupas"):
		var er: Dictionary = d["escala_roupas"]
		for q in [1, 2, 3]:
			if er.has(str(q)) and ResourceLoader.exists("%schar_%d_a.res" % [PHOTO_DIR, q]):
				char_rep[q] = float(er[str(q)])
	if typeof(d) == TYPE_DICTIONARY and d.has("escala"):
		for k in (d["escala"] as Dictionary).keys():
			if ResourceLoader.exists("%s%02d_a.res" % [PHOTO_DIR, int(k)]) and ResourceLoader.exists("%s%02d_b.res" % [PHOTO_DIR, int(k)]):
				photo_scales[int(k)] = float(d["escala"][k])


## Foto da camada (Image .res em BC7 com mipmaps, de tools/pack_layers.gd).
## Se `size` for menor que a foto, começa num nível de mipmap mais baixo (sem
## descomprimir). Se faltar alguma foto, as camadas voltam a RGBA no tamanho
## das procedurais (o Texture2DArray exige o mesmo formato em todas).
func _photo_layer(layer: int, ch: int, size: int) -> Image:
	if not photo_scales.has(layer):
		return null
	var path := "%s%02d_%s.res" % [PHOTO_DIR, layer, "a" if ch == 0 else "b"]
	var src := load(path) as Image
	if src == null:
		return null
	var img := src
	# --texturas-rgba: descomprime (testes em Vulkan por software, onde BC7 é
	# decodificado na CPU a cada amostra e a imagem leva minutos por quadro)
	if photo_scales.size() < LAYER_COUNT or "--texturas-rgba" in OS.get_cmdline_user_args():
		size = mini(size, 1024)
		img = src.duplicate() as Image
		if img.is_compressed():
			img.decompress()
		if img.has_mipmaps():
			img.clear_mipmaps()
		img.convert(Image.FORMAT_RGBA8)
		if img.get_width() != size:
			img.resize(size, size, Image.INTERPOLATE_LANCZOS)
		return img
	if img.get_width() > size and img.has_mipmaps():
		var w := img.get_width()
		var lv := 0
		while w > size:
			w >>= 1
			lv += 1
		var data := img.get_data().slice(img.get_mipmap_offset(lv))
		img = Image.create_from_data(w, w, true, img.get_format(), data)
	return img


## Escala por camada usada pelos materiais: a real da foto ou a procedural.
func layer_scales() -> PackedFloat32Array:
	var out := PackedFloat32Array(LAYER_SCALES)
	for k in photo_scales.keys():
		out[int(k)] = float(photo_scales[k])
	return out


## Atlas 2×2 de personagens (pele, malha, brim, couro) => Texture2DArray de 4
## camadas: sem "vazamento" do quadrante vizinho nas bordas de repetição.
func _atlas_to_array(img: Image, normal: bool, ch: String = "") -> Texture2DArray:
	if img.has_mipmaps():
		img.clear_mipmaps()
	var half := img.get_width() / 2
	var layers: Array[Image] = []
	for q in 4:
		var part := img.get_region(Rect2i((q % 2) * half, (q / 2) * half, half, half))
		# tecidos fotográficos (malha, brim, couro) no lugar dos procedurais; a pele (0) fica
		var photo := "%schar_%d_%s.res" % [PHOTO_DIR, q, ch]
		if q > 0 and ch != "" and ResourceLoader.exists(photo):
			var src := load(photo) as Image
			if src:
				var p := src.duplicate() as Image
				if p.is_compressed():
					p.decompress()
				if p.has_mipmaps():
					p.clear_mipmaps()
				p.convert(Image.FORMAT_RGBA8)
				if p.get_width() != half:
					p.resize(half, half, Image.INTERPOLATE_LANCZOS)
				part = p
		part.generate_mipmaps(normal)
		layers.append(part)
	var arr := Texture2DArray.new()
	arr.create_from_images(layers)
	return arr


func _refresh_materials() -> void:
	var sc := layer_scales()
	for m in _tex_users:
		if m is ShaderMaterial:
			_assign_textures(m)
			if (m as ShaderMaterial).shader and (m as ShaderMaterial).shader.resource_path.ends_with("world_surface.gdshader"):
				m.set_shader_parameter("layer_scales", sc)
			elif (m as ShaderMaterial).shader and (m as ShaderMaterial).shader.resource_path.ends_with("terrain.gdshader"):
				_terrain_scales(m)
	if _mats.has("leaf_particle") and SPR_LEAF < sprites.size():
		(_mats["leaf_particle"] as ShaderMaterial).set_shader_parameter("tex", sprites[SPR_LEAF])


func _assign_textures(m: ShaderMaterial) -> void:
	var sh := m.shader
	if sh == null:
		return
	m.set_shader_parameter("tex_a", surface_a)
	m.set_shader_parameter("tex_b", surface_b)
	m.set_shader_parameter("noise_tex", noise_tex)
	# fotos do Poly Haven: canal A de tex_b é o relevo (nas procedurais é o metal)
	m.set_shader_parameter("has_height", photo_scales.size() == LAYER_COUNT)
	m.set_shader_parameter("detail_a", char_a)
	m.set_shader_parameter("detail_b", char_b)
	m.set_shader_parameter("detail_rep", char_rep)
	m.set_shader_parameter("leaf_tex", m.get_meta("photo_tex") if m.has_meta("photo_tex") else leaf_tex)
	m.set_shader_parameter("weapon_a", weapon_a)
	m.set_shader_parameter("weapon_b", weapon_b)


## Material de fora da biblioteca que usa as texturas compartilhadas (camadas,
## ruído): recebe agora e de novo a cada rebake.
func track_textures(m: ShaderMaterial) -> ShaderMaterial:
	return _track(m)


func _track(m: ShaderMaterial) -> ShaderMaterial:
	_tex_users.append(m)
	_assign_textures(m)
	return m


# ---------------------------------------------------------------------------
# Materiais
# ---------------------------------------------------------------------------
## kind: "exterior" (prédios/ruas), "interior", "props" (multimesh com tinta),
##       "props_interior", "roads"
func world_material(kind: String = "exterior") -> ShaderMaterial:
	var key := "world_" + kind
	if _mats.has(key):
		return _mats[key]
	var m := ShaderMaterial.new()
	m.shader = shader("res://shaders/world_surface.gdshader")
	m.set_shader_parameter("layer_scales", layer_scales())
	match kind:
		"interior":
			m.set_shader_parameter("exterior", false)
			m.set_shader_parameter("enable_windows", false)
			m.set_shader_parameter("enable_puddles", false)
			m.set_shader_parameter("grime", 0.55)
		"props":
			m.set_shader_parameter("use_instance_tint", true)
			m.set_shader_parameter("enable_windows", false)
		"props_interior":
			m.set_shader_parameter("use_instance_tint", true)
			m.set_shader_parameter("exterior", false)
			m.set_shader_parameter("enable_windows", false)
			m.set_shader_parameter("enable_puddles", false)
			m.set_shader_parameter("grime", 0.5)
		"roads":
			m.set_shader_parameter("enable_windows", false)
		_:
			pass
	_mats[key] = _track(m)
	return m


func terrain_material() -> ShaderMaterial:
	if _mats.has("terrain"):
		return _mats["terrain"]
	var m := ShaderMaterial.new()
	m.shader = shader("res://shaders/terrain.gdshader")
	_mats["terrain"] = _track(m)
	_terrain_scales(m)
	return m


## Terreno: terra/rocha/cascalho com a escala real da foto (rocha um pouco
## maior: encosta inteira com a mesma pedra miúda fica repetitiva)
func _terrain_scales(m: ShaderMaterial) -> void:
	if photo_scales.has(L_GRASS):
		m.set_shader_parameter("grass_scale", float(photo_scales[L_GRASS]))
	if photo_scales.has(L_DIRT):
		m.set_shader_parameter("dirt_scale", float(photo_scales[L_DIRT]))
	if photo_scales.has(L_ROCK):
		m.set_shader_parameter("rock_scale", float(photo_scales[L_ROCK]) * 0.5)
	if photo_scales.has(L_GRAVEL):
		m.set_shader_parameter("gravel_scale", float(photo_scales[L_GRAVEL]))


func water_material() -> ShaderMaterial:
	if _mats.has("water"):
		return _mats["water"]
	var m := ShaderMaterial.new()
	# Forward+: água opaca (recebe SSR) com margem pela profundidade
	m.shader = shader("res://shaders/water_fp.gdshader" if Settings.is_forward_plus() else "res://shaders/water.gdshader")
	m.render_priority = -1
	_mats["water"] = _track(m)
	return m


func foliage_material(kind: String = "tree") -> ShaderMaterial:
	var key := "foliage_" + kind
	if _mats.has(key):
		return _mats[key]
	var m := ShaderMaterial.new()
	m.shader = shader("res://shaders/foliage.gdshader")
	# folhagem fotográfica (tools/make_foliage.py, folhas dos modelos do Poly Haven)
	var photo := {"tree": "leaves_tree", "bush": "leaves_bush", "vine": "leaves_vine", "pine": "leaves_pine",
		"dry": "frond_palm", "jacaranda": "leaves_jacaranda", "acacia": "leaves_acacia"}
	var tex_path := FOLIAGE_DIR + str(photo.get(kind, "leaves_tree")) + ".png"
	if ResourceLoader.exists(tex_path):
		m.set_meta("photo_tex", load(tex_path))
		m.set_shader_parameter("photo", true)
		m.set_shader_parameter("alpha_cut", 0.5)
		match kind:
			"pine": m.set_shader_parameter("tint", Vector3(0.78, 0.9, 0.8))
			"dry": m.set_shader_parameter("tint", Vector3(1.0, 1.0, 0.9))
			"jacaranda": m.set_shader_parameter("tint", Vector3(0.72, 0.86, 0.66))
			"acacia": m.set_shader_parameter("tint", Vector3(0.95, 1.0, 0.92))
			_: m.set_shader_parameter("tint", Vector3(1.0, 1.0, 1.0))
	else:
		match kind:
			"pine": m.set_shader_parameter("tint", Vector3(0.62, 0.82, 0.68))
			"dry": m.set_shader_parameter("tint", Vector3(1.25, 1.0, 0.62))
			"bush": m.set_shader_parameter("tint", Vector3(0.85, 1.0, 0.8))
			"vine": m.set_shader_parameter("tint", Vector3(0.75, 0.95, 0.7))
			_: m.set_shader_parameter("tint", Vector3(1.0, 1.0, 1.0))
	var far := Settings.get_tree_distance()
	m.set_shader_parameter("fade_start", far * 0.9)
	m.set_shader_parameter("fade_end", far)
	_mats[key] = _track(m)
	return m


func grass_material() -> ShaderMaterial:
	if _mats.has("grass"):
		return _mats["grass"]
	var m := ShaderMaterial.new()
	m.shader = shader("res://shaders/grass.gdshader")
	m.set_shader_parameter("fade_distance", maxf(Settings.get_grass_distance(), 10.0))
	var tuft := FOLIAGE_DIR + "grass_tuft.png"
	if ResourceLoader.exists(tuft):
		m.set_shader_parameter("grass_tex", load(tuft))
		m.set_shader_parameter("photo", true)
	else:
		m.set_shader_parameter("grass_tex", load("res://assets/textures/grass_bush.png"))
	_mats["grass"] = m
	return m


func glass_material(condensation: float = 0.0, dirt: float = 0.2) -> ShaderMaterial:
	var key := "glass_%.2f_%.2f" % [condensation, dirt]
	if _mats.has(key):
		return _mats[key]
	var m := ShaderMaterial.new()
	m.shader = shader("res://shaders/glass.gdshader")
	m.set_shader_parameter("condensation", condensation)
	m.set_shader_parameter("dirt", dirt)
	m.render_priority = 1
	_mats[key] = _track(m)
	return m


## Material único por instância (glass do paciente animado na cinemática etc.)
func glass_material_unique() -> ShaderMaterial:
	var m := ShaderMaterial.new()
	m.shader = shader("res://shaders/glass.gdshader")
	m.render_priority = 1
	return _track(m)


func screen_material(style: int, seed_value: float = 0.0, tint: Color = Color(0.45, 0.85, 0.75)) -> ShaderMaterial:
	var m := ShaderMaterial.new()
	m.shader = shader("res://shaders/screen_monitor.gdshader")
	m.set_shader_parameter("style", style)
	m.set_shader_parameter("seed", seed_value)
	m.set_shader_parameter("tint", tint)
	return m


func character_material(infection: float = 0.0) -> ShaderMaterial:
	var m := ShaderMaterial.new()
	m.shader = shader("res://shaders/character.gdshader")
	m.set_shader_parameter("infection", infection)
	m.set_shader_parameter("detail_a", char_a)
	m.set_shader_parameter("detail_b", char_b)
	return m


func window_light_material() -> ShaderMaterial:
	if _mats.has("window_light"):
		return _mats["window_light"]
	var m := ShaderMaterial.new()
	m.shader = shader("res://shaders/window_light.gdshader")
	_mats["window_light"] = m
	return m


## mode 0 poste, 1 semáforo, 2 sempre aceso
func power_emitter(mode: int, color: Color = Color(1.0, 0.82, 0.55), energy: float = 2.5) -> ShaderMaterial:
	var key := "power_%d_%s_%.1f" % [mode, color.to_html(), energy]
	if _mats.has(key):
		return _mats[key]
	var m := ShaderMaterial.new()
	m.shader = shader("res://shaders/emissive_power.gdshader")
	m.set_shader_parameter("mode", mode)
	m.set_shader_parameter("color", color)
	m.set_shader_parameter("energy", energy)
	_mats[key] = m
	return m


## Material das armas (atlas nogueira/aço/polímero/borracha, UV2.x = camada).
func weapon_material() -> ShaderMaterial:
	if _mats.has("weapon"):
		return _mats["weapon"]
	var m := ShaderMaterial.new()
	m.shader = shader("res://shaders/weapon.gdshader")
	_mats["weapon"] = _track(m)
	return m


## Itens soltos no mundo: mesmo atlas das armas, com a luz indireta dos interiores.
func item_material() -> ShaderMaterial:
	if _mats.has("item"):
		return _mats["item"]
	var m := ShaderMaterial.new()
	m.shader = shader("res://shaders/weapon.gdshader")
	_mats["item"] = _track(m)
	return m


func sky_material() -> ShaderMaterial:
	var m := ShaderMaterial.new()
	m.shader = shader("res://shaders/sky.gdshader")
	return _track(m)


## Material PBR simples (veículos, metal pintado, borracha…) com cache.
func pbr(color: Color, rough: float = 0.6, metal: float = 0.0, emission: Color = Color.BLACK, energy: float = 0.0) -> StandardMaterial3D:
	var key := "pbr_%s_%.2f_%.2f_%s_%.2f" % [color.to_html(), rough, metal, emission.to_html(), energy]
	if _mats.has(key):
		return _mats[key]
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = rough
	m.metallic = metal
	m.metallic_specular = 0.5
	if energy > 0.0:
		m.emission_enabled = true
		m.emission = emission
		m.emission_energy_multiplier = energy
	_mats[key] = m
	return m


func emissive(color: Color, energy: float = 2.0) -> StandardMaterial3D:
	var key := "emit_%s_%.2f" % [color.to_html(), energy]
	if _mats.has(key):
		return _mats[key]
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = color * energy
	m.albedo_color.a = 1.0
	_mats[key] = m
	return m


## Material de partícula (billboard), com sprite gerado.
func particle_material(sprite: int, color: Color = Color.WHITE, additive: bool = false, billboard: int = BaseMaterial3D.BILLBOARD_PARTICLES) -> StandardMaterial3D:
	var key := "part_%d_%s_%s_%d" % [sprite, color.to_html(), str(additive), billboard]
	if _mats.has(key):
		return _mats[key]
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.albedo_color = color
	if sprite >= 0 and sprite < sprites.size():
		m.albedo_texture = sprites[sprite]
	m.vertex_color_use_as_albedo = true
	m.billboard_mode = billboard
	m.billboard_keep_scale = true
	if billboard == BaseMaterial3D.BILLBOARD_PARTICLES:
		m.particles_anim_h_frames = 1
		m.particles_anim_v_frames = 1
	if additive:
		m.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	_mats[key] = m
	return m


## Papel/folhas voando: iluminado, com recorte alfa.
func debris_material(sprite: int, vcol: bool = false) -> StandardMaterial3D:
	var key := "debris_%d_%s" % [sprite, str(vcol)]
	if _mats.has(key):
		return _mats[key]
	var m := StandardMaterial3D.new()
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	m.alpha_scissor_threshold = 0.5
	if sprite < sprites.size():
		m.albedo_texture = sprites[sprite]
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	m.roughness = 0.9
	m.vertex_color_use_as_albedo = vcol
	_mats[key] = m
	return m


## Folha solta caindo das árvores (partícula tingida pela cor da instância).
func leaf_particle_material() -> ShaderMaterial:
	if _mats.has("leaf_particle"):
		return _mats["leaf_particle"]
	var m := ShaderMaterial.new()
	m.shader = load("res://shaders/leaf_particle.gdshader")
	if SPR_LEAF < sprites.size():
		m.set_shader_parameter("tex", sprites[SPR_LEAF])
	_mats["leaf_particle"] = m
	return m


# ---------------------------------------------------------------------------
# Cache de malhas
# ---------------------------------------------------------------------------
func cached_mesh(key: String, builder: Callable) -> Mesh:
	if _mesh_cache.has(key):
		return _mesh_cache[key]
	var m: Mesh = builder.call()
	_mesh_cache[key] = m
	return m


func has_mesh(key: String) -> bool:
	return _mesh_cache.has(key)
