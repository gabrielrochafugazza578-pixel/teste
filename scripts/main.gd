extends Node3D
## Monta a cena do jogo: ambiente, ceu, sol, mundo, jogador e interface.
## Tambem contem o modo "foto" usado para gerar screenshots automaticamente.

var env: Environment
var sky_mat: ShaderMaterial
var sun: DirectionalLight3D
var day_night: DayNight
var world: World
var player: Player
var hud: Hud
var mobs: MobManager
var fireflies: CPUParticles3D
var spawn_point := Vector3.ZERO
var menu: GameMenu
var outline_quad: MeshInstance3D
var in_title := false
var loaded_save := false
var _autosave := 0.0

var _shot_frames := 0
var _shot_elapsed := 0.0
var _demo_done := false


func _ready() -> void:
	_build_environment()
	world = World.new()
	world.name = "World"
	world.view_radius = Game.view_distance
	if Game.has_arg("radius"):
		world.view_radius = int(Game.arg("radius"))
	add_child(world)

	player = Player.new()
	player.name = "Player"
	player.world = world
	add_child(player)
	world.focus = player
	_add_outline(player.camera)

	_build_fireflies()

	mobs = MobManager.new()
	mobs.name = "Mobs"
	mobs.world = world
	mobs.player = player
	mobs.day_night = day_night
	add_child(mobs)

	hud = Hud.new()
	hud.player = player
	hud.world = world
	hud.day_night = day_night
	player.hud = hud
	add_child(hud)
	hud.visible = not Game.has_arg("nohud")
	player.died.connect(_on_player_died)
	day_night.night_started.connect(func(): hud.show_message("A noite chegou... cuidado com as criaturas!", 4.0))
	day_night.day_started.connect(func(): hud.show_message("Bom dia! Dia %d" % day_night.day_count, 3.0))

	menu = GameMenu.new()
	menu.name = "Menu"
	add_child(menu)
	menu.play_pressed.connect(_on_play)
	menu.resume_pressed.connect(_resume)
	menu.save_menu_pressed.connect(_on_save_menu)
	menu.save_quit_pressed.connect(_on_save_quit)
	menu.respawn_pressed.connect(_on_respawn)
	menu.settings_changed.connect(_apply_settings)

	_apply_fog()
	spawn_point = find_spawn()
	player.global_position = spawn_point
	if Game.is_screenshot_mode():
		_setup_screenshot()
		match String(Game.arg("menu", "")):
			"1", "title":
				_show_title()
			"pause":
				menu.show_screen(GameMenu.Screen.PAUSE)
			"settings":
				menu.show_screen(GameMenu.Screen.SETTINGS)
			"death":
				player.hp = 0
				menu.show_screen(GameMenu.Screen.DEATH)
		return
	if Game.has_arg("autotest"):
		_start_playing()
		var at: Node = load("res://scripts/autotest.gd").new()
		at.set("main", self)
		at.set("player", player)
		at.set("world", world)
		at.set("mobs", mobs)
		at.set("day_night", day_night)
		at.set("duration", float(Game.arg("autotest")))
		add_child(at)
		return
	# mundo salvo? carrega antes dos chunks aparecerem
	loaded_save = SaveGame.load_into(world, player, day_night)
	if Game.started:
		_start_playing()
	else:
		_show_title()


## Tela inicial: a camera fica girando devagar mostrando o mundo.
func _show_title() -> void:
	in_title = true
	player.set_physics_process(false)
	hud.visible = false
	mobs.enabled = false
	menu.has_save = loaded_save
	player.hand.visible = false
	menu.show_screen(GameMenu.Screen.TITLE)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player.global_position.y = maxf(player.global_position.y, world.height_at(player.global_position.x, player.global_position.z) + 0.2) + 2.0


func _start_playing() -> void:
	in_title = false
	Game.started = true
	menu.show_screen(GameMenu.Screen.NONE)
	hud.visible = not Game.has_arg("nohud")
	mobs.enabled = true
	player.hand.visible = true
	player.set_physics_process(true)
	player.frozen = true
	if not loaded_save:
		player.global_position = spawn_point
		player.set_look(randf() * 360.0, -5.0)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hud.show_message("Bem-vindo à Terra Redonda!" if not loaded_save else "Bem-vindo de volta!", 4.0)
	_apply_settings()


func _on_play(new_seed: int) -> void:
	if new_seed != Game.world_seed:
		# outro mundo: recarrega a cena com a nova semente
		Game.world_seed = new_seed
		Game.started = true
		Game.save_config()
		get_tree().reload_current_scene()
		return
	Game.save_config()
	_start_playing()


func _pause() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menu.show_screen(GameMenu.Screen.PAUSE)


func _resume() -> void:
	get_tree().paused = false
	menu.show_screen(GameMenu.Screen.NONE)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func save_now() -> void:
	if in_title or Game.is_screenshot_mode() or Game.has_arg("autotest"):
		return
	if SaveGame.save(world, player, day_night):
		loaded_save = true


