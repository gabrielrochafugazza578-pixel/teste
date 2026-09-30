class_name HUDCompass
extends Control
## Bússola horizontal com pontos cardeais, marcador do objetivo, locais
## conhecidos próximos e companheiros.

var hud: HUD
const SPAN := PI * 0.9   # campo de visão da faixa (rad)
const CARD := {0.0: "N", PI * 0.25: "NE", PI * 0.5: "L", PI * 0.75: "SE", PI: "S", PI * 1.25: "SO", PI * 1.5: "O", PI * 1.75: "NO"}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _process(_d: float) -> void:
	queue_redraw()


func _heading() -> float:
	if hud == null or hud.player == null:
		return 0.0
	var f := hud.player.cam_rig.flat_forward()
	return fposmod(atan2(f.x, -f.z), TAU)   # 0 = norte (-Z)


func _x_for(angle: float) -> float:
	var d := angle_difference(_heading(), angle)
	return size.x * 0.5 + d / (SPAN * 0.5) * size.x * 0.5


func _draw() -> void:
	if hud == null or hud.player == null:
		return
	var font := get_theme_default_font()
	var w := size.x
	draw_rect(Rect2(0, 12, w, 1), Color(1, 1, 1, 0.18))
	for a: float in CARD.keys():
		var x := _x_for(a)
		if x < 0.0 or x > w:
			continue
		var s: String = CARD[a]
		var big := s.length() == 1
		var fade := 1.0 - absf(x - w * 0.5) / (w * 0.5)
		draw_string(font, Vector2(x - (6 if big else 9), 32), s, HORIZONTAL_ALIGNMENT_LEFT, -1, 16 if big else 12, Color(0.9, 0.88, 0.8, 0.35 + fade * 0.6))
	for i in 24:
		var x := _x_for(float(i) * TAU / 24.0)
		if x >= 0.0 and x <= w:
			draw_rect(Rect2(x, 8, 1, 8), Color(1, 1, 1, 0.25))
	var pp := hud.player.global_position
	# locais descobertos próximos
	if hud.game and hud.game.world:
		for id in GameState.discovered.keys():
			var poi: Dictionary = hud.game.world.layout.pois.get(id, {})
			if poi.is_empty():
				continue
			var p: Vector3 = poi["pos"]
			var d := Vector2(p.x - pp.x, p.z - pp.z)
			if d.length() > 400.0 or d.length() < 8.0:
				continue
			var x := _x_for(fposmod(atan2(d.x, -d.y), TAU))
			if x >= 0.0 and x <= w:
				draw_circle(Vector2(x, 12), 3.0, Color(0.8, 0.78, 0.7, 0.6))
	# companheiros
	if hud.game and hud.game.survivors:
		for n in hud.game.survivors.followers():
			var d := Vector2((n as Node3D).global_position.x - pp.x, (n as Node3D).global_position.z - pp.z)
			var x := _x_for(fposmod(atan2(d.x, -d.y), TAU))
			if x >= 0.0 and x <= w:
				draw_circle(Vector2(x, 12), 4.0, UITheme.GOOD)
	# objetivo
	var tp := MissionManager.tracked_marker()
	if tp != Vector3.INF and bool(Settings.gameplay.get("show_objective_markers", true)):
		var d := Vector2(tp.x - pp.x, tp.z - pp.z)
		var x := clampf(_x_for(fposmod(atan2(d.x, -d.y), TAU)), 0.0, w)
		var c := UITheme.ACCENT
		var pts := PackedVector2Array([Vector2(x, 2), Vector2(x + 7, 12), Vector2(x, 22), Vector2(x - 7, 12)])
		draw_colored_polygon(pts, c)
