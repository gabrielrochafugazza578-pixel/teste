extends Node3D
## Vitrine rápida da vegetação (sem carregar o mundo): gramado com o material
## do terreno, moitas de grama, árvores e arbustos sob o ambiente real do jogo.
## Uso: xvfb-run godot --path . --rendering-driver opengl3 res://tests/veg_probe.tscn -- --no-audio --out=/tmp/veg [--hour=12]

var out := "/tmp/veg"
var hour := 11.0


func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--out="):
			out = a.substr(6)
		elif a.begins_with("--hour="):
			hour = float(a.substr(7))
	DirAccess.make_dir_recursive_absolute(out)
	Settings.apply_preset(1)
	await Assets.bake_all()
	var li := Assets.leaf_tex.get_image()
	li.decompress()
	if li.has_mipmaps():
		li.clear_mipmaps()
	li.save_png(out + "/folha.png")
	var ni := Assets.noise_tex.get_image()
	ni.decompress()
	ni.save_png(out + "/ruido.png")
	for k in [7, 13]:
		var la := Assets.surface_a.get_layer_data(k)
		la.decompress()
		if la.has_mipmaps():
			la.clear_mipmaps()
		la.save_png("%s/camada_%d.png" % [out, k])
		var lb := Assets.surface_b.get_layer_data(k)
		lb.decompress()
		if lb.has_mipmaps():
			lb.clear_mipmaps()
		lb.save_png("%s/camada_%d_b.png" % [out, k])
	GameState.in_game = false
	TimeManager.locked_hour = hour
	TimeManager.set_time(hour)
	var clima := WeatherManager.State.CLEAR
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--clima="):
			clima = int(a.substr(8))
	WeatherManager.set_weather(clima, true, true)
	var env := EnvironmentController.new()
	add_child(env)
	_ground()
	_grass()
	_trees()
	var cam := Camera3D.new()
	cam.fov = 70.0
	add_child(cam)
	cam.current = true
	if "--sem-normal" in OS.get_cmdline_user_args():
		Assets.world_material("props").set_shader_parameter("normal_strength", 0.0)
	if "--cilindros" in OS.get_cmdline_user_args():
		var codes := [Assets.L_BARK, Assets.L_PLASTER, Assets.L_GRAVEL, Assets.L_FABRIC, Assets.L_WOOD, -1]
		for i in codes.size():
			var mb := MeshBuf.new()
			mb.cylinder(Transform3D.IDENTITY, 0.5, 4.0, 10, Assets.uv2_code(maxi(codes[i], 0)), 0.0, Color(1, 1, 1), true)
			var mi := MeshInstance3D.new()
			var mat: Material = Assets.world_material("props") if codes[i] >= 0 else StandardMaterial3D.new()
			if "--debug-alb" in OS.get_cmdline_user_args() and codes[i] >= 0:
				var dbg := Shader.new()
				var mode := ""
				for a in OS.get_cmdline_user_args():
					if a.begins_with("--debug-alb="):
						mode = a.substr(12)
				dbg.code = Assets.world_material("props").shader.code.replace("EMISSION = emit;", "EMISSION = %s; ALBEDO = vec3(0.0);" % (mode if mode != "" else "alb"))
				var dm := Assets.world_material("props").duplicate() as ShaderMaterial
				dm.shader = dbg
				mat = dm
			mi.mesh = mb.to_mesh(mat)
			mi.position = Vector3(-6 + i * 2.4, 0, 2)
			add_child(mi)
	if "--props" in OS.get_cmdline_user_args():
		var names := ["barrel", "trash_bags", "barrel", "traffic_cone", "trash_bags"]
		for i in names.size():
			var mi := MeshInstance3D.new()
			mi.mesh = PropLib.mesh(names[i])
			mi.position = Vector3(-3 + i * 1.6, 0, 4.5)
			mi.rotation.y = i * 0.7
			add_child(mi)
	if "--bandeira" in OS.get_cmdline_user_args():
		add_child(Chunk.flag_node(Vector3(1.5, 0, 1.0), 0.0))
	if "--passaros" in OS.get_cmdline_user_args():
		var alvo := Node3D.new()
		add_child(alvo)
		var bd := Birds.new()
		add_child(bd)
		bd.target = alvo
		for fl in bd._flocks:
			fl["off"] = Vector3(0, -25.0, -30.0)
	if "--encosta" in OS.get_cmdline_user_args():
		# encosta virada para longe do sol da tarde (sol a +x): só luz ambiente
		var hill := MeshInstance3D.new()
		var pm := PlaneMesh.new()
		pm.size = Vector2(30, 30)
		hill.mesh = pm
		hill.material_override = Assets.terrain_material()
		hill.transform = Transform3D(Basis(Vector3.BACK, deg_to_rad(40.0)), Vector3(-8, 6, -8))
		add_child(hill)
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--exp="):
			env.exposure = float(a.substr(6))
		if a.begins_with("--skyfog="):
			env.env.fog_sky_affect = float(a.substr(9))
	for i in 3:
		await get_tree().process_frame
	print("AMB cor=%s energia=%.2f fonte=%d sol=%.2f cor_sol=%s exp=%.2f sh=%.2f dl=%.2f" % [env.env.ambient_light_color, env.env.ambient_light_energy,
		env.env.ambient_light_source, env.sun.light_energy, env.sun.light_color, env.env.tonemap_exposure, TimeManager.sun_height(), TimeManager.daylight()])
	var views := [["perto", Vector3(0, 1.6, 9), Vector3(0, 0.6, -6)], ["campo", Vector3(-6, 2.2, 22), Vector3(4, 1.0, -20)],
		["arvores", Vector3(10, 1.7, 6), Vector3(-6, 3.0, -14)], ["ceu", Vector3(0, 1.7, 10), Vector3(0, 30, -60)]]
	if "--passaros" in OS.get_cmdline_user_args():
		views.append(["passaros", Vector3(0, 1.7, 10), Vector3(0, 22, -30)])
		views.append(["passaros2", Vector3(0, 1.7, 10), Vector3(0, 22, -30)])
	if "--bandeira" in OS.get_cmdline_user_args():
		views.append(["bandeira", Vector3(2.6, 2.5, 9.5), Vector3(2.2, 7.2, 1.0)])
	if "--folhas" in OS.get_cmdline_user_args():
		views.append(["folhas", Vector3(-11.5, 1.8, -5.5), Vector3(-13.5, 2.6, -12.0)])
	for v in views:
		cam.global_position = v[1]
		cam.look_at(v[2], Vector3.UP)
		for i in 6:
			await get_tree().process_frame
		if v[0] == "folhas":
			await get_tree().create_timer(3.0).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("%s/veg_%s.png" % [out, v[0]])
		print("foto ", v[0])
	get_tree().quit(0)


