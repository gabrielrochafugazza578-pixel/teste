extends Node3D
## Vitrine do relevo das camadas (parallax + poças/sujeira nas frestas): paredes,
## pisos e uma faixa de terreno com transição grama/terra/rocha, sem carregar o mundo.
## Uso: xvfb-run godot --path . --rendering-method forward_plus res://tests/relevo.tscn --
##      --no-audio --out=/tmp/relevo [--sem-relevo] [--chuva] [--hour=10] [--so=terreno,pisos] [--energia]

var out := "/tmp/relevo"
var hour := 10.0
var so: PackedStringArray = []


func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	for a in args:
		if a.begins_with("--out="):
			out = a.substr(6)
		elif a.begins_with("--hour="):
			hour = float(a.substr(7))
		elif a.begins_with("--so="):
			so = a.substr(5).split(",")
	DirAccess.make_dir_recursive_absolute(out)
	Settings.apply_preset(4 if RenderingServer.get_current_rendering_method() == "forward_plus" else 1)
	await Assets.bake_all()
	if "--ruido" in OS.get_cmdline_user_args():
		var ni := Assets.noise_tex.get_image()
		ni.decompress()
		ni.save_png(out + "/ruido.png")
		get_tree().quit()
		return
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
	# rua e muro de reboco largos (buracos e reboco caído aparecem com o abandono)
	mb.box(Vector3(-24.0, -0.05, 4.0), Vector3(16, 0.1, 16), Assets.uv2_code(Assets.L_ASPHALT), 0.2)
	mb.box(Vector3(-24.0, 2.0, -4.15), Vector3(16, 4, 0.3), Assets.uv2_code(Assets.L_PLASTER), 0.45, Color(0.85, 0.78, 0.62))
	# fachadas com janelas (residencial de reboco e escritório de concreto)
	mb.box(Vector3(-7.0, 6.0, -14.3), Vector3(12, 12, 0.6), Assets.uv2_code(Assets.L_PLASTER, Assets.WM_RES), 0.5, Color(0.86, 0.8, 0.7))
	mb.box(Vector3(7.0, 9.0, -14.3), Vector3(14, 18, 0.6), Assets.uv2_code(Assets.L_CONCRETE, Assets.WM_OFFICE), 0.7)
	mb.box(Vector3(0.0, -0.05, -9.0), Vector3(32, 0.1, 10), Assets.uv2_code(Assets.L_CONCRETE), 0.25)
	var mi := MeshInstance3D.new()
	mi.mesh = mb.to_mesh(mat)
	add_child(mi)
	add_child(_terrain(tm))
	if "--chuva" in args:
		RenderingServer.global_shader_parameter_set("wetness", 0.85)
	RenderingServer.global_shader_parameter_set("world_decay", 1.0 if "--abandono" in args else 0.0)
	RenderingServer.global_shader_parameter_set("city_power", 1.0 if "--energia" in args else 0.0)
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
		["terreno_largo", Vector3(-4.0, 5.5, 19.0), Vector3(-1.0, 0.0, 10.0)],
		["abandono_rua", Vector3(-24.0, 3.5, 11.5), Vector3(-24.0, 0.0, 1.0)],
		["abandono_muro", Vector3(-21.0, 1.7, 4.0), Vector3(-25.0, 1.4, -4.0)],
		["janelas", Vector3(0.0, 3.0, -2.5), Vector3(1.0, 7.0, -14.0)],
		["janelas_perto", Vector3(-5.0, 4.5, -8.5), Vector3(-7.5, 4.6, -14.0)]]
	for v in views:
		if not so.is_empty() and not str(v[0]) in so:
			continue
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
