extends Node3D
## Mostruário dos carros: cada tipo nos 4 estados (limpo, empoeirado, destruído,
## queimado), vista de 3/4 dianteira e traseira.
## Uso: xvfb-run godot --path . res://tests/cars_test.tscn -- --out=/tmp/carros

var out := "user://carros"


func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--out="):
			out = a.substr(6)
	DirAccess.make_dir_recursive_absolute(out)
	await Assets.bake_all()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.45, 0.5, 0.56)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.55, 0.58, 0.62)
	env.ambient_light_energy = 0.7
	env.tonemap_mode = Environment.TONE_MAPPER_ACES
	env.tonemap_exposure = 1.1
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation = Vector3(-0.8, -0.6, 0)
	sun.light_energy = 2.0
	sun.shadow_enabled = true
	add_child(sun)
	var ground := MeshInstance3D.new()
	var pm := PlaneMesh.new()
	pm.size = Vector2(200, 200)
	ground.mesh = pm
	var gm := StandardMaterial3D.new()
	gm.albedo_color = Color(0.25, 0.25, 0.26)
	ground.material_override = gm
	add_child(ground)
	var cam := Camera3D.new()
	cam.fov = 38.0
	add_child(cam)
	cam.make_current()
	var types := ["compact", "hatch", "sedan", "suv", "pickup", "van", "police", "taxi", "ambulance", "bus", "truck"]
	var states := ["clean", "dusty", "wreck", "burned"]
	var colors := [Color(0.7, 0.1, 0.08), Color(0.15, 0.3, 0.6), Color(0.85, 0.85, 0.82), Color(0.2, 0.45, 0.25)]
	var n := 0
	for type in types:
		for si in states.size():
			var st: String = states[si]
			var mi := MeshInstance3D.new()
			mi.mesh = VehicleMeshBuilder.mesh(type, st == "burned", true, st)
			var pmat := (mi.mesh.surface_get_material(0) as ShaderMaterial).duplicate() as ShaderMaterial
			var col: Color = colors[si]
			if type == "taxi":
				col = Color(0.95, 0.8, 0.15)
			elif type in ["police", "ambulance"]:
				col = Color(0.93, 0.93, 0.95)
			pmat.set_shader_parameter("paint_color", col)
			mi.set_surface_override_material(0, pmat)
			add_child(mi)
			var d := VehicleMeshBuilder.dims(type)
			var L: float = d["L"]
			var ext := L * 0.62
			for view in 2:
				var ang := deg_to_rad(-35.0 if view == 0 else 145.0)
				cam.position = Vector3(sin(ang) * ext * 2.3, float(d["roof"]) * 0.9 + 0.6, -cos(ang) * ext * 2.3)
				cam.look_at(Vector3(0, float(d["roof"]) * 0.45, 0), Vector3.UP)
				for i in 4:
					await get_tree().process_frame
				await RenderingServer.frame_post_draw
				var img := get_viewport().get_texture().get_image()
				n += 1
				img.save_png("%s/%s_%s_%d.png" % [out, type, st, view])
			mi.queue_free()
			await get_tree().process_frame
	print("CARROS OK: %d fotos" % n)
	get_tree().quit(0)
