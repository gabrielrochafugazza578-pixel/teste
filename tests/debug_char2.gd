extends Node3D
func _ready() -> void:
	await Assets.bake_all()
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color(0.35, 0.38, 0.42)
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.6, 0.6, 0.6)
	env.environment = e
	add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation = Vector3(-0.8, 0.6, 0)
	add_child(sun)
	var ap := Appearance.helena()
	# 1) malha estática sem esqueleto
	var mi := MeshInstance3D.new()
	mi.mesh = HumanoidMeshBuilder.build(ap, 0)
	mi.material_override = Assets.character_material(0.0)
	mi.position = Vector3(-0.6, 0, 0)
	mi.rotation.y = PI
	add_child(mi)
	# 2) corpo com esqueleto, sem animar
	var b := HumanoidBody.new()
	add_child(b)
	b.setup(ap, 0)
	b.position = Vector3(0.6, 0, 0)
	b.rotation.y = PI
	var cam := Camera3D.new()
	add_child(cam)
	cam.position = Vector3(0, 1.4, 3.2)
	cam.look_at(Vector3(0, 1.3, 0))
	cam.current = true
	for i in 5:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("/tmp/claude-0/dbg/static_vs_skinned.png")
	get_tree().quit()
