class_name HUDCrosshair
extends Control
## Mira discreta (só ao mirar arma de longo alcance) ou ponto central.

var active: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _draw() -> void:
	var c := size * 0.5
	if active:
		var col := Color(1, 1, 1, 0.85)
		for d: Vector2 in [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]:
			draw_line(c + d * 4.0, c + d * 10.0, col, 1.5)
	else:
		draw_circle(c, 1.5, Color(1, 1, 1, 0.35))
