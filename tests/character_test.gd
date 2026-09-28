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
	e.ambient_light_color = Color(0.55, 0.57, 0.6)
	e.tonemap_mode = Environment.TONE_MAPPER_ACES
	env.environment = e
	add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation = Vector3(-0.8, 0.6, 0)
	sun.light_energy = 1.3
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
		cam.position = b.position + Vector3(0.0, 1.62, 1.0)
		cam.look_at(b.position + Vector3(0, 1.55, 0))
		await _snap("face_%d" % k)
		cam.position = b.position + Vector3(1.6, 1.3, 1.6)
		cam.look_at(b.position + Vector3(0, 1.0, 0))
		await _snap("body_%d" % k)
	get_tree().quit()


func _snap(n: String) -> void:
	for i in 3:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(out_dir + "/" + n + ".png")
	print("snap ", n)
