extends Node3D
## Fotos de uma ação/pose do AnimLibrary em vários ângulos (ajustar poses).
## Uso: xvfb-run godot --path . --rendering-driver opengl3 res://tests/pose_test.tscn --
##      --no-audio --texturas-rgba --acao=sit_floor --out=/tmp/pose [--t=1.5] [--quem=caio] [--caixa]

var out := "/tmp/pose"


func _ready() -> void:
	var acao := "sit_floor"
	var tt := 2.0
	var quem := "caio"
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--out="):
			out = a.substr(6)
		elif a.begins_with("--acao="):
			acao = a.substr(7)
		elif a.begins_with("--t="):
			tt = float(a.substr(4))
		elif a.begins_with("--quem="):
			quem = a.substr(7)
	DirAccess.make_dir_recursive_absolute(out)
	await Assets.bake_all()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.5, 0.55, 0.6)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.6, 0.62, 0.66)
	env.ambient_light_energy = 0.9
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-40, -30, 0)
	sun.light_energy = 1.6
	sun.shadow_enabled = true
	add_child(sun)
	var fl := MeshInstance3D.new()
	var pm := PlaneMesh.new()
	pm.size = Vector2(8, 8)
	fl.mesh = pm
	var fm := StandardMaterial3D.new()
	fm.albedo_color = Color(0.35, 0.33, 0.3)
	fl.material_override = fm
	add_child(fl)
	# parede atrás (para ver se encosta)
	var wall := MeshInstance3D.new()
	var bm := BoxMesh.new()
	bm.size = Vector3(0.1, 2.5, 4)
	wall.mesh = bm
	wall.position = Vector3(0.62, 1.25, 0)
	wall.material_override = fm
	if "--parede" in OS.get_cmdline_user_args():
		add_child(wall)
	var ap := Appearance.caio()
	if quem == "zumbi":
		ap = Appearance.infected("errante", 12)
	elif quem == "civil":
		ap = Appearance.civilian(3)
	var body := HumanoidBody.new()
	add_child(body)
	body.setup(ap, 0)
	body.rotation.y = deg_to_rad(90.0)
	body.anim_interval = 0.0
	body.animator.play(acao)
	if "--caixa" in OS.get_cmdline_user_args():
		# mesma caixa que os saqueadores da abertura carregam
		var bx := MeshInstance3D.new()
		var cx := BoxMesh.new()
		cx.size = Vector3(0.44, 0.3, 0.32)
		bx.mesh = cx
		body.attach("chest", bx, Transform3D(Basis(), Vector3(0, -0.1, -0.36)))
	var el := 0.0
	while el < tt:
		body.tick(1.0 / 30.0)
		el += 1.0 / 30.0
	var cam := Camera3D.new()
	cam.fov = 40.0
	add_child(cam)
	cam.current = true
	var views := [["lado", Vector3(0, 0.9, 3.6)], ["frente", Vector3(-3.6, 0.9, 0)], ["tres", Vector3(-2.6, 1.4, 2.6)], ["cima", Vector3(-1.2, 3.2, 1.2)]]
	for v in views:
		cam.look_at_from_position(v[1], Vector3(0, 0.55, 0))
		for i in 3:
			body.tick(1.0 / 30.0)
			await get_tree().process_frame
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("%s/%s_%s.png" % [out, acao, v[0]])
	print("POSE OK")
	get_tree().quit()
