class_name GameUI
extends CanvasLayer
## Raiz da interface no jogo: HUD, overlay da cinemática, filtro de
## acessibilidade, telas (inventário, mapa, diário, diálogo, troca, pausa,
## sono, leitura, morte) e atalhos globais. Cuida do mouse, da pausa e de
## devolver o controle ao jogador.

var game: Node
var player: Player
var hud: HUD
var cine: CinematicOverlay
var filter: ColorRect
var screens: Control
var debug: DebugOverlay = null
var current: Control = null
var _filter_mat: ShaderMaterial
var _photo: bool = false


func _ready() -> void:
	layer = 10
	process_mode = Node.PROCESS_MODE_ALWAYS
	filter = ColorRect.new()
	UIKit.full_rect(filter)
	filter.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_filter_mat = ShaderMaterial.new()
	_filter_mat.shader = Assets.shader("res://shaders/post_accessibility.gdshader")
	filter.material = _filter_mat
	add_child(filter)
	hud = HUD.new()
	add_child(hud)
	cine = CinematicOverlay.new()
	add_child(cine)
	screens = Control.new()
	UIKit.full_rect(screens)
	screens.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(screens)
	EventBus.container_ui_requested.connect(func(inv: Inventory, title: String, src: Node) -> void: open_inventory(inv, title, src, ""))
	EventBus.crafting_ui_requested.connect(func(station: String, _src: Node) -> void: open_inventory(null, "", null, station))
	EventBus.readable_opened.connect(_on_readable)
	EventBus.sleep_requested.connect(_on_sleep)
	EventBus.dialogue_requested.connect(_on_dialogue)
	EventBus.trade_requested.connect(_on_trade)
	EventBus.player_died.connect(_on_died)
	EventBus.settings_changed.connect(_update_filter)
	EventBus.hud_menu_requested.connect(_open_menu)
	_update_filter()


func bind(g: Node, p: Player) -> void:
	game = g
	player = p
	hud.bind(p, g)


func _update_filter() -> void:
	var mode := int(Settings.accessibility.get("colorblind_mode", 0))
	_filter_mat.set_shader_parameter("mode", mode)
	filter.visible = mode != 0 or (player != null and (player.survival.fever > 0.0 or player.survival.infection > 40.0))


func _process(_d: float) -> void:
	if player == null:
		return
	var s := player.survival
	var fever := clampf((s.body_temp - 37.6) / 2.0, 0.0, 1.0) + clampf((s.infection - 40.0) / 60.0, 0.0, 1.0) * 0.6
	var exh := clampf((20.0 - s.energy) / 20.0, 0.0, 1.0)
	_filter_mat.set_shader_parameter("fever", fever)
	_filter_mat.set_shader_parameter("exhaustion", exh)
	filter.visible = int(Settings.accessibility.get("colorblind_mode", 0)) != 0 or fever > 0.01 or exh > 0.01


# ---------------------------------------------------------------------------
# Atalhos globais
# ---------------------------------------------------------------------------
func _unhandled_input(event: InputEvent) -> void:
	if player == null or game == null:
		return
	if event.is_action_pressed("debug_overlay"):
		_toggle_debug()
		return
	if current != null and is_instance_valid(current):
		return
	if player.cinematic or player.survival.dead or game.transitioning:
		return
	if event.is_action_pressed("photo_mode"):
		_photo = not _photo
		EventBus.hud_visibility.emit(not _photo)
	elif event.is_action_pressed("pause"):
		if game.structures and game.structures.placing != "":
			return
		var pm := PauseMenu.new()
		pm.game = game
		open(pm, true)
	elif event.is_action_pressed("inventory"):
		_open_menu("inventory")
	elif event.is_action_pressed("map"):
		_open_menu("map")
	elif event.is_action_pressed("journal"):
		_open_menu("journal")
	elif event.is_action_pressed("quicksave"):
		if game.can_save():
			SaveManager.save_game("quick")
		else:
			EventBus.toast("Não é possível salvar agora.", "warn")
	elif event.is_action_pressed("quickload"):
		if SaveManager.has_slot("quick"):
			SaveManager.load_game("quick")


