class_name SettingsMenu
extends Control
## Configurações: Gráficos, Áudio, Controles (remapeamento), Acessibilidade
## e Jogo. Usado no menu principal e na pausa. Salva ao fechar.

signal closed

const RESOLUTIONS := [Vector2i(1280, 720), Vector2i(1366, 768), Vector2i(1600, 900), Vector2i(1920, 1080), Vector2i(2560, 1440)]
const QUALITY := ["Muito baixo", "Baixo", "Médio", "Alto", "Ultra"]

var tabs: TabContainer
var _rebind_action: String = ""
var _rebind_btn: Button = null
var _gfx_controls: Dictionary = {}
var _building: bool = false


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	add_child(UIKit.dim_bg(0.55))
	var p := UIKit.panel(20)
	p.custom_minimum_size = Vector2(980, 640)
	var v := UIKit.vbox(10)
	p.add_child(v)
	v.add_child(UIKit.title("CONFIGURAÇÕES", 28))
	tabs = TabContainer.new()
	tabs.custom_minimum_size = Vector2(940, 520)
	tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(tabs)
	_build_graphics()
	_build_audio()
	_build_controls()
	_build_accessibility()
	_build_gameplay()
	var bottom := UIKit.hbox(12)
	bottom.alignment = BoxContainer.ALIGNMENT_END
	bottom.add_child(UIKit.button("Restaurar padrão", _reset_tab, 200))
	bottom.add_child(UIKit.button("Voltar", close, 200))
	v.add_child(bottom)
	add_child(UIKit.center(p))


func _scroll(name_: String) -> VBoxContainer:
	var sc := ScrollContainer.new()
	sc.name = name_
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	var v := UIKit.vbox(8)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(v)
	tabs.add_child(sc)
	return v


