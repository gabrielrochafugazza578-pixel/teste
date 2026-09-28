extends Node
## AudioManager — barramentos, pool de players 3D/2D, loops e música dinâmica.
##
## Barramentos: Master > Music, SFX (com reverb variável), Ambience (com
## passa-baixa quando em interiores), Voice, UI. Players 3D usam atenuação
## com filtro de distância (sons distantes ficam abafados — informação
## espacial para o jogador).

signal audio_ready

const POOL_3D := 26
const POOL_2D := 10

var streams: Dictionary = {}
var is_ready: bool = false
var generating: bool = false
var progress: float = 0.0
var music: MusicDirector
var env_mode: String = "outdoor"

var _pool3d: Array = []
var _pool2d: Array = []
var _i3: int = 0
var _i2: int = 0
var _loops: Dictionary = {}
var _reverb: AudioEffectReverb
var _amb_lp: AudioEffectLowPassFilter
var _task_id: int = -1
var _pcm: Dictionary = {}
var _mutex := Mutex.new()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_buses()
	for i in POOL_3D:
		var p := AudioStreamPlayer3D.new()
		p.bus = "SFX"
		p.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
		p.unit_size = 4.0
		p.max_distance = 60.0
		p.attenuation_filter_cutoff_hz = 6000.0
		p.attenuation_filter_db = -18.0
		p.doppler_tracking = AudioStreamPlayer3D.DOPPLER_TRACKING_DISABLED
		add_child(p)
		_pool3d.append(p)
	for i in POOL_2D:
		var p := AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		_pool2d.append(p)
	music = MusicDirector.new()
	add_child(music)


func _setup_buses() -> void:
	var names := ["Music", "SFX", "Ambience", "Voice", "UI"]
	for n in names:
		if AudioServer.get_bus_index(n) < 0:
			AudioServer.add_bus()
			var idx := AudioServer.bus_count - 1
			AudioServer.set_bus_name(idx, n)
			AudioServer.set_bus_send(idx, "Master")
	var sfx := AudioServer.get_bus_index("SFX")
	_reverb = AudioEffectReverb.new()
	_reverb.room_size = 0.3
	_reverb.damping = 0.6
	_reverb.wet = 0.06
	_reverb.dry = 1.0
	_reverb.spread = 0.8
	AudioServer.add_bus_effect(sfx, _reverb)
	var amb := AudioServer.get_bus_index("Ambience")
	_amb_lp = AudioEffectLowPassFilter.new()
	_amb_lp.cutoff_hz = 20000.0
	AudioServer.add_bus_effect(amb, _amb_lp)
	var mus := AudioServer.get_bus_index("Music")
	var comp := AudioEffectCompressor.new()
	comp.threshold = -12.0
	comp.ratio = 3.0
	AudioServer.add_bus_effect(mus, comp)


# ---------------------------------------------------------------------------
# Geração dos sons (thread)
# ---------------------------------------------------------------------------
func generate_async() -> void:
	if is_ready or generating:
		if generating:
			await audio_ready
		return
	generating = true
	var list := SoundBank.names()
	if OS.get_cmdline_user_args().has("--no-audio"):
		list = []
	_task_id = WorkerThreadPool.add_task(_generate_worker.bind(list), true, "Síntese de áudio")
	while not WorkerThreadPool.is_task_completed(_task_id):
		await get_tree().process_frame
	WorkerThreadPool.wait_for_task_completion(_task_id)
	for n in _pcm.keys():
		streams[n] = Synth.to_stream(_pcm[n], SoundBank.is_loop(n))
	_pcm.clear()
	generating = false
	is_ready = true
	audio_ready.emit()


func _generate_worker(list: Array) -> void:
	var total := float(maxi(list.size(), 1))
	var done := 0
	for n in list:
		var pcm := SoundBank.load_or_generate(n)
		_mutex.lock()
		_pcm[n] = pcm
		_mutex.unlock()
		done += 1
		progress = float(done) / total


func stream(n: String) -> AudioStream:
	return streams.get(n, null)


# ---------------------------------------------------------------------------
# Reprodução
# ---------------------------------------------------------------------------
func play_2d(n: String, vol_db: float = 0.0, pitch: float = 1.0, bus: String = "SFX") -> AudioStreamPlayer:
	var s := stream(n)
	if s == null:
		return null
	var p: AudioStreamPlayer = _pool2d[_i2]
	_i2 = (_i2 + 1) % POOL_2D
	p.stream = s
	p.volume_db = vol_db
	p.pitch_scale = pitch
	p.bus = bus
	p.play()
	return p


