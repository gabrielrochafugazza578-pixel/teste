extends Node
## Settings — configurações gráficas, áudio, controles e acessibilidade.
##
## Presets: MUITO BAIXO, BAIXO (alvo: i3-4130 + GTX 750 Ti @ 900p/30 FPS),
## MÉDIO, ALTO, ULTRA. Cada sistema pode ser ajustado individualmente; ao
## mudar qualquer valor manualmente o preset vira "Personalizado" (-1).
##
## Sistemas que dependem de configuração (ambiente, streaming, IA, clima…)
## escutam EventBus.settings_changed e consultam os getters abaixo.

const PATH := "user://settings.cfg"
const PRESET_NAMES := ["MUITO BAIXO", "BAIXO", "MÉDIO", "ALTO", "ULTRA"]
const TEXTURE_SIZES := [256, 512, 1024, 2048]

enum { PRESET_VERY_LOW, PRESET_LOW, PRESET_MEDIUM, PRESET_HIGH, PRESET_ULTRA }

## Valores de cada preset. Os números do BAIXO foram calibrados para
## GTX 750 Ti 2 GB: sombras 2 cascatas 1024, vegetação 50%, glow leve.
const PRESETS := {
	0: {"render_scale": 0.67, "texture_quality": 0, "shadow_quality": 0, "view_distance": 260.0,
		"vegetation_quality": 0, "particle_quality": 0, "post_processing": 0, "object_distance": 0.55,
		"npc_density": 0.4, "infected_density": 0.5, "weather_quality": 0, "reflection_quality": 0,
		"antialiasing": 0, "occlusion_culling": false},
	1: {"render_scale": 0.85, "texture_quality": 1, "shadow_quality": 1, "view_distance": 420.0,
		"vegetation_quality": 1, "particle_quality": 1, "post_processing": 1, "object_distance": 0.8,
		"npc_density": 0.65, "infected_density": 0.75, "weather_quality": 1, "reflection_quality": 1,
		"antialiasing": 1, "occlusion_culling": true},
	2: {"render_scale": 1.0, "texture_quality": 2, "shadow_quality": 2, "view_distance": 620.0,
		"vegetation_quality": 2, "particle_quality": 2, "post_processing": 2, "object_distance": 1.0,
		"npc_density": 0.85, "infected_density": 0.9, "weather_quality": 2, "reflection_quality": 2,
		"antialiasing": 2, "occlusion_culling": true},
	3: {"render_scale": 1.0, "texture_quality": 2, "shadow_quality": 3, "view_distance": 900.0,
		"vegetation_quality": 3, "particle_quality": 3, "post_processing": 3, "object_distance": 1.25,
		"npc_density": 1.0, "infected_density": 1.0, "weather_quality": 3, "reflection_quality": 2,
		"antialiasing": 2, "occlusion_culling": true},
	4: {"render_scale": 1.0, "texture_quality": 3, "shadow_quality": 4, "view_distance": 1300.0,
		"vegetation_quality": 4, "particle_quality": 4, "post_processing": 3, "object_distance": 1.5,
		"npc_density": 1.25, "infected_density": 1.25, "weather_quality": 3, "reflection_quality": 3,
		"antialiasing": 3, "occlusion_culling": true},
}

var graphics := {
	"preset": 1,
	"window_mode": 0, # 0 janela, 1 tela cheia, 2 tela cheia exclusiva
	"resolution": Vector2i(1600, 900),
	"vsync": 1, # 0 off, 1 on, 2 adaptativo
	"fps_limit": 0,
	"fov": 70.0,
	"render_scale": 0.85,
	"texture_quality": 1,
	"shadow_quality": 1,
	"view_distance": 420.0,
	"vegetation_quality": 1,
	"particle_quality": 1,
	"post_processing": 1,
	"object_distance": 0.8,
	"npc_density": 0.65,
	"infected_density": 0.75,
	"weather_quality": 1,
	"reflection_quality": 1,
	"antialiasing": 1, # 0 off, 1 MSAA 2x, 2 MSAA 4x, 3 MSAA 8x
	"occlusion_culling": true,
	"show_fps": false,
}

var audio := {
	"master": 0.9, "music": 0.7, "sfx": 0.9, "ambience": 0.85, "voice": 1.0, "ui": 0.7,
	"subtitles": true,
}

var controls := {
	"mouse_sensitivity": 0.22,
	"gamepad_sensitivity": 2.6,
	"invert_y": false,
	"toggle_sprint": false,
	"toggle_crouch": true,
	"bindings": {},
}

var accessibility := {
	"subtitle_size": 1, # 0 pequeno .. 3 enorme
	"subtitle_background": true,
	"colorblind_mode": 0, # 0 nenhum, 1 protanopia, 2 deuteranopia, 3 tritanopia
	"camera_shake": 1.0,
	"head_bob": 1.0,
	"ui_scale": 1.0,
	"high_contrast_hud": false,
	"reduce_flashing": false,
	"auto_pickup_prompts": true,
}

