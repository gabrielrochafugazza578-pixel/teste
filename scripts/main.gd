extends Node3D
## Monta a cena do jogo: ambiente, ceu, sol, mundo, jogador e interface.
## Tambem contem o modo "foto" usado para gerar screenshots automaticamente.

var env: Environment
var sky_mat: ShaderMaterial
var sun: DirectionalLight3D
var day_night: DayNight
var world: World
var player: Player

var _shot_frames := 0
var _shot_elapsed := 0.0


func _ready() -> void:
	_build_environment()
	world = World.new()
	world.name = "World"
	if Game.has_arg("radius"):
		world.view_radius = int(Game.arg("radius"))
	add_child(world)

	player = Player.new()
	player.name = "Player"
	player.world = world
	add_child(player)
	world.focus = player

	if Game.is_screenshot_mode():
		_setup_screenshot()
	else:
		var spawn := find_spawn()
		player.global_position = spawn
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _build_environment() -> void:
	var we := WorldEnvironment.new()
	env = Environment.new()
	env.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	sky_mat = ShaderMaterial.new()
	sky_mat.shader = load("res://shaders/sky.gdshader")
	sky.sky_material = sky_mat
	sky.radiance_size = Sky.RADIANCE_SIZE_32
	sky.process_mode = Sky.PROCESS_MODE_REALTIME
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_energy = 1.0
	env.ambient_light_sky_contribution = 0.0
	env.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
	env.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	env.fog_enabled = true
	env.fog_mode = Environment.FOG_MODE_DEPTH
	env.fog_density = 1.0
	env.fog_depth_begin = 70.0
	env.fog_depth_end = 125.0
	env.fog_depth_curve = 1.4
	env.fog_sky_affect = 0.0
	env.glow_enabled = true
	env.glow_intensity = 0.5
	env.glow_hdr_threshold = 1.0
	env.glow_blend_mode = Environment.GLOW_BLEND_MODE_SOFTLIGHT
	env.adjustment_enabled = true
	env.adjustment_saturation = 1.05
	we.environment = env
	add_child(we)

	sun = DirectionalLight3D.new()
	sun.name = "Sun"
	sun.shadow_enabled = true
	sun.directional_shadow_max_distance = 90.0
	sun.shadow_blur = 0.6
	add_child(sun)

	day_night = DayNight.new()
	day_night.name = "DayNight"
	add_child(day_night)
	day_night.setup(sun, env, sky_mat)


## Procura um lugar em terra firme perto da origem para nascer.
func find_spawn() -> Vector3:
	var gen := world.gen
	for r in range(0, 60):
		for i in 8:
			var ang := i * TAU / 8.0 + r * 0.7
			var x := cos(ang) * r * 12.0
			var z := sin(ang) * r * 12.0
			var h := gen.height_at(x, z)
			var b := gen.biome_at(x, z, h)
			if h > WorldGen.SEA + 2.0 and h < 45.0 and (b == WorldGen.Biome.PLAINS or b == WorldGen.Biome.FOREST):
				return Vector3(x, h + 1.0, z)
	return Vector3(0, 60, 0)


# ---------------------------------------------------------------- modo foto --

func _setup_screenshot() -> void:
	world.fast_mode = true
	day_night.paused = true
	day_night.time_of_day = float(Game.arg("time", "0.42"))
	day_night._apply()
	player.set_physics_process(false)
	var pos := Game.arg_floats("pos")
	var p: Vector3
	if pos.size() >= 3:
		p = Vector3(pos[0], pos[1], pos[2])
	elif pos.size() == 2:
		p = Vector3(pos[0], world.height_at(pos[0], pos[1]) + 0.2, pos[1])
	else:
		p = find_spawn()
	if Game.has_arg("above"):
		p.y += float(Game.arg("above"))
	player.global_position = p
	var look := Game.arg_floats("look")
	if look.size() >= 2:
		player.set_look(look[0], look[1])


func _process(delta: float) -> void:
	if not Game.is_screenshot_mode():
		return
	_shot_elapsed += delta
	if world.pending_count() == 0 and world.chunks.size() > 0:
		_shot_frames += 1
	if _shot_frames > int(Game.arg("frames", "8")) or _shot_elapsed > 600.0:
		var path := String(Game.arg("shot"))
		var img := get_viewport().get_texture().get_image()
		img.save_png(path)
		print("FOTO SALVA: ", path, " chunks=", world.chunks.size(), " tempo=", _shot_elapsed)
		get_tree().quit()
