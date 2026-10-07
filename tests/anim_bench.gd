extends Node
## Bancada de animação: renderiza quadros de cada ação/locomoção (lateral e frontal)
## e mede apoio dos pés (altura, deslize). Saída em --out=DIR (PNG por quadro + relatório).
## Uso: xvfb-run godot --path . --rendering-driver opengl3 res://tests/anim_bench.tscn -- --out=/tmp/anim [--only=nome]

var FW := 200
var FH := 300
var quem := "caio"
var out := "/tmp/anim"
var only := ""
var view_mode := "side"
var vp: SubViewport
var cam: Camera3D
var body: HumanoidBody
var rest_ankle_y := 0.085


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--out="):
			out = a.substr(6)
		elif a.begins_with("--only="):
			only = a.substr(7)
		elif a.begins_with("--view="):
			view_mode = a.substr(7)
		elif a == "--grande":
			# quadros grandes para mostrar (com sombra)
			FW = 480
			FH = 720
		elif a.begins_with("--quem="):
			quem = a.substr(7)
	DirAccess.make_dir_recursive_absolute(out)
	_run()


func _stage() -> void:
	vp = SubViewport.new()
	vp.size = Vector2i(FW, FH)
	vp.own_world_3d = true
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(vp)
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.62, 0.66, 0.72)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.75, 0.78, 0.82)
	env.ambient_light_energy = 0.8
	var we := WorldEnvironment.new()
	we.environment = env
	vp.add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, -30, 0)
	sun.light_energy = 1.1
	sun.shadow_enabled = FW > 200
	vp.add_child(sun)
	var floor_mi := MeshInstance3D.new()
	var pm := PlaneMesh.new()
	pm.size = Vector2(12, 12)
	floor_mi.mesh = pm
	var fm := StandardMaterial3D.new()
	fm.albedo_color = Color(0.38, 0.4, 0.36)
	floor_mi.material_override = fm
	vp.add_child(floor_mi)
	for i in range(-6, 7):
		var tick := MeshInstance3D.new()
		var bm := BoxMesh.new()
		bm.size = Vector3(0.02, 0.004, 12.0)
		tick.mesh = bm
		var tm := StandardMaterial3D.new()
		tm.albedo_color = Color(0.9, 0.9, 0.3) if i == 0 else Color(0.2, 0.2, 0.2)
		tick.material_override = tm
		tick.position = Vector3(i * 0.5, 0.003, 0)
		vp.add_child(tick)
	cam = Camera3D.new()
	cam.fov = 34.0
	vp.add_child(cam)
	body = HumanoidBody.new()
	vp.add_child(body)
	body.setup(Appearance.infected("errante", 12) if quem == "zumbi" else Appearance.caio(), 0)
	body.mesh_instance.custom_aabb = AABB(Vector3(-3, -1, -3), Vector3(6, 5, 6))


func _view(side: bool, dist: float = 4.6, ycam: float = 1.0) -> void:
	var pos: Vector3
	if not side or view_mode == "front":
		pos = Vector3(0.0, ycam, -dist)
	elif view_mode == "three":
		pos = Vector3(dist * 0.62, ycam + 0.2, -dist * 0.78)
	else:
		pos = Vector3(dist, ycam, 0.0)
	cam.position = pos
	cam.look_at(Vector3(0, 0.92, 0), Vector3.UP)


func _reset() -> ProceduralAnimator:
	var an := body.animator
	an.stop_immediate()
	an.style = "human"
	an.speed = 0.0
	an.forward_speed = 0.0
	an.grounded = true
	an.crouch_target = 0.0
	an.crouch = 0.0
	an.injured = 0.0
	an.twitchiness = 0.0
	an.t = 0.0
	an.phase = 0.0
	an.update(0.0)
	return an


func _grab(name_: String, idx: int) -> void:
	for i in 3:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var img := vp.get_texture().get_image()
	img.save_png("%s/%s_%02d.png" % [out, name_, idx])


## Posição do tornozelo (osso do pé) no espaço do corpo.
func _ankle(right: bool) -> Vector3:
	var idx := body.skeleton.find_bone("foot_r" if right else "foot_l")
	return body.skeleton.get_bone_global_pose(idx).origin