var gameplay := {
	"difficulty": 1, # 0 fácil, 1 normal, 2 difícil, 3 sobrevivente
	"autosave_minutes": 8.0,
	"show_objective_markers": true,
	"day_length_minutes": 48.0,
}

var first_run := true


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_settings()
	InputSetup.register_all(controls.get("bindings", {}))
	if first_run:
		apply_preset(detect_preset(), false)
		first_run = false
		save_settings()
	apply_all()


# ---------------------------------------------------------------------------
# Detecção de hardware
# ---------------------------------------------------------------------------
func detect_preset() -> int:
	var adapter := RenderingServer.get_video_adapter_name().to_lower()
	if adapter.is_empty() or DisplayServer.get_name() == "headless":
		return PRESET_LOW
	if adapter.contains("llvmpipe") or adapter.contains("software") or adapter.contains("swiftshader"):
		return PRESET_VERY_LOW
	if adapter.contains("intel") and not adapter.contains("arc"):
		return PRESET_VERY_LOW
	for key: String in ["750", "gt 7", "gtx 6", "gt 1030", "hd 7", "r7 ", "rx 550", "rx 460", "950", "960"]:
		if adapter.contains(key):
			return PRESET_LOW
	for key: String in ["970", "980", "1050", "1060", "1650", "rx 470", "rx 480", "rx 570", "rx 580", "arc a3"]:
		if adapter.contains(key):
			return PRESET_MEDIUM
	for key: String in ["1070", "1080", "1660", "2060", "2070", "3050", "3060", "rx 5", "rx 66", "arc a7"]:
		if adapter.contains(key):
			return PRESET_HIGH
	for key: String in ["2080", "3070", "3080", "3090", "rtx 40", "rtx 50", "rx 67", "rx 68", "rx 69", "rx 7", "rx 9"]:
		if adapter.contains(key):
			return PRESET_ULTRA
	return PRESET_LOW


# ---------------------------------------------------------------------------
# Persistência
# ---------------------------------------------------------------------------
func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		first_run = true
		return
	first_run = false
	for section: String in ["graphics", "audio", "controls", "accessibility", "gameplay"]:
		var target: Dictionary = get(section)
		for key in target.keys():
			if cfg.has_section_key(section, key):
				target[key] = cfg.get_value(section, key)


func save_settings() -> void:
	var cfg := ConfigFile.new()
	for section: String in ["graphics", "audio", "controls", "accessibility", "gameplay"]:
		var target: Dictionary = get(section)
		for key in target.keys():
			cfg.set_value(section, key, target[key])
	cfg.save(PATH)


# ---------------------------------------------------------------------------
# Presets e aplicação
# ---------------------------------------------------------------------------
func apply_preset(index: int, apply_now: bool = true) -> void:
	index = clampi(index, 0, 4)
	var p: Dictionary = PRESETS[index]
	for key in p.keys():
		graphics[key] = p[key]
	graphics["preset"] = index
	if apply_now:
		apply_all()


func set_graphics(key: String, value: Variant, apply_now: bool = true) -> void:
	graphics[key] = value
	if PRESETS[0].has(key):
		graphics["preset"] = _matching_preset()
	if apply_now:
		apply_all()


func _matching_preset() -> int:
	for i in PRESETS.keys():
		var p: Dictionary = PRESETS[i]
		var same := true
		for key in p.keys():
			if typeof(p[key]) == TYPE_FLOAT:
				if absf(float(graphics[key]) - float(p[key])) > 0.001:
					same = false
					break
			elif graphics[key] != p[key]:
				same = false
				break
		if same:
			return int(i)
	return -1


func apply_all() -> void:
	_apply_display()
	_apply_viewport()
	_apply_audio()
	EventBus.settings_changed.emit()


func _apply_display() -> void:
	if DisplayServer.get_name() == "headless":
		return
	var mode := int(graphics["window_mode"])
	match mode:
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		_:
			if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			var res: Vector2i = graphics["resolution"]
			var screen := DisplayServer.screen_get_size()
			res.x = mini(res.x, screen.x)
			res.y = mini(res.y, screen.y)
			if DisplayServer.window_get_size() != res:
				DisplayServer.window_set_size(res)
				DisplayServer.window_set_position((screen - res) / 2)
	match int(graphics["vsync"]):
		0: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		2: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
		_: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	Engine.max_fps = int(graphics["fps_limit"])