# ---------------------------------------------------------------------------
# Gráficos
# ---------------------------------------------------------------------------
func _build_graphics() -> void:
	var v := _scroll("Gráficos")
	_building = true
	var g := Settings.graphics
	var preset_items := Settings.PRESET_NAMES.duplicate()
	preset_items.append("PERSONALIZADO")
	var pi := int(g["preset"])
	var preset := UIKit.options(preset_items, pi if pi >= 0 else 5, func(i: int) -> void:
		if i < 5 and not _building:
			Settings.apply_preset(i)
			_refresh_graphics())
	_gfx_controls["preset"] = preset
	v.add_child(UIKit.row("Predefinição de qualidade", preset, "BAIXO é o alvo para i3-4130 + GTX 750 Ti (900p/30 FPS)."))
	v.add_child(UIKit.label("Detectado: " + RenderingServer.get_video_adapter_name(), 14, UITheme.TEXT_DIM))
	v.add_child(UIKit.separator())
	var res_items: Array = []
	var res_i := 2
	for i in RESOLUTIONS.size():
		res_items.append("%d × %d" % [RESOLUTIONS[i].x, RESOLUTIONS[i].y])
		if RESOLUTIONS[i] == g["resolution"]:
			res_i = i
	v.add_child(UIKit.row("Modo de janela", UIKit.options(["Janela", "Tela cheia", "Tela cheia exclusiva"], int(g["window_mode"]), func(i: int) -> void: _gset("window_mode", i))))
	v.add_child(UIKit.row("Resolução", UIKit.options(res_items, res_i, func(i: int) -> void: _gset("resolution", RESOLUTIONS[i]))))
	_add_gfx_slider(v, "render_scale", "Resolução interna (escala 3D)", 0.5, 1.0, 0.05, "%.0f%%", 100.0, "Renderiza o 3D abaixo da resolução da tela e amplia. Maior ganho de desempenho.")
	v.add_child(UIKit.row("VSync", UIKit.options(["Desligado", "Ligado", "Adaptativo"], int(g["vsync"]), func(i: int) -> void: _gset("vsync", i))))
	v.add_child(UIKit.row("Limite de FPS", UIKit.options(["Sem limite", "30", "45", "60", "120"], [0, 30, 45, 60, 120].find(int(g["fps_limit"])), func(i: int) -> void: _gset("fps_limit", [0, 30, 45, 60, 120][i]))))
	_add_gfx_slider(v, "fov", "Campo de visão", 55.0, 95.0, 1.0, "%.0f°", 1.0)
	_add_gfx_slider(v, "brightness", "Brilho", 0.5, 2.0, 0.05, "%.0f%%", 100.0, "Clareia a imagem inteira (útil em monitores escuros e à noite).")
	v.add_child(UIKit.separator())
	_add_gfx_option(v, "texture_quality", "Qualidade das texturas", ["Baixa (256)", "Média (512)", "Alta (1024)", "Ultra (2048)"], "Requer reiniciar o jogo para regenerar as texturas.")
	_add_gfx_option(v, "shadow_quality", "Sombras", QUALITY)
	_add_gfx_slider(v, "view_distance", "Distância de visão", 200.0, 1400.0, 20.0, "%.0f m", 1.0)
	_add_gfx_slider(v, "object_distance", "Distância de objetos/detalhes", 0.5, 1.5, 0.05, "%.0f%%", 100.0)
	_add_gfx_option(v, "vegetation_quality", "Vegetação", QUALITY)
	_add_gfx_option(v, "particle_quality", "Partículas", QUALITY)
	_add_gfx_option(v, "post_processing", "Pós-processamento", ["Desligado", "Leve", "Médio", "Completo"])
	_add_gfx_option(v, "weather_quality", "Qualidade do clima", ["Baixa", "Média", "Alta", "Ultra"])
	_add_gfx_option(v, "reflection_quality", "Reflexos", ["Desligados", "Baixos", "Médios", "Altos"])
	_add_gfx_option(v, "antialiasing", "Antisserrilhado (MSAA)", ["Desligado", "2x", "4x", "8x"], "O renderer Compatibility suporta apenas MSAA.")
	_add_gfx_slider(v, "npc_density", "Densidade de sobreviventes", 0.3, 1.3, 0.05, "%.0f%%", 100.0)
	_add_gfx_slider(v, "infected_density", "Densidade de infectados", 0.3, 1.3, 0.05, "%.0f%%", 100.0)
	var oc := UIKit.check(bool(g["occlusion_culling"]), func(on: bool) -> void: _gset("occlusion_culling", on))
	_gfx_controls["occlusion_culling"] = oc
	v.add_child(UIKit.row("Occlusion culling", oc))
	v.add_child(UIKit.row("Mostrar FPS", UIKit.check(bool(g["show_fps"]), func(on: bool) -> void: _gset("show_fps", on))))
	_building = false


func _add_gfx_option(v: VBoxContainer, key: String, text: String, items: Array, tip: String = "") -> void:
	var o := UIKit.options(items, int(Settings.graphics[key]), func(i: int) -> void: _gset(key, i))
	_gfx_controls[key] = o
	v.add_child(UIKit.row(text, o, tip))


func _add_gfx_slider(v: VBoxContainer, key: String, text: String, a: float, b: float, step: float, fmt: String, mult: float, tip: String = "") -> void:
	var s := UIKit.slider(a, b, step, float(Settings.graphics[key]), func(x: float) -> void: _gset(key, x), fmt, mult)
	_gfx_controls[key] = s
	v.add_child(UIKit.row(text, s, tip))


func _gset(key: String, value: Variant) -> void:
	if _building:
		return
	Settings.set_graphics(key, value)
	var pi := int(Settings.graphics["preset"])
	_building = true
	(_gfx_controls["preset"] as OptionButton).select(pi if pi >= 0 else 5)
	_building = false


func _refresh_graphics() -> void:
	_building = true
	for key in _gfx_controls.keys():
		var c: Control = _gfx_controls[key]
		if key == "preset":
			continue
		if c is OptionButton:
			(c as OptionButton).select(int(Settings.graphics[key]))
		elif c is CheckButton:
			(c as CheckButton).button_pressed = bool(Settings.graphics[key])
		elif c is HBoxContainer:
			var s := c.get_child(0) as HSlider
			if s:
				s.value = float(Settings.graphics[key])
	_building = false


