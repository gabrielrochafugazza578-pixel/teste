extends Node
## WeatherManager — clima dinâmico (cadeia de Markov com transições suaves).
##
## Estados: limpo, nublado, encoberto, neblina, chuva, tempestade.
## Parâmetros contínuos (nuvens, neblina, chuva, vento, umidade acumulada)
## são publicados como uniforms globais de shader — sem custo por objeto.

enum State { CLEAR, CLOUDY, OVERCAST, FOG, RAIN, STORM }
const NAMES := ["Céu limpo", "Nublado", "Encoberto", "Neblina", "Chuva", "Tempestade"]

## Alvos por estado: [nuvens, escuridão, neblina, chuva, vento]
const TARGETS := {
	State.CLEAR: [0.12, 0.0, 0.0, 0.0, 0.25],
	State.CLOUDY: [0.5, 0.1, 0.1, 0.0, 0.4],
	State.OVERCAST: [0.85, 0.35, 0.25, 0.0, 0.5],
	State.FOG: [0.7, 0.2, 1.0, 0.0, 0.1],
	State.RAIN: [0.95, 0.55, 0.45, 0.6, 0.6],
	State.STORM: [1.0, 0.85, 0.55, 1.0, 1.0],
}
const TRANSITIONS := {
	State.CLEAR: [[State.CLEAR, 4], [State.CLOUDY, 4], [State.FOG, 1]],
	State.CLOUDY: [[State.CLEAR, 3], [State.OVERCAST, 3], [State.RAIN, 1], [State.CLOUDY, 2]],
	State.OVERCAST: [[State.RAIN, 4], [State.CLOUDY, 3], [State.STORM, 1], [State.FOG, 1]],
	State.FOG: [[State.CLOUDY, 3], [State.CLEAR, 2], [State.OVERCAST, 1]],
	State.RAIN: [[State.OVERCAST, 3], [State.STORM, 1], [State.RAIN, 2], [State.CLOUDY, 1]],
	State.STORM: [[State.RAIN, 4], [State.OVERCAST, 1]],
}

var state: int = State.CLOUDY
var clouds: float = 0.5
var darkness: float = 0.1
var fog: float = 0.1
var rain: float = 0.0
var wind: float = 0.4
var wind_dir := Vector2(1, 0.3).normalized()
var wetness: float = 0.0
var lightning: float = 0.0
var locked: bool = false
var transition_rate: float = 0.02
var _hours_left: float = 6.0
var _lightning_timer: float = 8.0
var _gust: float = 0.0
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	_rng.randomize()
	_publish()


func set_weather(s: int, instant: bool = false, lock: bool = false, hours: float = 6.0) -> void:
	state = s
	locked = lock
	_hours_left = hours
	if instant:
		var t: Array = TARGETS[s]
		clouds = t[0]
		darkness = t[1]
		fog = t[2]
		rain = t[3]
		wind = t[4]
		if rain > 0.3:
			wetness = 0.9
	EventBus.weather_changed.emit(state)


func _process(delta: float) -> void:
	var game_hours := delta * TimeManager.hours_per_second() * TimeManager.time_scale
	if not locked and GameState.in_game:
		_hours_left -= game_hours
		if _hours_left <= 0.0:
			var nxt = Util.weighted_pick(TRANSITIONS[state], _rng)
			state = int(nxt)
			_hours_left = _rng.randf_range(2.0, 9.0)
			EventBus.weather_changed.emit(state)
	var t: Array = TARGETS[state]
	var k := 1.0 - exp(-delta * (0.25 if locked else 0.06))
	clouds = lerpf(clouds, t[0], k)
	darkness = lerpf(darkness, t[1], k)
	fog = lerpf(fog, t[2], k)
	rain = lerpf(rain, t[3], k * 1.4)
	wind = lerpf(wind, t[4], k)
	# rajadas
	_gust = lerpf(_gust, _rng.randf(), delta * 0.5)
	wind_dir = wind_dir.rotated(sin(Time.get_ticks_msec() * 0.00005) * delta * 0.02).normalized()
	# umidade: sobe com chuva, seca devagar (mais rápido com sol)
	if rain > 0.05:
		wetness = minf(1.0, wetness + delta * rain * 0.05)
	else:
		wetness = maxf(0.0, wetness - delta * (0.004 + TimeManager.daylight() * 0.01))
	# relâmpagos
	lightning = maxf(0.0, lightning - delta * 4.0)
	if state == State.STORM and rain > 0.6:
		_lightning_timer -= delta
		if _lightning_timer <= 0.0:
			_lightning_timer = _rng.randf_range(5.0, 20.0)
			_strike()
	_publish()


func _strike() -> void:
	lightning = 1.0 if not Settings.accessibility.get("reduce_flashing", false) else 0.35
	var focus := SimScheduler.focus_position
	var p := focus + Vector3(_rng.randf_range(-600, 600), 0, _rng.randf_range(-600, 600))
	EventBus.lightning_strike.emit(p)
	var dist := p.distance_to(focus)
	get_tree().create_timer(clampf(dist / 343.0, 0.3, 4.0)).timeout.connect(func() -> void:
		AudioManager.play_2d("thunder", lerpf(0.0, -12.0, clampf(dist / 800.0, 0.0, 1.0)), _rng.randf_range(0.8, 1.1)))


func strike_now() -> void:
	_strike()


func _publish() -> void:
	RenderingServer.global_shader_parameter_set("wetness", wetness)
	RenderingServer.global_shader_parameter_set("rain_intensity", rain)
	RenderingServer.global_shader_parameter_set("wind", Vector4(wind_dir.x, wind_dir.y, wind * (0.7 + _gust * 0.6), _gust))


## Temperatura ambiente aproximada (°C) na posição (altitude e clima).
func temperature_at(pos: Vector3, indoors: bool = false) -> float:
	var h := TimeManager.hour
	var daily := 20.0 + 7.0 * sin((h - 9.0) / 24.0 * TAU)
	daily -= clouds * 2.0 + rain * 4.0 + (3.0 if state == State.STORM else 0.0)
	daily -= maxf(0.0, pos.y - 10.0) * 0.08
	daily -= wind * 2.0 * (0.0 if indoors else 1.0)
	if indoors:
		daily = lerpf(daily, 22.0, 0.45)
	return daily


func state_name() -> String:
	return NAMES[state]


func to_dict() -> Dictionary:
	return {"state": state, "clouds": clouds, "fog": fog, "rain": rain, "wind": wind, "wetness": wetness, "left": _hours_left}


func from_dict(d: Dictionary) -> void:
	state = int(d.get("state", State.CLOUDY))
	clouds = float(d.get("clouds", 0.5))
	fog = float(d.get("fog", 0.1))
	rain = float(d.get("rain", 0.0))
	wind = float(d.get("wind", 0.4))
	wetness = float(d.get("wetness", 0.0))
	_hours_left = float(d.get("left", 5.0))
	locked = false