## Abre Mochila/Mapa/Diário (teclas ou botões do HUD).
func _open_menu(action: String) -> void:
	if player == null or game == null or is_screen_open():
		return
	if player.cinematic or player.survival.dead or game.transitioning:
		return
	match action:
		"inventory":
			open_inventory(null, "", null, "")
		"map":
			var m := MapScreen.new()
			m.game = game
			m.player = player
			open(m, _menu_pause())
		"journal":
			var j := JournalScreen.new()
			j.game = game
			open(j, _menu_pause())


## Segurar Alt libera o cursor (para clicar nos botões do HUD); soltar recaptura.
func _input(event: InputEvent) -> void:
	if player == null or is_screen_open() or player.cinematic or player.survival.dead:
		return
	if event.is_action_pressed("free_cursor"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_released("free_cursor") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _menu_pause() -> bool:
	return bool(Settings.gameplay.get("pause_in_menus", true))


func _toggle_debug() -> void:
	if debug and is_instance_valid(debug):
		debug.queue_free()
		debug = null
	else:
		debug = DebugOverlay.new()
		debug.game = game
		add_child(debug)


# ---------------------------------------------------------------------------
# Abertura de telas
# ---------------------------------------------------------------------------
func open(c: Control, pause: bool) -> void:
	if current != null and is_instance_valid(current):
		current.queue_free()
	current = c
	screens.add_child(c)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player.control_enabled = false
	player.cam_rig.input_enabled = false
	if pause:
		get_tree().paused = true
	c.tree_exited.connect(_on_screen_closed.bind(c))


func _on_screen_closed(c: Control) -> void:
	if current != c:
		return
	current = null
	if not is_inside_tree():
		return
	get_tree().paused = false
	if player and is_instance_valid(player) and not player.survival.dead and not player.cinematic:
		player.control_enabled = true
		player.cam_rig.input_enabled = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func is_screen_open() -> bool:
	return current != null and is_instance_valid(current)


func open_inventory(inv: Inventory, title: String, src: Node, station: String) -> void:
	if player.cinematic or player.survival.dead:
		return
	var s := InventoryScreen.new()
	s.player = player
	s.game = game
	s.other = inv
	s.other_title = title
	s.other_source = src
	s.station = station
	open(s, _menu_pause())


func _on_readable(title: String, text: String) -> void:
	var r := ReadableScreen.new()
	r.title_text = title
	r.body_text = text
	open(r, true)


func _on_sleep(src: Node) -> void:
	var d := SleepDialog.new()
	d.danger = game.director and game.director.threat > 0.25
	d.sleep_confirmed.connect(func(h: float) -> void: game.sleep(h, src))
	open(d, true)


func _on_dialogue(npc: Node) -> void:
	if not (npc is SurvivorNPC) or player.cinematic:
		return
	var d := DialogueScreen.new()
	d.npc = npc
	d.player = player
	d.manager = game.survivors
	open(d, false)
	game.focus_dialogue(npc)


func _on_trade(npc: Node) -> void:
	var sn := npc as SurvivorNPC
	if sn == null or sn.trade_inv == null:
		EventBus.toast("Não tem nada para trocar.", "info")
		return
	var t := TradeScreen.new()
	t.npc = sn
	t.player = player
	t.manager = game.survivors
	# a troca é aberta logo após o diálogo fechar
	(func() -> void: open(t, false)).call_deferred()


func _on_died(cause: String) -> void:
	await get_tree().create_timer(2.5).timeout
	if current and is_instance_valid(current):
		current.queue_free()
	var d := DeathScreen.new()
	d.cause = cause
	screens.add_child(d)
	current = d
