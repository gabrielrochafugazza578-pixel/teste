class_name HUDEye
extends Control
## Indicador de furtividade: olho que abre conforme a visibilidade do
## jogador (luz, postura, movimento) e fica vermelho com suspeita inimiga.

var level: float = 0.5
var crouched: bool = false
var threat: float = 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _draw() -> void:
	var c := size * 0.5
	var open := clampf(level, 0.05, 1.0)
	var col := Color(0.85, 0.84, 0.78, 0.85).lerp(UITheme.DANGER, clampf(threat, 0.0, 1.0))
	var pts := PackedVector2Array()
	for i in 17:
		var t := float(i) / 16.0
		pts.append(c + Vector2((t - 0.5) * size.x, -sin(t * PI) * size.y * 0.45 * open))
	for i in range(16, -1, -1):
		var t := float(i) / 16.0
		pts.append(c + Vector2((t - 0.5) * size.x, sin(t * PI) * size.y * 0.45 * open))
	draw_polyline(pts, col, 1.6, true)
	draw_circle(c, size.y * 0.18 * open + 1.0, col)
	if crouched:
		draw_rect(Rect2(0, size.y + 2, size.x, 2), Color(0.8, 0.8, 0.75, 0.6))