func _on_save_menu() -> void:
	save_now()
	get_tree().paused = false
	Game.started = false
	get_tree().reload_current_scene()


func _on_save_quit() -> void:
	save_now()
	get_tree().quit()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_now()


func _apply_settings() -> void:
	if not Game.has_arg("radius") and world.view_radius != Game.view_distance:
		world.set_view_radius(Game.view_distance)
	if outline_quad:
		outline_quad.visible = Game.outline
	_apply_fog()


## A neblina acompanha a distancia de visao (esconde a borda do mundo).
func _apply_fog() -> void:
	env.fog_depth_end = world.view_radius * WorldGen.N - 4.0
	env.fog_depth_begin = env.fog_depth_end * 0.55


func _unhandled_input(event: InputEvent) -> void:
	if in_title or Game.is_screenshot_mode():
		return
	if event.is_action_pressed("pause"):
		if menu.screen == GameMenu.Screen.NONE and not player.dead:
			_pause()
		elif menu.screen == GameMenu.Screen.PAUSE:
			_resume()
	elif event is InputEventMouseButton and event.pressed and menu.screen == GameMenu.Screen.NONE and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_viewport().set_input_as_handled()


func _on_player_died() -> void:
	await get_tree().create_timer(1.2).timeout
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menu.show_screen(GameMenu.Screen.DEATH)


func _on_respawn() -> void:
	mobs.clear_all()
	player.respawn(spawn_point)
	menu.show_screen(GameMenu.Screen.NONE)
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
	sky.process_mode = Sky.PROCESS_MODE_INCREMENTAL
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
	env.glow_intensity = 0.9
	env.glow_strength = 1.1
	env.glow_bloom = 0.0
	env.glow_hdr_threshold = 0.95
	env.glow_blend_mode = Environment.GLOW_BLEND_MODE_SCREEN
	for lvl in range(1, 7):
		env.set_glow_level(lvl - 1, 1.0 if lvl >= 2 and lvl <= 5 else 0.0)
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


## Vaga-lumes que aparecem a noite em volta do jogador.
func _build_fireflies() -> void:
	fireflies = CPUParticles3D.new()
	fireflies.amount = 150
	fireflies.lifetime = 7.0
	fireflies.preprocess = 7.0
	fireflies.local_coords = false
	fireflies.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	fireflies.emission_box_extents = Vector3(20, 2.5, 20)
	fireflies.gravity = Vector3.ZERO
	fireflies.direction = Vector3.UP
	fireflies.spread = 180.0
	fireflies.initial_velocity_min = 0.15
	fireflies.initial_velocity_max = 0.6
	fireflies.angular_velocity_min = -20.0
	fireflies.angular_velocity_max = 20.0
	var sm := SphereMesh.new()
	sm.radius = 0.06
	sm.height = 0.12
	sm.radial_segments = 6
	sm.rings = 3
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = Color(0.9, 1.0, 0.45)
	m.emission_enabled = true
	m.emission = Color(0.85, 1.0, 0.35)
	m.emission_energy_multiplier = 6.0
	m.vertex_color_use_as_albedo = true
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	sm.material = m
	fireflies.mesh = sm
	var grad := Gradient.new()
	grad.offsets = PackedFloat32Array([0.0, 0.2, 0.5, 0.8, 1.0])
	grad.colors = PackedColorArray([Color(1, 1, 1, 0), Color(1, 1, 1, 1), Color(1, 1, 1, 0.3), Color(1, 1, 1, 1), Color(1, 1, 1, 0)])
	fireflies.color_ramp = grad
	fireflies.emitting = false
	add_child(fireflies)


## Contorno cartoon: um quad que cobre a tela inteira, preso na camera.
func _add_outline(cam: Camera3D) -> void:
	if RenderingServer.get_current_rendering_method() != "forward_plus":
		return  # precisa do buffer de normais (so existe no Forward+)
	var quad := MeshInstance3D.new()
	var qm := QuadMesh.new()
	qm.size = Vector2(2, 2)
	quad.mesh = qm
	var mat := ShaderMaterial.new()
	mat.shader = load("res://shaders/outline_post.gdshader")
	mat.render_priority = 127
	mat.set_shader_parameter("sea_level", WorldGen.SEA - 0.35)
	quad.material_override = mat
	quad.extra_cull_margin = 16384.0
	quad.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	quad.position = Vector3(0, 0, -1)
	cam.add_child(quad)
	outline_quad = quad


## Procura um lugar em terra firme perto da origem para nascer.
func find_spawn(origin := Vector2.ZERO, only_biome := -1) -> Vector3:
	var gen := world.gen
	for r in range(0, 60):
		for i in 8:
			var ang := i * TAU / 8.0 + r * 0.7
			var x := origin.x + cos(ang) * r * 12.0
			var z := origin.y + sin(ang) * r * 12.0
			var h := gen.height_at(x, z)
			var b := gen.biome_at(x, z, h)
			var ok := (b == WorldGen.Biome.PLAINS or b == WorldGen.Biome.FOREST) if only_biome < 0 else b == only_biome
			if h > WorldGen.SEA + 2.0 and h < 45.0 and ok:
				return Vector3(x, h + 1.0, z)
	return Vector3(0, 60, 0)


