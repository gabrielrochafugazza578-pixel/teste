extends Node
## Controle (gamepad): descobre qual aparelho o jogador está usando (teclado/mouse
## ou controle, e se o controle é PlayStation, Xbox ou Nintendo) para a interface
## mostrar os botões certos, transforma os gatilhos L2/R2 em "botões" com
## histerese (o eixo analógico sozinho dispararia várias vezes), move o foco dos
## menus com o analógico esquerdo (com repetição ao segurar), rola listas com o
## analógico direito, esconde o cursor do mouse enquanto o controle navega e faz
## as vibrações.

signal device_changed(using_pad: bool)

## Botões virtuais (índices livres do SDL) que os gatilhos geram.
const BTN_L2 := 100
const BTN_R2 := 101
const TRIG_ON := 0.38
const TRIG_OFF := 0.18
const NAV_ON := 0.55
const NAV_OFF := 0.3
const REPEAT_DELAY := 0.38
const REPEAT_RATE := 0.085

var using_pad: bool = false
var style: String = "xbox"    # "ps" | "xbox" | "nintendo"
var device: int = 0
var _trig := [false, false]
var _nav_dir := Vector2i.ZERO
var _nav_t := 0.0
var _dpad_held := ""
var _dpad_t := 0.0


var _focus_chain: Array = []     # ancestrais (WeakRef) do último controle focado
var _focus_check: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	Input.joy_connection_changed.connect(_on_joy_changed)
	var pads := Input.get_connected_joypads()
	if not pads.is_empty():
		device = pads[0]
		style = detect_style(Input.get_joy_name(device))


func _on_joy_changed(dev: int, connected: bool) -> void:
	if connected:
		device = dev
		style = detect_style(Input.get_joy_name(dev))
		print("Controle conectado: %s (%s)" % [Input.get_joy_name(dev), style])
		if using_pad:
			device_changed.emit(true)
	elif using_pad and Input.get_connected_joypads().is_empty():
		_set_pad(false)


static func detect_style(name: String) -> String:
	var n := name.to_lower()
	for k in ["ps3", "ps4", "ps5", "playstation", "dualshock", "dualsense", "sony", "wireless controller"]:
		if n.contains(k):
			return "ps"
	for k in ["nintendo", "switch", "joy-con", "pro controller"]:
		if n.contains(k):
			return "nintendo"
	return "xbox"


## Estilo dos ícones: a opção "Botões na tela" das configurações manda; no automático
## segue o controle conectado.
func glyph_style() -> String:
	match int(Settings.controls.get("pad_glyphs", 0)):
		1: return "ps"
		2: return "xbox"
		3: return "nintendo"
	return style


func _set_pad(v: bool) -> void:
	if using_pad == v:
		return
	using_pad = v
	if v and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	elif not v and Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	device_changed.emit(v)


func ui_mode() -> bool:
	return Input.mouse_mode != Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if (event as InputEventJoypadButton).pressed:
			if event.device != device or not using_pad:
				device = event.device
				style = detect_style(Input.get_joy_name(device))
			_set_pad(true)
		# d-pad segurado nos menus repete a navegação
		var jb := event as InputEventJoypadButton
		var dname: String = {JOY_BUTTON_DPAD_UP: "ui_up", JOY_BUTTON_DPAD_DOWN: "ui_down", JOY_BUTTON_DPAD_LEFT: "ui_left", JOY_BUTTON_DPAD_RIGHT: "ui_right"}.get(jb.button_index, "")
		if dname != "":
			_dpad_held = dname if jb.pressed else ("" if _dpad_held == dname else _dpad_held)
			_dpad_t = REPEAT_DELAY
	elif event is InputEventJoypadMotion:
		var jm := event as InputEventJoypadMotion
		if absf(jm.axis_value) > 0.45:
			if jm.device != device or not using_pad:
				device = jm.device
				style = detect_style(Input.get_joy_name(device))
			_set_pad(true)
		if jm.axis == JOY_AXIS_TRIGGER_LEFT or jm.axis == JOY_AXIS_TRIGGER_RIGHT:
			var i := 0 if jm.axis == JOY_AXIS_TRIGGER_LEFT else 1
			var on: bool = _trig[i]
			if not on and jm.axis_value > TRIG_ON:
				_trig[i] = true
				_emit_button(BTN_L2 if i == 0 else BTN_R2, true, jm.device)
			elif on and jm.axis_value < TRIG_OFF:
				_trig[i] = false
				_emit_button(BTN_L2 if i == 0 else BTN_R2, false, jm.device)
	elif event is InputEventKey or event is InputEventMouseButton:
		if event.is_pressed():
			_set_pad(false)
	elif event is InputEventMouseMotion:
		if (event as InputEventMouseMotion).relative.length() > 3.0 and ui_mode():
			_set_pad(false)


