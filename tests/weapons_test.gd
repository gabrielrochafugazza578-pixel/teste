extends Node3D
## Mostruário das armas (vista lateral) para conferir modelos e texturas.
## Uso: xvfb-run godot --path . res://tests/weapons_test.tscn -- --out=/tmp/armas

var out := "user://armas"


func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--out="):
			out = a.substr(6)
	DirAccess.make_dir_recursive_absolute(out)
	await Assets.bake_all()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.2, 0.21, 0.23)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.5, 0.52, 0.56)
	env.ambient_light_energy = 0.8
	env.tonemap_mode = Environment.TONE_MAPPER_ACES
	env.tonemap_exposure = 1.2
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation = Vector3(-0.7, -0.9, 0)
	sun.light_energy = 2.2
	add_child(sun)
	var fill := DirectionalLight3D.new()
	fill.rotation = Vector3(-0.3, 2.2, 0)
	fill.light_energy = 0.6
	add_child(fill)
	var melee: Array = []
	var guns: Array = []
	for id in ItemDB.items.keys():
		if ItemDB.get_item(id).has("ranged"):
			guns.append(id)
		elif ItemDB.is_weapon(id):
			melee.append(id)
	await _sheet(melee, false, "armas_brancas")
	await _sheet(guns, true, "armas_fogo")
	print("ARMAS OK: %d brancas, %d de fogo" % [melee.size(), guns.size()])
	get_tree().quit(0)


func _sheet(ids: Array, firearms: bool, name: String) -> void:
	var cam := Camera3D.new()
	cam.fov = 35.0
	add_child(cam)
	cam.make_current()
	for id in ids:
		var mi := MeshInstance3D.new()
		mi.mesh = WeaponMeshes.mesh(str(id))
		add_child(mi)
		var bb := mi.get_aabb()
		var c := bb.get_center()
		var ext := maxf(bb.size.y, bb.size.z) * 0.62 + 0.04
		# câmera no lado +X, um pouco acima e à frente: vê a face lateral e o volume
		cam.position = c + Vector3(ext / tan(deg_to_rad(17.5)), ext * 0.25, -ext * 0.35)
		cam.look_at(c, Vector3.UP)
		for i in 3:
			await get_tree().process_frame
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("%s/%s_%s.png" % [out, name, id])
		mi.queue_free()
		await get_tree().process_frame
	cam.queue_free()
