class_name InventoryScreen
extends Control
## Inventário limitado (peso e espaços) em grade com ícones + contêiner aberto +
## equipamento + fabricação + condição. Clique seleciona; duplo clique/Enter faz
## a ação principal (usar/equipar, ou transferir quando há contêiner aberto);
## botão direito transfere/larga.

signal closed

const FILTERS := [
	["Tudo", "star", []],
	["Comida", "food", ["comida", "bebida"]],
	["Médico", "cross", ["medicamento"]],
	["Armas", "knife", ["arma", "arremesso", "municao"]],
	["Ferramentas", "wrench", ["ferramenta", "equipamento"]],
	["Materiais", "gear", ["material", "combustivel", "estrutura"]],
	["Outros", "document", ["historia", "diversos"]],
]

var player: Player
var game: Node
var other: Inventory = null
var other_title: String = ""
var other_source: Node = null
var station: String = ""
var start_tab: String = ""

var inv_grid: GridContainer
var other_grid: GridContainer
var inv_header: Label
var weight_bar: ProgressBar
var weight_label: Label
var slots_label: Label
var filter_row: HBoxContainer
var right_tabs: TabContainer
var other_header: Label
var detail_icon: UIGlyph
var detail_name: Label
var detail_cat: HBoxContainer
var detail_text: RichTextLabel
var actions: HFlowContainer
var equip_box: VBoxContainer
var status_box: VBoxContainer
var craft_cat: OptionButton
var craft_list: VBoxContainer
var craft_detail: RichTextLabel
var craft_icon: UIGlyph
var craft_btn: Button
var craft_bar: ProgressBar

var _filter: int = 0
var _sel_side: String = "inv"     # "inv" | "other"
var _sel_index: int = -1
var _craft_ids: Array = []
var _craft_sel: String = ""
var _crafting: String = ""
var _craft_t: float = 0.0
var _craft_total: float = 0.0
var _refresh_queued: bool = false


func _ready() -> void:
	theme = UITheme.game_theme()
	UIKit.full_rect(self)
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(UIKit.dim_bg(0.55))
	var win := UIKit.window(18)
	win.custom_minimum_size = Vector2(1420, 780)
	var wv := UIKit.vbox(12)
	win.add_child(wv)
	# cabeçalho: título, peso, espaços, dica
	var head := UIKit.header("backpack", "MOCHILA", "", "inventory", "Fechar")
	var meters := UIKit.vbox(3)
	meters.custom_minimum_size = Vector2(360, 0)
	meters.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var wl := UIKit.hbox(8)
	weight_label = UIKit.label("", 15)
	weight_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wl.add_child(weight_label)
	slots_label = UIKit.label("", 15, UITheme.TEXT_DIM, HORIZONTAL_ALIGNMENT_RIGHT)
	wl.add_child(slots_label)
	meters.add_child(wl)
	weight_bar = UIKit.bar(UITheme.GOOD, 1.0)
	weight_bar.custom_minimum_size = Vector2(360, 10)
	meters.add_child(weight_bar)
	head.add_child(meters)
	head.move_child(meters, 2)
	wv.add_child(head)
	wv.add_child(UIKit.separator())
	var root := UIKit.hbox(16)
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	wv.add_child(root)
	# --- esquerda: grade do jogador + detalhe ---
	var lv := UIKit.vbox(10)
	lv.custom_minimum_size = Vector2(640, 0)
	root.add_child(lv)
	filter_row = UIKit.hbox(6)
	lv.add_child(filter_row)
	for i in FILTERS.size():
		var fb := _filter_button(i)
		filter_row.add_child(fb)
	var sc := ScrollContainer.new()
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sc.custom_minimum_size = Vector2(640, 330)
	inv_grid = GridContainer.new()
	inv_grid.columns = 6
	inv_grid.add_theme_constant_override("h_separation", 8)
	inv_grid.add_theme_constant_override("v_separation", 8)
	sc.add_child(inv_grid)
	lv.add_child(sc)
	lv.add_child(_build_detail())
	# --- direita: abas ---
	right_tabs = TabContainer.new()
	right_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(right_tabs)
	_build_other()
	_build_equipment()
	_build_crafting()
	_build_status()
	wv.add_child(UIKit.pad_hints([["ui_accept", "Usar / equipar / transferir"], ["ui_secondary", "Mais ações"], ["ui_tertiary", "Atalho"],
		["ui_tab_prev", ""], ["ui_tab_next", "Abas"], ["ui_page_prev", ""], ["ui_page_next", "Mapa / Diário"], ["ui_cancel", "Fechar"]]))
	add_child(UIKit.center(win))
	if other == null:
		right_tabs.set_tab_hidden(0, true)
		right_tabs.current_tab = 1
	else:
		right_tabs.current_tab = 0
	if station != "" or start_tab == "crafting":
		right_tabs.current_tab = 2
	player.inventory.changed.connect(_queue_refresh)
	if other:
		other.changed.connect(_queue_refresh)
	EventBus.equipment_changed.connect(func(_s: String, _i: String) -> void: _queue_refresh())
	_refresh()
	_focus_first()
	EventBus.ui_screen_opened.emit("inventory")


