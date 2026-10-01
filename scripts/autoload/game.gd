extends Node
## Estado global: semente do mundo, controles e argumentos de linha de comando.
##
## Argumentos (depois de `--` na linha de comando) usados pela ferramenta de fotos:
##   --shot=arquivo.png   tira uma foto e fecha o jogo
##   --time=0.5           hora do dia (0 = meia-noite, 0.25 = amanhecer, 0.5 = meio-dia)
##   --pos=x,z  ou x,y,z  posicao do jogador
##   --look=yaw,pitch     direcao da camera em graus
##   --seed=N             semente do mundo

var world_seed: int = 20260930
var args: Dictionary = {}

# estado entre recarregamentos da cena
var started := false             # ja saiu do menu inicial?

# configuracoes (salvas em user://config.cfg)
var view_distance := 8
var mouse_sens := 1.0
var fullscreen := false
var outline := true

const CONFIG_PATH := "user://config.cfg"


func _ready() -> void:
	_parse_args()
	_setup_input()
	if not is_screenshot_mode() and not args.has("autotest"):
		load_config()
	if args.has("seed"):
		world_seed = int(args["seed"])


func load_config() -> void:
	var cf := ConfigFile.new()
	if cf.load(CONFIG_PATH) != OK:
		return
	view_distance = int(cf.get_value("video", "view_distance", view_distance))
	fullscreen = bool(cf.get_value("video", "fullscreen", fullscreen))
	outline = bool(cf.get_value("video", "outline", outline))
	mouse_sens = float(cf.get_value("controls", "mouse_sens", mouse_sens))
	world_seed = int(cf.get_value("world", "seed", world_seed))
	apply_fullscreen()


func save_config() -> void:
	var cf := ConfigFile.new()
	cf.set_value("video", "view_distance", view_distance)
	cf.set_value("video", "fullscreen", fullscreen)
	cf.set_value("video", "outline", outline)
	cf.set_value("controls", "mouse_sens", mouse_sens)
	cf.set_value("world", "seed", world_seed)
	cf.save(CONFIG_PATH)


func apply_fullscreen() -> void:
	if is_screenshot_mode():
		return
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)


func _parse_args() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--"):
			var kv := a.substr(2).split("=", true, 1)
			args[kv[0]] = kv[1] if kv.size() > 1 else "1"


func has_arg(arg_name: String) -> bool:
	return args.has(arg_name)


func arg(arg_name: String, default_value = null):
	return args.get(arg_name, default_value)


func arg_floats(arg_name: String) -> PackedFloat32Array:
	var out := PackedFloat32Array()
	if args.has(arg_name):
		for s in String(args[arg_name]).split(","):
			out.append(float(s))
	return out


func is_screenshot_mode() -> bool:
	return args.has("shot")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		fullscreen = not fullscreen
		apply_fullscreen()
		save_config()


func _setup_input() -> void:
	_add_keys("move_forward", [KEY_W, KEY_UP])
	_add_keys("move_back", [KEY_S, KEY_DOWN])
	_add_keys("move_left", [KEY_A, KEY_LEFT])
	_add_keys("move_right", [KEY_D, KEY_RIGHT])
	_add_keys("jump", [KEY_SPACE])
	_add_keys("sprint", [KEY_SHIFT])
	_add_keys("crouch", [KEY_CTRL, KEY_C])
	_add_keys("pause", [KEY_ESCAPE])
	_add_keys("toggle_fly", [KEY_F])
	_add_keys("toggle_creative", [KEY_G])
	_add_keys("toggle_fullscreen", [KEY_F11])
	for i in range(0, 10):
		_add_keys("slot_%d" % i, [KEY_0 + i])
	_add_mouse("attack", MOUSE_BUTTON_LEFT)
	_add_mouse("use", MOUSE_BUTTON_RIGHT)
	_add_mouse("next_slot", MOUSE_BUTTON_WHEEL_DOWN)
	_add_mouse("prev_slot", MOUSE_BUTTON_WHEEL_UP)


func _add_keys(action: String, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for k in keys:
		var ev := InputEventKey.new()
		ev.physical_keycode = k
		InputMap.action_add_event(action, ev)


func _add_mouse(action: String, button: MouseButton) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var ev := InputEventMouseButton.new()
	ev.button_index = button
	InputMap.action_add_event(action, ev)
