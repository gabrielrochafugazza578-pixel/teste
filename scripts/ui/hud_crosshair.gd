class_name HUDCrosshair
extends Control
## Mira discreta (só ao mirar arma de longo alcance) ou ponto central, e o
## marcador de acerto: um "X" rápido quando o golpe conecta (vermelho no abate).

var active: bool = false
var _hit_t: float = 0.0
var _kill: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func flash(kill: bool) -> void:
	_hit_t = 0.28 if not kill else 0.45
	_kill = kill or _kill and _hit_t > 0.0
	queue_redraw()


func _process(delta: float) -> void:
	if _hit_t > 0.0:
		_hit_t = maxf(0.0, _hit_t - delta)
		if _hit_t <= 0.0:
			_kill = false
		queue_redraw()


func _draw() -> void:
	var c := size * 0.5
	if active:
		var col := Color(1, 1, 1, 0.85)
		for d: Vector2 in [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]:
			draw_line(c + d * 4.0, c + d * 10.0, col, 1.5)
	else:
		draw_circle(c, 1.5, Color(1, 1, 1, 0.35))
	if _hit_t > 0.0:
		var a := clampf(_hit_t / 0.2, 0.0, 1.0)
		var col2 := Color(0.95, 0.3, 0.25, a) if _kill else Color(1, 1, 1, a * 0.9)
		var r0 := 6.0 + (1.0 - a) * 3.0
		for d: Vector2 in [Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1)]:
			draw_line(c + d.normalized() * r0, c + d.normalized() * (r0 + 7.0), Color(0, 0, 0, a * 0.6), 4.0, true)
			draw_line(c + d.normalized() * r0, c + d.normalized() * (r0 + 7.0), col2, 2.0, true)
