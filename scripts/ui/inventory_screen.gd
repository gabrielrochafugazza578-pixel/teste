class_name InventoryScreen
extends Control
## Inventário limitado (peso e espaços) + contêiner aberto + equipamento +
## fabricação + estado de saúde. Clique duplo: ação principal (usar/equipar,
## ou transferir quando há contêiner aberto).

signal closed

var player: Player
var game: Node
var other: Inventory = null
var other_title: String = ""
var other_source: Node = null
var station: String = ""
var start_tab: String = ""

var inv_list: ItemList
var inv_header: Label
var weight_bar: ProgressBar
var right_tabs: TabContainer
var other_list: ItemList
var other_header: Label
var detail_name: Label
var detail_text: RichTextLabel
var actions: HBoxContainer
var equip_box: VBoxContainer
var status_text: RichTextLabel
var craft_cat: OptionButton
var craft_list: ItemList
var craft_detail: RichTextLabel
var craft_btn: Button
var craft_bar: ProgressBar

var _sel_side: String = "inv"     # "inv" | "other"
var _sel_index: int = -1
var _craft_ids: Array = []
var _crafting: String = ""
var _craft_t: float = 0.0
var _craft_total: float = 0.0


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(UIKit.dim_bg(0.5))
	var root := UIKit.hbox(14)
	root.custom_minimum_size = Vector2(1320, 700)
	# --- esquerda: inventário do jogador ---
	var left := UIKit.panel(16)
	left.custom_minimum_size = Vector2(520, 700)
	var lv := UIKit.vbox(8)
	left.add_child(lv)
	lv.add_child(UIKit.title("MOCHILA", 24))
	inv_header = UIKit.label("", 15, UITheme.TEXT_DIM)
	lv.add_child(inv_header)
	weight_bar = UIKit.bar(UITheme.ACCENT, 1.0)
	weight_bar.custom_minimum_size = Vector2(480, 6)
	lv.add_child(weight_bar)
	inv_list = ItemList.new()
	inv_list.custom_minimum_size = Vector2(480, 330)
	inv_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	inv_list.item_selected.connect(func(i: int) -> void: _select("inv", i))
	inv_list.item_activated.connect(func(i: int) -> void: _primary("inv", i))
	lv.add_child(inv_list)
	var dp := UIKit.panel(10)
	dp.custom_minimum_size = Vector2(480, 200)
	var dv := UIKit.vbox(4)
	dp.add_child(dv)
	detail_name = UIKit.label("", 19, UITheme.ACCENT)
	dv.add_child(detail_name)
	detail_text = RichTextLabel.new()
	detail_text.bbcode_enabled = true
	detail_text.custom_minimum_size = Vector2(460, 100)
	detail_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dv.add_child(detail_text)
	actions = UIKit.hbox(6)
	dv.add_child(actions)
	lv.add_child(dp)
	root.add_child(left)
	# --- direita: abas ---
	var right := UIKit.panel(16)
	right.custom_minimum_size = Vector2(780, 700)
	right_tabs = TabContainer.new()
	right_tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.add_child(right_tabs)
	root.add_child(right)
	_build_other()
	_build_equipment()
	_build_crafting()
	_build_status()
	add_child(UIKit.center(root))
	if other == null:
		right_tabs.set_tab_hidden(0, true)
		right_tabs.current_tab = 1
	else:
		right_tabs.current_tab = 0
	if station != "" or start_tab == "crafting":
		right_tabs.current_tab = 2
	player.inventory.changed.connect(_refresh)
	if other:
		other.changed.connect(_refresh)
	EventBus.equipment_changed.connect(func(_s: String, _i: String) -> void: _refresh())
	_refresh()
	inv_list.grab_focus()
	EventBus.ui_screen_opened.emit("inventory")