func _loco(name_: String, style: String, spd: float, crouch: bool = false, frames: int = 8, view_side: bool = true) -> void:
	if only != "" and not name_ in only.split(","):
		return
	var an := _reset()
	an.style = style
	an.speed = spd
	an.forward_speed = spd
	an.crouch_target = 1.0 if crouch else 0.0
	_view(view_side)
	for i in 60:
		an.update(1.0 / 60.0)
	var stride := lerpf(0.68, 1.15, smoothstep(2.4, 4.4, spd)) * an.height_scale
	var cycle := 2.0 * maxf(stride, 0.1) / maxf(spd, 0.05) if spd > 0.05 else 2.0
	var dt := 1.0 / 60.0
	var n := int(round(cycle / dt))
	var step := maxi(1, n / frames)
	var min_y := 9.0
	var max_stance_y := -9.0
	var slide_sum := 0.0
	var slide_n := 0
	var prev_l := _ankle(false)
	var prev_r := _ankle(true)
	var hips_min := 9.0
	var hips_max := -9.0
	for k in n:
		an.update(dt)
		var l := _ankle(false)
		var r := _ankle(true)
		hips_min = minf(hips_min, body.skeleton.get_bone_global_pose(0).origin.y)
		hips_max = maxf(hips_max, body.skeleton.get_bone_global_pose(0).origin.y)
		min_y = minf(min_y, minf(l.y, r.y))
		# pé de apoio = o mais baixo; em apoio deve andar para trás à velocidade do corpo (+Z)
		var lo_is_l := l.y < r.y
		var lo := l if lo_is_l else r
		var lo_prev := prev_l if lo_is_l else prev_r
		max_stance_y = maxf(max_stance_y, lo.y)
		if spd > 0.3 and absf(lo.y - lo_prev.y) < 0.02:
			var v := (lo.z - lo_prev.z) / dt
			slide_sum += absf(v - spd)
			slide_n += 1
		prev_l = l
		prev_r = r
		if k % step == 0 and k / step < frames:
			await _grab(name_, k / step)
	var slide := slide_sum / maxf(slide_n, 1)
	print("LOCO %-16s v=%.1f  tornozelo_min=%.3f (repouso %.3f)  apoio_max=%.3f  quadril[%.3f..%.3f]  deslize_medio=%.2f m/s" % [name_, spd, min_y, rest_ankle_y, max_stance_y, hips_min, hips_max, slide])


func _action(name_: String, frames: int = 8, speed_mult: float = 1.0, side: bool = true) -> void:
	if only != "" and not name_ in only.split(","):
		return
	var an := _reset()
	_view(side)
	if not an.play(name_, speed_mult, true):
		print("ACTION %s: não existe" % name_)
		return
	var dur: float = an.action["dur"]
	var dt := 1.0 / 60.0
	var n := int(round(dur / dt / speed_mult))
	var step := maxi(1, n / frames)
	var min_y := 9.0
	for k in n + 20:
		an.update(dt)
		min_y = minf(min_y, minf(_ankle(false).y, _ankle(true).y))
		if k % step == 0 and k / step < frames:
			await _grab(name_, k / step)
	print("ACTION %-16s dur=%.2f  tornozelo_min=%.3f" % [name_, dur, min_y])


func _run() -> void:
	Settings.apply_preset(1)
	await Assets.bake_all()
	_stage()
	await get_tree().process_frame
	rest_ankle_y = _ankle(false).y
	print("repouso: tornozelo y=%.3f quadril y=%.3f" % [rest_ankle_y, body.skeleton.get_bone_global_pose(0).origin.y])
	await _loco("idle", "human", 0.0, false, 6)
	await _loco("walk", "human", 1.4)
	await _loco("walk_front", "human", 1.4, false, 8, false)
	await _loco("jog", "human", 3.0)
	await _loco("run", "human", 4.6)
	await _loco("sprint", "human", 6.2)
	await _loco("crouch_walk", "human", 1.2, true)
	await _loco("crouch_idle", "human", 0.0, true, 4)
	await _loco("shamble", "shamble", 1.0)
	await _loco("feral_run", "feral", 5.0)
	await _loco("brute_walk", "brute", 1.6)
	await _loco("injured_walk", "injured", 1.2)
	await _loco("crawl", "crawl", 0.8)
	await _loco("panic_run", "panic", 4.5)
	for a in ["attack_light", "attack_light_2", "attack_heavy", "block", "dodge", "dodge_side", "shove", "stomp", "throw",
			"hit_front", "stagger", "knockdown", "death", "death_front", "interact", "pickup", "use_eat", "use_drink", "use_bandage",
			"climb", "vault", "sit", "drive", "inf_lunge", "inf_swipe", "inf_grab", "brute_slam", "get_up", "scream", "cough", "wave", "point"]:
		await _action(a)
	print("FIM")
	get_tree().quit(0)
