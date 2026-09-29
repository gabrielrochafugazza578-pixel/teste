class_name TradeScreen
extends Control
## Escambo: clique no que oferece (esquerda) e no que quer (direita) para
## adicionar 1 unidade; botão direito remove. A troca só fecha quando o valor
## oferecido cobre o pedido.

signal closed

var npc: SurvivorNPC
var player: Player
var manager: SurvivorManager
var left_grid: GridContainer
var right_grid: GridContainer
var give_label: Label
var take_label: Label
var balance_bar: ProgressBar
var confirm: Button
var give: Dictionary = {}   # índice -> qtd
var take: Dictionary = {}


func _ready() -> void:
	theme = UITheme.game_theme()
	UIKit.full_rect(self)
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(UIKit.dim_bg(0.6))
	var p := UIKit.window(18)
	p.custom_minimum_size = Vector2(1280, 720)
	var v := UIKit.vbox(12)
	p.add_child(v)
	var att := npc.attitude()
	var att_t: String = {"friendly": "Amigável — preços melhores", "neutral": "Neutra", "wary": "Desconfiada — preços piores", "hostile": "Hostil"}.get(att, att)
	var head := UIKit.header("people", "TROCA — " + npc.display_name.to_upper(), "", "Esc", "Sair")
	var att_col := UITheme.GOOD if att == "friendly" else (UITheme.DANGER if att in ["wary", "hostile"] else UITheme.TEXT_DIM)
	var chip := UIKit.chip("Atitude: " + att_t, att_col, 14)
	chip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(chip)
	head.move_child(chip, 2)
	v.add_child(head)
	var tip := UIKit.hbox(6)
	tip.add_child(UIKit.label("Clique adiciona 1 unidade à troca,", 14, UITheme.TEXT_DIM))
	tip.add_child(UIKit.keycap("Botão direito"))
	tip.add_child(UIKit.label("remove. O número no canto é o valor de cada unidade.", 14, UITheme.TEXT_DIM))
	v.add_child(tip)
	var h := UIKit.hbox(16)
	h.size_flags_vertical = Control.SIZE_EXPAND_FILL
	h.add_child(_side("Você oferece", true))
	h.add_child(_side(npc.display_name + " oferece", false))
	v.add_child(h)
	# balança
	var bc := UIKit.card(12)
	var bh := UIKit.hbox(14)
	bc.add_child(bh)
	give_label = UIKit.label("", 18, UITheme.ACCENT)
	give_label.custom_minimum_size = Vector2(230, 0)
	bh.add_child(give_label)
	var mid := UIKit.vbox(4)
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mid.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	balance_bar = UIKit.bar(UITheme.GOOD, 1.0)
	balance_bar.custom_minimum_size = Vector2(300, 12)
	mid.add_child(balance_bar)
	bh.add_child(mid)
	take_label = UIKit.label("", 18, UITheme.TEXT, HORIZONTAL_ALIGNMENT_RIGHT)
	take_label.custom_minimum_size = Vector2(230, 0)
	bh.add_child(take_label)
	confirm = UIKit.button("Fechar negócio", _confirm, 220)
	bh.add_child(confirm)
	bh.add_child(UIKit.button("Sair", close, 120))
	v.add_child(bc)
	add_child(UIKit.center(p))
	_refresh()
	EventBus.ui_screen_opened.emit("trade")


func _side(title_text: String, mine: bool) -> Control:
	var c := UIKit.card(12)
	c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var lv := UIKit.vbox(8)
	c.add_child(lv)
	lv.add_child(UIKit.section(title_text))
	var sc := ScrollContainer.new()
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var g := GridContainer.new()
	g.columns = 6
	g.add_theme_constant_override("h_separation", 8)
	g.add_theme_constant_override("v_separation", 8)
	sc.add_child(g)
	lv.add_child(sc)
	if mine:
		left_grid = g
	else:
		right_grid = g
	return c


func _click(sel: Dictionary, inv: Inventory, i: int, right: bool) -> void:
	var s: Dictionary = inv.stacks[i]
	var n := int(sel.get(i, 0))
	if right:
		n = maxi(0, n - 1)
	else:
		if ItemDB.get_item(str(s["id"])).get("story", false):
			EventBus.toast("Isso não está à venda.", "info")
			return
		n = mini(int(s["qty"]), n + 1)
	if n == 0:
		sel.erase(i)
	else:
		sel[i] = n
	AudioManager.play_ui("ui_click", -10.0)
	_refresh()


func _fill(g: GridContainer, inv: Inventory, sel: Dictionary, mine: bool) -> float:
	for c in g.get_children():
		g.remove_child(c)
		c.queue_free()
	var total := 0.0
	for i in inv.stacks.size():
		var s: Dictionary = inv.stacks[i]
		var price := Trade.sell_price(s, npc, manager) if mine else Trade.buy_price(s, npc, manager)
		var n := int(sel.get(i, 0))
		total += price * n
		var sl := ItemSlot.new()
		sl.set_stack(s, i)
		sl.price = int(round(price))
		sl.marked = n
		sl.dim = mine and price <= 0.0
		var dsel := sel
		var dinv := inv
		# o clique vai direto para a troca (sem duplo clique); Enter também adiciona
		sl.gui_input.connect(func(e: InputEvent) -> void:
			if e is InputEventMouseButton and (e as InputEventMouseButton).pressed and not (e as InputEventMouseButton).double_click:
				var mb := (e as InputEventMouseButton).button_index
				if mb == MOUSE_BUTTON_LEFT or mb == MOUSE_BUTTON_RIGHT:
					_click(dsel, dinv, sl.index, mb == MOUSE_BUTTON_RIGHT)
			elif e.is_action_pressed("ui_accept"):
				_click(dsel, dinv, sl.index, false))
		g.add_child(sl)
	return total


func _refresh() -> void:
	var gv := _fill(left_grid, player.inventory, give, true)
	var tv := _fill(right_grid, npc.trade_inv, take, false)
	give_label.text = "Você oferece: %.0f" % gv
	take_label.text = "Você pede: %.0f" % tv
	var ok := gv >= tv and (gv > 0.0 or tv > 0.0)
	balance_bar.value = clampf(gv / maxf(tv, 1.0), 0.0, 1.0) if tv > 0.0 else (1.0 if gv > 0.0 else 0.0)
	balance_bar.add_theme_stylebox_override("fill", UITheme.box(UITheme.GOOD if ok else Color(0.9, 0.55, 0.25), Color(0, 0, 0, 0), 0, 3))
	take_label.add_theme_color_override("font_color", UITheme.GOOD if ok else UITheme.DANGER)
	confirm.disabled = gv < tv or (give.is_empty() and take.is_empty())


func _confirm() -> void:
	if Trade.execute(player, npc, manager, give, take):
		give.clear()
		take.clear()
		_refresh()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	if not is_inside_tree():
		return
	EventBus.ui_screen_closed.emit("trade")
	closed.emit()
	queue_free()