func _filter_button(i: int) -> Button:
	var b := Button.new()
	b.toggle_mode = true
	b.button_pressed = i == _filter
	b.text = str(FILTERS[i][0])
	b.icon = null
	b.add_theme_font_size_override("font_size", 14)
	b.custom_minimum_size = Vector2(0, 32)
	b.focus_mode = Control.FOCUS_ALL
	b.pressed.connect(func() -> void:
		_filter = i
		for k in filter_row.get_child_count():
			(filter_row.get_child(k) as Button).button_pressed = k == i
		AudioManager.play_ui("ui_click", -10.0)
		_refresh())
	return b


func _build_detail() -> Control:
	var dp := UIKit.card(14)
	dp.custom_minimum_size = Vector2(640, 250)
	var h := UIKit.hbox(14)
	dp.add_child(h)
	detail_icon = UIGlyph.new()
	detail_icon.custom_minimum_size = Vector2(84, 84)
	detail_icon.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	h.add_child(detail_icon)
	var dv := UIKit.vbox(6)
	dv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(dv)
	var nh := UIKit.hbox(10)
	detail_name = UIKit.label("", 21, UITheme.ACCENT)
	nh.add_child(detail_name)
	detail_cat = UIKit.hbox(6)
	detail_cat.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	nh.add_child(detail_cat)
	dv.add_child(nh)
	detail_text = RichTextLabel.new()
	detail_text.bbcode_enabled = true
	detail_text.fit_content = false
	detail_text.custom_minimum_size = Vector2(500, 110)
	detail_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	detail_text.add_theme_font_size_override("normal_font_size", 15)
	dv.add_child(detail_text)
	actions = HFlowContainer.new()
	actions.add_theme_constant_override("h_separation", 6)
	actions.add_theme_constant_override("v_separation", 6)
	dv.add_child(actions)
	return dp


func _build_other() -> void:
	var v := UIKit.vbox(10)
	v.name = other_title if other_title != "" else "Contêiner"
	var hh := UIKit.hbox(10)
	other_header = UIKit.label("", 15, UITheme.TEXT_DIM)
	other_header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hh.add_child(other_header)
	hh.add_child(UIKit.button("Pegar tudo", _take_all, 180, 16))
	v.add_child(hh)
	var sc := ScrollContainer.new()
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	other_grid = GridContainer.new()
	other_grid.columns = 6
	other_grid.add_theme_constant_override("h_separation", 8)
	other_grid.add_theme_constant_override("v_separation", 8)
	sc.add_child(other_grid)
	v.add_child(sc)
	var tip := UIKit.hbox(6)
	tip.add_child(UIKit.label("Duplo clique ou", 13, UITheme.TEXT_DIM))
	tip.add_child(UIKit.keycap("Botão direito"))
	tip.add_child(UIKit.label("transfere entre a mochila e o contêiner.", 13, UITheme.TEXT_DIM))
	v.add_child(tip)
	right_tabs.add_child(v)


func _build_equipment() -> void:
	var sc := ScrollContainer.new()
	sc.name = "Equipamento"
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	equip_box = UIKit.vbox(10)
	equip_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(equip_box)
	right_tabs.add_child(sc)


func _build_crafting() -> void:
	var v := UIKit.vbox(10)
	v.name = "Fabricação"
	var h := UIKit.hbox(10)
	var cats := ["Todas"]
	cats.append_array(CraftingDB.CATEGORIES)
	craft_cat = UIKit.options(cats, 0, func(_i: int) -> void: _refresh_crafting())
	h.add_child(UIKit.label("Categoria", 15, UITheme.TEXT_DIM))
	h.add_child(craft_cat)
	var st := UIKit.chip("", UITheme.ACCENT, 14)
	st.name = "StationChip"
	h.add_child(st)
	v.add_child(h)
	var hh := UIKit.hbox(12)
	hh.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var sc := ScrollContainer.new()
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.custom_minimum_size = Vector2(330, 0)
	craft_list = UIKit.vbox(4)
	craft_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(craft_list)
	hh.add_child(sc)
	var dcard := UIKit.card(14)
	dcard.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var dv := UIKit.vbox(8)
	dcard.add_child(dv)
	craft_icon = UIGlyph.new()
	craft_icon.custom_minimum_size = Vector2(64, 64)
	craft_icon.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	dv.add_child(craft_icon)
	craft_detail = RichTextLabel.new()
	craft_detail.bbcode_enabled = true
	craft_detail.size_flags_vertical = Control.SIZE_EXPAND_FILL
	craft_detail.custom_minimum_size = Vector2(300, 300)
	craft_detail.add_theme_font_size_override("normal_font_size", 15)
	dv.add_child(craft_detail)
	craft_bar = UIKit.bar(UITheme.ACCENT, 1.0)
	craft_bar.custom_minimum_size = Vector2(300, 10)
	craft_bar.visible = false
	dv.add_child(craft_bar)
	craft_btn = UIKit.button("Fabricar", _start_craft, 240)
	dv.add_child(craft_btn)
	hh.add_child(dcard)
	v.add_child(hh)
	right_tabs.add_child(v)


