class_name AmbienceController
extends Node
## Mistura as camadas de ambiência (vento, chuva, noite, pássaros, cidade,
## rio, floresta, túnel, laboratório) pela posição do ouvinte, hora e clima,
## e dispara sons distantes esporádicos (tiros, gritos, cães, metal) que
## dão vida ao mundo sem simular nada de verdade.

const LOOPS := ["amb_wind", "amb_rain", "amb_rain_indoor", "amb_night", "amb_birds", "amb_city", "amb_river", "amb_forest", "amb_tunnel", "amb_lab", "crowd_panic", "siren"]

var world: World = null
var listener: Node3D = null
var mode: String = "outdoor"        # outdoor | indoor | tunnel | lab | underground
var phase_override: int = -1        # cinemática: força camadas da fase PRE/SILENCE
var panic: float = 0.0              # cinemática: multidão em pânico / sirenes
var enabled: bool = true
var _vols: Dictionary = {}
var _one_shot_t: float = 12.0
var _rng := RandomNumberGenerator.new()
var _started: bool = false


func _ready() -> void:
	_rng.randomize()


func start() -> void:
	if _started:
		return
	_started = true
	for n in LOOPS:
		AudioManager.loop_2d(n, n, -60.0, "Ambience" if n != "siren" else "SFX")
		_vols[n] = 0.0


func stop() -> void:
	_started = false
	for n in LOOPS:
		AudioManager.stop_loop(n)


func _process(delta: float) -> void:
	if not _started or listener == null or not is_instance_valid(listener):
		return
	var p := listener.global_position
	var phase := GameState.world_phase if phase_override < 0 else phase_override
	var dl := TimeManager.daylight()
	var night := 1.0 - dl
	var rain := WeatherManager.rain
	var wind := WeatherManager.wind
	var inside := mode in ["indoor", "lab", "underground"]
	var tunnel := mode == "tunnel"
	var urban := 0.0
	var forest := 0.0
	var river := 0.0
	if world:
		urban = 1.0 if WorldLayout.URBAN.has_point(Vector2(p.x, p.z)) else 0.0
		var rd := world.layout.river_distance(p.x, p.z)
		river = clampf(1.0 - (rd - WorldLayout.RIVER_HALF) / 70.0, 0.0, 1.0)
		var le := ((Vector2(p.x, p.z) - WorldLayout.LAKE_CENTER) / WorldLayout.LAKE_R).length()
		river = maxf(river, clampf(1.6 - le, 0.0, 1.0) * 0.6)
		var dist := world.district_at(p)
		forest = 1.0 if dist in ["floresta", "rural", "serra", "parque_norte"] else 0.0
	var outside_f := 0.0 if inside or tunnel else 1.0
	var v := {
		"amb_wind": (0.18 + wind * 0.55) * (outside_f + (0.25 if inside else 0.0)) * (1.0 if mode != "underground" else 0.0),
		"amb_rain": rain * outside_f * 0.9,
		"amb_rain_indoor": rain * (0.55 if inside and mode != "underground" else 0.0),
		"amb_night": night * outside_f * (1.0 - rain * 0.7) * 0.7 * (1.0 if phase != GameState.Phase.PRE else 0.4),
		"amb_birds": dl * outside_f * (1.0 - rain) * (0.25 + forest * 0.6) * (1.0 if phase != GameState.Phase.PRE else 0.5),
		"amb_city": (0.75 if phase == GameState.Phase.PRE else 0.0) * urban * outside_f * (0.4 + dl * 0.6),
		"amb_river": river * outside_f * 0.7,
		"amb_forest": forest * outside_f * 0.5 * (1.0 - rain * 0.5),
		"amb_tunnel": 0.8 if tunnel else 0.0,
		"amb_lab": 0.7 if mode in ["lab", "underground"] else 0.0,
		"crowd_panic": panic * 0.8,
		"siren": panic * 0.45,
	}
	if not enabled:
		for k in v.keys():
			v[k] = 0.0
	for n in LOOPS:
		AudioManager.set_loop_volume(n, float(v[n]), delta, 1.2)
	# sons distantes (somente no mundo pós-colapso)
	if phase == GameState.Phase.POST and enabled and mode != "underground":
		_one_shot_t -= delta
		if _one_shot_t <= 0.0:
			_one_shot_t = _rng.randf_range(18.0, 55.0) * (0.7 if night > 0.5 else 1.0)
			_distant_one_shot(p, night)


func _distant_one_shot(p: Vector3, night: float) -> void:
	var pool := ["distant_scream", "distant_shot", "dog_bark", "metal_clang", "infected_groan2", "glass_break"]
	var w := [1.0 + night, 0.8, 0.9 * (1.0 - night * 0.5), 0.7, 1.2 + night, 0.5]
	var total := 0.0
	for x in w:
		total += float(x)
	var r := _rng.randf() * total
	var pick := 0
	for i in w.size():
		r -= float(w[i])
		if r <= 0.0:
			pick = i
			break
	var ang := _rng.randf() * TAU
	var d := _rng.randf_range(40.0, 70.0)
	var pos := p + Vector3(cos(ang) * d, _rng.randf_range(2.0, 10.0), sin(ang) * d)
	AudioManager.play_3d(pool[pick], pos, -12.0 if pool[pick] != "distant_shot" else -9.0, _rng.randf_range(0.8, 1.05), 90.0)