# ---------------------------------------------------------------------------
# Áudio
# ---------------------------------------------------------------------------
func _build_audio() -> void:
	var v := _scroll("Áudio")
	for pair: Array in [["master", "Volume geral"], ["music", "Música"], ["sfx", "Efeitos"], ["ambience", "Ambiente"], ["voice", "Vozes e gravações"], ["ui", "Interface"]]:
		var key: String = pair[0]
		v.add_child(UIKit.row(pair[1], UIKit.slider(0.0, 1.0, 0.01, float(Settings.audio[key]), func(x: float) -> void: Settings.set_audio(key, x))))
	v.add_child(UIKit.row("Legendas", UIKit.check(bool(Settings.audio["subtitles"]), func(on: bool) -> void: Settings.set_audio("subtitles", on))))


# ---------------------------------------------------------------------------
# Controles
# ---------------------------------------------------------------------------
func _build_controls() -> void:
	var v := _scroll("Controles")
	var c := Settings.controls
	v.add_child(UIKit.row("Sensibilidade do mouse", UIKit.slider(0.05, 0.8, 0.01, float(c["mouse_sensitivity"]), func(x: float) -> void: c["mouse_sensitivity"] = x, "%.2f", 1.0)))
	v.add_child(UIKit.row("Sensibilidade do gamepad", UIKit.slider(0.5, 6.0, 0.1, float(c["gamepad_sensitivity"]), func(x: float) -> void: c["gamepad_sensitivity"] = x, "%.1f", 1.0)))
	v.add_child(UIKit.row("Inverter eixo Y", UIKit.check(bool(c["invert_y"]), func(on: bool) -> void: c["invert_y"] = on)))
	v.add_child(UIKit.row("Correr: alternar (em vez de segurar)", UIKit.check(bool(c["toggle_sprint"]), func(on: bool) -> void: c["toggle_sprint"] = on)))
	v.add_child(UIKit.row("Agachar: alternar (em vez de segurar)", UIKit.check(bool(c["toggle_crouch"]), func(on: bool) -> void: c["toggle_crouch"] = on)))
	v.add_child(UIKit.row("Câmera em 1ª pessoa (V / R3 troca no jogo)", UIKit.check(str(c.get("camera_mode", "third")) == "first", func(on: bool) -> void:
		c["camera_mode"] = "first" if on else "third"
		var g: Node = SaveManager.game
		if g != null and is_instance_valid(g) and g.get("player") != null:
			var pc: PlayerCamera = g.player.cam_rig
			pc.first_person = on)))
	v.add_child(UIKit.separator())
	v.add_child(UIKit.section("Controle (PlayStation, Xbox e outros)"))
	var pad_name := Input.get_joy_name(Pad.device) if not Input.get_connected_joypads().is_empty() else "nenhum conectado"
	v.add_child(UIKit.label("Controle detectado: %s" % pad_name, 15, UITheme.TEXT_DIM))
	v.add_child(UIKit.row("Botões na tela", UIKit.options(["Automático", "PlayStation (✕ ○ □ △)", "Xbox (A B X Y)", "Nintendo"], int(c.get("pad_glyphs", 0)), func(i: int) -> void:
		c["pad_glyphs"] = i
		Pad.device_changed.emit(Pad.using_pad))))
	v.add_child(UIKit.row("Vibração", UIKit.slider(0.0, 1.0, 0.05, float(c.get("vibration", 1.0)), func(x: float) -> void:
		c["vibration"] = x
		if x > 0.0:
			Input.start_joy_vibration(Pad.device, 0.3 * x, 0.5 * x, 0.2))))
	v.add_child(UIKit.row("Inverter eixo Y do analógico", UIKit.check(bool(c.get("pad_invert_y", false)), func(on: bool) -> void: c["pad_invert_y"] = on)))
	v.add_child(UIKit.row("Zona morta do analógico", UIKit.slider(0.05, 0.35, 0.01, float(c.get("pad_deadzone", 0.15)), func(x: float) -> void: c["pad_deadzone"] = x)))
	v.add_child(UIKit.row("Assistência de mira (controle)", UIKit.check(bool(c.get("aim_assist", true)), func(on: bool) -> void: c["aim_assist"] = on)))
	v.add_child(_pad_layout())
	v.add_child(UIKit.separator())
	v.add_child(UIKit.section("Teclado e mouse"))
	v.add_child(UIKit.label("Clique numa ação e pressione a nova tecla (Esc cancela).", 15, UITheme.TEXT_DIM))
	var defs := InputSetup.defaults()
	for action in defs.keys():
		var d: Array = defs[action]
		if int(d[1]) < 0:
			continue
		var b := Button.new()
		b.text = InputSetup.code_to_text(InputSetup.current_code(action))
		b.custom_minimum_size = Vector2(200, 34)
		var act: String = action
		b.pressed.connect(func() -> void: _start_rebind(act, b))
		v.add_child(UIKit.row(str(d[0]), b))
	v.add_child(UIKit.button("Restaurar teclas padrão", func() -> void:
		Settings.reset_bindings()
		_rebuild_tab(2), 280))