func _build_status() -> void:
	var sc := ScrollContainer.new()
	sc.name = "Condição"
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	status_box = UIKit.vbox(8)
	status_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(status_box)
	right_tabs.add_child(sc)


# ---------------------------------------------------------------------------
# Atualização
# ---------------------------------------------------------------------------
func _queue_refresh() -> void:
	if _refresh_queued:
		return
	_refresh_queued = true
	(func() -> void:
		_refresh_queued = false
		_refresh()).call_deferred()


func _passes(id: String) -> bool:
	var cats: Array = FILTERS[_filter][2]
	return cats.is_empty() or ItemDB.category(id) in cats


func _fill(grid: GridContainer, inv: Inventory, side: String, pad_to_capacity: bool) -> void:
	for c in grid.get_children():
		grid.remove_child(c)
		c.queue_free()
	var shown := 0
	for i in inv.stacks.size():
		var s: Dictionary = inv.stacks[i]
		if side == "inv" and not _passes(str(s["id"])):
			continue
		var sl := ItemSlot.new()
		sl.set_stack(s, i)
		if side == "inv":
			sl.quick = player.quick_slots.find(str(s["id"]))
		sl.selected = _sel_side == side and _sel_index == i
		sl.picked.connect(func(x: ItemSlot) -> void: _select(side, x.index))
		sl.activated.connect(func(x: ItemSlot) -> void: _primary(side, x.index))
		sl.secondary.connect(func(x: ItemSlot) -> void: _secondary(side, x.index))
		sl.tertiary.connect(func(x: ItemSlot) -> void: _cycle_quick(side, x.index))
		grid.add_child(sl)
		shown += 1
	if pad_to_capacity and _filter == 0:
		for k in maxi(0, inv.max_slots - inv.stacks.size()):
			grid.add_child(ItemSlot.new())
	elif shown == 0:
		var l := UIKit.label("Nada aqui.", 15, UITheme.TEXT_DIM)
		grid.add_child(l)


func _refresh() -> void:
	if not is_inside_tree():
		return
	_fill(inv_grid, player.inventory, "inv", true)
	var w := player.inventory.total_weight()
	var frac := w / maxf(player.inventory.max_weight, 0.1)
	weight_label.text = "Peso  %.1f / %.1f kg" % [w, player.inventory.max_weight]
	slots_label.text = "Espaços %d / %d" % [player.inventory.stacks.size(), player.inventory.max_slots]
	weight_bar.value = minf(frac, 1.0)
	var wc := UITheme.GOOD if frac < 0.7 else (Color(0.95, 0.75, 0.3) if frac < 1.0 else UITheme.DANGER)
	weight_bar.add_theme_stylebox_override("fill", UITheme.box(wc, Color(0, 0, 0, 0), 0, 3))
	if other:
		_fill(other_grid, other, "other", false)
		other_header.text = "%s   ·   %.1f / %.1f kg   ·   %d / %d espaços" % [other_title, other.total_weight(), other.max_weight, other.stacks.size(), other.max_slots]
	_refresh_equipment()
	_refresh_crafting()
	_refresh_status()
	_refresh_detail()
	# a célula focada foi recriada: devolve o foco à selecionada (teclado/gamepad)
	if get_viewport().gui_get_focus_owner() == null:
		var grid := inv_grid if _sel_side == "inv" else other_grid
		for c in grid.get_children():
			if c is ItemSlot and (c as ItemSlot).index == _sel_index and not (c as ItemSlot).stack.is_empty():
				(c as Control).grab_focus.call_deferred()
				break


func _focus_first() -> void:
	for c in inv_grid.get_children():
		if c is ItemSlot and not (c as ItemSlot).stack.is_empty():
			(c as Control).grab_focus.call_deferred()
			return


