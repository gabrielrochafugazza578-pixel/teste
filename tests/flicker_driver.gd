extends "res://tests/gallery_driver.gd"
## Medidor de "piscar": em cada cena grava uma sequência de quadros com a câmera
## andando bem devagar (poucos cm por quadro). Superfícies coplanares brigando
## pelo depth (z-fighting), padrões finos sem antisserrilhado (janelas, faixas)
## e sombras tremendo mudam de um quadro para o outro de forma não suave — o
## script tools/flicker_score.py compara cada quadro com a média dos vizinhos.
## Uso: xvfb-run godot --path . res://tests/flicker.tscn -- --no-audio --out=/tmp/pisca [--only=rua,casa]

var only: PackedStringArray = []
var cam: Camera3D
const FRAMES := 7
var step_mul := 0.12


func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--only="):
			only = a.substr(7).split(",")
	super._ready()


func _want(name: String) -> bool:
	return only.is_empty() or name in only


## Sequência: câmera própria (sem suavização do rig) andando `step` por quadro.
func _seq(name: String, eye: Vector3, look: Vector3, step: Vector3) -> void:
	if cam == null:
		cam = Camera3D.new()
		g.add_child(cam)
	var gc := g.player.cam_rig.cam
	cam.fov = gc.fov
	cam.near = gc.near
	cam.far = gc.far
	cam.current = true
	g.ui.hud.visible = false
	# a câmera de teste fica onde o Caio está: esconde o corpo dele
	g.player.visible = false
	for i in FRAMES:
		var e := eye + step * float(i) * step_mul
		cam.global_position = e
		cam.look_at(look + step * float(i) * step_mul, Vector3.UP)
		for k in 2:
			await get_tree().process_frame
		await RenderingServer.frame_post_draw
		var img := get_viewport().get_texture().get_image()
		img.save_png("%s/%s_%02d.png" % [out, name, i])
	# dois quadros com a câmera parada: o que muda aqui é animação (vento nas
	# folhas, gente andando), não piscar — o placar desconta
	for k in 2:
		for j in 2:
			await get_tree().process_frame
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("%s/%s_s%d.png" % [out, name, k])
	_log("seq %s ok" % name)
	cam.current = false
	gc.current = true
	g.ui.hud.visible = true
	g.player.visible = true


func _gallery() -> void:
	var L := g.layout
	var W := WeatherManager.State
	# relógio parado: mede só o piscar de geometria/textura (sol fixo)
	TimeManager.running = "--sol" in OS.get_cmdline_user_args()
	var av := L.poi_pos("avenida_central")
	GameState.set_phase(GameState.Phase.POST)
	var args := OS.get_cmdline_user_args()
	if "--sem-sombra" in args:
		g.env.sun.shadow_enabled = false
	if "--sem-blend" in args:
		g.env.sun.directional_shadow_blend_splits = false
	if "--split-log" in args:
		_log("sombra: dist=%.0f modo=%d split1=%.2f bias=%.2f nbias=%.2f" % [g.env.sun.directional_shadow_max_distance, g.env.sun.directional_shadow_mode,
			g.env.sun.directional_shadow_split_1, g.env.sun.shadow_bias, g.env.sun.shadow_normal_bias])
	if "--band" in args:
		await _band_probe(av)
		return
	if "--janela" in args:
		GameState.set_phase(GameState.Phase.PRE)
		await _go(av + Vector3(11.5, 0, 40), av + Vector3(0, 0, 10), 10.2, W.CLEAR)
		var e := av + Vector3(11.5, 1.6, 40)
		var lk := av + Vector3(-14, 9, 22)
		await _seq("janela_a", e, lk, Vector3.ZERO)
		var m: ShaderMaterial = Assets.world_material("exterior")
		m.set_shader_parameter("enable_windows", false)
		await _seq("janela_sem", e, lk, Vector3.ZERO)
		m.set_shader_parameter("enable_windows", true)
		TimeManager.set_time(21.0)
		await _wait(1.0)
		await _seq("janela_noite", e, lk, Vector3.ZERO)
		return
	if _want("avenida"):
		await _go(av + Vector3(4, 0, 30), av + Vector3(4, 0, -20), 11.0, W.CLOUDY)
		var e := av + Vector3(4, 1.7, 30)
		await _seq("avenida", e, e + Vector3(0, -0.25, -40), Vector3(0.03, 0, -0.04))
		if "--cima" in OS.get_cmdline_user_args():
			var top := av + Vector3(4, 45, 15)
			await _seq("avenida_cima", top, top + Vector3(0, -45, -0.01), Vector3(0.01, 0, 0))
			var cp := av + Vector3(4, 0, 15)
			var cc := Vector2i(floori(cp.x / WorldLayout.CHUNK), floori(cp.z / WorldLayout.CHUNK))
			for dz in range(-1, 2):
				for dx in range(-1, 2):
					var k := cc + Vector2i(dx, dz)
					if g.world.chunks.has(k):
						var ch: Chunk = g.world.chunks[k]
						_log("chunk %s lod=%s" % [k, ch.get("lod")])
			_log("av=%s chunk_camera=%s" % [av, cc])
	if _want("calcada"):
		await _go(av + Vector3(9, 0, 20), av + Vector3(9, 0, -10), 11.0, W.CLOUDY)
		var e := av + Vector3(8.5, 1.6, 20)
		await _seq("calcada", e, e + Vector3(1.5, -1.2, -8), Vector3(0.02, 0, -0.03))
	if _want("fachada"):
		await _go(av + Vector3(-3, 0, -40), av + Vector3(-3, 0, -80), 11.0, W.CLOUDY)
		var e := av + Vector3(-3, 1.7, -40)
		await _seq("fachada", e, e + Vector3(-30, 8, -60), Vector3(0.0, 0, -0.05))
	if _want("longe"):
		await _go(av + Vector3(3, 0, 420), av + Vector3(3, 0, 360), 11.0, W.CLEAR)
		var e := av + Vector3(3, 1.7, 420)
		await _seq("longe", e, e + Vector3(0, 2, -300), Vector3(0.02, 0, -0.05))
	if _want("serra"):
		var mp := L.poi_pos("mirante")
		await _go(mp + Vector3(-2, 0, 0), mp + Vector3(0, -20, 400), 11.0, W.CLEAR, -0.05)
		var e := g.player.global_position + Vector3(0, 1.7, 0)
		await _seq("serra", e, e + Vector3(0, -30, 400), Vector3(0.05, 0, 0.0))
	if _want("casa"):
		await _casa_seq()


