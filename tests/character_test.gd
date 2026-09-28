extends Node3D
## Renderiza personagens de perto (LOD 0 e 1) para inspeção visual.
## Uso: xvfb-run godot --path . --rendering-driver opengl3 res://tests/character_test.tscn -- --out=/tmp/x

var out_dir := "user://shots"

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--out="):
			out_dir = a.substr(6)
	DirAccess.make_dir_recursive_absolute(out_dir)
	await Assets.bake_all()
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color(0.35, 0.38, 0.42)
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.5, 0.53, 0.58)
	e.ambient_light_energy = 0.8
	# mesmo tonemap do jogo (EnvironmentController)
	e.tonemap_mode = Environment.TONE_MAPPER_ACES
	e.tonemap_white = 6.0
	e.adjustment_enabled = true
	e.adjustment_saturation = 0.92
	e.adjustment_contrast = 1.06
	env.environment = e
	add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation = Vector3(-0.8, 0.6, 0)
	sun.light_energy = 1.6
	sun.shadow_enabled = true
	add_child(sun)
	var ground := MeshInstance3D.new()
	var pm := PlaneMesh.new()
	pm.size = Vector2(30, 30)
	ground.mesh = pm
	ground.material_override = Assets.pbr(Color(0.4, 0.4, 0.38), 0.9)
	add_child(ground)
	var aps := [Appearance.caio(), Appearance.helena(), Appearance.researcher(2), Appearance.civilian(501), Appearance.civilian(508),
		Appearance.police(20), Appearance.patient(), Appearance.infected("errante", 1), Appearance.infected("colosso", 2), Appearance.survivor(Color(0.35, 0.55, 0.35), 101, true)]
	var t0 := Time.get_ticks_msec()
	HeadTemplate.warm()
	print("moldes de cabeça: %d ms" % (Time.get_ticks_msec() - t0))
	var bodies: Array = []
	for i in aps.size():
		var b := HumanoidBody.new()
		add_child(b)
		b.setup(aps[i], 0)
		b.position = Vector3((i - 4.5) * 1.1, 0, 0)
		b.rotation.y = PI
		bodies.append(b)
	var cam := Camera3D.new()
	add_child(cam)
	cam.current = true
	cam.fov = 45
	for i in 20:
		for b in bodies:
			(b as HumanoidBody).tick(0.05)
		await get_tree().process_frame
	cam.position = Vector3(0, 1.1, 8.5)
	cam.look_at(Vector3(0, 0.95, 0))
	await _snap("chars_all")
	for k in [0, 1, 7]:
		var b: HumanoidBody = bodies[k]
		var hy := float(b.appearance.get("height", 1.75)) * 0.935
		cam.position = b.position + Vector3(0.0, hy + 0.02, 0.62)
		cam.look_at(b.position + Vector3(0, hy - 0.02, 0))
		await _snap("face_%d" % k)
		cam.position = b.position + Vector3(0.42, hy + 0.03, 0.45)
		cam.look_at(b.position + Vector3(0, hy - 0.03, 0))
		await _snap("face34_%d" % k)
		cam.position = b.position + Vector3(0.62, hy, 0.0)
		cam.look_at(b.position + Vector3(0, hy - 0.03, 0))
		await _snap("profile_%d" % k)
		var eye := b.position + Vector3(-0.032, 1.673, 0.1) * float(b.appearance.get("height", 1.75)) / 1.78
		cam.position = eye + Vector3(0.0, 0.0, 0.16)
		cam.look_at(eye)
		await _snap("eye_%d" % k)
		var mouth := b.position + Vector3(0.0, 1.605, 0.1) * float(b.appearance.get("height", 1.75)) / 1.78
		cam.position = mouth + Vector3(0.05, 0.01, 0.2)
		cam.look_at(mouth)
		await _snap("mouth_%d" % k)
		cam.position = b.position + Vector3(1.6, 1.3, 1.6)
		cam.look_at(b.position + Vector3(0, 1.0, 0))
		await _snap("body_%d" % k)
		cam.position = b.position + Vector3(0.0, 1.05, 1.3)
		cam.look_at(b.position + Vector3(0, 1.0, 0))
		await _snap("torso_%d" % k)
	get_tree().quit()


func _snap(n: String) -> void:
	for i in 3:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(out_dir + "/" + n + ".png")
	print("snap ", n)