func _ground() -> void:
	# grade 80x80 m com splat de grama (COLOR.r) e manchas de terra
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var n := 40
	var sz := 80.0
	for iz in n:
		for ix in n:
			for k in [[0, 0], [1, 0], [1, 1], [0, 0], [1, 1], [0, 1]]:
				var x: float = (ix + k[0]) * sz / n - sz * 0.5
				var z: float = (iz + k[1]) * sz / n - sz * 0.5
				var dirt := clampf(sin(x * 0.21) * cos(z * 0.17) - 0.55, 0.0, 1.0) * 2.0
				st.set_color(Color(dirt * 0.6, 0.0, 0.0, 0.0))
				st.set_normal(Vector3.UP)
				st.set_uv(Vector2(x, z))
				st.add_vertex(Vector3(x, 0.0, z))
	var mi := MeshInstance3D.new()
	mi.mesh = st.commit()
	mi.material_override = Assets.terrain_material()
	add_child(mi)


func _grass() -> void:
	var r := RandomNumberGenerator.new()
	r.seed = 7
	var xfs: Array = []
	var cols: Array = []
	# mesma distribuição de ChunkBuilder._grass
	var step := 1.4
	for iz in int(50.0 / step):
		for ix in int(60.0 / step):
			var p := Vector2(-30 + (ix + r.randf()) * step, -36 + (iz + r.randf()) * step)
			var patch := 0.5 + 0.5 * sin(p.x * 0.13 + sin(p.y * 0.11) * 2.0) * cos(p.y * 0.09 + p.x * 0.05)
			if r.randf() > 0.3 + patch * 0.9:
				continue
			var s := r.randf_range(0.7, 1.25)
			xfs.append(Transform3D(Basis(Vector3.UP, r.randf() * TAU).scaled(Vector3(s, 1.0, s)), Vector3(p.x, 0.0, p.y)))
			cols.append(Color(r.randf_range(0.5, 1.0) + patch * 0.25, r.randf(), r.randf() * 0.35, 1.0))
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_colors = true
	mm.mesh = Vegetation.grass_mesh()
	mm.instance_count = xfs.size()
	for i in xfs.size():
		mm.set_instance_transform(i, xfs[i])
		mm.set_instance_color(i, cols[i])
	var mmi := MultiMeshInstance3D.new()
	mmi.multimesh = mm
	mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(mmi)


func _trees() -> void:
	var kinds := ["broadleaf", "broadleaf_big", "pine", "bush", "palm", "bush", "broadleaf"]
	for i in kinds.size():
		var mi := MeshInstance3D.new()
		mi.mesh = Vegetation.mesh(kinds[i], 0)
		mi.position = Vector3(-14 + i * 5.0, 0, -12 - (i % 2) * 6.0)
		add_child(mi)
		if "--folhas" in OS.get_cmdline_user_args() and str(kinds[i]).begins_with("broadleaf"):
			var le := Chunk.leaf_emitter(Transform3D(Basis(), mi.position), kinds[i])
			add_child(le)
			print("folhas ", le.amount, " vida ", le.lifetime, " pos ", le.position)
			if OS.get_environment("FOLHA_DBG") != "":
				le.amount = 60
				(le.draw_pass_1 as QuadMesh).size = Vector2(0.6, 0.6)
