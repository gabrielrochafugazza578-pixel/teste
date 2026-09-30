extends Node
## Teste visual: gera o mundo, faz streaming ao redor de pontos e salva
## screenshots (uso: godot --path . res://tests/visual_test.tscn -- --out=/caminho)

var out_dir := "user://shots"
var world: World
var cam: Camera3D
var envc: EnvironmentController

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--out="):
			out_dir = a.substr(6)
	DirAccess.make_dir_recursive_absolute(out_dir)
	await Assets.bake_all()
	var t0 := Time.get_ticks_msec()
	var layout := WorldLayout.new()
	layout.generate(GameState.world_seed)
	print("layout: %d ms, prédios=%d, ruas=%d, quarteirões=%d" % [Time.get_ticks_msec() - t0, layout.buildings.size(), layout.roads.size(), layout.blocks.size()])
	GameState.in_game = true
	GameState.world_phase = GameState.Phase.POST
	RenderingServer.global_shader_parameter_set("world_decay", 1.0)
	envc = EnvironmentController.new()
	add_child(envc)
	world = World.new()
	add_child(world)
	world.setup(layout)
	cam = Camera3D.new()
	cam.far = 900.0
	cam.fov = 70.0
	add_child(cam)
	cam.current = true
	SimScheduler.camera = cam
	var shots := [
		["avenida", Vector3(4, 1.7, 40), Vector3(0, 3, -20), 10.0, 1],
		["acacias", layout.poi_pos("casa_familia") + Vector3(8, 2.0, -12), layout.poi_pos("casa_familia") + Vector3(0, 2, 0), 15.5, 0],
		["mirante", layout.poi_pos("mirante") + Vector3(0, 1.7, 0), Vector3(0, 0, -300), 7.5, 3],
		["hospital", layout.poi_pos("hospital") + Vector3(-20, 3, 25), layout.poi_pos("hospital") + Vector3(0, 8, 0), 12.0, 4],
		["industrial", layout.poi_pos("lab_nexus") + Vector3(-25, 4, 30), layout.poi_pos("lab_nexus"), 17.0, 2],
		["noite", Vector3(-4, 1.7, 60), Vector3(0, 4, 0), 22.0, 0],
	]
	for s in shots:
		var nm: String = s[0]
		var pos: Vector3 = s[1]
		var look: Vector3 = s[2]
		TimeManager.set_time(float(s[3]))
		WeatherManager.set_weather(int(s[4]), true, true)
		cam.global_position = pos
		SimScheduler.focus_position = pos
		SimScheduler.focus_node = cam
		cam.look_at(look, Vector3.UP)
		var tt := Time.get_ticks_msec()
		await world.wait_area(pos, 60.0, 40.0)
		for i in 30:
			await get_tree().process_frame
		print("%s: área pronta em %d ms, chunks=%d, draw=%d, vram=%.1f MB" % [nm, Time.get_ticks_msec() - tt, world.chunks.size(),
			Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME), Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1048576.0])
		await RenderingServer.frame_post_draw
		var img := get_viewport().get_texture().get_image()
		if img:
			img.save_png(out_dir + "/" + nm + ".png")
		world.clear_focus_points()
	print("OK")
	get_tree().quit()
