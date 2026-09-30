class_name MapView
extends Control
## Área desenhável do mapa com zoom/pan e marcadores.

var screen: MapScreen
var tex: Texture2D
var zoom: float = 1.4          # pixels de tela por pixel do mapa
var center_px := Vector2(512, 512)
var _drag: bool = false


func center_on(world_xz: Vector2) -> void:
	center_px = MapScreen.world_to_px(world_xz)
	queue_redraw()


func _to_screen(px: Vector2) -> Vector2:
	return size * 0.5 + (px - center_px) * zoom


func _to_map(sp: Vector2) -> Vector2:
	return center_px + (sp - size * 0.5) / zoom


func _gui_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventAction:
		if _unhandled_key_or_pad(event):
			accept_event()
		return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = clampf(zoom * 1.15, 0.6, 8.0)
		elif mb.pressed and mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = clampf(zoom / 1.15, 0.6, 8.0)
		elif mb.button_index == MOUSE_BUTTON_LEFT:
			_drag = mb.pressed
		elif mb.pressed and mb.button_index == MOUSE_BUTTON_RIGHT:
			var m := _to_map(mb.position)
			var w := m / MapScreen.SIZE * WorldLayout.HALF * 2.0 - Vector2(WorldLayout.HALF, WorldLayout.HALF)
			if screen.game.waypoint != Vector3.INF and Vector2(screen.game.waypoint.x, screen.game.waypoint.z).distance_to(w) < 30.0 / zoom * 3.0:
				screen.game.waypoint = Vector3.INF
			else:
				screen.game.waypoint = Vector3(w.x, 0, w.y)
		queue_redraw()
	elif event is InputEventMouseMotion and _drag:
		center_px -= (event as InputEventMouseMotion).relative / zoom
		queue_redraw()


func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	set_meta("pad_stick", true)   # o analógico esquerdo move o mapa (não o foco)


func _process(d: float) -> void:
	# controle: analógico esquerdo move, direito aproxima/afasta
	if Pad.using_pad and has_focus():
		var lv := Vector2(Input.get_joy_axis(Pad.device, JOY_AXIS_LEFT_X), Input.get_joy_axis(Pad.device, JOY_AXIS_LEFT_Y))
		if lv.length() > 0.18:
			center_px += lv * lv.length() * 520.0 / zoom * d
		var ry := Input.get_joy_axis(Pad.device, JOY_AXIS_RIGHT_Y)
		if absf(ry) > 0.2:
			zoom = clampf(zoom * exp(-ry * 1.8 * d), 0.6, 8.0)
		center_px = center_px.clamp(Vector2.ZERO, Vector2(MapScreen.SIZE, MapScreen.SIZE))
	queue_redraw()


## ✕ marca/desmarca o destino no centro da mira; △ volta para o jogador; □ apaga o destino.
func _unhandled_key_or_pad(event: InputEvent) -> bool:
	if event.is_action_pressed("ui_accept"):
		var w := center_px / MapScreen.SIZE * WorldLayout.HALF * 2.0 - Vector2(WorldLayout.HALF, WorldLayout.HALF)
		if screen.game.waypoint != Vector3.INF and Vector2(screen.game.waypoint.x, screen.game.waypoint.z).distance_to(w) < 30.0 / zoom * 3.0:
			screen.game.waypoint = Vector3.INF
		else:
			screen.game.waypoint = Vector3(w.x, 0, w.y)
		AudioManager.play_ui("ui_click", -8.0)
		return true
	if event.is_action_pressed("ui_tertiary"):
		center_on(Vector2(screen.player.global_position.x, screen.player.global_position.z))
		return true
	if event.is_action_pressed("ui_secondary"):
		screen.game.waypoint = Vector3.INF
		return true
	return false


func _marker(world: Vector3) -> Vector2:
	return _to_screen(MapScreen.world_to_px(Vector2(world.x, world.z)))