## Esquema do controle: botão (desenhado no estilo do controle) + o que faz.
func _pad_layout() -> Control:
	var g := GridContainer.new()
	g.columns = 4
	g.add_theme_constant_override("h_separation", 10)
	g.add_theme_constant_override("v_separation", 6)
	for e in [["move_forward", "Andar"], ["look_up", "Câmera"], ["sprint", "Correr (clique)"], ["toggle_camera", "1ª / 3ª pessoa"],
			["jump", "Pular / escalar"], ["crouch", "Agachar"], ["interact", "Interagir (segurar: ações longas)"], ["pad_use", "Usar atalho (segurar: arremessar)"],
			["attack", "Atacar / atirar"], ["block", "Defender / mirar"], ["shove", "Empurrar"], ["dodge", "Esquivar"],
			["flashlight", "Lanterna / faróis"], ["quick_heal", "Cura rápida"], ["slot_prev", "Atalho anterior"], ["slot_next", "Próximo atalho"],
			["inventory", "Mochila"], ["map", "Mapa"], ["pause", "Pausa"], ["horn", "Buzina (no carro)"],
			["veh_throttle", "Acelerar (no carro)"], ["veh_brake", "Frear / ré (no carro)"], ["handbrake", "Freio de mão (no carro)"], ["ui_page_next", "Menus: trocar de tela"]]:
		var ip := InputPrompt.make(str(e[0]), 22)
		ip.set_meta("force_pad", true)
		g.add_child(ip)
		g.add_child(UIKit.label(str(e[1]), 14, UITheme.TEXT_DIM))
	return g


func _start_rebind(action: String, b: Button) -> void:
	_rebind_action = action
	_rebind_btn = b
	b.text = "Pressione uma tecla..."


func _input(event: InputEvent) -> void:
	if _rebind_action == "":
		if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
			get_viewport().set_input_as_handled()
			close()
		return
	var is_key: bool = event is InputEventKey and event.pressed and not event.echo
	var is_mouse: bool = event is InputEventMouseButton and event.pressed \
		and not ((event as InputEventMouseButton).button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN, MOUSE_BUTTON_WHEEL_LEFT, MOUSE_BUTTON_WHEEL_RIGHT])
	if is_key or is_mouse:
		get_viewport().set_input_as_handled()
		if event is InputEventKey and (event as InputEventKey).physical_keycode == KEY_ESCAPE:
			_rebind_btn.text = InputSetup.code_to_text(InputSetup.current_code(_rebind_action))
		else:
			var code := InputSetup.code_from_event(event)
			Settings.rebind(_rebind_action, code)
			_rebind_btn.text = InputSetup.code_to_text(code)
		_rebind_action = ""
		_rebind_btn = null


