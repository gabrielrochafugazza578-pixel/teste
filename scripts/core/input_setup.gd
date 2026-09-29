class_name InputSetup
extends RefCounted
## Registro das ações de controle em runtime + remapeamento persistente.
##
## Cada ação tem uma tecla/botão padrão de teclado+mouse e um de gamepad.
## O remapeamento do jogador é salvo em user://settings.cfg (seção "controls").

const MOUSE_PREFIX := "mouse:"
const KEY_PREFIX := "key:"

## Gatilhos L2/R2 viram estes "botões" (ver PadInput): o eixo analógico sozinho
## dispara várias vezes por aperto.
const PAD_L2 := 100
const PAD_R2 := 101

## nome_ação -> [descrição, evento_padrão_teclado, botão_gamepad (ou -1), eixo_gamepad (Vector2i eixo,sinal ou null)]
## Layout do controle (nomes PlayStation / Xbox):
##   L: andar · L3: correr · R: câmera · R3: 1ª/3ª pessoa
##   ✕/A pular · ○/B agachar · □/X interagir (segurar = ações longas) · △/Y usar o atalho (segurar = arremessar)
##   R2/RT atacar · L2/LT defender/mirar · R1/RB empurrar · L1/LB esquivar
##   ↑ lanterna · ↓ cura rápida · ←/→ escolher atalho
##   Options/Menu pausa · Share/View mochila · Touchpad mapa
static func defaults() -> Dictionary:
	return {
		"move_forward": ["Andar para frente", KEY_W, -1, Vector2i(JOY_AXIS_LEFT_Y, -1)],
		"move_back": ["Andar para trás", KEY_S, -1, Vector2i(JOY_AXIS_LEFT_Y, 1)],
		"move_left": ["Andar para a esquerda", KEY_A, -1, Vector2i(JOY_AXIS_LEFT_X, -1)],
		"move_right": ["Andar para a direita", KEY_D, -1, Vector2i(JOY_AXIS_LEFT_X, 1)],
		"look_left": ["Câmera esquerda (controle)", -1, -1, Vector2i(JOY_AXIS_RIGHT_X, -1)],
		"look_right": ["Câmera direita (controle)", -1, -1, Vector2i(JOY_AXIS_RIGHT_X, 1)],
		"look_up": ["Câmera cima (controle)", -1, -1, Vector2i(JOY_AXIS_RIGHT_Y, -1)],
		"look_down": ["Câmera baixo (controle)", -1, -1, Vector2i(JOY_AXIS_RIGHT_Y, 1)],
		"sprint": ["Correr (sprint)", KEY_SHIFT, JOY_BUTTON_LEFT_STICK, null],
		"crouch": ["Agachar", KEY_C, JOY_BUTTON_B, null],
		"jump": ["Pular / Escalar / Transpor", KEY_SPACE, JOY_BUTTON_A, null],
		"interact": ["Interagir", KEY_E, JOY_BUTTON_X, null],
		"attack": ["Atacar (segurar: ataque pesado)", MOUSE_BUTTON_LEFT + 1000, PAD_R2, null],
		"block": ["Defender / Aparar / Mirar", MOUSE_BUTTON_RIGHT + 1000, PAD_L2, null],
		"dodge": ["Esquivar", KEY_Q, JOY_BUTTON_LEFT_SHOULDER, null],
		"shove": ["Empurrar", KEY_F, JOY_BUTTON_RIGHT_SHOULDER, null],
		"flashlight": ["Lanterna", KEY_L, JOY_BUTTON_DPAD_UP, null],
		"throw": ["Arremessar distração", KEY_G, -1, null],
		"quick_heal": ["Cura rápida", KEY_H, JOY_BUTTON_DPAD_DOWN, null],
		"slot_1": ["Atalho 1", KEY_1, -1, null],
		"slot_2": ["Atalho 2", KEY_2, -1, null],
		"slot_3": ["Atalho 3", KEY_3, -1, null],
		"slot_4": ["Atalho 4", KEY_4, -1, null],
		"slot_prev": ["Atalho anterior (controle)", -1, JOY_BUTTON_DPAD_LEFT, null],
		"slot_next": ["Próximo atalho (controle)", -1, JOY_BUTTON_DPAD_RIGHT, null],
		"pad_use": ["Usar atalho escolhido / segurar: arremessar (controle)", -1, JOY_BUTTON_Y, null],
		"toggle_camera": ["Câmera 1ª / 3ª pessoa", KEY_V, JOY_BUTTON_RIGHT_STICK, null],
		"inventory": ["Inventário / Fabricação", KEY_TAB, JOY_BUTTON_BACK, null],
		"map": ["Mapa", KEY_M, JOY_BUTTON_TOUCHPAD, null],
		"journal": ["Diário", KEY_J, -1, null],
		"free_cursor": ["Liberar o cursor do mouse (segurar)", KEY_ALT, -1, null],
		"pause": ["Pausa / Voltar", KEY_ESCAPE, JOY_BUTTON_START, null],
		"handbrake": ["Freio de mão (veículo)", KEY_SPACE, JOY_BUTTON_A, null],
		"horn": ["Buzina (veículo)", KEY_R, JOY_BUTTON_Y, null],
		"veh_throttle": ["Acelerar (veículo, controle)", -1, -1, Vector2i(JOY_AXIS_TRIGGER_RIGHT, 1)],
		"veh_brake": ["Frear / ré (veículo, controle)", -1, -1, Vector2i(JOY_AXIS_TRIGGER_LEFT, 1)],
		"skip": ["Pular cinemática (segurar)", KEY_ENTER, JOY_BUTTON_Y, null],
		"ui_tab_prev": ["Aba anterior (menus, controle)", -1, JOY_BUTTON_LEFT_SHOULDER, null],
		"ui_tab_next": ["Próxima aba (menus, controle)", -1, JOY_BUTTON_RIGHT_SHOULDER, null],
		"ui_page_prev": ["Tela anterior (menus, controle)", -1, PAD_L2, null],
		"ui_page_next": ["Próxima tela (menus, controle)", -1, PAD_R2, null],
		"ui_secondary": ["Ação secundária (menus, controle)", -1, JOY_BUTTON_X, null],
		"ui_tertiary": ["Ação extra (menus, controle)", -1, JOY_BUTTON_Y, null],
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
	# navegação dos menus: o analógico esquerdo é tratado pelo PadInput (com
	# repetição); aqui ficam só teclado e d-pad, sem o eixo que dispararia várias vezes
	for ui in ["ui_up", "ui_down", "ui_left", "ui_right"]:
		if InputMap.has_action(ui):
			for ev in InputMap.action_get_events(ui):
				if ev is InputEventJoypadMotion:
					InputMap.action_erase_event(ui, ev)
	for pair in [["ui_accept", JOY_BUTTON_A], ["ui_cancel", JOY_BUTTON_B]]:
		var has := false
		for ev in InputMap.action_get_events(pair[0]):
			if ev is InputEventJoypadButton and (ev as InputEventJoypadButton).button_index == int(pair[1]):
				has = true
		if not has:
			var jb := InputEventJoypadButton.new()
			jb.button_index = int(pair[1]) as JoyButton
			InputMap.action_add_event(pair[0], jb)


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


## Texto curto da tecla atual de uma ação ("Tab", "E", "Mouse Esq.").
static func key_text(action: String) -> String:
	return code_to_text(current_code(action))


static func current_code(action: String) -> int:
	if not InputMap.has_action(action):
		return -1
	for ev in InputMap.action_get_events(action):
		if ev is InputEventKey or ev is InputEventMouseButton:
			return code_from_event(ev)
	return -1


## Botão do controle ligado à ação: índice do botão, PAD_L2/PAD_R2 para os
## gatilhos, -10 - eixo para ações de analógico, ou -1.
static func pad_button(action: String) -> int:
	if action == "ui_accept":
		return JOY_BUTTON_A
	if action == "ui_cancel":
		return JOY_BUTTON_B
	if not InputMap.has_action(action):
		return -1
	for ev in InputMap.action_get_events(action):
		if ev is InputEventJoypadButton:
			return int((ev as InputEventJoypadButton).button_index)
	for ev in InputMap.action_get_events(action):
		if ev is InputEventJoypadMotion:
			return -10 - int((ev as InputEventJoypadMotion).axis)
	return -1


## Nome do botão no estilo do controle ("✕", "L2", "RT", "Share"...), para textos.
static func pad_text(action: String, style: String) -> String:
	var b := pad_button(action)
	return pad_button_text(b, style)


static func pad_button_text(b: int, style: String) -> String:
	var ps := style == "ps"
	var nin := style == "nintendo"
	match b:
		JOY_BUTTON_A: return "✕" if ps else ("B" if nin else "A")
		JOY_BUTTON_B: return "○" if ps else ("A" if nin else "B")
		JOY_BUTTON_X: return "□" if ps else ("Y" if nin else "X")
		JOY_BUTTON_Y: return "△" if ps else ("X" if nin else "Y")
		JOY_BUTTON_LEFT_SHOULDER: return "L1" if ps else ("L" if nin else "LB")
		JOY_BUTTON_RIGHT_SHOULDER: return "R1" if ps else ("R" if nin else "RB")
		PAD_L2: return "L2" if ps else ("ZL" if nin else "LT")
		PAD_R2: return "R2" if ps else ("ZR" if nin else "RT")
		JOY_BUTTON_LEFT_STICK: return "L3" if ps else "LS"
		JOY_BUTTON_RIGHT_STICK: return "R3" if ps else "RS"
		JOY_BUTTON_START: return "Options" if ps else ("+" if nin else "Menu")
		JOY_BUTTON_BACK: return "Share" if ps else ("−" if nin else "View")
		JOY_BUTTON_TOUCHPAD: return "Touchpad" if ps else ("Captura" if nin else "Share")
		JOY_BUTTON_DPAD_UP: return "↑"
		JOY_BUTTON_DPAD_DOWN: return "↓"
		JOY_BUTTON_DPAD_LEFT: return "←"
		JOY_BUTTON_DPAD_RIGHT: return "→"
	if b <= -10:
		var ax := -10 - b
		if ax == JOY_AXIS_TRIGGER_LEFT:
			return "L2" if ps else ("ZL" if nin else "LT")
		if ax == JOY_AXIS_TRIGGER_RIGHT:
			return "R2" if ps else ("ZR" if nin else "RT")
		return "L" if ax <= JOY_AXIS_LEFT_Y else "R"
	return "—"
