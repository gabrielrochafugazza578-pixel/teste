extends "res://tests/gallery_driver.gd"
## Controle simulado (DualSense): eventos de botão/gatilho/analógico injetados
## com Input.parse_input_event. Confere câmera 1ª/3ª pessoa (R3), gatilhos
## virando um aperto só, atalhos no d-pad, abrir Mochila (Share), foco e
## navegação nos menus, L2/R2 trocando Mochila/Mapa/Diário, ○ fechando, pausa
## (Options) e fotos com os ícones do controle.
## Uso: xvfb-run godot --path . res://tests/pad.tscn -- --no-audio --out=/tmp/pad

var fails := 0


func _check(name: String, ok: bool, extra: String = "") -> void:
	_log("%s %s %s" % ["OK  " if ok else "FALHOU", name, extra])
	if not ok:
		fails += 1


func _btn(idx: int, pressed: bool) -> void:
	var e := InputEventJoypadButton.new()
	e.button_index = idx as JoyButton
	e.pressed = pressed
	e.device = 0
	Input.parse_input_event(e)


func _tap(idx: int, hold: float = 0.08) -> void:
	_btn(idx, true)
	await _wait(hold)
	_btn(idx, false)
	await _wait(0.2)


func _axis(ax: int, v: float) -> void:
	var e := InputEventJoypadMotion.new()
	e.axis = ax as JoyAxis
	e.axis_value = v
	e.device = 0
	Input.parse_input_event(e)


## Espera em tempo de jogo (o ambiente de teste roda a poucos quadros por segundo).
func _game_wait(sec: float) -> void:
	var t := 0.0
	while t < sec:
		await get_tree().process_frame
		t += get_process_delta_time()


func _focus_name() -> String:
	var f := get_viewport().gui_get_focus_owner()
	if f == null:
		return "<nada>"
	var s := f.get_class()
	if f is Button:
		s += " '%s'" % (f as Button).text.strip_edges()
	elif f is ItemSlot:
		s += " #%d" % (f as ItemSlot).index
	return s