# ---------------------------------------------------------------------------
# Acessibilidade
# ---------------------------------------------------------------------------
func _build_accessibility() -> void:
	var v := _scroll("Acessibilidade")
	var a := Settings.accessibility
	v.add_child(UIKit.row("Tamanho das legendas", UIKit.options(["Pequeno", "Médio", "Grande", "Enorme"], int(a["subtitle_size"]), func(i: int) -> void: _aset("subtitle_size", i))))
	v.add_child(UIKit.row("Fundo das legendas", UIKit.check(bool(a["subtitle_background"]), func(on: bool) -> void: _aset("subtitle_background", on))))
	v.add_child(UIKit.row("Filtro para daltonismo", UIKit.options(["Nenhum", "Protanopia", "Deuteranopia", "Tritanopia"], int(a["colorblind_mode"]), func(i: int) -> void: _aset("colorblind_mode", i))))
	v.add_child(UIKit.row("Tremor de câmera", UIKit.slider(0.0, 1.0, 0.05, float(a["camera_shake"]), func(x: float) -> void: _aset("camera_shake", x))))
	v.add_child(UIKit.row("Balanço da câmera ao andar", UIKit.slider(0.0, 1.0, 0.05, float(a["head_bob"]), func(x: float) -> void: _aset("head_bob", x))))
	v.add_child(UIKit.row("Escala da interface", UIKit.slider(0.75, 1.5, 0.05, float(a["ui_scale"]), func(x: float) -> void:
		_aset("ui_scale", x)
		UITheme.apply_scale(get_tree()))))
	v.add_child(UIKit.row("HUD de alto contraste", UIKit.check(bool(a["high_contrast_hud"]), func(on: bool) -> void: _aset("high_contrast_hud", on))))
	v.add_child(UIKit.row("Reduzir clarões (relâmpagos, flashes)", UIKit.check(bool(a["reduce_flashing"]), func(on: bool) -> void: _aset("reduce_flashing", on))))


func _aset(key: String, value: Variant) -> void:
	Settings.accessibility[key] = value
	EventBus.settings_changed.emit()


# ---------------------------------------------------------------------------
# Jogo
# ---------------------------------------------------------------------------
func _build_gameplay() -> void:
	var v := _scroll("Jogo")
	var gp := Settings.gameplay
	v.add_child(UIKit.row("Dificuldade", UIKit.options(["Fácil", "Normal", "Difícil", "Sobrevivente"], int(gp["difficulty"]), func(i: int) -> void: _pset("difficulty", i)),
		"Afeta dano recebido, fome/sede, loot e resistência dos infectados."))
	v.add_child(UIKit.row("Salvamento automático", UIKit.options(["5 min", "8 min", "15 min", "Desligado"], [5.0, 8.0, 15.0, 9999.0].find(float(gp["autosave_minutes"])), func(i: int) -> void: _pset("autosave_minutes", [5.0, 8.0, 15.0, 9999.0][i]))))
	v.add_child(UIKit.row("Marcadores de objetivo", UIKit.check(bool(gp["show_objective_markers"]), func(on: bool) -> void: _pset("show_objective_markers", on))))
	v.add_child(UIKit.row("Pausar ao abrir inventário/mapa/diário", UIKit.check(bool(gp.get("pause_in_menus", true)), func(on: bool) -> void: _pset("pause_in_menus", on)),
		"Desligado: o mundo continua enquanto você mexe na mochila (mais tenso)."))
	v.add_child(UIKit.row("Duração do dia", UIKit.options(["24 min", "48 min", "72 min", "96 min"], [24.0, 48.0, 72.0, 96.0].find(float(gp["day_length_minutes"])), func(i: int) -> void: _pset("day_length_minutes", [24.0, 48.0, 72.0, 96.0][i]))))


func _pset(key: String, value: Variant) -> void:
	Settings.gameplay[key] = value
	EventBus.settings_changed.emit()


# ---------------------------------------------------------------------------
func _reset_tab() -> void:
	match tabs.current_tab:
		0:
			Settings.graphics["brightness"] = 1.0
			Settings.apply_preset(Settings.detect_preset())
			_refresh_graphics()
			_gset("preset", Settings.graphics["preset"])
		2:
			Settings.reset_bindings()
			_rebuild_tab(2)


func _rebuild_tab(i: int) -> void:
	var cur := tabs.current_tab
	for c in tabs.get_children():
		c.queue_free()
	await get_tree().process_frame
	_build_graphics()
	_build_audio()
	_build_controls()
	_build_accessibility()
	_build_gameplay()
	tabs.current_tab = cur


func close() -> void:
	Settings.save_settings()
	closed.emit()
	queue_free()