func _emit_button(idx: int, pressed: bool, dev: int) -> void:
	var e := InputEventJoypadButton.new()
	e.button_index = idx as JoyButton
	e.pressed = pressed
	e.device = dev
	Input.parse_input_event(e)


func _emit_action(action: String) -> void:
	for p in [true, false]:
		var e := InputEventAction.new()
		e.action = action
		e.pressed = p
		Input.parse_input_event(e)


func _on_focus_changed(c: Control) -> void:
	_focus_chain.clear()
	var n: Node = c
	while n != null:
		_focus_chain.append(weakref(n))
		n = n.get_parent()


## Foco perdido (o controle focado foi recriado/escondido): devolve ao primeiro
## controle focável do ancestral mais próximo que ainda existe.
func _restore_focus() -> void:
	for w in _focus_chain:
		var n: Variant = (w as WeakRef).get_ref()
		if n == null or not (n is Control) or not (n as Control).is_visible_in_tree():
			continue
		var f := first_focusable(n as Control)
		if f:
			f.grab_focus()
			return
	var top := _topmost_screen()
	if top:
		var f2 := first_focusable(top)
		if f2:
			f2.grab_focus()


static func first_focusable(root: Control) -> Control:
	if root.focus_mode == Control.FOCUS_ALL and root.is_visible_in_tree() and not (root is BaseButton and (root as BaseButton).disabled):
		return root
	for ch in root.get_children():
		if ch is Control and (ch as Control).is_visible_in_tree():
			var f := first_focusable(ch as Control)
			if f:
				return f
	return null


## Tela visível mais em cima: a última com fundo escurecido (UIKit.dim_bg) ou,
## sem nenhuma, a raiz da interface com o último controle focável.
func _topmost_screen() -> Control:
	var best: Control = null
	var dimmed: Control = null
	var stack: Array = [get_tree().root]
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		var kids := n.get_children()
		kids.reverse()
		for ch in kids:
			stack.append(ch)
		if not (n is Control) or not (n as Control).is_visible_in_tree():
			continue
		if n.has_meta("screen_bg") and n.get_parent() is Control:
			dimmed = n.get_parent() as Control
		if (n as Control).focus_mode == Control.FOCUS_ALL:
			var p: Node = n
			while p.get_parent() != null and p.get_parent() is Control:
				p = p.get_parent()
			best = p as Control
	return dimmed if dimmed != null else best


## L1/R1: troca a aba do TabContainer que contém o foco (ou o visível mais em cima).
func _switch_tab(dir: int) -> void:
	var tc: TabContainer = null
	var n: Node = get_viewport().gui_get_focus_owner()
	while n != null:
		if n is TabContainer:
			tc = n
			break
		n = n.get_parent()
	if tc == null:
		var stack: Array = [get_tree().root]
		while not stack.is_empty():
			var m: Node = stack.pop_back()
			var kids := m.get_children()
			kids.reverse()
			for ch in kids:
				stack.append(ch)
			if m is TabContainer and (m as TabContainer).is_visible_in_tree():
				tc = m
	if tc == null or tc.get_tab_count() < 2:
		return
	var fo := get_viewport().gui_get_focus_owner()
	var was_inside := fo != null and tc.is_ancestor_of(fo)
	var i := tc.current_tab
	for _k in tc.get_tab_count():
		i = wrapi(i + dir, 0, tc.get_tab_count())
		if not tc.is_tab_hidden(i) and not tc.is_tab_disabled(i):
			break
	tc.current_tab = i
	AudioManager.play_ui("ui_click", -10.0)
	if was_inside or fo == null:
		var page := tc.get_current_tab_control()
		if page:
			var f := first_focusable(page)
			if f:
				f.grab_focus.call_deferred()