## Diagnóstico: esconde um grupo de nós por vez e fotografa a mesma vista, para
## descobrir qual malha desenha uma faixa estranha.
func _band_probe(av: Vector3) -> void:
	await _go(av + Vector3(4, 0, 30), av + Vector3(4, 0, -20), 11.0, WeatherManager.State.CLOUDY)
	var e := av + Vector3(4, 1.7, 30)
	var groups := {}
	for c in g.world.chunks.keys():
		var ch: Node = g.world.chunks[c]
		for n in ch.get_children():
			var key: String = str(n.name).rstrip("0123456789@")
			if n is MultiMeshInstance3D:
				var mm := (n as MultiMeshInstance3D).multimesh
				key = "MM:" + (mm.mesh.resource_name if mm and mm.mesh and mm.mesh.resource_name != "" else str(n.name).rstrip("0123456789@"))
			if not groups.has(key):
				groups[key] = []
			groups[key].append(n)
	for n in g.world.get_children():
		if not (n is Chunk):
			var k2 := "W:" + str(n.name)
			groups[k2] = [n]
	for n in g.get_children():
		if n != g.world and n is Node3D:
			groups["G:" + str(n.name)] = [n]
	_log("grupos: %s" % str(groups.keys()))
	await _seq("banda_base", e, e + Vector3(0, -0.25, -40), Vector3.ZERO)
	cam.current = true
	cam.global_position = e
	cam.look_at(e + Vector3(0, -0.25, -40), Vector3.UP)
	g.ui.hud.visible = false
	var i := 0
	for key in groups.keys():
		var hidden: Array = []
		for n in groups[key]:
			if n is Node3D and (n as Node3D).visible:
				(n as Node3D).visible = false
				hidden.append(n)
		if hidden.is_empty():
			continue
		await get_tree().process_frame
		await RenderingServer.frame_post_draw
		await get_tree().process_frame
		await RenderingServer.frame_post_draw
		var img := get_viewport().get_texture().get_image()
		img.save_png("%s/sem_%02d.png" % [out, i])
		_log("sem_%02d = %s (%d nós)" % [i, key, hidden.size()])
		for n in hidden:
			(n as Node3D).visible = true
		i += 1


## Dentro da casa mais perto da avenida, olhando o chão/paredes do maior cômodo.
func _casa_seq() -> void:
	var L := g.layout
	var av := L.poi_pos("avenida_central")
	var best := -1
	var bd := INF
	for i in L.buildings.size():
		var b: Dictionary = L.buildings[i]
		if str(b.get("interior", b.get("type", ""))) == "house" and bool(b.get("enterable", false)):
			var c := (b["rect"] as Rect2).get_center()
			var d := Vector2(c.x - av.x, c.y - av.z).length()
			if d < bd:
				bd = d
				best = i
	if best < 0:
		return
	var b: Dictionary = L.buildings[best]
	var di := BuildingGen.door_info(b)
	var door: Vector3 = di[0]
	var n: Vector3 = di[1]
	g.world.force_interior(best, true)
	await _go(door + n * 3.0, door, 13.0, WeatherManager.State.CLEAR, 0.0)
	var t := 0.0
	while g.world.interior_root(best) == null and t < 20.0:
		await _wait(0.25)
		t += 0.25
	var data: Dictionary = {}
	for c in g.world.chunks.keys():
		var chk: Chunk = g.world.chunks[c]
		if chk.interiors.has(best):
			data = chk.interiors[best]["data"]
	var views: Array = data.get("room_views", []).duplicate()
	views.sort_custom(func(a, bb): return float(a["area"]) > float(bb["area"]))
	if views.is_empty():
		return
	var a: Vector3 = views[0]["a"]
	var cc: Vector3 = views[0]["b"]
	var p := g.player
	p.set_physics_process(false)
	p.global_position = a
	p.set_physics_process(true)
	# lanterna para enxergar o chão
	p.equipment["light"] = Inventory.make_stack("lanterna", 1, 1.0, {"battery": 100.0})
	await _wait(2.0)
	var e := a + Vector3(0, 1.6, 0)
	var dir := (cc - a).normalized()
	await _seq("casa", e, cc + Vector3(0, 0.0, 0), Vector3(dir.z, 0, -dir.x) * 0.02)
	await _seq("casa_chao", e, e + dir * 2.5 + Vector3(0, -1.5, 0), dir * 0.02)