func play_ui(n: String, vol_db: float = -4.0) -> void:
	play_2d(n, vol_db, randf_range(0.97, 1.03), "UI")


func play_3d(n: String, pos: Vector3, vol_db: float = 0.0, pitch: float = -1.0, max_dist: float = 55.0, bus: String = "SFX") -> AudioStreamPlayer3D:
	var s := stream(n)
	if s == null:
		return null
	# descarta sons muito distantes do ouvinte (economia)
	if pos.distance_squared_to(SimScheduler.focus_position) > max_dist * max_dist * 1.2:
		return null
	var p: AudioStreamPlayer3D = _pool3d[_i3]
	_i3 = (_i3 + 1) % POOL_3D
	p.stream = s
	p.global_position = pos
	p.volume_db = vol_db
	p.pitch_scale = pitch if pitch > 0.0 else randf_range(0.92, 1.08)
	p.max_distance = max_dist
	p.bus = bus
	p.play()
	return p


## Player 3D dedicado preso a um nó (motor de carro, sirene, alarme…).
func attach_loop(n: String, parent: Node3D, vol_db: float = 0.0, max_dist: float = 80.0, bus: String = "SFX") -> AudioStreamPlayer3D:
	var p := AudioStreamPlayer3D.new()
	p.stream = stream(n)
	p.volume_db = vol_db
	p.max_distance = max_dist
	p.unit_size = 6.0
	p.bus = bus
	p.attenuation_filter_cutoff_hz = 5000.0
	p.doppler_tracking = AudioStreamPlayer3D.DOPPLER_TRACKING_DISABLED
	parent.add_child(p)
	if p.stream:
		p.play()
	return p


func loop_2d(id: String, n: String, vol_db: float = 0.0, bus: String = "Ambience") -> AudioStreamPlayer:
	var p: AudioStreamPlayer
	if _loops.has(id):
		p = _loops[id]
	else:
		p = AudioStreamPlayer.new()
		add_child(p)
		_loops[id] = p
	var s := stream(n)
	if p.stream != s:
		p.stream = s
		p.volume_db = vol_db
		p.bus = bus
		if s:
			p.play(randf() * 2.0)
	return p


func set_loop_volume(id: String, vol_linear: float, delta: float = 1.0, rate: float = 1.5) -> void:
	if not _loops.has(id):
		return
	var p: AudioStreamPlayer = _loops[id]
	var target := linear_to_db(maxf(vol_linear, 0.0001))
	p.volume_db = lerpf(p.volume_db, target, 1.0 - exp(-rate * delta))
	if vol_linear <= 0.001 and p.volume_db < -50.0:
		p.stream_paused = true
	elif p.stream_paused:
		p.stream_paused = false


func stop_loop(id: String) -> void:
	if _loops.has(id):
		var p: AudioStreamPlayer = _loops[id]
		p.stop()
		p.stream = null


func stop_all_loops() -> void:
	for id in _loops.keys():
		stop_loop(id)


func footstep(surface: String, pos: Vector3, loudness: float) -> void:
	var n := "step_" + surface
	if not streams.has(n):
		n = "step_asphalt"
	play_3d(n, pos, linear_to_db(clampf(loudness, 0.05, 1.2)) - 4.0, randf_range(0.88, 1.12), 30.0)


## Acústica do ambiente atual (reverb/abafamento).
func set_environment(mode: String) -> void:
	if mode == env_mode:
		return
	env_mode = mode
	match mode:
		"indoor":
			_reverb.room_size = 0.35
			_reverb.wet = 0.16
			_amb_lp.cutoff_hz = 1100.0
		"tunnel":
			_reverb.room_size = 0.9
			_reverb.wet = 0.42
			_reverb.damping = 0.3
			_amb_lp.cutoff_hz = 2500.0
		"lab":
			_reverb.room_size = 0.55
			_reverb.wet = 0.22
			_amb_lp.cutoff_hz = 900.0
		_:
			_reverb.room_size = 0.3
			_reverb.wet = 0.06
			_reverb.damping = 0.6
			_amb_lp.cutoff_hz = 20000.0
