class_name InputSetup
extends RefCounted
## Registro das ações de controle em runtime + remapeamento persistente.
##
## Cada ação tem uma tecla/botão padrão de teclado+mouse e um de gamepad.
## O remapeamento do jogador é salvo em user://settings.cfg (seção "controls").

const MOUSE_PREFIX := "mouse:"
const KEY_PREFIX := "key:"

## nome_ação -> [descrição, evento_padrão_teclado, botão_gamepad (ou -1), eixo_gamepad (Vector2i eixo,sinal ou null)]
static func defaults() -> Dictionary:
	return {
		"move_forward": ["Andar para frente", KEY_W, -1, Vector2i(JOY_AXIS_LEFT_Y, -1)],
		"move_back": ["Andar para trás", KEY_S, -1, Vector2i(JOY_AXIS_LEFT_Y, 1)],
		"move_left": ["Andar para a esquerda", KEY_A, -1, Vector2i(JOY_AXIS_LEFT_X, -1)],
		"move_right": ["Andar para a direita", KEY_D, -1, Vector2i(JOY_AXIS_LEFT_X, 1)],
		"look_left": ["Câmera esquerda (gamepad)", -1, -1, Vector2i(JOY_AXIS_RIGHT_X, -1)],
		"look_right": ["Câmera direita (gamepad)", -1, -1, Vector2i(JOY_AXIS_RIGHT_X, 1)],
		"look_up": ["Câmera cima (gamepad)", -1, -1, Vector2i(JOY_AXIS_RIGHT_Y, -1)],
		"look_down": ["Câmera baixo (gamepad)", -1, -1, Vector2i(JOY_AXIS_RIGHT_Y, 1)],
		"sprint": ["Correr (sprint)", KEY_SHIFT, JOY_BUTTON_LEFT_STICK, null],
		"crouch": ["Agachar", KEY_C, JOY_BUTTON_RIGHT_STICK, null],
		"jump": ["Pular / Escalar / Transpor", KEY_SPACE, JOY_BUTTON_A, null],
		"interact": ["Interagir", KEY_E, JOY_BUTTON_X, null],
		"attack": ["Atacar (segurar: ataque pesado)", MOUSE_BUTTON_LEFT + 1000, -1, Vector2i(JOY_AXIS_TRIGGER_RIGHT, 1)],
		"block": ["Defender / Aparar", MOUSE_BUTTON_RIGHT + 1000, -1, Vector2i(JOY_AXIS_TRIGGER_LEFT, 1)],
		"dodge": ["Esquivar", KEY_Q, JOY_BUTTON_B, null],
		"shove": ["Empurrar", KEY_F, JOY_BUTTON_RIGHT_SHOULDER, null],
		"flashlight": ["Lanterna", KEY_L, JOY_BUTTON_DPAD_UP, null],
		"throw": ["Arremessar distração", KEY_G, JOY_BUTTON_LEFT_SHOULDER, null],
		"quick_heal": ["Cura rápida", KEY_H, JOY_BUTTON_DPAD_DOWN, null],
		"slot_1": ["Atalho 1", KEY_1, -1, null],
		"slot_2": ["Atalho 2", KEY_2, -1, null],
		"slot_3": ["Atalho 3", KEY_3, -1, null],
		"slot_4": ["Atalho 4", KEY_4, -1, null],
		"inventory": ["Inventário / Fabricação", KEY_TAB, JOY_BUTTON_BACK, null],
		"map": ["Mapa", KEY_M, -1, null],
		"journal": ["Diário", KEY_J, -1, null],
		"pause": ["Pausa / Voltar", KEY_ESCAPE, JOY_BUTTON_START, null],
		"handbrake": ["Freio de mão (veículo)", KEY_SPACE, JOY_BUTTON_A, null],
		"horn": ["Buzina (veículo)", KEY_R, JOY_BUTTON_Y, null],
		"skip": ["Pular cinemática (segurar)", KEY_ENTER, JOY_BUTTON_Y, null],
		"quicksave": ["Salvamento rápido", KEY_F5, -1, null],
		"quickload": ["Carregamento rápido", KEY_F9, -1, null],
		"debug_overlay": ["Painel de desempenho", KEY_F3, -1, null],
		"photo_mode": ["Esconder interface", KEY_F1, -1, null],
	}


static func register_all(overrides: Dictionary) -> void:
	var defs := defaults()
	for action in defs.keys():
		var d: Array = defs[action]
		if InputMap.has_action(action):
			InputMap.erase_action(action)
		InputMap.add_action(action, 0.25)
		var primary = overrides.get(action, d[1])
		var ev := event_from_code(int(primary))
		if ev != null:
			InputMap.action_add_event(action, ev)
		if int(d[2]) >= 0:
			var jb := InputEventJoypadButton.new()
			jb.button_index = int(d[2])
			InputMap.action_add_event(action, jb)
		if d[3] != null:
			var ax := InputEventJoypadMotion.new()
			var v: Vector2i = d[3]
			ax.axis = v.x
			ax.axis_value = float(v.y)
			InputMap.action_add_event(action, ax)


## Códigos >= 1000 representam botões do mouse (1000 + MouseButton).
static func event_from_code(code: int) -> InputEvent:
	if code < 0:
		return null
	if code >= 1000 and code < 1100:
		var mb := InputEventMouseButton.new()
		mb.button_index = code - 1000
		return mb
	var k := InputEventKey.new()
	k.physical_keycode = code
	return k


static func code_from_event(ev: InputEvent) -> int:
	if ev is InputEventMouseButton:
		return 1000 + (ev as InputEventMouseButton).button_index
	if ev is InputEventKey:
		var k := ev as InputEventKey
		return int(k.physical_keycode) if k.physical_keycode != 0 else int(k.keycode)
	return -1


static func code_to_text(code: int) -> String:
	if code < 0:
		return "—"
	if code >= 1000 and code < 1100:
		match code - 1000:
			MOUSE_BUTTON_LEFT: return "Mouse Esq."
			MOUSE_BUTTON_RIGHT: return "Mouse Dir."
			MOUSE_BUTTON_MIDDLE: return "Mouse Meio"
			MOUSE_BUTTON_XBUTTON1: return "Mouse 4"
			MOUSE_BUTTON_XBUTTON2: return "Mouse 5"
			_: return "Mouse %d" % (code - 1000)
	return OS.get_keycode_string(code)


static func current_code(action: String) -> int:
	if not InputMap.has_action(action):
		return -1
	for ev in InputMap.action_get_events(action):
		if ev is InputEventKey or ev is InputEventMouseButton:
			return code_from_event(ev)
	return -1
