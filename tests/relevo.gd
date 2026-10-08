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
	_calcadas(mb)
	_igreja(mb)
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
		["janelas_perto", Vector3(-5.0, 4.5, -8.5), Vector3(-7.5, 4.6, -14.0)],
		["fachada_rua", Vector3(-3.0, 1.6, -7.5), Vector3(-1.0, 2.6, -14.0)],
		["calcadas", Vector3(38.0, 1.7, 60.5), Vector3(70.0, 0.0, 55.0)],
		["calcadas_sul", Vector3(38.0, 1.7, 59.5), Vector3(70.0, 0.0, 65.0)],
		["bloquete", Vector3(57.0, 1.6, 59.0), Vector3(58.0, 0.0, 54.0)],
		["pedra_portuguesa", Vector3(73.0, 1.6, 59.0), Vector3(74.0, 0.0, 54.5)],
		["ladrilho", Vector3(89.0, 1.6, 59.0), Vector3(90.0, 0.0, 54.3)],
		["sextavado", Vector3(41.0, 1.6, 61.0), Vector3(42.0, 0.0, 65.8)],
		["losangos", Vector3(60.0, 2.4, 61.0), Vector3(60.0, 0.0, 66.5)],
		["sarjeta", Vector3(46.0, 1.4, 58.5), Vector3(50.0, 0.0, 55.4)],
		["igreja", Vector3(119.0, 1.7, 97.0), Vector3(119.0, 10.0, 70.0)],
		["igreja_lado", Vector3(98.0, 2.5, 90.0), Vector3(119.0, 10.0, 62.0)],
		["igreja_torre", Vector3(130.0, 8.0, 80.0), Vector3(124.0, 18.0, 68.0)]]
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


## Rua com sarjeta (x 36..100, z = 60) e oito quarteirões, um de cada piso de
## calçada (placas, bloquete retangular/sextavado, pedra portuguesa em ondas e
## losangos, ladrilho hidráulico), metade com a guia caiada.
func _calcadas(mb: MeshBuf) -> void:
	var hw := 4.5
	var z0 := 60.0
	var code := Assets.uv2_code(Assets.L_ASPHALT, 4)
	var y := 0.02
	mb.quad(Vector3(36, y, z0 + hw), Vector3(100, y, z0 + hw), Vector3(100, y, z0 - hw), Vector3(36, y, z0 - hw), Vector3.UP,
		Vector2(-hw, 0.0), Vector2(-hw, 64.0), Vector2(hw, 64.0), Vector2(hw, 0.0), code, ChunkBuilder.road_seed(hw, true, 64.0), Color(1, 1, 1))
	# [piso, guia caiada, variação]
	var kinds := [[0, false, 0.3], [1, true, 0.3], [2, false, 0.3], [3, true, 0.3],
		[1, false, 0.7], [2, true, 0.7], [3, false, 0.75], [0, true, 0.7]]
	for i in kinds.size():
		var k: Array = kinds[i]
		var north := i < 4
		var x := 36.0 + (i % 4) * 16.0
		var br := Rect2(x, z0 - hw - 14.0, 15.0, 14.0) if north else Rect2(x, z0 + hw, 15.0, 14.0)
		var s := (float(k[0]) + (4.0 if k[1] else 0.0) + float(k[2])) / 8.0
		var cy := WorldLayout.CURB
		ChunkBuilder._sidewalk_ring(mb, br, cy, Assets.uv2_code(Assets.L_CONCRETE, 7), s, Color(0.85, 0.84, 0.8))
		var inner := br.grow(-WorldLayout.SIDEWALK)
		mb.quad(Vector3(inner.position.x, cy, inner.position.y), Vector3(inner.end.x, cy, inner.position.y), Vector3(inner.end.x, cy, inner.end.y), Vector3(inner.position.x, cy, inner.end.y),
			Vector3.UP, inner.position, Vector2(inner.end.x, inner.position.y), inner.end, Vector2(inner.position.x, inner.end.y), Assets.uv2_code(Assets.L_GRASS), 0.0, Color(1, 1, 1))
		var gcol := Color(0.98, 0.97, 0.93) if k[1] else Color(0.7, 0.7, 0.68)
		ChunkBuilder._curb_ring(mb, br, cy, gcol)


## Igreja matriz (x 110..128, z 40..70, fachada para +z) sobre um chão de praça.
func _igreja(mb: MeshBuf) -> void:
	var b := {"type": "church", "rect": Rect2(110, 40, 18, 30), "floors": 1, "fh": 11.0, "gfh": 11.0, "roof": "gable", "facing": 2,
		"enterable": false, "layer": Assets.L_PLASTER, "roof_layer": Assets.L_ROOF, "tint": Color(0.94, 0.92, 0.86), "wmode": Assets.WM_NONE,
		"seed": 77, "name": "IGREJA MATRIZ", "poi": "", "district": "centro", "base": 0.0, "interior": "church"}
	BuildingGen.build(b, mb, mb, 0, false, 2)
	mb.quad(Vector3(96, -0.01, 30), Vector3(142, -0.01, 30), Vector3(142, -0.01, 104), Vector3(96, -0.01, 104), Vector3.UP,
		Vector2(96, 30), Vector2(142, 30), Vector2(142, 104), Vector2(96, 104), Assets.uv2_code(Assets.L_GRASS), 0.0, Color(1, 1, 1))


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
