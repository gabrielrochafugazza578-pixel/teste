class_name SaveLoadMenu
extends Control
## Lista de slots de salvamento (carregar ou salvar), com capítulo, dia,
## hora, local e tempo de jogo.

signal closed

var mode: String = "load"   # "load" | "save"
var list: VBoxContainer


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	add_child(UIKit.dim_bg(0.6))
	var p := UIKit.panel(20)
	p.custom_minimum_size = Vector2(820, 560)
	var v := UIKit.vbox(10)
	p.add_child(v)
	v.add_child(UIKit.title("CARREGAR JOGO" if mode == "load" else "SALVAR JOGO", 28))
	var sc := ScrollContainer.new()
	sc.custom_minimum_size = Vector2(780, 440)
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	list = UIKit.vbox(6)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(list)
	v.add_child(sc)
	var h := UIKit.hbox(10)
	h.alignment = BoxContainer.ALIGNMENT_END
	h.add_child(UIKit.button("Voltar", close, 200))
	v.add_child(h)
	add_child(UIKit.center(p))
	_refresh()


func _refresh() -> void:
	for c in list.get_children():
		c.queue_free()
	for slot in SaveManager.SLOTS:
		if mode == "save" and slot == "auto":
			continue
		var meta := SaveManager.read_meta(slot)
		var row := UIKit.hbox(10)
		var info := UIKit.vbox(2)
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info.add_child(UIKit.label(SaveManager.slot_label(slot), 19, UITheme.ACCENT))
		if meta.is_empty():
			info.add_child(UIKit.label("— vazio —", 15, UITheme.TEXT_DIM))
		else:
			var pt := float(meta.get("playtime", 0.0))
			info.add_child(UIKit.label("Capítulo %d — %s  ·  Dia %d, %s  ·  %s" % [int(meta.get("chapter", 1)), str(meta.get("chapter_title", "")),
				int(meta.get("day", 1)), Util.format_time(float(meta.get("hour", 8.0))), str(meta.get("location", ""))], 15))
			info.add_child(UIKit.label("Salvo em %s  ·  Tempo de jogo %dh%02d" % [str(meta.get("time", "")), int(pt / 3600.0), int(fmod(pt / 60.0, 60.0))], 13, UITheme.TEXT_DIM))
		row.add_child(info)
		var s: String = slot
		if mode == "load":
			var b := UIKit.button("Carregar", func() -> void: _load(s), 140)
			b.disabled = meta.is_empty()
			row.add_child(b)
		else:
			row.add_child(UIKit.button("Salvar aqui", func() -> void: _save(s), 140))
		if not meta.is_empty():
			row.add_child(UIKit.button("Apagar", func() -> void:
				SaveManager.delete_slot(s)
				_refresh(), 110))
		var pc := UIKit.panel(10)
		pc.add_child(row)
		list.add_child(pc)


func _load(slot: String) -> void:
	get_tree().paused = false
	SaveManager.load_game(slot)


func _save(slot: String) -> void:
	if SaveManager.save_game(slot):
		_refresh()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	closed.emit()
	queue_free()