func _refresh_equipment() -> void:
	for c in equip_box.get_children():
		c.queue_free()
	var names := {"weapon": ["Arma", "knife"], "back": ["Costas", "backpack"], "torso": ["Tronco", "jacket"], "hands": ["Mãos", "glove"],
		"head": ["Cabeça", "helmet"], "feet": ["Pés", "boot"], "light": ["Lanterna", "flashlight"]}
	var warmth := 0.0
	var armor := 0.0
	var rain := 0.0
	equip_box.add_child(UIKit.section("Equipado"))
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	equip_box.add_child(grid)
	for slot in names.keys():
		var s: Dictionary = player.equipment[slot]
		var card := UIKit.card(10, UITheme.ACCENT if not s.is_empty() else Color(0, 0, 0, 0))
		card.custom_minimum_size = Vector2(340, 78)
		var h := UIKit.hbox(10)
		card.add_child(h)
		var ic: UIGlyph
		if s.is_empty():
			ic = UIGlyph.make(str(names[slot][1]), 44, Color(0.35, 0.34, 0.31))
		else:
			ic = UIGlyph.for_item(str(s["id"]), 48)
		ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(ic)
		var v := UIKit.vbox(2)
		v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(v)
		v.add_child(UIKit.label(str(names[slot][0]).to_upper(), 12, UITheme.TEXT_DIM))
		if s.is_empty():
			v.add_child(UIKit.label("Vazio", 16, UITheme.TEXT_DIM))
		else:
			var def := ItemDB.get_item(str(s["id"]))
			warmth += float(def.get("warmth", 0.0))
			armor += float(def.get("armor", 0.0))
			rain += float(def.get("rain", 0.0))
			var nl := UIKit.label(ItemDB.item_name(str(s["id"])), 16)
			nl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			nl.custom_minimum_size = Vector2(150, 0)
			v.add_child(nl)
			var dd: Dictionary = s.get("data", {})
			if ItemDB.has_durability(str(s["id"])) or dd.has("battery"):
				var b := UIKit.bar(UITheme.ACCENT, 1.0)
				b.custom_minimum_size = Vector2(150, 6)
				b.value = float(dd["battery"]) / 100.0 if dd.has("battery") else float(s.get("cond", 1.0))
				v.add_child(b)
			var sl: String = slot
			var rb := UIKit.button("Remover", func() -> void: player.unequip(sl), 96, 13)
			rb.custom_minimum_size = Vector2(96, 32)
			rb.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			h.add_child(rb)
		grid.add_child(card)
	equip_box.add_child(UIKit.spacer(4))
	equip_box.add_child(UIKit.section("Proteção"))
	var pills := HFlowContainer.new()
	pills.add_theme_constant_override("h_separation", 8)
	pills.add_theme_constant_override("v_separation", 8)
	pills.add_child(UIKit.chip("Isolamento térmico  %d%%" % int(warmth * 100.0), Color(0.95, 0.6, 0.35), 15))
	pills.add_child(UIKit.chip("Proteção  %d%%" % int(armor * 100.0), Color(0.6, 0.7, 0.85), 15))
	pills.add_child(UIKit.chip("Chuva  %d%%" % int(rain * 100.0), UITheme.INFO, 15))
	pills.add_child(UIKit.chip("Carga total  %.1f kg" % player.carry_weight(), UITheme.TEXT_DIM, 15))
	equip_box.add_child(pills)


