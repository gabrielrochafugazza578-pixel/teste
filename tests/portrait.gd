extends Node
## Retratos dos personagens (corpo inteiro e rosto) para avaliar o visual.
## Uso: xvfb-run godot --path . --rendering-driver opengl3 res://tests/portrait.tscn -- --out=/tmp/retratos [--day]

var out := "/tmp/retratos"
var vp: SubViewport
var cam: Camera3D
var body: HumanoidBody


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--out="):
			out = a.substr(6)
	DirAccess.make_dir_recursive_absolute(out)
	_run()


func _run() -> void:
	Settings.apply_preset(1)
	await Assets.bake_all()
	for q in 4:
		var im: Image = Assets.char_a.get_layer_data(q)
		im.decompress() if im.is_compressed() else null
		im.convert(Image.FORMAT_RGBA8)
		var sum := Vector3.ZERO
		var n := 0
		for y in range(0, im.get_height(), 8):
			for x in range(0, im.get_width(), 8):
				var c := im.get_pixel(x, y)
				sum += Vector3(c.r, c.g, c.b)
				n += 1
		print("CAMADA %d albedo médio (linear?) = %s  rugosidade=%.2f" % [q, str((sum / n).snapped(Vector3.ONE * 0.001)), im.get_pixel(3, 3).a])
	vp = SubViewport.new()
	vp.size = Vector2i(420, 640)
	vp.own_world_3d = true
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(vp)
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.42, 0.46, 0.5)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.55, 0.58, 0.62)
	env.ambient_light_energy = 0.6
	env.tonemap_mode = Environment.TONE_MAPPER_ACES
	var we := WorldEnvironment.new()
	we.environment = env
	vp.add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-38, -35, 0)
	sun.light_energy = 1.35
	vp.add_child(sun)
	var fill := DirectionalLight3D.new()
	fill.rotation_degrees = Vector3(-15, 150, 0)
	fill.light_energy = 0.35
	vp.add_child(fill)
	var floor_mi := MeshInstance3D.new()
	var pm := PlaneMesh.new()
	pm.size = Vector2(12, 12)
	floor_mi.mesh = pm
	var fm := StandardMaterial3D.new()
	fm.albedo_color = Color(0.3, 0.32, 0.29)
	floor_mi.material_override = fm
	vp.add_child(floor_mi)
	cam = Camera3D.new()
	cam.fov = 30.0
	vp.add_child(cam)
	var cast := {
		"caio": Appearance.caio(),
		"helena": Appearance.helena(),
		"civil_a": Appearance.civilian(3),
		"civil_b": Appearance.civilian(8),
		"policial": Appearance.police(4),
		"sobrevivente": Appearance.survivor(Color(0.55, 0.3, 0.2), 5, true),
		"inf_errante": Appearance.infected("errante", 12),
		"inf_bruto": Appearance.infected("colosso", 3),
	}
	var only := ""
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--only="):
			only = a.substr(7)
	for name_ in cast.keys():
		if only != "" and only != name_:
			continue
		if body:
			body.queue_free()
		body = HumanoidBody.new()
		vp.add_child(body)
		body.setup(cast[name_], 0)
		body.mesh_instance.custom_aabb = AABB(Vector3(-3, -1, -3), Vector3(6, 5, 6))
		body.animator.update(0.0)
		body.rotation.y = deg_to_rad(28.0)
		var h := float(cast[name_].get("height", 1.75))
		# corpo inteiro
		cam.position = Vector3(0.0, h * 0.55, -h * 2.55)
		cam.look_at(Vector3(0, h * 0.5, 0), Vector3.UP)
		await _grab("%s_corpo" % name_)
		# costas
		body.rotation.y = deg_to_rad(28.0 + 180.0)
		await _grab("%s_costas" % name_)
		body.rotation.y = deg_to_rad(28.0)
		# rosto
		cam.fov = 18.0
		cam.position = Vector3(0.0, h * 0.9, -h * 0.95)
		cam.look_at(Vector3(0, h * 0.885, 0), Vector3.UP)
		await _grab("%s_rosto" % name_)
		# rosto de frente e de perfil
		body.rotation.y = deg_to_rad(0.0)
		cam.position = Vector3(0.0, h * 0.9, -h * 0.95)
		cam.look_at(Vector3(0, h * 0.885, 0), Vector3.UP)
		await _grab("%s_frente" % name_)
		body.rotation.y = deg_to_rad(-90.0)
		await _grab("%s_perfil" % name_)
		body.rotation.y = deg_to_rad(28.0)
		cam.fov = 30.0
	print("FIM")
	get_tree().quit(0)


func _grab(n: String) -> void:
	for i in 4:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	vp.get_texture().get_image().save_png("%s/%s.png" % [out, n])