func _apply_viewport() -> void:
	var vp := get_tree().root
	if vp == null:
		return
	# Compatibility suporta apenas escala bilinear; a resolução interna menor
	# é o principal ganho de GPU no hardware alvo.
	vp.scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
	vp.scaling_3d_scale = clampf(float(graphics["render_scale"]), 0.5, 1.0)
	# O renderer Compatibility (GL3) só oferece MSAA; FXAA/TAA são exclusivos
	# de Forward+/Mobile. 2x MSAA é o ponto ideal na GTX 750 Ti.
	var aa := int(graphics["antialiasing"])
	match aa:
		1: vp.msaa_3d = Viewport.MSAA_2X
		2: vp.msaa_3d = Viewport.MSAA_4X
		3: vp.msaa_3d = Viewport.MSAA_8X
		_: vp.msaa_3d = Viewport.MSAA_DISABLED
	vp.use_debanding = int(graphics["post_processing"]) >= 3
	vp.use_occlusion_culling = bool(graphics["occlusion_culling"])
	vp.mesh_lod_threshold = lerpf(4.0, 1.0, float(graphics["object_distance"]) / 1.5)
	var sq := int(graphics["shadow_quality"])
	var sizes := [512, 1024, 2048, 4096, 4096]
	RenderingServer.directional_shadow_atlas_set_size(sizes[sq], true)
	RenderingServer.directional_soft_shadow_filter_set_quality([0, 1, 1, 2, 3][sq])
	RenderingServer.positional_soft_shadow_filter_set_quality([0, 0, 1, 2, 3][sq])
	vp.positional_shadow_atlas_size = [256, 512, 1024, 2048, 4096][sq]
	RenderingServer.global_shader_parameter_set("detail_distance", get_detail_distance())


func _apply_audio() -> void:
	var map := {"Master": "master", "Music": "music", "SFX": "sfx", "Ambience": "ambience", "Voice": "voice", "UI": "ui"}
	for bus_name in map.keys():
		var idx := AudioServer.get_bus_index(bus_name)
		if idx >= 0:
			var v := clampf(float(audio[map[bus_name]]), 0.0, 1.0)
			AudioServer.set_bus_volume_db(idx, linear_to_db(maxf(v, 0.0001)))
			AudioServer.set_bus_mute(idx, v <= 0.001)


func set_audio(key: String, value: Variant) -> void:
	audio[key] = value
	_apply_audio()
	EventBus.settings_changed.emit()


func rebind(action: String, code: int) -> void:
	var b: Dictionary = controls["bindings"]
	b[action] = code
	controls["bindings"] = b
	InputSetup.register_all(b)


func reset_bindings() -> void:
	controls["bindings"] = {}
	InputSetup.register_all({})


# ---------------------------------------------------------------------------
# Getters derivados (consultados pelos sistemas)
# ---------------------------------------------------------------------------
func get_texture_size() -> int:
	return TEXTURE_SIZES[clampi(int(graphics["texture_quality"]), 0, 3)]


## [habilitado, distância máxima, modo de cascatas (1,2,4), blend]
func get_shadow_params() -> Dictionary:
	var q := int(graphics["shadow_quality"])
	match q:
		0: return {"enabled": false, "distance": 0.0, "splits": 1, "character_shadows": false, "local_shadows": false}
		1: return {"enabled": true, "distance": 55.0, "splits": 2, "character_shadows": true, "local_shadows": false}
		2: return {"enabled": true, "distance": 90.0, "splits": 2, "character_shadows": true, "local_shadows": false}
		3: return {"enabled": true, "distance": 140.0, "splits": 4, "character_shadows": true, "local_shadows": true}
		_: return {"enabled": true, "distance": 200.0, "splits": 4, "character_shadows": true, "local_shadows": true}


func get_view_distance() -> float:
	return float(graphics["view_distance"])


## Distância até onde detalhes (props, decalques, interiores) aparecem.
func get_detail_distance() -> float:
	return 70.0 * float(graphics["object_distance"])


func get_vegetation_density() -> float:
	return [0.2, 0.45, 0.7, 1.0, 1.3][clampi(int(graphics["vegetation_quality"]), 0, 4)]


func get_grass_distance() -> float:
	return [0.0, 26.0, 38.0, 52.0, 70.0][clampi(int(graphics["vegetation_quality"]), 0, 4)]


func get_tree_distance() -> float:
	return clampf(get_view_distance() * 0.8, 180.0, 900.0)


func get_particle_multiplier() -> float:
	return [0.2, 0.45, 0.75, 1.0, 1.5][clampi(int(graphics["particle_quality"]), 0, 4)]


func get_weather_quality() -> int:
	return int(graphics["weather_quality"])


func get_post_quality() -> int:
	return int(graphics["post_processing"])


func get_reflection_quality() -> int:
	return int(graphics["reflection_quality"])


## Limite de infectados com nó ativo (o resto é simulação abstrata).
func get_infected_cap() -> int:
	return int(round(34.0 * float(graphics["infected_density"])))


func get_npc_cap() -> int:
	return int(round(14.0 * float(graphics["npc_density"])))


func get_ai_budget_usec() -> int:
	return 2200 if int(graphics["preset"]) <= 1 else 3200


func get_stream_budget_usec() -> int:
	return 3500 if int(graphics["preset"]) <= 1 else 5000


func get_fov() -> float:
	return float(graphics["fov"])


func difficulty() -> int:
	return int(gameplay["difficulty"])


func damage_taken_multiplier() -> float:
	return [0.6, 1.0, 1.35, 1.7][clampi(difficulty(), 0, 3)]


func needs_multiplier() -> float:
	return [0.7, 1.0, 1.2, 1.45][clampi(difficulty(), 0, 3)]


func loot_multiplier() -> float:
	return [1.35, 1.0, 0.8, 0.6][clampi(difficulty(), 0, 3)]
