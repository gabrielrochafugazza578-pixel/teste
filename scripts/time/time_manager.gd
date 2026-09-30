extends Node
## TimeManager — ciclo de dia e noite (manhã, tarde, noite, madrugada).
##
## 1 dia de jogo = Settings.gameplay.day_length_minutes minutos reais (48 por
## padrão). Emite eventos de hora/período/dia (sem polling pelos sistemas).

enum Period { MADRUGADA, MANHA, TARDE, NOITE }
const PERIOD_NAMES := ["Madrugada", "Manhã", "Tarde", "Noite"]

var hour: float = 7.0
var day: int = 1
var running: bool = true
var time_scale: float = 1.0      # multiplicador (dormir acelera)
var locked_hour: float = -1.0    # cinemáticas podem fixar o horário
var _last_hour: int = -1
var _last_period: int = -1
var _last_usec: int = 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


func _notification(what: int) -> void:
	# pausa/menus: não conta o tempo parado
	if what == NOTIFICATION_UNPAUSED:
		_last_usec = Time.get_ticks_usec()


func hours_per_second() -> float:
	var mins := maxf(float(Settings.gameplay.get("day_length_minutes", 48.0)), 1.0)
	return 24.0 / (mins * 60.0)


func _process(_delta: float) -> void:
	# relógio pelo tempo real (e não pelo delta do quadro, que o Godot limita
	# quando o FPS cai muito): 24 h de jogo = 48 min reais mesmo com o jogo lento
	var now := Time.get_ticks_usec()
	var real_dt := 0.0 if _last_usec == 0 else clampf(float(now - _last_usec) / 1000000.0, 0.0, 0.5)
	_last_usec = now
	if locked_hour >= 0.0:
		hour = locked_hour
	elif running and GameState.in_game:
		advance(real_dt * hours_per_second() * time_scale)
	_check_events()


func advance(hours: float) -> void:
	hour += hours
	while hour >= 24.0:
		hour -= 24.0
		day += 1
		GameState.stats["days"] = day
		EventBus.day_changed.emit(day)


func _check_events() -> void:
	var h := int(hour)
	if h != _last_hour:
		_last_hour = h
		EventBus.hour_changed.emit(h)
	var p := period()
	if p != _last_period:
		_last_period = p
		EventBus.period_changed.emit(p)


func set_time(h: float, d: int = -1) -> void:
	hour = fposmod(h, 24.0)
	if d > 0:
		day = d
	_check_events()


func period() -> int:
	if hour < 5.0:
		return Period.MADRUGADA
	if hour < 12.0:
		return Period.MANHA
	if hour < 18.0:
		return Period.TARDE
	return Period.NOITE


func period_name() -> String:
	return PERIOD_NAMES[period()]


## Altura do sol: -1 (meia-noite) .. 1 (meio-dia). Nascer ~5h30, pôr ~18h30.
func sun_height() -> float:
	return sin((hour - 6.0) / 24.0 * TAU)


func sun_direction() -> Vector3:
	# arco leste -> oeste com inclinação para o norte (hemisfério sul)
	var a := (hour - 6.0) / 24.0 * TAU
	var d := Vector3(-cos(a), sin(a), -0.35)
	return d.normalized()


func daylight() -> float:
	return smoothstep(-0.18, 0.25, sun_height())


func is_night() -> bool:
	return daylight() < 0.2


func to_dict() -> Dictionary:
	return {"hour": hour, "day": day}


func from_dict(d: Dictionary) -> void:
	hour = float(d.get("hour", 8.0))
	day = int(d.get("day", 1))
	_last_hour = -1
	_last_period = -1