func _refresh_status() -> void:
	for c in status_box.get_children():
		c.queue_free()
	var s := player.survival
	status_box.add_child(UIKit.section("Sinais vitais"))
	var rows := [["heart", "Saúde", s.health, Color(0.82, 0.25, 0.22)], ["wind", "Fôlego", s.stamina / maxf(s.max_stamina(), 1.0) * 100.0, Color(0.85, 0.82, 0.7)],
		["food", "Fome", s.hunger, Color(0.88, 0.62, 0.28)], ["drop", "Sede", s.thirst, Color(0.35, 0.62, 0.92)],
		["bolt", "Energia", s.energy, Color(0.65, 0.55, 0.9)], ["mind", "Moral", s.morale, Color(0.55, 0.8, 0.6)]]
	for r in rows:
		var m := UIKit.meter(str(r[0]), str(r[1]), r[3], 300.0)
		(m[1] as ProgressBar).value = float(r[2])
		(m[2] as Label).text = "%d" % int(r[2])
		status_box.add_child(m[0])
	var th := UIKit.hbox(8)
	th.add_child(UIGlyph.make("thermo", 18, UITheme.INFO if s.body_temp < 35.8 else (UITheme.DANGER if s.body_temp > 37.8 else UITheme.TEXT)))
	var tl := UIKit.label("Temperatura", 15, UITheme.TEXT_DIM)
	tl.custom_minimum_size = Vector2(96, 0)
	th.add_child(tl)
	th.add_child(UIKit.label("%.1f °C" % s.body_temp, 15))
	status_box.add_child(th)
	status_box.add_child(UIKit.spacer(6))
	status_box.add_child(UIKit.section("Condições"))
	var conds := s.conditions()
	if conds.is_empty():
		var ok := UIKit.card(10, UITheme.GOOD)
		ok.add_child(UIKit.label("Nenhuma condição grave.", 15, UITheme.GOOD))
		status_box.add_child(ok)
	for c in conds:
		var col: Color = [Color(0.7, 0.7, 0.7), Color(0.95, 0.75, 0.35), UITheme.DANGER][clampi(int(c[2]), 0, 2)]
		var cc := UIKit.card(10, col)
		var cv := UIKit.vbox(2)
		cc.add_child(cv)
		cv.add_child(UIKit.label(str(c[1]), 16, col))
		var help := _cond_help(str(c[0]))
		if help != "":
			cv.add_child(UIKit.label("O que fazer: " + help, 14, UITheme.TEXT_DIM))
		status_box.add_child(cc)
	var wl := UIKit.label("Peso: %.1f/%.1f kg — acima do limite você fica lento e cansa mais." % [player.carry_weight(), player.inventory.max_weight], 14, UITheme.TEXT_DIM)
	wl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_box.add_child(wl)


func _cond_help(id: String) -> String:
	match id:
		"bleeding": return "use bandagem ou pano limpo."
		"fracture": return "use uma tala e evite correr."
		"infection": return "inibidor NX retarda. Procure ajuda."
		"wound_infection": return "antisséptico e antibióticos."
		"food_poisoning": return "descanse, beba água limpa, carvão ativado."
		"cold": return "aqueça-se, chá de ervas, descanse."
		"hypothermia": return "fogo, abrigo e roupas secas."
		"fever": return "antitérmico e água."
		"hunger": return "coma algo."
		"thirst": return "beba água limpa."
		"energy": return "durma numa cama ou descanse."
		"wet": return "fique perto de fogo ou abrigado."
		"pain": return "analgésicos."
		"overweight": return "largue ou guarde itens."
	return ""


func _select(side: String, i: int) -> void:
	if _sel_side == side and _sel_index == i:
		return
	_sel_side = side
	_sel_index = i
	for grid in [inv_grid, other_grid]:
		if grid == null:
			continue
		for c in grid.get_children():
			if c is ItemSlot:
				(c as ItemSlot).selected = (grid == inv_grid) == (side == "inv") and (c as ItemSlot).index == i
	_refresh_detail()


func _sel_stack() -> Dictionary:
	var inv := player.inventory if _sel_side == "inv" else other
	if inv == null or _sel_index < 0 or _sel_index >= inv.stacks.size():
		return {}
	return inv.stacks[_sel_index]


func _action(text: String, cb: Callable, primary: bool = false) -> void:
	var b := UIKit.button(text, cb, 0, 15)
	b.custom_minimum_size = Vector2(108, 36)
	if primary:
		b.add_theme_stylebox_override("normal", UITheme.box(Color(0.26, 0.21, 0.11, 0.96), UITheme.ACCENT, 1, 5, 12))
	actions.add_child(b)


