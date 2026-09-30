class_name ItemSlot
extends Control
## Célula da grade de itens (inventário, contêiner, troca): ícone, nome,
## quantidade, condição, atalho. Clique seleciona, duplo clique/Enter faz a
## ação principal, botão direito a secundária. Vazia = espaço livre.

signal picked(slot: ItemSlot)
signal activated(slot: ItemSlot)
signal secondary(slot: ItemSlot)
signal tertiary(slot: ItemSlot)      # △/Y no controle

const SIZE := Vector2(96, 104)

var stack: Dictionary = {}
var index: int = -1
var selected: bool = false:
	set(v):
		selected = v
		queue_redraw()
var quick: int = -1          # atalho 1..4 (0-based) ou -1
var price: int = -1          # troca: valor unitário
var marked: int = 0          # troca: unidades na oferta
var dim: bool = false
var _hover: bool = false


func _ready() -> void:
	custom_minimum_size = SIZE
	focus_mode = Control.FOCUS_ALL if not stack.is_empty() else Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_entered.connect(func() -> void:
		_hover = true
		queue_redraw())
	mouse_exited.connect(func() -> void:
		_hover = false
		queue_redraw())
	focus_entered.connect(func() -> void:
		picked.emit(self)
		queue_redraw())
	focus_exited.connect(queue_redraw)
	if not stack.is_empty():
		var id := str(stack["id"])
		tooltip_text = "%s\n%s" % [ItemDB.item_name(id), str(ItemDB.get_item(id).get("desc", ""))]


func set_stack(s: Dictionary, i: int) -> void:
	stack = s
	index = i
	focus_mode = Control.FOCUS_ALL if not s.is_empty() else Control.FOCUS_NONE
	queue_redraw()


func _gui_input(event: InputEvent) -> void:
	if stack.is_empty():
		return
	if event is InputEventMouseButton and event.pressed:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			grab_focus()
			picked.emit(self)
			if mb.double_click:
				activated.emit(self)
			accept_event()
		elif mb.button_index == MOUSE_BUTTON_RIGHT:
			grab_focus()
			picked.emit(self)
			secondary.emit(self)
			accept_event()
	elif event.is_action_pressed("ui_accept"):
		activated.emit(self)
		accept_event()
	elif event.is_action_pressed("ui_secondary") and event is InputEventJoypadButton:
		secondary.emit(self)
		accept_event()
	elif event.is_action_pressed("ui_tertiary") and event is InputEventJoypadButton:
		tertiary.emit(self)
		accept_event()


func _draw() -> void:
	var r := Rect2(Vector2.ZERO, size)
	var empty := stack.is_empty()
	var sel := selected or has_focus()
	var bg := Color(0.075, 0.08, 0.085, 0.92) if not empty else Color(0.05, 0.052, 0.056, 0.55)
	if _hover and not empty:
		bg = Color(0.12, 0.115, 0.1, 0.95)
	if sel and not empty:
		bg = Color(0.17, 0.145, 0.09, 0.97)
	var sb := UITheme.box(bg, UITheme.ACCENT if sel and not empty else Color(0.26, 0.25, 0.22, 0.55 if not empty else 0.3), 2 if sel and not empty else 1, 6)
	draw_style_box(sb, r)
	if empty:
		return
	var id := str(stack["id"])
	var cat_col := UIIcons.item_color(id)
	# faixa da categoria
	draw_rect(Rect2(6, 2, size.x - 12, 3), cat_col * Color(1, 1, 1, 0.85))
	# ícone
	var ic := 50.0
	UIIcons.draw_item(self, id, Rect2((size.x - ic) * 0.5, 10, ic, ic), dim)
	# nome (até 2 linhas, cortado)
	var font := get_theme_default_font()
	var fs := 12
	var name_ := ItemDB.item_name(id)
	var lines := _wrap(font, name_, fs, size.x - 10)
	var y := 72.0
	for ln in lines:
		draw_string(font, Vector2(5, y), ln, HORIZONTAL_ALIGNMENT_CENTER, size.x - 10, fs, UITheme.TEXT if not dim else UITheme.TEXT_DIM)
		y += 13.0
	# quantidade
	var qty := int(stack.get("qty", 1))
	if qty > 1:
		var qt := "×%d" % qty
		var w := font.get_string_size(qt, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x
		draw_style_box(UITheme.box(Color(0, 0, 0, 0.7), Color(0, 0, 0, 0), 0, 4), Rect2(size.x - w - 12, 8, w + 8, 17))
		draw_string(font, Vector2(size.x - w - 8, 21), qt, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color(1, 0.95, 0.85))
	# atalho
	if quick >= 0:
		draw_style_box(UITheme.box(UITheme.ACCENT * Color(1, 1, 1, 0.9), Color(0, 0, 0, 0), 0, 3), Rect2(6, 8, 17, 17))
		draw_string(font, Vector2(6, 21), str(quick + 1), HORIZONTAL_ALIGNMENT_CENTER, 17, 12, Color(0.08, 0.07, 0.05))
	# troca: preço e marcados
	if price >= 0:
		draw_string(font, Vector2(6, 21), "$%d" % price, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(0.85, 0.8, 0.55))
	if marked > 0:
		draw_style_box(UITheme.box(UITheme.GOOD * Color(1, 1, 1, 0.3), UITheme.GOOD, 2, 6), r)
		draw_string(font, Vector2(0, 62), "+%d" % marked, HORIZONTAL_ALIGNMENT_CENTER, size.x, 16, UITheme.GOOD)
	# condição / bateria
	var frac := -1.0
	if ItemDB.has_durability(id) or ItemDB.get_item(id).has("spoils"):
		frac = clampf(float(stack.get("cond", 1.0)), 0.0, 1.0)
	var d: Dictionary = stack.get("data", {})
	if d.has("battery"):
		frac = clampf(float(d["battery"]) / 100.0, 0.0, 1.0)
	if frac >= 0.0:
		var br := Rect2(8, size.y - 8, size.x - 16, 4)
		draw_rect(br, Color(0, 0, 0, 0.6))
		var col := Color(0.85, 0.3, 0.22).lerp(Color(0.95, 0.78, 0.3), clampf(frac * 2.0, 0.0, 1.0)).lerp(Color(0.45, 0.8, 0.45), clampf(frac * 2.0 - 1.0, 0.0, 1.0))
		draw_rect(Rect2(br.position, Vector2(br.size.x * frac, br.size.y)), col)


static func _wrap(font: Font, text: String, fs: int, width: float) -> Array:
	var words := text.split(" ")
	var lines: Array = []
	var cur := ""
	for w in words:
		var t := w if cur == "" else cur + " " + w
		if font.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x <= width or cur == "":
			cur = t
		else:
			lines.append(cur)
			cur = w
	if cur != "":
		lines.append(cur)
	if lines.size() > 2:
		lines = [lines[0], str(lines[1]) + "…"]
	for i in lines.size():
		var ln := str(lines[i])
		while ln.length() > 1 and font.get_string_size(ln, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > width:
			ln = ln.substr(0, ln.length() - 2) + "…"
		lines[i] = ln
	return lines