func _build_other() -> void:
	var v := UIKit.vbox(8)
	v.name = other_title if other_title != "" else "Contêiner"
	other_header = UIKit.label("", 15, UITheme.TEXT_DIM)
	v.add_child(other_header)
	other_list = ItemList.new()
	other_list.custom_minimum_size = Vector2(740, 520)
	other_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	other_list.item_selected.connect(func(i: int) -> void: _select("other", i))
	other_list.item_activated.connect(func(i: int) -> void: _primary("other", i))
	v.add_child(other_list)
	var h := UIKit.hbox(8)
	h.add_child(UIKit.button("Pegar tudo", _take_all, 200))
	h.add_child(UIKit.label("Clique duplo transfere entre os lados.", 14, UITheme.TEXT_DIM))
	v.add_child(h)
	right_tabs.add_child(v)


func _build_equipment() -> void:
	var sc := ScrollContainer.new()
	sc.name = "Equipamento"
	equip_box = UIKit.vbox(8)
	equip_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(equip_box)
	right_tabs.add_child(sc)


func _build_crafting() -> void:
	var v := UIKit.vbox(8)
	v.name = "Fabricação"
	var h := UIKit.hbox(10)
	var cats := ["Todas"]
	cats.append_array(CraftingDB.CATEGORIES)
	craft_cat = UIKit.options(cats, 0, func(_i: int) -> void: _refresh_crafting())
	h.add_child(UIKit.label("Categoria", 15))
	h.add_child(craft_cat)
	var st := UIKit.label("", 15, UITheme.ACCENT)
	st.name = "StationLabel"
	h.add_child(st)
	v.add_child(h)
	var hh := UIKit.hbox(10)
	craft_list = ItemList.new()
	craft_list.custom_minimum_size = Vector2(340, 520)
	craft_list.item_selected.connect(func(_i: int) -> void: _refresh_craft_detail())
	craft_list.item_activated.connect(func(_i: int) -> void: _start_craft())
	hh.add_child(craft_list)
	var dv := UIKit.vbox(8)
	dv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	craft_detail = RichTextLabel.new()
	craft_detail.bbcode_enabled = true
	craft_detail.custom_minimum_size = Vector2(380, 420)
	dv.add_child(craft_detail)
	craft_bar = UIKit.bar(UITheme.ACCENT, 1.0)
	craft_bar.custom_minimum_size = Vector2(380, 6)
	craft_bar.visible = false
	dv.add_child(craft_bar)
	craft_btn = UIKit.button("Fabricar", _start_craft, 240)
	dv.add_child(craft_btn)
	hh.add_child(dv)
	v.add_child(hh)
	right_tabs.add_child(v)


func _build_status() -> void:
	var v := UIKit.vbox(6)
	v.name = "Condição"
	status_text = RichTextLabel.new()
	status_text.bbcode_enabled = true
	status_text.custom_minimum_size = Vector2(740, 560)
	v.add_child(status_text)
	right_tabs.add_child(v)


# ---------------------------------------------------------------------------
# Atualização
# ---------------------------------------------------------------------------
func _stack_text(s: Dictionary) -> String:
	var id := str(s["id"])
	var t := ItemDB.item_name(id)
	if int(s["qty"]) > 1:
		t += "  ×%d" % int(s["qty"])
	if ItemDB.has_durability(id):
		t += "  [%d%%]" % int(float(s.get("cond", 1.0)) * 100.0)
	var d: Dictionary = s.get("data", {})
	if d.has("fuel"):
		t += "  (%d L)" % int(d["fuel"])
	if d.has("battery"):
		t += "  (bateria %d%%)" % int(d["battery"])
	var slot := player.quick_slots.find(id)
	if slot >= 0:
		t += "  ⟨%d⟩" % (slot + 1)
	t += "   %.1f kg" % (ItemDB.weight(id) * int(s["qty"]))
	return t


func _fill(list: ItemList, inv: Inventory) -> void:
	var sel := list.get_selected_items()
	list.clear()
	for s in inv.stacks:
		var i := list.add_item(_stack_text(s))
		list.set_item_custom_fg_color(i, ItemDB.CAT_COLORS.get(ItemDB.category(str(s["id"])), UITheme.TEXT).lerp(UITheme.TEXT, 0.45))
		list.set_item_tooltip(i, str(ItemDB.get_item(str(s["id"])).get("desc", "")))
	if not sel.is_empty() and sel[0] < list.item_count:
		list.select(sel[0])


