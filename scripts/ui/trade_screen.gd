class_name TradeScreen
extends Control
## Escambo: selecione o que oferece (esquerda) e o que quer (direita). A
## troca só fecha quando o valor oferecido cobre o pedido.

signal closed

var npc: SurvivorNPC
var player: Player
var manager: SurvivorManager
var left_list: ItemList
var right_list: ItemList
var balance: Label
var confirm: Button
var give: Dictionary = {}   # índice -> qtd
var take: Dictionary = {}


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(UIKit.dim_bg(0.6))
	var p := UIKit.panel(18)
	p.custom_minimum_size = Vector2(1180, 660)
	var v := UIKit.vbox(10)
	p.add_child(v)
	v.add_child(UIKit.title("TROCA — " + npc.display_name.to_upper(), 24))
	var att := npc.attitude()
	v.add_child(UIKit.label("Atitude: %s. Clique para adicionar 1 unidade, botão direito para remover." % {"friendly": "amigável (preços melhores)", "neutral": "neutra", "wary": "desconfiada (preços piores)", "hostile": "hostil"}.get(att, att), 14, UITheme.TEXT_DIM))
	var h := UIKit.hbox(14)
	var lv := UIKit.vbox(6)
	lv.add_child(UIKit.label("Você oferece", 17, UITheme.ACCENT))
	left_list = ItemList.new()
	left_list.custom_minimum_size = Vector2(560, 460)
	left_list.item_clicked.connect(func(i: int, _p: Vector2, mb: int) -> void: _click(give, player.inventory, i, mb))
	lv.add_child(left_list)
	h.add_child(lv)
	var rv := UIKit.vbox(6)
	rv.add_child(UIKit.label(npc.display_name + " oferece", 17, UITheme.ACCENT))
	right_list = ItemList.new()
	right_list.custom_minimum_size = Vector2(560, 460)
	right_list.item_clicked.connect(func(i: int, _p: Vector2, mb: int) -> void: _click(take, npc.trade_inv, i, mb))
	rv.add_child(right_list)
	h.add_child(rv)
	v.add_child(h)
	var bh := UIKit.hbox(12)
	balance = UIKit.label("", 18)
	balance.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bh.add_child(balance)
	confirm = UIKit.button("Fechar negócio", _confirm, 220)
	bh.add_child(confirm)
	bh.add_child(UIKit.button("Sair", close, 140))
	v.add_child(bh)
	add_child(UIKit.center(p))
	_refresh()
	EventBus.ui_screen_opened.emit("trade")


func _click(sel: Dictionary, inv: Inventory, i: int, mb: int) -> void:
	var s: Dictionary = inv.stacks[i]
	var n := int(sel.get(i, 0))
	if mb == MOUSE_BUTTON_RIGHT:
		n = maxi(0, n - 1)
	else:
		if ItemDB.get_item(str(s["id"])).get("story", false):
			return
		n = mini(int(s["qty"]), n + 1)
	if n == 0:
		sel.erase(i)
	else:
		sel[i] = n
	_refresh()


func _refresh() -> void:
	left_list.clear()
	right_list.clear()
	var gv := 0.0
	var tv := 0.0
	for i in player.inventory.stacks.size():
		var s: Dictionary = player.inventory.stacks[i]
		var price := Trade.sell_price(s, npc, manager)
		var n := int(give.get(i, 0))
		gv += price * n
		var k := left_list.add_item("%s%s ×%d   (%.0f)" % ["▶ %d  " % n if n > 0 else "", ItemDB.item_name(str(s["id"])), int(s["qty"]), price])
		if n > 0:
			left_list.set_item_custom_fg_color(k, UITheme.ACCENT)
		elif price <= 0.0:
			left_list.set_item_custom_fg_color(k, UITheme.TEXT_DIM)
	for i in npc.trade_inv.stacks.size():
		var s: Dictionary = npc.trade_inv.stacks[i]
		var price := Trade.buy_price(s, npc, manager)
		var n := int(take.get(i, 0))
		tv += price * n
		var k := right_list.add_item("%s%s ×%d   (%.0f)" % ["◀ %d  " % n if n > 0 else "", ItemDB.item_name(str(s["id"])), int(s["qty"]), price])
		if n > 0:
			right_list.set_item_custom_fg_color(k, UITheme.ACCENT)
	balance.text = "Você oferece: %.0f   ·   Você pede: %.0f" % [gv, tv]
	balance.add_theme_color_override("font_color", UITheme.GOOD if gv >= tv and (gv > 0.0 or tv > 0.0) else UITheme.DANGER)
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