func _refresh_detail() -> void:
	for c in actions.get_children():
		c.queue_free()
	for c in detail_cat.get_children():
		c.queue_free()
	var s := _sel_stack()
	if s.is_empty():
		detail_icon.item_id = ""
		detail_icon.glyph = "backpack"
		detail_icon.color = Color(0.3, 0.29, 0.27)
		detail_name.text = ""
		detail_text.text = "[color=#888888]Selecione um item para ver detalhes e ações.[/color]"
		return
	var id := str(s["id"])
	var def := ItemDB.get_item(id)
	detail_icon.item_id = id
	detail_name.text = ItemDB.item_name(id)
	detail_cat.add_child(UIKit.chip(str(ItemDB.CATS.get(ItemDB.category(id), "")), UIIcons.item_color(id)))
	var t := "%s\n" % str(def.get("desc", ""))
	var info: Array = ["%.2f kg" % ItemDB.weight(id), "valor %d" % int(ItemDB.value(id))]
	if int(s["qty"]) > 1:
		info.push_front("%d unidades" % int(s["qty"]))
	t += "[color=#9a988f]%s[/color]\n" % "  ·  ".join(info)
	if def.has("weapon"):
		var w: Dictionary = def["weapon"]
		t += "[color=#e0a070]Dano %d  ·  Velocidade %.1f  ·  Alcance %.1f m[/color]\n" % [int(w.get("dmg", 0)), float(w.get("speed", 1.0)), float(w.get("reach", 1.0))]
	if def.has("ranged"):
		var r: Dictionary = def["ranged"]
		t += "[color=#e0a070]Dano %d  ·  Munição: %s  ·  Ruído %d m[/color]\n" % [int(r.get("dmg", 0)), ItemDB.item_name(str(r.get("ammo", ""))), int(r.get("noise", 0))]
	if def.has("use"):
		var parts: Array = []
		var u: Dictionary = def["use"]
		var names := {"hunger": "Fome", "thirst": "Sede", "health": "Saúde", "energy": "Energia", "stamina": "Fôlego", "infection": "Infecção", "morale": "Moral", "pain": "Dor", "temp": "Calor"}
		for k in u.keys():
			if names.has(k):
				parts.append("%s %s%d" % [names[k], "+" if float(u[k]) > 0.0 else "", int(u[k])])
		if not parts.is_empty():
			t += "[color=#90c090]%s[/color]\n" % "  ·  ".join(parts)
	if ItemDB.has_durability(id):
		t += "[color=#aaaaaa]Condição: %d%%[/color]\n" % int(float(s.get("cond", 1.0)) * 100.0)
	if def.has("spoils"):
		t += "[color=#aaaaaa]Frescor: %d%%[/color]\n" % int(float(s.get("cond", 1.0)) * 100.0)
	var dd: Dictionary = s.get("data", {})
	if dd.has("battery"):
		t += "[color=#aaaaaa]Bateria: %d%%[/color]\n" % int(dd["battery"])
	if dd.has("fuel"):
		t += "[color=#aaaaaa]Combustível: %d L[/color]\n" % int(dd["fuel"])
	detail_text.text = t
	if _sel_side == "other":
		_action("Pegar", func() -> void: _transfer("other", _sel_index, -1), true)
		if int(s["qty"]) > 1:
			_action("Pegar 1", func() -> void: _transfer("other", _sel_index, 1))
		return
	if def.has("weapon") or def.has("ranged") or def.has("equip"):
		_action("Equipar", func() -> void: player.equip_from_inventory(_sel_index), true)
	elif def.has("use") or def.get("purifier", false) or id == "pilha":
		_action("Usar", func() -> void: _use(_sel_index), true)
	if def.has("place"):
		_action("Posicionar", func() -> void: _place(id))
	if other:
		_action("Guardar", func() -> void: _transfer("inv", _sel_index, -1))
	_action("Largar", func() -> void: player.drop_from_inventory(_sel_index))
	if int(s["qty"]) > 1:
		_action("Largar 1", func() -> void: player.drop_from_inventory(_sel_index, 1))
	var qs := OptionButton.new()
	qs.add_item("Atalho…", 0)
	for i in 4:
		qs.add_item("Atalho %d" % (i + 1), i + 1)
	qs.custom_minimum_size = Vector2(120, 36)
	qs.add_theme_font_size_override("font_size", 15)
	qs.item_selected.connect(func(k: int) -> void:
		if k > 0:
			for j in 4:
				if player.quick_slots[j] == id:
					player.quick_slots[j] = ""
			player.quick_slots[k - 1] = id
			_refresh())
	actions.add_child(qs)


func _primary(side: String, i: int) -> void:
	_sel_side = side
	_sel_index = i
	if other != null:
		_transfer(side, i, -1)
		return
	var s := _sel_stack()
	if s.is_empty():
		return
	var def := ItemDB.get_item(str(s["id"]))
	if def.has("weapon") or def.has("ranged") or def.has("equip"):
		player.equip_from_inventory(i)
	elif def.has("place"):
		_place(str(s["id"]))
	else:
		_use(i)


## Botão direito: transfere quando há contêiner; senão usa/equipa.
## No controle (□/X): leva o foco para os botões de ação do item.
func _secondary(side: String, i: int) -> void:
	if Pad.using_pad:
		_select(side, i)
		_focus_actions.call_deferred()
		return
	if other != null:
		_transfer(side, i, -1)
	else:
		_primary(side, i)


func _focus_actions() -> void:
	for c in actions.get_children():
		if c is Control and (c as Control).focus_mode == Control.FOCUS_ALL and not c.is_queued_for_deletion():
			(c as Control).grab_focus()
			return


func _focus_selected_slot() -> void:
	var grid := inv_grid if _sel_side == "inv" else other_grid
	for c in grid.get_children():
		if c is ItemSlot and (c as ItemSlot).index == _sel_index and not (c as ItemSlot).stack.is_empty():
			(c as Control).grab_focus()
			return
	_focus_first()