func _refresh() -> void:
	if not is_inside_tree():
		return
	_fill(inv_list, player.inventory)
	var w := player.inventory.total_weight()
	inv_header.text = "Peso %.1f / %.1f kg   ·   Espaços %d / %d" % [w, player.inventory.max_weight, player.inventory.stacks.size(), player.inventory.max_slots]
	weight_bar.value = w / maxf(player.inventory.max_weight, 0.1)
	if other:
		_fill(other_list, other)
		other_header.text = "%s   ·   %.1f / %.1f kg   ·   %d / %d espaços" % [other_title, other.total_weight(), other.max_weight, other.stacks.size(), other.max_slots]
	_refresh_equipment()
	_refresh_crafting()
	_refresh_status()
	_refresh_detail()


func _refresh_equipment() -> void:
	for c in equip_box.get_children():
		c.queue_free()
	var names := {"weapon": "Arma", "back": "Costas (mochila)", "torso": "Tronco", "hands": "Mãos", "head": "Cabeça", "feet": "Pés", "light": "Lanterna"}
	var warmth := 0.0
	var armor := 0.0
	var rain := 0.0
	for slot in names.keys():
		var s: Dictionary = player.equipment[slot]
		var h := UIKit.hbox(10)
		var l := UIKit.label(names[slot], 16, UITheme.TEXT_DIM)
		l.custom_minimum_size = Vector2(190, 0)
		h.add_child(l)
		if s.is_empty():
			h.add_child(UIKit.label("—", 16))
		else:
			var def := ItemDB.get_item(str(s["id"]))
			warmth += float(def.get("warmth", 0.0))
			armor += float(def.get("armor", 0.0))
			rain += float(def.get("rain", 0.0))
			var t := ItemDB.item_name(str(s["id"]))
			if ItemDB.has_durability(str(s["id"])):
				t += "  [%d%%]" % int(float(s.get("cond", 1.0)) * 100.0)
			var dd: Dictionary = s.get("data", {})
			if dd.has("battery"):
				t += "  (bateria %d%%)" % int(dd["battery"])
			var il := UIKit.label(t, 16)
			il.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			h.add_child(il)
			var sl: String = slot
			h.add_child(UIKit.button("Remover", func() -> void: player.unequip(sl), 120, 15))
		equip_box.add_child(h)
	equip_box.add_child(UIKit.separator())
	equip_box.add_child(UIKit.label("Isolamento térmico: %d%%   ·   Proteção: %d%%   ·   Chuva: %d%%" % [int(warmth * 100.0), int(armor * 100.0), int(rain * 100.0)], 15, UITheme.TEXT_DIM))
	equip_box.add_child(UIKit.label("Carga total: %.1f kg" % player.carry_weight(), 15, UITheme.TEXT_DIM))


func _refresh_status() -> void:
	var s := player.survival
	var t := "[b]Saúde[/b] %d   ·   [b]Fôlego[/b] %d   ·   [b]Temperatura[/b] %.1f °C\n" % [int(s.health), int(s.stamina), s.body_temp]
	t += "[b]Fome[/b] %d   ·   [b]Sede[/b] %d   ·   [b]Energia[/b] %d   ·   [b]Moral[/b] %d\n\n" % [int(s.hunger), int(s.thirst), int(s.energy), int(s.morale)]
	var conds := s.conditions()
	if conds.is_empty():
		t += "[color=#8fbf8f]Nenhuma condição grave.[/color]\n"
	for c in conds:
		var col: String = ["#bbbbbb", "#f0c070", "#e05a4a"][clampi(int(c[2]), 0, 2)]
		t += "[color=%s]• %s[/color]  — %s\n" % [col, c[1], _cond_help(str(c[0]))]
	t += "\n[color=#888888]Peso: %.1f/%.1f kg (acima do limite você fica lento e cansa mais).[/color]" % [player.carry_weight(), player.inventory.max_weight]
	status_text.text = t


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
	_sel_side = side
	_sel_index = i
	if side == "inv":
		if other_list:
			other_list.deselect_all()
	else:
		inv_list.deselect_all()
	_refresh_detail()