func _gallery() -> void:
	Settings.controls["pad_glyphs"] = 1   # ícones PlayStation nas fotos
	Settings.controls["camera_mode"] = "third"
	var av := g.layout.poi_pos("avenida_central")
	await _go(av + Vector3(4, 0, 30), av + Vector3(4, 0, 0), 10.5, WeatherManager.State.CLEAR)
	var p := g.player
	p.cam_rig.first_person = false
	for e in [["faca_tatica", 1], ["lata_feijao", 3], ["agua_garrafa", 2], ["bandagem", 4], ["tabua", 6], ["pano", 3], ["pedra", 3]]:
		p.inventory.add(str(e[0]), int(e[1]))
	p.quick_slots = ["bandagem", "agua_garrafa", "lata_feijao", ""]
	# qualquer botão liga o modo controle
	await _tap(JOY_BUTTON_DPAD_RIGHT)
	_check("modo controle ligado", Pad.using_pad)
	_check("d-pad → escolhe atalho 2", p.selected_slot == 1, "slot=%d" % p.selected_slot)
	await _tap(JOY_BUTTON_DPAD_RIGHT)
	await _tap(JOY_BUTTON_DPAD_RIGHT)
	_check("d-pad pula atalho vazio", p.selected_slot == 0, "slot=%d" % p.selected_slot)
	await _wait(0.5)
	await _shot("hud_controle")
	# gatilho R2 analógico: vários eventos de eixo = um aperto
	var fired := [0]
	var cb := func(_a: Node, _b: Node, _d: float) -> void: fired[0] += 1
	EventBus.combat_hit.connect(cb)
	var presses := [0]
	var watcher := func(ev: InputEvent) -> void:
		if ev is InputEventJoypadButton and (ev as InputEventJoypadButton).button_index == InputSetup.PAD_R2 and ev.is_pressed():
			presses[0] += 1
	get_viewport().window_input.connect(watcher)
	for v in [0.1, 0.3, 0.5, 0.7, 0.9, 1.0, 0.95, 1.0]:
		_axis(JOY_AXIS_TRIGGER_RIGHT, v)
		await get_tree().process_frame
	await _wait(0.1)
	for v in [0.6, 0.3, 0.1, 0.0]:
		_axis(JOY_AXIS_TRIGGER_RIGHT, v)
		await get_tree().process_frame
	await _wait(0.6)
	get_viewport().window_input.disconnect(watcher)
	EventBus.combat_hit.disconnect(cb)
	_check("R2 vira um aperto só", presses[0] == 1, "apertos=%d" % presses[0])
	_check("R2 ataca", p._attack_active or p.body.animator.is_playing(), "")
	await _wait(1.0)
	# câmera: R3 alterna 1ª/3ª pessoa
	await _tap(JOY_BUTTON_RIGHT_STICK)
	await _game_wait(1.5)
	_check("R3 → 1ª pessoa", p.cam_rig.first_person and p.cam_rig.fp > 0.95, "fp=%.2f" % p.cam_rig.fp)
	_check("cabeça escondida", p.body.hide_head)
	var eye := p.eye_position(p.cam_rig.flat_forward())
	_check("câmera nos olhos", p.cam_rig.cam.global_position.distance_to(eye) < 0.25, "dist=%.2f" % p.cam_rig.cam.global_position.distance_to(eye))
	await _shot("primeira_pessoa")
	p.cam_rig.pitch = -0.9
	await _wait(0.6)
	await _shot("primeira_pessoa_olhando_baixo")
	p.cam_rig.pitch = -0.1
	# analógico direito gira a câmera
	var y0 := p.cam_rig.yaw
	_axis(JOY_AXIS_RIGHT_X, 1.0)
	var fr := 0
	var t_acc := 0.0
	while t_acc < 0.5:
		await get_tree().process_frame
		t_acc += get_process_delta_time()
		fr += 1
		if fr <= 3:
			_log("eixo RX=%.2f yaw=%.2f fps=%d dt=%.3f input=%s" % [Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), p.cam_rig.yaw, Engine.get_frames_per_second(), get_process_delta_time(), p.cam_rig.input_enabled])
	_axis(JOY_AXIS_RIGHT_X, 0.0)
	await _wait(0.1)
	_check("analógico direito gira a câmera", absf(angle_difference(y0, p.cam_rig.yaw)) > 0.3, "Δ=%.2f" % angle_difference(y0, p.cam_rig.yaw))
	# arma na mão em 1ª pessoa
	p.equipment["weapon"] = Inventory.make_stack("taco_beisebol", 1, 0.9)
	p._update_weapon_visual()
	await _wait(0.5)
	await _shot("primeira_pessoa_taco")
	await _tap(JOY_BUTTON_RIGHT_STICK)
	await _wait(1.2)
	_check("R3 → volta para 3ª pessoa", not p.cam_rig.first_person and p.cam_rig.fp < 0.05 and not p.body.hide_head)
	# andar com o analógico esquerdo
	var pos0 := p.global_position
	_axis(JOY_AXIS_LEFT_Y, -1.0)
	# tempo de jogo (o ambiente de teste roda a poucos quadros por segundo)
	var gt := 0.0
	while gt < 1.0:
		await get_tree().physics_frame
		gt += get_physics_process_delta_time()
	_axis(JOY_AXIS_LEFT_Y, 0.0)
	await _wait(0.3)
	_check("analógico esquerdo anda", p.global_position.distance_to(pos0) > 1.5, "%.1f m" % p.global_position.distance_to(pos0))
	# Share → Mochila
	await _tap(JOY_BUTTON_BACK)
	await _wait(0.6)
	_check("Share abre a mochila", g.ui.current is InventoryScreen)
	await _wait(0.4)
	_check("foco numa célula", get_viewport().gui_get_focus_owner() is ItemSlot, _focus_name())
	var f0 := get_viewport().gui_get_focus_owner()
	await _tap(JOY_BUTTON_DPAD_RIGHT)
	_check("d-pad move o foco", get_viewport().gui_get_focus_owner() != f0, _focus_name())
	# analógico esquerdo também navega (uma casa por inclinada)
	var f1 := get_viewport().gui_get_focus_owner() as ItemSlot
	_axis(JOY_AXIS_LEFT_X, 1.0)
	await _wait(0.12)
	_axis(JOY_AXIS_LEFT_X, 0.0)
	await _wait(0.3)
	var f2 := get_viewport().gui_get_focus_owner() as ItemSlot
	_check("analógico move o foco uma casa", f1 != null and f2 != null and f2.index == f1.index + 1, _focus_name())
	# △ põe no atalho
	var id := str(f2.stack.get("id", "")) if f2 else ""
	await _tap(JOY_BUTTON_Y)
	_check("△ põe o item num atalho", id != "" and p.quick_slots.has(id), id)
	# □ leva o foco para as ações; ○ volta
	await _tap(JOY_BUTTON_X)
	await _wait(0.2)
	var fa := get_viewport().gui_get_focus_owner()
	_check("□ foca as ações do item", fa is Button, _focus_name())
	await _shot("mochila_controle")
	await _tap(JOY_BUTTON_B)
	_check("○ volta para a grade", get_viewport().gui_get_focus_owner() is ItemSlot and g.ui.current is InventoryScreen, _focus_name())
	# R1 troca aba
	var inv := g.ui.current as InventoryScreen
	var tab0 := inv.right_tabs.current_tab
	await _tap(JOY_BUTTON_RIGHT_SHOULDER)
	_check("R1 troca a aba", inv.right_tabs.current_tab != tab0, "%d → %d" % [tab0, inv.right_tabs.current_tab])
	# R2 → Mapa → Diário
	_axis(JOY_AXIS_TRIGGER_RIGHT, 1.0)
	await _wait(0.1)
	_axis(JOY_AXIS_TRIGGER_RIGHT, 0.0)
	await _wait(0.6)
	_check("R2 no menu → Mapa", g.ui.current is MapScreen)
	if g.ui.current is MapScreen:
		var mv := (g.ui.current as MapScreen).view
		var c0 := mv.center_px
		_axis(JOY_AXIS_LEFT_X, 1.0)
		await _wait(0.4)
		_axis(JOY_AXIS_LEFT_X, 0.0)
		_check("analógico move o mapa", mv.center_px.x > c0.x + 5.0, "%.0f → %.0f" % [c0.x, mv.center_px.x])
		g.waypoint = Vector3.INF
		await _tap(JOY_BUTTON_A)
		_check("✕ marca destino no mapa", g.waypoint != Vector3.INF)
		await _shot("mapa_controle")
	_axis(JOY_AXIS_TRIGGER_RIGHT, 1.0)
	await _wait(0.1)
	_axis(JOY_AXIS_TRIGGER_RIGHT, 0.0)
	await _wait(0.6)
	_check("R2 no menu → Diário", g.ui.current is JournalScreen)
	await _wait(0.3)
	await _shot("diario_controle")
	await _tap(JOY_BUTTON_B)
	await _wait(0.5)
	_check("○ fecha o diário", not g.ui.is_screen_open() and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED)
	# Options → pausa
	await _tap(JOY_BUTTON_START)
	await _wait(0.5)
	_check("Options abre a pausa", g.ui.current is PauseMenu)
	_check("foco num botão da pausa", get_viewport().gui_get_focus_owner() is Button, _focus_name())
	await _tap(JOY_BUTTON_DPAD_DOWN)
	_check("d-pad desce na pausa", get_viewport().gui_get_focus_owner() is Button, _focus_name())
	await _shot("pausa_controle")
	await _tap(JOY_BUTTON_B)
	await _wait(0.5)
	_check("○ fecha a pausa", not g.ui.is_screen_open() and not get_tree().paused)
	# ✕ pula (não fica preso no menu)
	var jy := p.global_position.y
	await _tap(JOY_BUTTON_A, 0.05)
	await _wait(0.15)
	_check("✕ pula", p.global_position.y > jy + 0.1 or not p.is_on_floor(), "Δy=%.2f" % (p.global_position.y - jy))
	await _wait(1.0)
	# △ segurado arremessa
	p.inventory.add("pedra", 2)
	var stones := 0
	for tid in ["garrafa_vazia", "lata_vazia", "pedra", "rojao", "coquetel"]:
		stones += p.inventory.count(tid)
	_btn(JOY_BUTTON_Y, true)
	var ht := 0.0
	while ht < 0.6:
		await get_tree().physics_frame
		ht += get_physics_process_delta_time()
	_btn(JOY_BUTTON_Y, false)
	ht = 0.0
	while ht < 1.2:
		await get_tree().physics_frame
		ht += get_physics_process_delta_time()
	var left := 0
	for tid in ["garrafa_vazia", "lata_vazia", "pedra", "rojao", "coquetel"]:
		left += p.inventory.count(tid)
	_check("△ segurado arremessa", left < stones, "arremessáveis %d → %d" % [stones, left])
	# carro: R2 acelera, L2 freia, □ sai
	if g.vehicles:
		# no meio da avenida, de frente para o fim dela
		# tira quem estiver no caminho (companheiros andam atrás do jogador)
		if g.survivors:
			for n in g.survivors.followers():
				(n as Node3D).global_position = av + Vector3(9.0, 0.2, 40.0)
		var st := {"id": "teste_pad_carro", "type": "sedan", "color": Color(0.6, 0.1, 0.1), "pos": av + Vector3(-1.5, 0.3, 12.0),
			"yaw": PI, "fuel": 30.0, "engine": 0.9, "battery": true, "needs": {}, "hp": 100.0, "placed": true}
		g.vehicles.states[st["id"]] = st
		var v: Vehicle = g.vehicles._spawn(st)
		await _game_wait(0.5)
		v.enter(p)
		await _game_wait(0.5)
		_check("entrou no carro", p.in_vehicle == v)
		_axis(JOY_AXIS_TRIGGER_RIGHT, 1.0)
		await _game_wait(0.3)
		_log("  carro: forca=%.2f throttle=%.2f brake=%.2f motor=%s pad=%s freeze=%s" % [Input.get_action_strength("veh_throttle"), v.throttle, v.brake, v.engine_on, Pad.using_pad, v.freeze])
		await _game_wait(1.7)
		var spd := v.linear_velocity.length()
		_axis(JOY_AXIS_TRIGGER_RIGHT, 0.0)
		_check("R2 acelera o carro", spd > 2.0, "%.1f m/s" % spd)
		var head_y := p.body.bone_global_position("head").y
		var roof_y := (v.global_transform * Vector3(0, float(v.dims["roof"]), 0)).y
		_check("cabeça abaixo do teto", head_y + 0.38 < roof_y, "cabeça %.2f · teto %.2f · local %s · quadril %s" % [head_y, roof_y,
			v.to_local(p.body.bone_global_position("head")), v.to_local(p.body.bone_global_position("hips"))])
		await _shot("carro_controle")
		_axis(JOY_AXIS_TRIGGER_LEFT, 1.0)
		await _game_wait(1.5)
		_axis(JOY_AXIS_TRIGGER_LEFT, 0.0)
		_check("L2 freia", v.linear_velocity.length() < spd, "%.1f m/s" % v.linear_velocity.length())
		await _game_wait(1.0)
		await _tap(JOY_BUTTON_X)
		await _game_wait(0.5)
		_check("□ sai do carro", p.in_vehicle == null)
	# volta para teclado
	Pad.device_changed.connect(func(on: bool) -> void: _log("  (aparelho: %s)" % ("controle" if on else "teclado/mouse")))
	await _wait(0.5)
	var k := InputEventKey.new()
	k.physical_keycode = KEY_W
	k.pressed = true
	Input.parse_input_event(k)
	k = k.duplicate()
	k.pressed = false
	Input.parse_input_event(k)
	await _wait(0.3)
	_check("teclado desliga o modo controle", not Pad.using_pad)
	_log("PAD: %s (%d falhas)" % ["OK" if fails == 0 else "FALHOU", fails])
