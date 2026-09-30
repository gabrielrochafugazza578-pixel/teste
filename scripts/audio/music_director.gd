class_name MusicDirector
extends Node
## Música dinâmica em camadas: exploração, tensão e combate misturadas pelo
## nível de ameaça (AIDirector). "Cues" substituem as camadas em cinemáticas
## e menus, com crossfade.

var layers: Dictionary = {}
var threat: float = 0.0
var _threat_smooth: float = 0.0
var cue_player: AudioStreamPlayer
var cue_player_b: AudioStreamPlayer
var cue_name: String = ""
var cue_volume: float = 1.0
var layers_enabled: bool = false
var _fade_cue: float = 0.0
var _stinger_cd: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for n in ["mus_explore", "mus_tension", "mus_combat"]:
		var p := AudioStreamPlayer.new()
		p.bus = "Music"
		p.volume_db = -80.0
		add_child(p)
		layers[n] = p
	cue_player = AudioStreamPlayer.new()
	cue_player.bus = "Music"
	add_child(cue_player)
	cue_player_b = AudioStreamPlayer.new()
	cue_player_b.bus = "Music"
	add_child(cue_player_b)
	EventBus.threat_level_changed.connect(func(v: float) -> void:
		if v > threat + 0.35 and _stinger_cd <= 0.0:
			AudioManager.play_2d("stinger", -8.0, 1.0, "Music")
			_stinger_cd = 25.0
		threat = v)


func start_layers() -> void:
	layers_enabled = true
	for n in layers.keys():
		var p: AudioStreamPlayer = layers[n]
		if p.stream == null:
			p.stream = AudioManager.stream(n)
		if p.stream and not p.playing:
			p.play()


func stop_layers() -> void:
	layers_enabled = false


## Toca uma trilha única (cinemática/menu) com crossfade.
func play_cue(n: String, vol: float = 1.0) -> void:
	if n == cue_name:
		cue_volume = vol
		return
	var s := AudioManager.stream(n)
	# troca de players para crossfade
	var tmp := cue_player
	cue_player = cue_player_b
	cue_player_b = tmp
	cue_player.stream = s
	cue_player.volume_db = -40.0
	if s:
		cue_player.play()
	cue_name = n
	cue_volume = vol


func stop_cue() -> void:
	cue_name = ""


func _process(delta: float) -> void:
	_stinger_cd -= delta
	_threat_smooth = lerpf(_threat_smooth, threat, 1.0 - exp(-delta * 0.8))
	var t := _threat_smooth
	var night := 1.0 - TimeManager.daylight()
	var vols := {
		"mus_explore": (1.0 - smoothstep(0.1, 0.45, t)) * (0.75 - night * 0.25),
		"mus_tension": smoothstep(0.1, 0.45, t) * (1.0 - smoothstep(0.6, 0.85, t)) + night * 0.2 * (1.0 - t),
		"mus_combat": smoothstep(0.55, 0.85, t),
	}
	var cue_on := cue_name != ""
	for n in layers.keys():
		var p: AudioStreamPlayer = layers[n]
		var target := float(vols[n]) if layers_enabled and not cue_on else 0.0
		var db := linear_to_db(maxf(target, 0.0001))
		p.volume_db = lerpf(p.volume_db, db, 1.0 - exp(-delta * 1.2))
	var cue_target := linear_to_db(maxf(cue_volume if cue_on else 0.0, 0.0001))
	cue_player.volume_db = lerpf(cue_player.volume_db, cue_target, 1.0 - exp(-delta * 1.5))
	cue_player_b.volume_db = lerpf(cue_player_b.volume_db, -80.0, 1.0 - exp(-delta * 1.5))
	if cue_player_b.volume_db < -60.0 and cue_player_b.playing:
		cue_player_b.stop()
