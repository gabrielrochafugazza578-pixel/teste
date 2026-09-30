class_name Hud
extends CanvasLayer
## Interface do jogo: mira, barra de materiais, coracoes de vida, relogio,
## mensagens e efeitos de tela (dano, embaixo d'agua).

var player: Player
var day_night: DayNight
var world: World

var draw_root: Control
var info_label: Label
var message_label: Label
var hint_label: Label
var hurt_rect: ColorRect
var water_rect: ColorRect
var night_rect: ColorRect

var _message_time := 0.0
var _hurt := 0.0
var _last_hp := -1

const OUTLINE := Color(0.10, 0.07, 0.15)


func _ready() -> void:
	layer = 5
	water_rect = _full_rect(Color(0.1, 0.35, 0.75, 0.0))
	night_rect = _full_rect(Color(0.05, 0.02, 0.15, 0.0))
	hurt_rect = _full_rect(Color(0.9, 0.05, 0.1, 0.0))

	draw_root = Control.new()
	draw_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	draw_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	draw_root.draw.connect(_on_draw)
	add_child(draw_root)

	info_label = _label(20, HORIZONTAL_ALIGNMENT_RIGHT)
	info_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	info_label.position = Vector2(-330, 14)
	info_label.size = Vector2(310, 80)

	message_label = _label(34, HORIZONTAL_ALIGNMENT_CENTER)
	message_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	message_label.position = Vector2(-450, 90)
	message_label.size = Vector2(900, 60)

	hint_label = _label(15, HORIZONTAL_ALIGNMENT_LEFT)
	hint_label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	hint_label.position = Vector2(14, -120)
	hint_label.size = Vector2(520, 110)
	hint_label.text = "WASD andar  |  Espaco pular  |  Shift correr\nClique esq. cavar/bater  |  Clique dir. construir\n1-0 / roda do mouse: escolher material  |  Esc pausa"
	hint_label.modulate.a = 0.85


func _full_rect(c: Color) -> ColorRect:
	var r := ColorRect.new()
	r.color = c
	r.set_anchors_preset(Control.PRESET_FULL_RECT)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(r)
	return r


func _label(size: int, align: HorizontalAlignment) -> Label:
	var l := Label.new()
	l.horizontal_alignment = align
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", Color(1, 1, 1))
	l.add_theme_color_override("font_outline_color", OUTLINE)
	l.add_theme_constant_override("outline_size", maxi(4, size / 4))
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(l)
	return l


func show_message(text: String, seconds := 3.0) -> void:
	message_label.text = text
	_message_time = seconds


func flash_hurt() -> void:
	_hurt = 0.55


func _process(delta: float) -> void:
	_message_time -= delta
	message_label.modulate.a = clampf(_message_time, 0.0, 1.0)
	_hurt = maxf(0.0, _hurt - delta)
	hurt_rect.color.a = _hurt * 0.5
	if player:
		if player.hp < _last_hp:
			flash_hurt()
		_last_hp = player.hp
		water_rect.color.a = 0.38 if player.head_in_water else 0.0
		if hint_label.modulate.a > 0.0 and (player.velocity.length() > 0.5 or Input.is_action_pressed("attack")):
			hint_label.modulate.a -= delta * 0.05
	if day_night and world and player:
		var p := player.global_position
		var biome: String = WorldGen.BIOME_NAMES[world.biome_at(p.x, p.z)]
		info_label.text = "Dia %d  -  %s\n%s" % [day_night.day_count, day_night.clock_string(), biome]
		night_rect.color.a = day_night.night_factor * 0.12
	draw_root.queue_redraw()


# ------------------------------------------------------------- desenho --

func _on_draw() -> void:
	var vs := draw_root.size
	var c := vs * 0.5
	# mira
	draw_root.draw_circle(c, 4.5, OUTLINE)
	draw_root.draw_circle(c, 2.5, Color(1, 1, 1))
	if player == null:
		return
	_draw_hotbar(vs)
	_draw_hearts()


func _draw_hotbar(vs: Vector2) -> void:
	var inv: Inventory = player.inventory
	var n := Inventory.HOTBAR.size()
	var slot := 58.0
	var gap := 8.0
	var total := n * slot + (n - 1) * gap
	var x0 := (vs.x - total) * 0.5
	var y0 := vs.y - slot - 18.0
	var font := ThemeDB.fallback_font
	for i in n:
		var m: int = Inventory.HOTBAR[i]
		var sel := i == inv.selected
		var r := Rect2(x0 + i * (slot + gap), y0 - (8.0 if sel else 0.0), slot, slot)
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color(1, 0.95, 0.7, 0.95) if sel else Color(0.98, 0.96, 1.0, 0.72)
		sb.set_corner_radius_all(14)
		sb.set_border_width_all(4 if sel else 3)
		sb.border_color = OUTLINE
		draw_root.draw_style_box(sb, r)
		var col: Color = Mats.COLORS[m]
		var center := r.get_center() - Vector2(0, 3)
		draw_root.draw_circle(center, 17.0, OUTLINE)
		draw_root.draw_circle(center, 14.5, col)
		draw_root.draw_circle(center + Vector2(-5, -5), 4.0, col.lightened(0.45))
		var cnt: int = inv.counts.get(m, 0)
		var txt := "inf" if inv.creative else str(cnt)
		var tpos := r.position + Vector2(slot - 8 - font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x, slot - 7)
		draw_root.draw_string_outline(font, tpos, txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, 5, OUTLINE)
		draw_root.draw_string(font, tpos, txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(1, 1, 1) if cnt > 0 or inv.creative else Color(1, 0.5, 0.5))
		var key := str((i + 1) % 10)
		draw_root.draw_string_outline(font, r.position + Vector2(7, 17), key, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, 4, OUTLINE)
		draw_root.draw_string(font, r.position + Vector2(7, 17), key, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color(1, 1, 1))
	# nome do material escolhido
	var name_txt: String = Mats.NAMES[inv.selected_material()]
	var fw := font.get_string_size(name_txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 20).x
	var np := Vector2((vs.x - fw) * 0.5, y0 - 20)
	draw_root.draw_string_outline(font, np, name_txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, 6, OUTLINE)
	draw_root.draw_string(font, np, name_txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color(1, 1, 1))


func _heart_points(c: Vector2, s: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 32:
		var t := float(i) / 32.0 * TAU
		var x := 16.0 * pow(sin(t), 3)
		var y := -(13.0 * cos(t) - 5.0 * cos(2 * t) - 2.0 * cos(3 * t) - cos(4 * t))
		pts.append(c + Vector2(x, y) * s / 16.0)
	return pts


func _draw_hearts() -> void:
	var hearts := player.max_hp / 2
	for i in hearts:
		var c := Vector2(30 + i * 34, 32)
		var outline_pts := _heart_points(c, 15.5)
		draw_root.draw_colored_polygon(outline_pts, OUTLINE)
		var inner := _heart_points(c, 12.0)
		draw_root.draw_colored_polygon(inner, Color(0.35, 0.2, 0.3))
		var hp_here := player.hp - i * 2
		if hp_here >= 2:
			draw_root.draw_colored_polygon(inner, Color(1.0, 0.25, 0.35))
			draw_root.draw_circle(c + Vector2(-5, -4), 2.6, Color(1, 0.75, 0.8))
		elif hp_here == 1:
			var half := PackedVector2Array()
			for p in inner:
				if p.x <= c.x + 0.01:
					half.append(p)
			if half.size() >= 3:
				draw_root.draw_colored_polygon(half, Color(1.0, 0.25, 0.35))
