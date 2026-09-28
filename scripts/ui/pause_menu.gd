class_name PauseMenu
extends Control
## Pausa: continuar, salvar, carregar, configurações, menu principal, sair.

signal closed

var game: Node
var _sub: Control = null
var _box: VBoxContainer


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(UIKit.dim_bg(0.65))
	var p := UIKit.panel(24)
	_box = UIKit.vbox(8)
	p.add_child(_box)
	_box.add_child(UIKit.title("PAUSA", 30))
	var m := MissionManager.tracked
	if m != "":
		_box.add_child(UIKit.label(str(MissionDB.get_mission(m).get("title", "")), 15, UITheme.TEXT_DIM))
	_box.add_child(UIKit.label("Dia %d · %s · %s" % [TimeManager.day, Util.format_time(TimeManager.hour), game.location_name() if game else ""], 14, UITheme.TEXT_DIM))
	_box.add_child(UIKit.spacer(10))
	_box.add_child(UIKit.button("Continuar", close))
	var sb := UIKit.button("Salvar jogo", _save)
	sb.disabled = game == null or not game.can_save()
	sb.tooltip_text = "" if not sb.disabled else "Não é possível salvar agora (combate, veículo em movimento ou cinemática)."
	_box.add_child(sb)
	_box.add_child(UIKit.button("Carregar jogo", _load))
	_box.add_child(UIKit.button("Configurações", func() -> void: _open(SettingsMenu.new())))
	_box.add_child(UIKit.button("Controles e dicas", _help))
	_box.add_child(UIKit.button("Menu principal", _to_menu))
	_box.add_child(UIKit.button("Sair do jogo", func() -> void: get_tree().quit()))
	add_child(UIKit.center(p))
	(_box.get_child(3) as Control).grab_focus.call_deferred()
	AudioManager.play_ui("ui_open", -6.0)


func _save() -> void:
	var s := SaveLoadMenu.new()
	s.mode = "save"
	_open(s)


func _load() -> void:
	var s := SaveLoadMenu.new()
	s.mode = "load"
	_open(s)


func _help() -> void:
	var r := ReadableScreen.new()
	r.title_text = "Controles e dicas"
	var t := ""
	var defs := InputSetup.defaults()
	for a in defs.keys():
		if int(defs[a][1]) >= 0:
			t += "%s — %s\n" % [InputSetup.code_to_text(InputSetup.current_code(a)), defs[a][0]]
	t += "\nSegure [E] em portas trancadas, carros e contêineres para ações longas.\nArraste itens com clique duplo no inventário.\nCama: dormir e salvar."
	r.body_text = t
	_open(r)


func _open(c: Control) -> void:
	_sub = c
	_box.get_parent().visible = false
	add_child(c)
	c.tree_exited.connect(func() -> void:
		if is_inside_tree():
			_box.get_parent().visible = true
			_sub = null)


func _to_menu() -> void:
	var d := ConfirmationDialog.new()
	d.dialog_text = "Voltar ao menu principal? O progresso desde o último salvamento será perdido."
	d.ok_button_text = "Sim"
	d.cancel_button_text = "Não"
	d.theme = UITheme.get_theme()
	d.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(d)
	d.confirmed.connect(func() -> void:
		get_tree().paused = false
		GameState.in_game = false
		AudioManager.stop_all_loops()
		get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn"))
	d.popup_centered(Vector2i(560, 180))


func _input(event: InputEvent) -> void:
	if _sub != null and is_instance_valid(_sub):
		return
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	if not is_inside_tree():
		return
	AudioManager.play_ui("ui_close", -6.0)
	closed.emit()
	queue_free()
