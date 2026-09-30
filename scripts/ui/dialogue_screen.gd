class_name DialogueScreen
extends Control
## Diálogo com sobreviventes: nome, texto com efeito de digitação e opções
## (clique ou teclas 1–4). A câmera enquadra o NPC (Game cuida disso).

signal closed

var npc: SurvivorNPC
var player: Player
var manager: SurvivorManager
var runner: DialogueRunner
var name_label: Label
var text_label: RichTextLabel
var opts_box: VBoxContainer
var _chars: float = 0.0
var _full: int = 0
var _opts: Array = []


func _ready() -> void:
	theme = UITheme.game_theme()
	UIKit.full_rect(self)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	# faixa escura na base (cinema) para o texto ler bem sobre qualquer cena
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.35)
	shade.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	shade.offset_top = -380
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	var p := UIKit.window(20)
	p.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	p.custom_minimum_size = Vector2(1040, 0)
	p.position = Vector2(-520, -340)
	var v := UIKit.vbox(10)
	p.add_child(v)
	var nh := UIKit.hbox(10)
	nh.add_child(UIGlyph.make("people", 26, UITheme.ACCENT))
	name_label = UIKit.label(npc.display_name, 22, UITheme.ACCENT)
	nh.add_child(name_label)
	if npc.faction != "":
		var fc := UIKit.chip(FactionManager.faction_name(npc.faction), Color(0.7, 0.65, 0.9), 13)
		fc.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		nh.add_child(fc)
	var att := npc.attitude()
	var ac := UIKit.chip({"friendly": "Amigável", "neutral": "Neutro", "wary": "Desconfiado", "hostile": "Hostil"}.get(att, att),
		UITheme.GOOD if att == "friendly" else (UITheme.DANGER if att in ["wary", "hostile"] else UITheme.TEXT_DIM), 13)
	ac.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	nh.add_child(ac)
	v.add_child(nh)
	text_label = RichTextLabel.new()
	text_label.bbcode_enabled = true
	text_label.fit_content = true
	text_label.custom_minimum_size = Vector2(1000, 70)
	text_label.add_theme_font_size_override("normal_font_size", 20)
	v.add_child(text_label)
	v.add_child(UIKit.separator())
	opts_box = UIKit.vbox(6)
	v.add_child(opts_box)
	add_child(p)
	runner = DialogueRunner.new(npc, player, manager)
	runner.node_changed.connect(_on_node)
	runner.finished.connect(close)
	runner.trade_opened.connect(func(n: SurvivorNPC) -> void: EventBus.trade_requested.emit(n))
	runner.start()
	EventBus.ui_screen_opened.emit("dialogue")


func _on_node(text: String, options: Array) -> void:
	text_label.text = text
	_full = text.length()
	_chars = 0.0
	text_label.visible_characters = 0
	_opts = options
	for c in opts_box.get_children():
		c.queue_free()
	for i in options.size():
		var o: Dictionary = options[i]
		var idx := i
		var b := UIKit.button("        " + str(o["t"]), func() -> void: runner.choose(idx), 1000, 17)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		var kc := UIKit.keycap(str(i + 1), 13)
		kc.position = Vector2(10, 9)
		b.add_child(kc)
		opts_box.add_child(b)
	if opts_box.get_child_count() > 0:
		(opts_box.get_child(0) as Control).grab_focus.call_deferred()
	EventBus.subtitle.emit("", "", 0.0)


func _process(delta: float) -> void:
	if _chars < _full:
		_chars += delta * 55.0
		text_label.visible_characters = int(_chars)
	if npc == null or not is_instance_valid(npc) or not npc.is_alive():
		close()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var k := (event as InputEventKey).physical_keycode
		if k >= KEY_1 and k <= KEY_9:
			var i := int(k - KEY_1)
			if i < _opts.size():
				get_viewport().set_input_as_handled()
				runner.choose(i)
				return
		if (event.is_action_pressed("interact") or event.is_action_pressed("ui_accept")) and _chars < _full:
			get_viewport().set_input_as_handled()
			_chars = _full
			text_label.visible_characters = -1
			return
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		runner.end()


func close() -> void:
	if not is_inside_tree():
		return
	EventBus.ui_screen_closed.emit("dialogue")
	closed.emit()
	queue_free()