func _sel_stack() -> Dictionary:
	var inv := player.inventory if _sel_side == "inv" else other
	if inv == null or _sel_index < 0 or _sel_index >= inv.stacks.size():
		return {}
	return inv.stacks[_sel_index]


func _refresh_detail() -> void:
	for c in actions.get_children():
		c.queue_free()
	var s := _sel_stack()
	if s.is_empty():
		detail_name.text = ""
		detail_text.text = "[color=#888888]Selecione um item.[/color]"
		return
	var id := str(s["id"])
	var def := ItemDB.get_item(id)
	detail_name.text = ItemDB.item_name(id)
	var t := "[color=#999999]%s  ·  %.2f kg  ·  valor %d[/color]\n%s\n" % [ItemDB.CATS.get(ItemDB.category(id), ""), ItemDB.weight(id), int(ItemDB.value(id)), str(def.get("desc", ""))]
	if def.has("weapon"):
		var w: Dictionary = def["weapon"]
		t += "[color=#e0a070]Dano %d · Velocidade %.1f · Alcance %.1f m[/color]\n" % [int(w.get("dmg", 0)), float(w.get("speed", 1.0)), float(w.get("reach", 1.0))]
	if def.has("ranged"):
		var r: Dictionary = def["ranged"]
		t += "[color=#e0a070]Dano %d · Munição: %s · Ruído %d m[/color]\n" % [int(r.get("dmg", 0)), ItemDB.item_name(str(r.get("ammo", ""))), int(r.get("noise", 0))]
	if def.has("use"):
		var parts: Array = []
		var u: Dictionary = def["use"]
		var names := {"hunger": "Fome", "thirst": "Sede", "health": "Saúde", "energy": "Energia", "stamina": "Fôlego", "infection": "Infecção", "morale": "Moral", "pain": "Dor", "temp": "Calor"}
		for k in u.keys():
			if names.has(k):
				parts.append("%s %s%d" % [names[k], "+" if float(u[k]) > 0.0 else "", int(u[k])])
		if not parts.is_empty():
			t += "[color=#90c090]%s[/color]\n" % "  ·  ".join(parts)
	if def.has("spoils"):
		t += "[color=#aaaaaa]Frescor: %d%%[/color]\n" % int(float(s.get("cond", 1.0)) * 100.0)
	detail_text.text = t
	if _sel_side == "other":
		actions.add_child(UIKit.button("Pegar", func() -> void: _transfer("other", _sel_index, -1), 130, 15))
		if int(s["qty"]) > 1:
			actions.add_child(UIKit.button("Pegar 1", func() -> void: _transfer("other", _sel_index, 1), 110, 15))
		return
	if def.has("weapon") or def.has("ranged") or def.has("equip"):
		actions.add_child(UIKit.button("Equipar", func() -> void: player.equip_from_inventory(_sel_index), 120, 15))
	elif def.has("use") or def.get("purifier", false) or id == "pilha":
		actions.add_child(UIKit.button("Usar", func() -> void: _use(_sel_index), 100, 15))
	if def.has("place"):
		actions.add_child(UIKit.button("Posicionar", func() -> void: _place(id), 130, 15))
	if other:
		actions.add_child(UIKit.button("Guardar", func() -> void: _transfer("inv", _sel_index, -1), 110, 15))
	actions.add_child(UIKit.button("Largar", func() -> void: player.drop_from_inventory(_sel_index), 100, 15))
	var qs := OptionButton.new()
	qs.add_item("Atalho…", 0)
	for i in 4:
		qs.add_item("Atalho %d" % (i + 1), i + 1)
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
	var lbl := craft_cat.get_parent().get_node("StationLabel") as Label
	lbl.text = {"workbench": "Na bancada", "fire": "No fogo"}.get(station, "Sem estação (receitas básicas)")
	var cat_i := craft_cat.selected
	var cat: String = "" if cat_i <= 0 else CraftingDB.CATEGORIES[cat_i - 1]
	var sel := craft_list.get_selected_items()
	craft_list.clear()
	_craft_ids.clear()
	var ids := CraftingDB.RECIPES.keys()
	for id in ids:
		var r: Dictionary = CraftingDB.RECIPES[id]
		if cat != "" and str(r["cat"]) != cat:
			continue
		if r.get("hidden", false) and not player.inventory.has("fragmento_1") and not player.inventory.has("fragmento_2") and not player.inventory.has("fragmento_3"):
			continue
		var c := Crafting.check(r, player, station)
		var i := craft_list.add_item(("✔ " if c["ok"] else "   ") + str(r["name"]))
		craft_list.set_item_custom_fg_color(i, UITheme.TEXT if c["ok"] else UITheme.TEXT_DIM)
		_craft_ids.append(id)
	if not sel.is_empty() and sel[0] < craft_list.item_count:
		craft_list.select(sel[0])
	_refresh_craft_detail()