# ---------------------------------------------------------------- modo foto --

func _setup_screenshot() -> void:
	world.fast_mode = true
	mobs.enabled = Game.has_arg("mobs")
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
		if Game.has_arg("land"):
			var only := -1
			if Game.has_arg("biome"):
				only = WorldGen.Biome[String(Game.arg("biome"))]
			p = find_spawn(Vector2(pos[0], pos[1]), only) - Vector3(0, 0.8, 0)
	else:
		p = find_spawn()
	if Game.has_arg("above"):
		p.y += float(Game.arg("above"))
	player.global_position = p
	var look := Game.arg_floats("look")
	if look.size() >= 2:
		player.set_look(look[0], look[1])


func _process(delta: float) -> void:
	if fireflies:
		fireflies.global_position = player.global_position + Vector3(0, 1.8, 0)
		fireflies.emitting = day_night.night_factor > 0.6
	if in_title:
		player.set_look(rad_to_deg(player.yaw) + delta * 4.0, -6.0)
	elif not Game.is_screenshot_mode() and not Game.has_arg("autotest"):
		_autosave += delta
		if _autosave > 120.0:
			_autosave = 0.0
			save_now()
	if not Game.is_screenshot_mode():
		return
	_shot_elapsed += delta
	if world.pending_count() == 0 and world.chunks.size() > 0:
		if Game.has_arg("demo") and not _demo_done:
			_demo_done = true
			_run_demo(String(Game.arg("demo")))
			return
		_shot_frames += 1
	if _shot_frames > int(Game.arg("frames", "8")) or _shot_elapsed > 600.0:
		var path := String(Game.arg("shot"))
		var img := get_viewport().get_texture().get_image()
		img.save_png(path)
		print("FOTO SALVA: ", path, " chunks=", world.chunks.size(), " tempo=", _shot_elapsed)
		get_tree().quit()


## Acoes automaticas para as fotos (mostram cavar/construir funcionando).
func _run_demo(kind: String) -> void:
	var fwd := -player.global_transform.basis.z
	fwd.y = 0.0
	fwd = fwd.normalized()
	var right := fwd.cross(Vector3.UP)
	var dist := float(Game.arg("demodist", "8"))
	var base := player.global_position + fwd * dist
	base.y = world.height_at(base.x, base.z)
	match kind:
		"dig":
			for i in 7:
				var p := base + right * (i - 3) * 1.1 + Vector3(0, -0.4, 0)
				world.edit_sphere(p, 1.5, false, 0)
				world.edit_sphere(p + Vector3(0, -1.4, 0), 1.3, false, 0)
			world.remove_small_decos(base, 5.0)
			player.inventory.add(Mats.GRASS, 7)
			player.inventory.add(Mats.DIRT, 7)
		"build":
			world.remove_small_decos(base, 9.0, true)
			# torre redonda de tijolos com telhado de madeira e cristal no topo
			for layer in 5:
				for k in 12:
					var a := k * TAU / 12.0
					if layer < 2 and k == 9:
						continue  # porta
					var p := base + Vector3(cos(a) * 2.6, 0.6 + layer * 1.25, sin(a) * 2.6)
					world.edit_sphere(p, 1.05, true, Mats.BRICK)
			for r in 4:
				for k in 12:
					var a := k * TAU / 12.0 + r * 0.3
					var rad := 3.0 - r * 0.85
					world.edit_sphere(base + Vector3(cos(a) * rad, 6.9 + r * 0.9, sin(a) * rad), 1.0, true, Mats.WOOD)
			world.edit_sphere(base + Vector3(0, 10.8, 0), 0.9, true, Mats.CRYSTAL)
			# murinho de pedra
			for k in 7:
				var p := base + right * (k - 3) * 1.2 - fwd * 4.5
				p.y = world.height_at(p.x, p.z) + 0.4
				world.edit_sphere(p, 0.9, true, Mats.STONE)
			player.inventory.select(6)
		"animals", "night":
			# fileira de bichos de frente para a camera
			var kinds: Array = Animal.SPECIES if kind == "animals" else ["lobo", "gosma", "espirito", "golem", "lobo"]
			world.remove_small_decos(base, 9.0, true)
			for i in kinds.size():
				var off := (i - (kinds.size() - 1) * 0.5) * 2.6
				var p := base + right * off + fwd * (absf(off) * -0.25)
				p.y = world.height_at(p.x, p.z) + 0.1
				var m: Mob
				if kind == "animals":
					m = Animal.create(kinds[i])
				else:
					m = NightCreature.create(kinds[i])
				mobs.spawn(m, p)
				m.fade = 1.0
				m.face_yaw = atan2(-fwd.x, -fwd.z) + randf_range(-0.5, 0.5)
				m.set_physics_process(false)
				if kinds[i] == "espirito":
					m.global_position.y += 2.2
			_shot_frames = -40