## △/Y no controle: põe o item no próximo atalho (1→2→3→4→nenhum).
func _cycle_quick(side: String, i: int) -> void:
	if side != "inv" or i < 0 or i >= player.inventory.stacks.size():
		return
	var id := str(player.inventory.stacks[i]["id"])
	var cur := player.quick_slots.find(id)
	for j in 4:
		if player.quick_slots[j] == id:
			player.quick_slots[j] = ""
	var nxt := cur + 1
	if nxt < 4:
		player.quick_slots[nxt] = id
		EventBus.toast("%s no atalho %d" % [ItemDB.item_name(id), nxt + 1], "info")
	else:
		EventBus.toast("%s fora dos atalhos" % ItemDB.item_name(id), "info")
	AudioManager.play_ui("ui_click", -8.0)
	_refresh()


func _use(i: int) -> void:
	player.use_item(i)
	# consumir exige a animação: fecha o inventário para o jogador ver
	var s := _sel_stack()
	if not s.is_empty() and ItemDB.get_item(str(s["id"])).has("use"):
		close()


func _place(id: String) -> void:
	close()
	if game and game.structures:
		game.structures.begin(id)


func _transfer(side: String, i: int, qty: int) -> void:
	var from := player.inventory if side == "inv" else other
	var to := other if side == "inv" else player.inventory
	if from == null or to == null:
		return
	var moved := from.transfer_to(to, i, qty)
	if moved <= 0:
		EventBus.toast("Não cabe.", "warn")
	else:
		AudioManager.play_ui("pickup", -8.0)
		if side == "other":
			var s: Dictionary = to.stacks.back() if not to.stacks.is_empty() else {}
			EventBus.item_picked.emit(str(s.get("id", "")), moved)
		if _sel_index >= from.stacks.size():
			_sel_index = from.stacks.size() - 1


func _take_all() -> void:
	if other == null:
		return
	var i := 0
	while i < other.stacks.size():
		var n := other.stacks.size()
		other.transfer_to(player.inventory, i, -1)
		if other.stacks.size() == n:
			i += 1
	EventBus.item_picked.emit("", 0)


# ---------------------------------------------------------------------------
# Fabricação
# ---------------------------------------------------------------------------
func _refresh_crafting() -> void:
	if craft_list == null:
		return
	var chip := craft_cat.get_parent().get_node("StationChip") as PanelContainer
	(chip.get_child(0) as Label).text = {"workbench": "Na bancada", "fire": "No fogo"}.get(station, "Sem estação — receitas básicas")
	var cat_i := craft_cat.selected
	var cat: String = "" if cat_i <= 0 else CraftingDB.CATEGORIES[cat_i - 1]
	for c in craft_list.get_children():
		craft_list.remove_child(c)
		c.queue_free()
	_craft_ids.clear()
	var ready_first: Array = []
	var rest: Array = []
	for id in CraftingDB.RECIPES.keys():
		var r: Dictionary = CraftingDB.RECIPES[id]
		if cat != "" and str(r["cat"]) != cat:
			continue
		if r.get("hidden", false) and not player.inventory.has("fragmento_1") and not player.inventory.has("fragmento_2") and not player.inventory.has("fragmento_3"):
			continue
		if Crafting.check(r, player, station)["ok"]:
			ready_first.append(id)
		else:
			rest.append(id)
	for id in ready_first + rest:
		var r: Dictionary = CraftingDB.RECIPES[id]
		var ok: bool = id in ready_first
		var b := Button.new()
		b.toggle_mode = true
		b.button_pressed = id == _craft_sel
		b.custom_minimum_size = Vector2(300, 46)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.text = "          " + str(r["name"])
		b.add_theme_font_size_override("font_size", 15)
		b.add_theme_color_override("font_color", UITheme.TEXT if ok else UITheme.TEXT_DIM)
		var ic: UIGlyph
		if r.has("result"):
			ic = UIGlyph.for_item(str((r["result"] as Array)[0]), 34)
			ic.dim = not ok
		else:
			ic = UIGlyph.make("wrench", 30, UITheme.ACCENT if ok else UITheme.TEXT_DIM)
		ic.position = Vector2(8, 6)
		b.add_child(ic)
		if ok:
			var ck := UIGlyph.make("check", 16, UITheme.GOOD)
			ck.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
			ck.position = Vector2(-26, -8)
			b.add_child(ck)
		var rid: String = id
		b.pressed.connect(func() -> void:
			# controle: ✕ de novo na receita já escolhida fabrica
			if Pad.using_pad and _craft_sel == rid:
				_start_craft()
				return
			_craft_sel = rid
			for k in craft_list.get_children():
				(k as Button).button_pressed = k == b
			_refresh_craft_detail())
		b.gui_input.connect(func(e: InputEvent) -> void:
			if e is InputEventMouseButton and (e as InputEventMouseButton).double_click:
				_craft_sel = rid
				_start_craft())
		craft_list.add_child(b)
		_craft_ids.append(id)
	if _craft_sel == "" or not _craft_sel in _craft_ids:
		_craft_sel = _craft_ids[0] if not _craft_ids.is_empty() else ""
		if craft_list.get_child_count() > 0:
			(craft_list.get_child(0) as Button).button_pressed = true
	_refresh_craft_detail()