func _refresh_craft_detail() -> void:
	var sel := craft_list.get_selected_items()
	if sel.is_empty() or sel[0] >= _craft_ids.size():
		craft_detail.text = "[color=#888888]Escolha uma receita.[/color]"
		craft_btn.disabled = true
		return
	var id: String = _craft_ids[sel[0]]
	var r: Dictionary = CraftingDB.RECIPES[id]
	var c := Crafting.check(r, player, station)
	var t := "[b][color=#dcb86a]%s[/color][/b]\n" % r["name"]
	if r.has("result"):
		var res: Array = r["result"]
		t += "Resultado: %s ×%d\n[color=#999999]%s[/color]\n\n" % [ItemDB.item_name(str(res[0])), int(res[1]), str(ItemDB.get_item(str(res[0])).get("desc", ""))]
	else:
		t += "Reparo do equipamento (+%d%% de condição)\n\n" % int(float(r.get("amount", 0.4)) * 100.0)
	t += "[b]Materiais[/b]\n"
	for e in r.get("in", []):
		var have := player.inventory.count(str(e[0]))
		var col := "#90c090" if have >= int(e[1]) else "#e05a4a"
		t += "[color=%s]• %s  %d/%d[/color]\n" % [col, ItemDB.item_name(str(e[0])), have, int(e[1])]
	if not (r.get("tools", []) as Array).is_empty():
		t += "\n[b]Ferramentas[/b]\n"
		for tg in r["tools"]:
			var ok := player.has_tool(str(tg))
			t += "[color=%s]• %s[/color]\n" % ["#90c090" if ok else "#e05a4a", Crafting.tool_name(str(tg))]
	var need: String = r.get("station", "")
	if need != "":
		t += "\n[b]Local[/b]\n[color=%s]• %s[/color]\n" % ["#90c090" if c["station_ok"] else "#e05a4a", "Bancada de trabalho" if need == "workbench" else "Fogueira ou fogão"]
	t += "\n[color=#999999]Tempo: %d s[/color]" % int(float(r.get("time", 3.0)))
	craft_detail.text = t
	craft_btn.disabled = not c["ok"] or _crafting != ""


func _start_craft() -> void:
	var sel := craft_list.get_selected_items()
	if sel.is_empty() or _crafting != "":
		return
	var id: String = _craft_ids[sel[0]]
	var r: Dictionary = CraftingDB.RECIPES[id]
	if not Crafting.check(r, player, station)["ok"]:
		return
	_crafting = id
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
	if event.is_action_pressed("inventory") or event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	if not is_inside_tree():
		return
	EventBus.ui_screen_closed.emit("inventory")
	closed.emit()
	queue_free()
