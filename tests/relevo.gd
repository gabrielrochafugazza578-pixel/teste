extends Node3D
## Vitrine do relevo das camadas (parallax + poças/sujeira nas frestas): paredes,
## pisos e uma faixa de terreno com transição grama/terra/rocha, sem carregar o mundo.
## Uso: xvfb-run godot --path . --rendering-method forward_plus res://tests/relevo.tscn --
##      --no-audio --out=/tmp/relevo [--sem-relevo] [--chuva] [--hour=10]

var out := "/tmp/relevo"
var hour := 10.0


func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	for a in args:
		if a.begins_with("--out="):
			out = a.substr(6)
		elif a.begins_with("--hour="):
			hour = float(a.substr(7))
	DirAccess.make_dir_recursive_absolute(out)
	Settings.apply_preset(4 if RenderingServer.get_current_rendering_method() == "forward_plus" else 1)
	await Assets.bake_all()
	GameState.in_game = false
	TimeManager.locked_hour = hour
	TimeManager.set_time(hour)
	WeatherManager.set_weather(WeatherManager.State.RAIN if "--chuva" in args else WeatherManager.State.CLEAR, true, true)
	var env := EnvironmentController.new()
	add_child(env)
	var mat := Assets.world_material("exterior")
	var tm := Assets.terrain_material()
	if "--sem-relevo" in args:
		mat.set_shader_parameter("has_height", false)
		tm.set_shader_parameter("has_height", false)
	var mb := MeshBuf.new()
	# pisos 4×4 m: asfalto, concreto, piso, cascalho, terra, rocha
	var floors := [Assets.L_ASPHALT, Assets.L_CONCRETE, Assets.L_TILES, Assets.L_GRAVEL, Assets.L_DIRT, Assets.L_ROCK]
	for i in floors.size():
		mb.box(Vector3(-10 + i * 4.0, -0.05, 2.0), Vector3(4, 0.1, 4), Assets.uv2_code(floors[i]), 0.3)
	# paredes 4×3 m: tijolo, reboco, painel, madeira, telha, casca
	var walls := [Assets.L_BRICK, Assets.L_PLASTER, Assets.L_PANELS, Assets.L_WOOD, Assets.L_ROOF, Assets.L_BARK]
	for i in walls.size():
		mb.box(Vector3(-10 + i * 4.0, 1.5, -0.15), Vector3(4, 3, 0.3), Assets.uv2_code(walls[i]), 0.6)
	var mi := MeshInstance3D.new()
	mi.mesh = mb.to_mesh(mat)
	add_child(mi)
	add_child(_terrain(tm))
	if "--chuva" in args:
		RenderingServer.global_shader_parameter_set("wetness", 0.85)
	var cam := Camera3D.new()
	cam.fov = 60.0
	add_child(cam)
	cam.current = true
	for i in 4:
		await get_tree().process_frame
	var views := [["tijolo", Vector3(-11.5, 1.5, 2.2), Vector3(-8.5, 1.2, -0.1)],
		["telha_madeira", Vector3(2.5, 1.6, 2.4), Vector3(4.0, 1.2, -0.1)],
		["pisos", Vector3(-6.0, 1.7, 5.5), Vector3(-6.0, 0.0, 1.2)],
		["rocha_cascalho", Vector3(2.0, 1.6, 5.0), Vector3(3.0, 0.0, 1.5)],
		["terreno", Vector3(0.0, 1.7, 15.0), Vector3(0.0, 0.0, 9.0)],
		["terreno_largo", Vector3(-4.0, 5.5, 19.0), Vector3(-1.0, 0.0, 10.0)]]
	for v in views:
		cam.look_at_from_position(v[1], v[2])
		for k in 30:
			await get_tree().process_frame
		await RenderingServer.frame_post_draw
		var img := get_viewport().get_texture().get_image()
		img.save_png("%s/%s.png" % [out, v[0]])
		print("foto ", v[0])
	get_tree().quit()


## Faixa de terreno 24×10 m: grama à esquerda, terra no meio, rocha à direita,
## com as transições largas para ver a mistura por altura.
func _terrain(m: Material) -> MeshInstance3D:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var nx := 96
	var nz := 40
	for j in nz + 1:
		for i in nx + 1:
			var x := -12.0 + 24.0 * i / nx
			var z := 6.0 + 10.0 * j / nz
			var t := float(i) / nx
			var dirt := smoothstep(0.15, 0.4, t) * (1.0 - smoothstep(0.6, 0.85, t))
			var rock := smoothstep(0.6, 0.9, t)
			st.set_color(Color(dirt, rock, 0.0, 1.0))
			st.set_normal(Vector3.UP)
			st.set_uv(Vector2(x, z))
			st.add_vertex(Vector3(x, 0.0, z))
	for j in nz:
		for i in nx:
			var a := j * (nx + 1) + i
			st.add_index(a)
			st.add_index(a + 1)
			st.add_index(a + nx + 1)
			st.add_index(a + 1)
			st.add_index(a + nx + 2)
			st.add_index(a + nx + 1)
	var mi := MeshInstance3D.new()
	mi.mesh = st.commit()
	mi.material_override = m
	return mi