func _refresh_craft_detail() -> void:
	if _craft_sel == "" or not CraftingDB.RECIPES.has(_craft_sel):
		craft_detail.text = "[color=#888888]Escolha uma receita.[/color]"
		craft_icon.item_id = ""
		craft_btn.disabled = true
		return
	var r: Dictionary = CraftingDB.RECIPES[_craft_sel]
	var c := Crafting.check(r, player, station)
	var t := "[font_size=20][color=#dcb86a]%s[/color][/font_size]\n" % r["name"]
	if r.has("result"):
		var res: Array = r["result"]
		craft_icon.item_id = str(res[0])
		t += "Resultado: [b]%s ×%d[/b]\n[color=#999999]%s[/color]\n\n" % [ItemDB.item_name(str(res[0])), int(res[1]), str(ItemDB.get_item(str(res[0])).get("desc", ""))]
	else:
		craft_icon.item_id = ""
		craft_icon.glyph = "wrench"
		craft_icon.color = UITheme.ACCENT
		t += "Reparo do equipamento (+%d%% de condição)\n\n" % int(float(r.get("amount", 0.4)) * 100.0)
	t += "[b]MATERIAIS[/b]\n"
	for e in r.get("in", []):
		var have := player.inventory.count(str(e[0]))
		var col := "#90c090" if have >= int(e[1]) else "#e05a4a"
		t += "[color=%s]%s  %s   %d/%d[/color]\n" % [col, "✔" if have >= int(e[1]) else "✖", ItemDB.item_name(str(e[0])), have, int(e[1])]
	if not (r.get("tools", []) as Array).is_empty():
		t += "\n[b]FERRAMENTAS[/b]\n"
		for tg in r["tools"]:
			var ok := player.has_tool(str(tg))
			t += "[color=%s]%s  %s[/color]\n" % ["#90c090" if ok else "#e05a4a", "✔" if ok else "✖", Crafting.tool_name(str(tg))]
	var need: String = r.get("station", "")
	if need != "":
		t += "\n[b]LOCAL[/b]\n[color=%s]%s  %s[/color]\n" % ["#90c090" if c["station_ok"] else "#e05a4a", "✔" if c["station_ok"] else "✖", "Bancada de trabalho" if need == "workbench" else "Fogueira ou fogão"]
	t += "\n[color=#999999]Tempo: %d s[/color]" % int(float(r.get("time", 3.0)))
	craft_detail.text = t
	craft_btn.disabled = not c["ok"] or _crafting != ""


func _start_craft() -> void:
	if _craft_sel == "" or _crafting != "":
		return
	var r: Dictionary = CraftingDB.RECIPES[_craft_sel]
	if not Crafting.check(r, player, station)["ok"]:
		return
	_crafting = _craft_sel
	_craft_total = float(r.get("time", 3.0))
	_craft_t = 0.0
	craft_bar.visible = true
	craft_btn.disabled = true
	AudioManager.play_ui("craft", -6.0)


func _process(delta: float) -> void:
	if _crafting == "":
		return
	_craft_t += delta
	craft_bar.value = _craft_t / maxf(_craft_total, 0.1)
	if _craft_t >= _craft_total:
		var id := _crafting
		_crafting = ""
		craft_bar.visible = false
		Crafting.craft(id, player, station)
		TimeManager.advance(_craft_total / 60.0 * 0.5)
		_refresh()


# ---------------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	# ○/B nos botões de ação volta para a grade (em vez de fechar)
	if event.is_action_pressed("ui_cancel") and event is InputEventJoypadButton:
		var fo := get_viewport().gui_get_focus_owner()
		if fo != null and actions.is_ancestor_of(fo):
			get_viewport().set_input_as_handled()
			_focus_selected_slot()
			return
	if event.is_action_pressed("inventory") or event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	if not is_inside_tree():
		return
	EventBus.ui_screen_closed.emit("inventory")
	closed.emit()
	queue_free()
