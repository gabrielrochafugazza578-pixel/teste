class_name HUDNearby
extends PanelContainer
## Painel "Itens por perto" (lado direito da tela): lista os itens soltos ao
## alcance do jogador — no chão, em mesas, balcões e prateleiras — com ícone,
## nome, quantidade e distância. O item que está na mira fica destacado com a
## tecla de interação; com o cursor livre dá para clicar e pegar o que está perto.

const RADIUS := 6.5
const MAX_ROWS := 6
const PICK_DIST := 2.6
const ROW_H := 34.0

var player: Player = null
var _rows: VBoxContainer
var _count: Label
var _t: float = 0.0
var _shown: Array = []   # [ItemPickup, dist]
var _alpha: float = 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_theme_stylebox_override("panel", UITheme.box(Color(0.03, 0.033, 0.036, 0.66), Color(1, 1, 1, 0.07), 1, 8, 10))
	custom_minimum_size = Vector2(300, 0)
	var v := UIKit.vbox(6)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(v)
	var h := UIKit.hbox(6)
	h.add_child(UIGlyph.make("eye", 15, UITheme.ACCENT))
	h.add_child(UIKit.label("ITENS POR PERTO", 12, UITheme.ACCENT))
	_count = UIKit.label("", 12, UITheme.TEXT_DIM, HORIZONTAL_ALIGNMENT_RIGHT)
	_count.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(_count)
	v.add_child(h)
	_rows = UIKit.vbox(3)
	_rows.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(_rows)
	modulate.a = 0.0
	visible = false


func tick(delta: float, show: bool) -> void:
	_t -= delta
	if _t <= 0.0:
		_t = 0.16
		_refresh()
	var want := show and not _shown.is_empty()
	_alpha = move_toward(_alpha, 1.0 if want else 0.0, delta * 5.0)
	modulate.a = _alpha
	visible = _alpha > 0.01


func _refresh() -> void:
	_shown.clear()
	if player == null or not is_instance_valid(player) or player.in_vehicle != null:
		_rebuild()
		return
	var pp := player.global_position
	var cands: Array = []
	for n in get_tree().get_nodes_in_group("item_pickup"):
		var ip := n as ItemPickup
		if ip == null or not ip.is_inside_tree() or ip.is_queued_for_deletion():
			continue
		var d := ip.global_position.distance_to(pp)
		if d > RADIUS or absf(ip.global_position.y - pp.y) > 2.2:
			continue
		cands.append([ip, d])
	cands.sort_custom(func(a, b): return float(a[1]) < float(b[1]))
	# só o que dá para ver (não lista itens do outro lado da parede)
	var space := player.get_world_3d().direct_space_state
	var eye := pp + Vector3(0, 1.45, 0)
	for c in cands:
		if _shown.size() >= MAX_ROWS:
			break
		var ip: ItemPickup = c[0]
		var tgt := ip.global_position + Vector3(0, 0.12, 0)
		var q := PhysicsRayQueryParameters3D.create(eye, tgt, 1)
		q.exclude = [player.get_rid()]
		var hit := space.intersect_ray(q)
		if not hit.is_empty() and (hit["position"] as Vector3).distance_to(tgt) > 0.6:
			continue
		_shown.append(c)
	_rebuild()


## Linhas fixas reaproveitadas (sem recriar nós a cada atualização).
var _row_nodes: Array = []   # [Button, UIGlyph, Label nome, keycap, Label dist]


func _make_rows() -> void:
	for i in MAX_ROWS:
		var b := Button.new()
		b.focus_mode = Control.FOCUS_NONE
		b.custom_minimum_size = Vector2(280, ROW_H)
		b.mouse_filter = Control.MOUSE_FILTER_STOP
		b.add_theme_stylebox_override("hover", UITheme.box(Color(0.16, 0.14, 0.1, 0.85), UITheme.ACCENT, 1, 6))
		b.add_theme_stylebox_override("pressed", UITheme.box(Color(0.24, 0.2, 0.12, 0.9), UITheme.ACCENT, 1, 6))
		var h := UIKit.hbox(8)
		h.set_anchors_preset(Control.PRESET_FULL_RECT)
		h.offset_left = 6
		h.offset_right = -8
		h.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var ic := UIGlyph.for_item("", 26)
		ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(ic)
		var nm := UIKit.label("", 14, UITheme.TEXT)
		nm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		nm.clip_text = true
		nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		nm.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		nm.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(nm)
		var kc := InputPrompt.make("interact", 15)
		kc.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		kc.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(kc)
		var dl := UIKit.label("", 12, UITheme.TEXT_DIM, HORIZONTAL_ALIGNMENT_RIGHT)
		dl.custom_minimum_size = Vector2(44, 0)
		dl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		dl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(dl)
		b.add_child(h)
		b.pressed.connect(_on_row.bind(i))
		b.visible = false
		_rows.add_child(b)
		_row_nodes.append([b, ic, nm, kc, dl])


func _rebuild() -> void:
	if _row_nodes.is_empty():
		_make_rows()
	var focus: Node = player.current_interactable if player != null and is_instance_valid(player) else null
	var total := _shown.size()
	_count.text = "%d" % total if total > 0 else ""
	for i in MAX_ROWS:
		var rn: Array = _row_nodes[i]
		var b: Button = rn[0]
		if i >= total:
			b.visible = false
			continue
		var ip: ItemPickup = _shown[i][0]
		var d: float = _shown[i][1]
		var id := str(ip.stack.get("id", ""))
		var hot := ip == focus
		b.visible = true
		var bg := Color(0.2, 0.16, 0.08, 0.75) if hot else Color(1, 1, 1, 0.035)
		b.add_theme_stylebox_override("normal", UITheme.box(bg, UITheme.ACCENT if hot else Color(0, 0, 0, 0), 1, 6))
		(rn[1] as UIGlyph).item_id = id
		var nm: Label = rn[2]
		nm.text = ip.label_text()
		nm.add_theme_color_override("font_color", UITheme.TEXT if d < PICK_DIST or hot else UITheme.TEXT_DIM)
		(rn[3] as Control).visible = hot
		var dl: Label = rn[4]
		dl.text = "%.1f m" % d
		dl.add_theme_color_override("font_color", UITheme.ACCENT if hot else UITheme.TEXT_DIM)
		b.tooltip_text = ItemDB.item_name(id)


func _on_row(i: int) -> void:
	if i >= _shown.size() or player == null or not is_instance_valid(player):
		return
	var o: Variant = _shown[i][0]
	if not is_instance_valid(o):
		return
	var ip := o as ItemPickup
	if ip.global_position.distance_to(player.global_position) > PICK_DIST:
		EventBus.toast("Chegue mais perto para pegar.", "info")
		return
	AudioManager.play_ui("ui_click", -8.0)
	ip.interact(player)
	_t = 0.0