func _unhandled_input(event: InputEvent) -> void:
	if not ui_mode():
		return
	if event.is_action_pressed("ui_tab_next") or event.is_action_pressed("ui_tab_prev"):
		_switch_tab(1 if event.is_action_pressed("ui_tab_next") else -1)
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if not using_pad or not ui_mode():
		_nav_dir = Vector2i.ZERO
		_dpad_held = ""
		return
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	_focus_check -= delta
	if _focus_check <= 0.0:
		_focus_check = 0.15
		var fo := get_viewport().gui_get_focus_owner()
		if fo == null or not fo.is_visible_in_tree():
			_restore_focus()
		else:
			# uma tela nova abriu por cima (configurações sobre a pausa): o foco vai para ela
			var top := _topmost_screen()
			if top != null and not top.is_ancestor_of(fo) and top != fo:
				var f := first_focusable(top)
				if f:
					f.grab_focus()
	# analógico esquerdo -> navegação por foco (com repetição)
	var lx := Input.get_joy_axis(device, JOY_AXIS_LEFT_X)
	var ly := Input.get_joy_axis(device, JOY_AXIS_LEFT_Y)
	var d := Vector2i.ZERO
	var th_x := NAV_OFF if _nav_dir.x != 0 else NAV_ON
	var th_y := NAV_OFF if _nav_dir.y != 0 else NAV_ON
	if absf(lx) > absf(ly):
		if absf(lx) > th_x:
			d.x = 1 if lx > 0.0 else -1
	elif absf(ly) > th_y:
		d.y = 1 if ly > 0.0 else -1
	if d != _nav_dir:
		_nav_dir = d
		_nav_t = REPEAT_DELAY
		if d != Vector2i.ZERO and not _stick_consumed():
			_emit_action(_nav_name(d))
	elif d != Vector2i.ZERO:
		_nav_t -= delta
		if _nav_t <= 0.0:
			_nav_t = REPEAT_RATE
			if not _stick_consumed():
				_emit_action(_nav_name(d))
	if _dpad_held != "":
		_dpad_t -= delta
		if _dpad_t <= 0.0:
			_dpad_t = REPEAT_RATE
			_emit_action(_dpad_held)
	# analógico direito -> rola a lista/texto sob o foco
	var ry := Input.get_joy_axis(device, JOY_AXIS_RIGHT_Y)
	if absf(ry) > 0.2:
		var sc := _scroll_target()
		if sc:
			sc.scroll_vertical += int(ry * ry * signf(ry) * 1400.0 * delta)


## Algumas telas (mapa) usam o analógico para outra coisa.
func _stick_consumed() -> bool:
	var fo := get_viewport().gui_get_focus_owner()
	return fo != null and fo.has_meta("pad_stick")


func _nav_name(d: Vector2i) -> String:
	if d.x < 0:
		return "ui_left"
	if d.x > 0:
		return "ui_right"
	return "ui_up" if d.y < 0 else "ui_down"


func _scroll_target() -> ScrollContainer:
	var n: Node = get_viewport().gui_get_focus_owner()
	while n != null:
		if n is ScrollContainer and (n as ScrollContainer).is_visible_in_tree():
			return n
		if n.has_meta("pad_scroll"):
			var t: Variant = n.get_meta("pad_scroll")
			if t is ScrollContainer and is_instance_valid(t):
				return t
		n = n.get_parent()
	# nada focado dentro de uma lista: rola a primeira lista visível da tela de cima
	var top := _topmost_screen()
	var stack: Array = [top] if top else []
	while not stack.is_empty():
		var m: Node = stack.pop_back()
		if m is ScrollContainer and (m as ScrollContainer).is_visible_in_tree():
			var sc := m as ScrollContainer
			if sc.get_v_scroll_bar().max_value > sc.size.y + 4.0:
				return sc
		var kids := m.get_children()
		kids.reverse()
		for ch in kids:
			stack.append(ch)
	return null


## Vibração (respeita a opção "Vibração" das configurações).
func rumble(weak: float, strong: float, duration: float) -> void:
	if not using_pad:
		return
	var k := float(Settings.controls.get("vibration", 1.0))
	if k <= 0.0:
		return
	Input.start_joy_vibration(device, clampf(weak * k, 0.0, 1.0), clampf(strong * k, 0.0, 1.0), duration)