func _draw() -> void:
	if tex == null:
		return
	var font := get_theme_default_font()
	var tl := _to_screen(Vector2.ZERO)
	draw_texture_rect(tex, Rect2(tl, Vector2(MapScreen.SIZE, MapScreen.SIZE) * zoom), false)
	var g: Node = screen.game
	# nomes de distritos
	if zoom < 2.5:
		for d: Array in [["Centro", Vector2(0, 0)], ["Bairro Alto", Vector2(0, -575)], ["Centro Sul", Vector2(0, 425)], ["Jardim das Acácias", Vector2(-625, -450)],
				["Vila Operária", Vector2(-625, 200)], ["Distrito Industrial", Vector2(675, 0)], ["Parque Norte", Vector2(675, -600)], ["Serra da Aurora", Vector2(0, -1150)],
				["Mata do Sabiá", Vector2(-1250, -200)], ["Zona Rural", Vector2(300, 1000)], ["Lago Azul", WorldLayout.LAKE_CENTER]]:
			var sp := _to_screen(MapScreen.world_to_px(d[1]))
			draw_string(font, sp - Vector2(60, 0), str(d[0]).to_upper(), HORIZONTAL_ALIGNMENT_CENTER, 120, 12, Color(1, 1, 1, 0.35))
	# locais descobertos
	for id in GameState.discovered.keys():
		var poi: Dictionary = g.world.layout.pois.get(id, {})
		if poi.is_empty():
			continue
		var sp := _marker(poi["pos"])
		draw_circle(sp, 4.0, Color(0.95, 0.85, 0.6))
		if zoom > 1.6:
			draw_string(font, sp + Vector2(7, 4), str(poi["name"]), HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(1, 0.95, 0.85, 0.9))
	# estruturas do jogador
	for s in GameState.structures:
		var sd: Dictionary = s
		if str(sd["type"]) in ["storage_box", "hidden_stash", "bedroll", "workbench"]:
			draw_rect(Rect2(_marker(Util.v3(sd["pos"])) - Vector2(3, 3), Vector2(6, 6)), UITheme.GOOD)
	# veículos
	if g.vehicles:
		for id in g.vehicles.states.keys():
			var st: Dictionary = g.vehicles.states[id]
			var sp := _marker(st["pos"])
			draw_rect(Rect2(sp - Vector2(4, 2.5), Vector2(8, 5)), Color(0.6, 0.75, 0.95))
	# objetivo
	var tp := MissionManager.tracked_marker()
	if tp != Vector3.INF:
		var sp := _marker(tp)
		draw_colored_polygon(PackedVector2Array([sp + Vector2(0, -9), sp + Vector2(8, 0), sp + Vector2(0, 9), sp + Vector2(-8, 0)]), UITheme.ACCENT)
	if g.waypoint != Vector3.INF:
		var sp := _marker(g.waypoint)
		draw_arc(sp, 8.0, 0.0, TAU, 20, Color(0.5, 0.9, 1.0), 2.0)
		draw_line(sp + Vector2(0, 8), sp + Vector2(0, 16), Color(0.5, 0.9, 1.0), 2.0)
	# companheiros
	if g.survivors:
		for n in g.survivors.followers():
			draw_circle(_marker((n as Node3D).global_position), 4.0, UITheme.GOOD)
	# jogador
	var pp := _marker(screen.player.global_position)
	var f := screen.player.cam_rig.flat_forward()
	var dir := Vector2(f.x, f.z).normalized()
	var side := Vector2(-dir.y, dir.x)
	draw_colored_polygon(PackedVector2Array([pp + dir * 11.0, pp - dir * 6.0 + side * 6.0, pp - dir * 3.0, pp - dir * 6.0 - side * 6.0]), Color(1, 1, 1))
	# mira do controle (o destino é marcado aqui)
	if Pad.using_pad and has_focus():
		var c := size * 0.5
		for dv: Vector2 in [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]:
			draw_line(c + dv * 5.0, c + dv * 14.0, Color(0, 0, 0, 0.6), 4.0)
			draw_line(c + dv * 5.0, c + dv * 14.0, Color(1, 1, 1, 0.9), 2.0)
	# escala
	var m100 := 100.0 / (WorldLayout.HALF * 2.0) * MapScreen.SIZE * zoom
	draw_line(Vector2(20, size.y - 20), Vector2(20 + m100, size.y - 20), Color(1, 1, 1, 0.7), 2.0)
	draw_string(font, Vector2(20, size.y - 26), "100 m", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(1, 1, 1, 0.7))
