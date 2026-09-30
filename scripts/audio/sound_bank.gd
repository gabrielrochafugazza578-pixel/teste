class_name SoundBank
extends RefCounted
## Receitas de todos os sons do jogo (sintetizados por Synth).
## Primeira execução: gera em thread (~alguns segundos) e salva em cache.

const CACHE_DIR := "user://cache/audio_v3"

const LOOPS := ["amb_wind", "amb_rain", "amb_rain_indoor", "amb_city", "amb_night", "amb_birds", "amb_tunnel", "amb_lab",
	"amb_fire", "amb_river", "amb_forest", "alarm", "siren", "helicopter", "car_engine", "radio_static", "electric_hum",
	"heartbeat", "mus_explore", "mus_tension", "mus_combat", "mus_opening_calm", "mus_opening_dark", "mus_silence", "mus_title", "crowd_panic"]

const ONESHOTS := ["step_asphalt", "step_grass", "step_wood", "step_metal", "step_water", "step_gravel", "swing", "swing_heavy",
	"hit_blunt", "hit_sharp", "hit_flesh", "block", "parry", "shove", "body_fall", "door_open", "door_close", "door_locked",
	"door_force", "door_bash", "barricade_hit", "search", "pickup", "eat", "drink", "bandage", "craft", "ui_click", "ui_open",
	"ui_close", "notify", "car_horn", "car_crash", "glass_break", "bottle_break", "can_rattle", "thunder", "infected_groan",
	"infected_groan2", "infected_scream", "infected_growl", "brute_roar", "infected_attack", "spores", "tape_click",
	"flashlight_click", "gun_shot", "bow_shot", "firecracker", "dog_bark", "distant_scream", "distant_shot", "metal_clang",
	"sparks", "steam_hiss", "cough", "gasp", "jump_land", "vault", "stinger", "news_jingle", "phone_ring", "power_down", "vehicle_start"]


static func names() -> Array:
	var a: Array = LOOPS.duplicate()
	a.append_array(ONESHOTS)
	return a


static func is_loop(n: String) -> bool:
	return n in LOOPS


## Retorna PCM 16 bits (gera ou lê do cache).
static func load_or_generate(n: String) -> PackedByteArray:
	var path := CACHE_DIR + "/" + n + ".pcm"
	if FileAccess.file_exists(path):
		var f := FileAccess.open(path, FileAccess.READ)
		if f:
			var data := f.get_buffer(f.get_length())
			if data.size() > 0:
				return data
	var b := generate(n)
	var pcm := Synth.to_pcm(b)
	DirAccess.make_dir_recursive_absolute(CACHE_DIR)
	var fw := FileAccess.open(path, FileAccess.WRITE)
	if fw:
		fw.store_buffer(pcm)
	return pcm


static func generate(n: String) -> PackedFloat32Array:
	var b: PackedFloat32Array
	match n:
		# --- ambiência -----------------------------------------------------
		"amb_wind":
			b = Synth.buf(8.25)
			for k in 6:
				Synth.noise(b, k * 1.3, 3.0, 0.35, 0.02 + k * 0.004, 0.002, 1.2, 3.0, k)
			Synth.noise(b, 0.0, 8.25, 0.25, 0.035, 0.003, 0.5, 20.0, 99)
			b = Synth.make_loop(b)
		"amb_rain":
			b = Synth.buf(6.25)
			Synth.noise(b, 0.0, 6.25, 0.6, 0.55, 0.08, 0.1, 30.0, 3)
			Synth.noise(b, 0.0, 6.25, 0.4, 0.12, 0.0, 0.1, 30.0, 4)
			var r := Util.rng(5)
			for k in 90:
				Synth.noise(b, r.randf() * 6.0, 0.03, r.randf_range(0.15, 0.4), 0.7, 0.2, 0.001, 0.02, k)
			b = Synth.make_loop(b)
		"amb_rain_indoor":
			b = Synth.buf(6.25)
			Synth.noise(b, 0.0, 6.25, 0.5, 0.05, 0.0, 0.1, 30.0, 8)
			var r := Util.rng(9)
			for k in 14:
				Synth.tone(b, r.randf() * 6.0, 0.12, r.randf_range(900, 1600), 0.12, 0, 0.001, 0.05, r.randf_range(500, 800))
			b = Synth.make_loop(b)
		"amb_city":
			b = Synth.buf(10.25)
			Synth.noise(b, 0.0, 10.25, 0.4, 0.03, 0.0, 0.5, 60.0, 11)
			Synth.tone(b, 0.0, 10.25, 55.0, 0.08, 1, 1.0, 60.0, 58.0, 0.2, 0.02, 0.05)
			var r := Util.rng(12)
			for k in 7:
				var t := r.randf() * 9.0
				Synth.noise(b, t, 1.6, 0.25, 0.05, 0.0, 0.6, 1.4, k + 20)
			for k in 2:
				var t := r.randf() * 8.5
				Synth.tone(b, t, 0.35, 420.0, 0.06, 2, 0.01, 0.35, -1.0, 0.0, 0.0, 0.2)
				Synth.tone(b, t, 0.35, 520.0, 0.05, 2, 0.01, 0.35, -1.0, 0.0, 0.0, 0.2)
			for k in 30:
				Synth.voice(b, r.randf() * 9.5, r.randf_range(0.2, 0.6), r.randf_range(150, 260), r.randf_range(150, 260), 0.025, 0.12, 0.1, k)
			b = Synth.make_loop(b)
		"crowd_panic":
			b = Synth.buf(6.25)
			var r := Util.rng(41)
			Synth.noise(b, 0.0, 6.25, 0.3, 0.06, 0.0, 0.3, 30.0, 41)
			for k in 40:
				Synth.voice(b, r.randf() * 5.8, r.randf_range(0.3, 0.9), r.randf_range(250, 450), r.randf_range(300, 700), 0.05, 0.2, 0.2, k)
			b = Synth.make_loop(b)
		"amb_night":
			b = Synth.buf(6.25)
			Synth.noise(b, 0.0, 6.25, 0.08, 0.02, 0.0, 0.5, 30.0, 13)
			var r := Util.rng(14)
			for k in 40:
				var t := r.randf() * 6.0
				var f := r.randf_range(4200, 5200)
				for c in 3:
					Synth.tone(b, t + c * 0.045, 0.03, f, 0.06, 0, 0.002, 0.02)
			b = Synth.make_loop(b)
		"amb_birds":
			b = Synth.buf(8.25)
			Synth.noise(b, 0.0, 8.25, 0.06, 0.03, 0.0, 0.5, 30.0, 15)
			var r := Util.rng(16)
			for k in 22:
				var t := r.randf() * 8.0
				var f0 := r.randf_range(2200, 3800)
				Synth.tone(b, t, r.randf_range(0.08, 0.2), f0, 0.08, 0, 0.005, 0.1, f0 * r.randf_range(0.7, 1.4), 30.0, 0.05)
			b = Synth.make_loop(b)
		"amb_tunnel":
			b = Synth.buf(8.25)
			Synth.tone(b, 0.0, 8.25, 42.0, 0.2, 1, 1.0, 60.0, 43.0, 0.1, 0.01, 0.03)
			Synth.noise(b, 0.0, 8.25, 0.18, 0.015, 0.0, 1.0, 40.0, 17)
			var r := Util.rng(18)
			for k in 6:
				var t := r.randf() * 8.0
				Synth.tone(b, t, 0.2, r.randf_range(700, 1100), 0.12, 0, 0.001, 0.08, 500.0)
			Synth.echo(b, 0.27, 0.45, 0.7)
			b = Synth.make_loop(b)
		"amb_lab":
			b = Synth.buf(6.25)
			Synth.tone(b, 0.0, 6.25, 120.0, 0.06, 1, 0.2, 60.0, 120.0, 0.0, 0.0, 0.1)
			Synth.tone(b, 0.0, 6.25, 60.0, 0.08, 0, 0.2, 60.0)
			Synth.noise(b, 0.0, 6.25, 0.12, 0.08, 0.01, 0.4, 40.0, 19)
			var r := Util.rng(20)
			for k in 8:
				Synth.tone(b, r.randf() * 6.0, 0.08, r.randf_range(1800, 2600), 0.03, 0, 0.002, 0.05)
			b = Synth.make_loop(b)
		"amb_fire":
			b = Synth.buf(4.25)
			Synth.noise(b, 0.0, 4.25, 0.25, 0.06, 0.0, 0.2, 30.0, 21)
			var r := Util.rng(22)
			for k in 60:
				Synth.noise(b, r.randf() * 4.0, 0.02, r.randf_range(0.2, 0.6), 0.8, 0.3, 0.001, 0.01, k + 50)
			b = Synth.make_loop(b)
		"amb_river":
			b = Synth.buf(6.25)
			Synth.noise(b, 0.0, 6.25, 0.4, 0.12, 0.02, 0.3, 40.0, 23)
			var r := Util.rng(24)
			for k in 40:
				var t := r.randf() * 6.0
				Synth.tone(b, t, 0.06, r.randf_range(400, 900), 0.05, 0, 0.004, 0.04, r.randf_range(900, 1400))
			b = Synth.make_loop(b)
		"amb_forest":
			b = Synth.buf(8.25)
			for k in 5:
				Synth.noise(b, k * 1.6, 3.0, 0.2, 0.2, 0.05, 1.0, 3.0, k + 30)
			var r := Util.rng(25)
			for k in 6:
				var t := r.randf() * 8.0
				var f0 := r.randf_range(1500, 2600)
				Synth.tone(b, t, 0.25, f0, 0.05, 0, 0.01, 0.2, f0 * 0.8, 12.0, 0.08)
			b = Synth.make_loop(b)
		"alarm":
			b = Synth.buf(2.0)
			Synth.tone(b, 0.0, 0.5, 780.0, 0.3, 2, 0.01, 2.0, -1.0, 0.0, 0.0, 0.25)
			Synth.tone(b, 0.5, 0.5, 980.0, 0.3, 2, 0.01, 2.0, -1.0, 0.0, 0.0, 0.25)
			Synth.tone(b, 1.0, 0.5, 780.0, 0.3, 2, 0.01, 2.0, -1.0, 0.0, 0.0, 0.25)
			Synth.tone(b, 1.5, 0.5, 980.0, 0.3, 2, 0.01, 2.0, -1.0, 0.0, 0.0, 0.25)
		"siren":
			b = Synth.buf(3.2)
			Synth.tone(b, 0.0, 1.6, 620.0, 0.3, 3, 0.02, 20.0, 1350.0)
			Synth.tone(b, 1.6, 1.6, 1350.0, 0.3, 3, 0.02, 20.0, 620.0)
		"helicopter":
			b = Synth.buf(2.0)
			for k in 14:
				Synth.noise(b, k / 7.0, 0.1, 0.6, 0.08, 0.0, 0.002, 0.08, k)
			Synth.tone(b, 0.0, 2.0, 320.0, 0.05, 1, 0.1, 30.0, 320.0, 3.0, 0.01, 0.2)
		"car_engine":
			b = Synth.buf(1.0)
			for k in 30:
				Synth.noise(b, k / 30.0, 0.04, 0.35, 0.06, 0.0, 0.002, 0.03, k)
			Synth.tone(b, 0.0, 1.0, 60.0, 0.2, 1, 0.01, 30.0, 60.0, 0.0, 0.0, 0.08)
			Synth.tone(b, 0.0, 1.0, 120.0, 0.08, 1, 0.01, 30.0, 120.0, 0.0, 0.0, 0.15)
		"radio_static":
			b = Synth.buf(2.25)
			Synth.noise(b, 0.0, 2.25, 0.35, 0.9, 0.3, 0.01, 20.0, 33)
			var r := Util.rng(34)
			for k in 30:
				Synth.noise(b, r.randf() * 2.2, 0.01, 0.6, 0.95, 0.5, 0.001, 0.005, k)
			b = Synth.make_loop(b)
		"electric_hum":
			b = Synth.buf(1.0)
			Synth.tone(b, 0.0, 1.0, 120.0, 0.2, 1, 0.01, 30.0, 120.0, 0.0, 0.0, 0.2)
			Synth.tone(b, 0.0, 1.0, 240.0, 0.08, 2, 0.01, 30.0, 240.0, 0.0, 0.0, 0.2)
		"heartbeat":
			b = Synth.buf(0.9)
			Synth.tone(b, 0.0, 0.15, 60.0, 0.9, 0, 0.005, 0.1, 40.0)
			Synth.tone(b, 0.2, 0.15, 55.0, 0.6, 0, 0.005, 0.1, 38.0)
		# --- música ---------------------------------------------------------
		"mus_explore":
			b = Synth.buf(16.5)
			var chords := [[57, 60, 64], [53, 57, 60], [48, 52, 55], [52, 56, 59]]
			for k in 4:
				var fr: Array = []
				for m in chords[k]:
					fr.append(Synth.note(int(m) - 12))
				Synth.pad(b, k * 4.0, 4.5, fr, 0.25, 0.05, 1.5, 1.5)
			var r := Util.rng(40)
			for k in 10:
				var t := r.randf() * 15.0
				Synth.pluck(b, t, Synth.note([69, 72, 76, 64, 67][r.randi() % 5]), 0.18, 2.5, 0.3)
			Synth.echo(b, 0.45, 0.4, 0.6)
			b = Synth.make_loop(b, 0.5)
		"mus_tension":
			b = Synth.buf(12.5)
			Synth.tone(b, 0.0, 12.5, 36.7, 0.3, 1, 2.0, 60.0, 36.7, 0.2, 0.01, 0.03)
			for k in 12:
				Synth.tone(b, k * 1.0, 0.25, 55.0, 0.35, 0, 0.005, 0.2, 40.0)
			Synth.tone(b, 0.0, 12.5, 880.0, 0.03, 3, 3.0, 60.0, 932.0, 5.0, 0.004)
			Synth.pad(b, 0.0, 12.5, [Synth.note(45), Synth.note(46)], 0.12, 0.03, 3.0, 2.0)
			b = Synth.make_loop(b, 0.5)
		"mus_combat":
			b = Synth.buf(8.5)
			for k in 32:
				var t := k * 0.25
				Synth.tone(b, t, 0.18, 70.0 if k % 4 == 0 else 95.0, 0.5 if k % 4 == 0 else 0.25, 0, 0.002, 0.12, 45.0)
				if k % 2 == 1:
					Synth.noise(b, t, 0.06, 0.2, 0.5, 0.2, 0.001, 0.04, k)
			Synth.pad(b, 0.0, 8.5, [Synth.note(40), Synth.note(47), Synth.note(52)], 0.18, 0.06, 0.5, 0.5)
			Synth.tone(b, 0.0, 8.5, 440.0, 0.03, 1, 0.5, 60.0, 466.0, 7.0, 0.01, 0.2)
			b = Synth.make_loop(b, 0.25)
		"mus_opening_calm":
			b = Synth.buf(16.5)
			var chords2 := [[60, 64, 67], [57, 60, 64], [53, 57, 60], [55, 59, 62]]
			for k in 4:
				var fr: Array = []
				for m in chords2[k]:
					fr.append(Synth.note(int(m) - 12))
				Synth.pad(b, k * 4.0, 4.5, fr, 0.2, 0.07, 1.0, 1.2)
			var arp := [72, 76, 79, 76, 69, 72, 76, 72, 65, 69, 72, 69, 67, 71, 74, 71]
			for k in 16:
				Synth.pluck(b, k * 1.0, Synth.note(arp[k]), 0.2, 2.0, 0.55)
			Synth.echo(b, 0.5, 0.35, 0.5)
			b = Synth.make_loop(b, 0.5)
		"mus_opening_dark":
			b = Synth.buf(12.5)
			Synth.pad(b, 0.0, 12.5, [Synth.note(38), Synth.note(45), Synth.note(51)], 0.3, 0.03, 3.0, 3.0)
			Synth.tone(b, 0.0, 12.5, 1244.0, 0.02, 3, 4.0, 60.0, 1180.0, 4.0, 0.006)
			for k in 3:
				Synth.tone(b, k * 4.0 + 1.0, 1.5, 49.0, 0.4, 0, 0.01, 1.2, 30.0)
			b = Synth.make_loop(b, 0.5)
		"mus_silence":
			b = Synth.buf(16.5)
			var notes := [64, 67, 71, 69, 64, 62, 60, 59]
			for k in 8:
				Synth.pluck(b, k * 2.0 + 0.3, Synth.note(notes[k]), 0.25, 3.5, 0.35)
			Synth.pad(b, 0.0, 16.5, [Synth.note(40), Synth.note(47)], 0.1, 0.03, 4.0, 4.0)
			Synth.echo(b, 0.6, 0.45, 0.6)
			b = Synth.make_loop(b, 0.5)
		"mus_title":
			b = Synth.buf(16.5)
			var ch := [[45, 52, 57], [41, 48, 53], [43, 50, 55], [40, 47, 52]]
			for k in 4:
				var fr: Array = []
				for m in ch[k]:
					fr.append(Synth.note(int(m)))
				Synth.pad(b, k * 4.0, 4.5, fr, 0.22, 0.04, 2.0, 1.5)
			for k in 8:
				Synth.pluck(b, k * 2.0 + 1.0, Synth.note([69, 72, 71, 67, 69, 64, 65, 64][k]), 0.22, 3.0, 0.3)
			Synth.echo(b, 0.55, 0.45, 0.6)
			b = Synth.make_loop(b, 0.5)
		# --- passos ---------------------------------------------------------
		"step_asphalt":
			b = Synth.buf(0.16)
			Synth.noise(b, 0.0, 0.14, 0.7, 0.35, 0.05, 0.002, 0.05, 1)
			Synth.tone(b, 0.0, 0.05, 140.0, 0.3, 0, 0.001, 0.03, 80.0)
		"step_grass":
			b = Synth.buf(0.22)
			Synth.noise(b, 0.0, 0.2, 0.45, 0.6, 0.15, 0.01, 0.12, 2)
			Synth.noise(b, 0.03, 0.15, 0.3, 0.4, 0.1, 0.01, 0.1, 3)
		"step_wood":
			b = Synth.buf(0.2)
			Synth.tone(b, 0.0, 0.12, 190.0, 0.5, 3, 0.001, 0.07, 150.0)
			Synth.noise(b, 0.0, 0.08, 0.35, 0.3, 0.05, 0.001, 0.04, 4)
		"step_metal":
			b = Synth.buf(0.35)
			Synth.tone(b, 0.0, 0.3, 520.0, 0.25, 0, 0.001, 0.15)
			Synth.tone(b, 0.0, 0.3, 833.0, 0.18, 0, 0.001, 0.12)
			Synth.noise(b, 0.0, 0.06, 0.4, 0.5, 0.1, 0.001, 0.03, 5)
		"step_water":
			b = Synth.buf(0.3)
			Synth.noise(b, 0.0, 0.25, 0.5, 0.5, 0.1, 0.005, 0.12, 6)
			Synth.tone(b, 0.02, 0.1, 500.0, 0.15, 0, 0.002, 0.06, 900.0)
		"step_gravel":
			b = Synth.buf(0.22)
			var r := Util.rng(7)
			for k in 12:
				Synth.noise(b, r.randf() * 0.15, 0.015, 0.5, 0.7, 0.2, 0.001, 0.01, k)
			Synth.noise(b, 0.0, 0.15, 0.3, 0.3, 0.05, 0.003, 0.08, 8)
		# --- combate --------------------------------------------------------
		"swing":
			b = Synth.buf(0.35)
			Synth.noise(b, 0.0, 0.32, 0.6, 0.08, 0.02, 0.1, 0.25, 9, 0.35)
		"swing_heavy":
			b = Synth.buf(0.55)
			Synth.noise(b, 0.0, 0.5, 0.7, 0.05, 0.01, 0.2, 0.35, 10, 0.25)
		"hit_blunt":
			b = Synth.buf(0.35)
			Synth.tone(b, 0.0, 0.25, 110.0, 0.8, 0, 0.001, 0.12, 45.0)
			Synth.noise(b, 0.0, 0.12, 0.6, 0.25, 0.05, 0.001, 0.05, 11)
		"hit_sharp":
			b = Synth.buf(0.3)
			Synth.noise(b, 0.0, 0.18, 0.7, 0.7, 0.3, 0.001, 0.06, 12)
			Synth.tone(b, 0.0, 0.1, 160.0, 0.4, 0, 0.001, 0.06, 70.0)
		"hit_flesh":
			b = Synth.buf(0.35)
			Synth.tone(b, 0.0, 0.2, 90.0, 0.7, 0, 0.001, 0.1, 50.0)
			Synth.noise(b, 0.0, 0.25, 0.5, 0.15, 0.02, 0.002, 0.12, 13)
		"block":
			b = Synth.buf(0.3)
			Synth.tone(b, 0.0, 0.2, 880.0, 0.3, 3, 0.001, 0.06)
			Synth.tone(b, 0.0, 0.2, 1420.0, 0.2, 0, 0.001, 0.05)
			Synth.noise(b, 0.0, 0.05, 0.5, 0.6, 0.2, 0.001, 0.02, 14)
		"parry":
			b = Synth.buf(0.9)
			for f: float in [1180.0, 1870.0, 2650.0, 3300.0]:
				Synth.tone(b, 0.0, 0.85, f, 0.18, 0, 0.001, 0.5)
			Synth.noise(b, 0.0, 0.05, 0.5, 0.8, 0.3, 0.001, 0.02, 15)
		"shove":
			b = Synth.buf(0.3)
			Synth.noise(b, 0.0, 0.25, 0.5, 0.15, 0.02, 0.01, 0.12, 16)
			Synth.tone(b, 0.02, 0.12, 100.0, 0.4, 0, 0.002, 0.08, 60.0)
		"body_fall":
			b = Synth.buf(0.6)
			Synth.tone(b, 0.0, 0.3, 70.0, 0.9, 0, 0.002, 0.18, 40.0)
			Synth.noise(b, 0.0, 0.45, 0.5, 0.12, 0.01, 0.005, 0.2, 17)
			Synth.tone(b, 0.18, 0.2, 60.0, 0.4, 0, 0.002, 0.1, 40.0)
		# --- portas / objetos -------------------------------------------------
		"door_open":
			b = Synth.buf(0.9)
			Synth.tone(b, 0.0, 0.8, 290.0, 0.18, 1, 0.1, 0.8, 470.0, 9.0, 0.03, 0.1)
			Synth.noise(b, 0.0, 0.6, 0.12, 0.3, 0.1, 0.05, 0.4, 18)
		"door_close":
			b = Synth.buf(0.4)
			Synth.tone(b, 0.0, 0.25, 85.0, 0.8, 0, 0.001, 0.12, 55.0)
			Synth.noise(b, 0.0, 0.1, 0.5, 0.4, 0.1, 0.001, 0.04, 19)
		"door_locked":
			b = Synth.buf(0.4)
			for k in 3:
				Synth.tone(b, k * 0.09, 0.05, 1200.0, 0.3, 2, 0.001, 0.02, -1.0, 0.0, 0.0, 0.3)
				Synth.noise(b, k * 0.09, 0.04, 0.4, 0.7, 0.3, 0.001, 0.02, k)
		"door_force":
			b = Synth.buf(1.0)
			Synth.tone(b, 0.0, 0.7, 220.0, 0.2, 1, 0.1, 0.6, 380.0, 12.0, 0.05, 0.12)
			Synth.noise(b, 0.6, 0.3, 0.8, 0.6, 0.2, 0.001, 0.1, 20)
			Synth.tone(b, 0.6, 0.2, 100.0, 0.6, 0, 0.001, 0.1, 50.0)
		"door_bash", "barricade_hit":
			b = Synth.buf(0.6)
			Synth.tone(b, 0.0, 0.35, 75.0, 0.9, 0, 0.001, 0.2, 40.0)
			Synth.noise(b, 0.0, 0.3, 0.6, 0.3 if n == "door_bash" else 0.45, 0.05, 0.001, 0.12, 21)
		"search":
			b = Synth.buf(0.7)
			for k in 5:
				Synth.noise(b, k * 0.12, 0.14, 0.4, 0.45, 0.12, 0.02, 0.1, k + 60)
		"pickup":
			b = Synth.buf(0.25)
			Synth.noise(b, 0.0, 0.15, 0.4, 0.4, 0.1, 0.005, 0.08, 22)
			Synth.tone(b, 0.0, 0.08, 400.0, 0.1, 0, 0.002, 0.05, 600.0)
		"eat":
			b = Synth.buf(0.8)
			for k in 6:
				Synth.noise(b, k * 0.12, 0.06, 0.4, 0.6, 0.2, 0.001, 0.04, k + 70)
		"drink":
			b = Synth.buf(0.9)
			for k in 4:
				Synth.tone(b, k * 0.2, 0.12, 160.0, 0.4, 0, 0.01, 0.08, 110.0)
				Synth.noise(b, k * 0.2, 0.1, 0.15, 0.3, 0.1, 0.01, 0.06, k + 80)
		"bandage":
			b = Synth.buf(0.8)
			Synth.noise(b, 0.0, 0.6, 0.5, 0.5, 0.2, 0.05, 0.5, 23, 0.8)
		"craft":
			b = Synth.buf(0.9)
			for k in 3:
				Synth.tone(b, k * 0.25, 0.15, 420.0, 0.3, 0, 0.001, 0.08, 300.0)
				Synth.noise(b, k * 0.25, 0.06, 0.4, 0.5, 0.2, 0.001, 0.03, k + 90)
		"ui_click":
			b = Synth.buf(0.05)
			Synth.tone(b, 0.0, 0.04, 2200.0, 0.3, 0, 0.001, 0.015)
		"ui_open":
			b = Synth.buf(0.25)
			Synth.noise(b, 0.0, 0.2, 0.3, 0.1, 0.02, 0.05, 0.15, 24, 0.4)
		"ui_close":
			b = Synth.buf(0.2)
			Synth.noise(b, 0.0, 0.15, 0.3, 0.4, 0.05, 0.02, 0.1, 25, 0.1)
		"notify":
			b = Synth.buf(0.5)
			Synth.tone(b, 0.0, 0.2, 660.0, 0.25, 0, 0.005, 0.15)
			Synth.tone(b, 0.12, 0.3, 880.0, 0.25, 0, 0.005, 0.2)
		"stinger":
			b = Synth.buf(2.5)
			Synth.tone(b, 0.0, 2.4, 55.0, 0.6, 1, 0.005, 1.5, 40.0, 0.0, 0.0, 0.1)
			Synth.noise(b, 0.0, 1.5, 0.4, 0.2, 0.0, 0.005, 1.0, 26)
			Synth.tone(b, 0.0, 2.0, 1480.0, 0.08, 3, 0.01, 1.5, 1400.0, 6.0, 0.01)
		"news_jingle":
			b = Synth.buf(1.8)
			for k in 4:
				Synth.tone(b, k * 0.2, 0.5, Synth.note([72, 76, 79, 84][k]), 0.2, 3, 0.005, 0.4)
			Synth.pad(b, 0.0, 1.8, [Synth.note(60), Synth.note(64), Synth.note(67)], 0.2, 0.1, 0.05, 0.6)
		"phone_ring":
			b = Synth.buf(1.2)
			for k in 12:
				Synth.tone(b, k * 0.05, 0.04, 1350.0, 0.2, 2, 0.001, 0.04, -1.0, 0.0, 0.0, 0.4)
		"power_down":
			b = Synth.buf(1.8)
			Synth.tone(b, 0.0, 1.7, 240.0, 0.4, 1, 0.01, 1.7, 30.0, 0.0, 0.0, 0.2)
			Synth.noise(b, 0.0, 0.2, 0.5, 0.7, 0.3, 0.001, 0.1, 27)
		# --- veículos / mundo ------------------------------------------------
		"car_horn":
			b = Synth.buf(0.7)
			Synth.tone(b, 0.0, 0.6, 400.0, 0.3, 2, 0.01, 2.0, -1.0, 0.0, 0.0, 0.3)
			Synth.tone(b, 0.0, 0.6, 505.0, 0.3, 2, 0.01, 2.0, -1.0, 0.0, 0.0, 0.3)
		"vehicle_start":
			b = Synth.buf(1.5)
			for k in 8:
				Synth.noise(b, k * 0.1, 0.07, 0.5, 0.1, 0.0, 0.002, 0.05, k)
			Synth.tone(b, 0.8, 0.7, 40.0, 0.4, 1, 0.05, 1.0, 70.0, 0.0, 0.0, 0.1)
		"car_crash":
			b = Synth.buf(1.4)
			Synth.noise(b, 0.0, 1.2, 0.9, 0.4, 0.05, 0.001, 0.6, 28)
			for f: float in [310.0, 470.0, 690.0]:
				Synth.tone(b, 0.0, 1.0, f, 0.15, 0, 0.001, 0.5)
			var r := Util.rng(29)
			for k in 20:
				Synth.tone(b, 0.1 + r.randf() * 0.6, 0.05, r.randf_range(3000, 6000), 0.08, 0, 0.001, 0.03)
		"glass_break", "bottle_break":
			b = Synth.buf(0.8)
			Synth.noise(b, 0.0, 0.2, 0.7, 0.9, 0.4, 0.001, 0.08, 30)
			var r := Util.rng(31 if n == "glass_break" else 32)
			for k in (24 if n == "glass_break" else 12):
				Synth.tone(b, r.randf() * 0.6, 0.06, r.randf_range(2500, 7000), 0.1, 0, 0.001, 0.04)
		"can_rattle":
			b = Synth.buf(0.6)
			var r := Util.rng(33)
			for k in 8:
				Synth.tone(b, r.randf() * 0.5, 0.06, r.randf_range(1400, 2400), 0.2, 2, 0.001, 0.03, -1.0, 0.0, 0.0, 0.5)
		"thunder":
			b = Synth.buf(4.5)
			Synth.noise(b, 0.0, 0.25, 0.8, 0.5, 0.05, 0.001, 0.1, 34)
			Synth.noise(b, 0.05, 4.3, 1.0, 0.012, 0.0, 0.2, 2.5, 35)
			Synth.noise(b, 0.6, 3.0, 0.5, 0.02, 0.0, 0.3, 1.5, 36)
		"metal_clang":
			b = Synth.buf(1.2)
			for f: float in [430.0, 915.0, 1530.0, 2210.0]:
				Synth.tone(b, 0.0, 1.1, f, 0.18, 0, 0.001, 0.6)
			Synth.noise(b, 0.0, 0.05, 0.6, 0.7, 0.2, 0.001, 0.02, 37)
		"sparks":
			b = Synth.buf(0.6)
			var r := Util.rng(38)
			for k in 20:
				Synth.noise(b, r.randf() * 0.5, 0.012, 0.6, 0.95, 0.6, 0.001, 0.008, k)
		"steam_hiss":
			b = Synth.buf(1.5)
			Synth.noise(b, 0.0, 1.4, 0.5, 0.9, 0.5, 0.05, 1.2, 39)
		# --- infectados -----------------------------------------------------
		"infected_groan":
			b = Synth.buf(1.6)
			Synth.voice(b, 0.0, 1.5, 95.0, 78.0, 0.8, 0.06, 0.35, 1)
			Synth.noise(b, 0.0, 1.4, 0.15, 0.08, 0.0, 0.3, 1.0, 41)
		"infected_groan2":
			b = Synth.buf(1.3)
			Synth.voice(b, 0.0, 1.2, 120.0, 150.0, 0.7, 0.09, 0.4, 2)
		"infected_growl":
			b = Synth.buf(0.9)
			Synth.voice(b, 0.0, 0.85, 72.0, 65.0, 0.9, 0.05, 0.6, 3)
		"infected_attack":
			b = Synth.buf(0.6)
			Synth.voice(b, 0.0, 0.5, 180.0, 260.0, 0.9, 0.12, 0.7, 4)
			Synth.noise(b, 0.0, 0.4, 0.3, 0.3, 0.05, 0.005, 0.2, 42)
		"infected_scream":
			b = Synth.buf(1.8)
			Synth.voice(b, 0.0, 1.7, 820.0, 1350.0, 0.8, 0.35, 0.5, 5)
			Synth.tone(b, 0.0, 1.6, 1650.0, 0.15, 1, 0.05, 1.5, 2400.0, 13.0, 0.05, 0.4)
			Synth.echo(b, 0.21, 0.3, 0.6)
		"brute_roar":
			b = Synth.buf(2.0)
			Synth.voice(b, 0.0, 1.9, 55.0, 45.0, 1.0, 0.04, 0.8, 6)
			Synth.noise(b, 0.0, 1.8, 0.4, 0.05, 0.0, 0.2, 1.4, 43)
		"spores":
			b = Synth.buf(1.8)
			Synth.noise(b, 0.0, 1.7, 0.6, 0.7, 0.4, 0.2, 1.3, 44)
			Synth.voice(b, 0.0, 1.0, 140.0, 90.0, 0.3, 0.1, 0.5, 7)
		"cough":
			b = Synth.buf(1.0)
			for k in 2:
				Synth.noise(b, k * 0.42, 0.25, 0.7, 0.3, 0.05, 0.005, 0.12, k + 45)
				Synth.voice(b, k * 0.42, 0.2, 180.0, 140.0, 0.3, 0.15, 0.6, k + 8)
		"gasp":
			b = Synth.buf(0.6)
			Synth.noise(b, 0.0, 0.5, 0.4, 0.4, 0.1, 0.1, 0.3, 46, 0.2)
		"jump_land":
			b = Synth.buf(0.3)
			Synth.tone(b, 0.0, 0.15, 90.0, 0.6, 0, 0.001, 0.08, 50.0)
			Synth.noise(b, 0.0, 0.15, 0.4, 0.3, 0.05, 0.001, 0.06, 47)
		"vault":
			b = Synth.buf(0.4)
			Synth.noise(b, 0.0, 0.35, 0.4, 0.2, 0.05, 0.05, 0.2, 48)
		# --- armas / distrações ------------------------------------------------
		"gun_shot":
			b = Synth.buf(1.6)
			Synth.noise(b, 0.0, 0.08, 1.0, 0.9, 0.2, 0.0005, 0.03, 49)
			Synth.tone(b, 0.0, 0.3, 120.0, 0.8, 0, 0.001, 0.15, 40.0)
			Synth.noise(b, 0.02, 1.4, 0.4, 0.05, 0.0, 0.01, 0.8, 50)
			Synth.echo(b, 0.35, 0.35, 0.6)
		"bow_shot":
			b = Synth.buf(0.6)
			Synth.tone(b, 0.0, 0.35, 220.0, 0.4, 3, 0.001, 0.2, 180.0)
			Synth.noise(b, 0.02, 0.4, 0.3, 0.2, 0.05, 0.05, 0.25, 51, 0.5)
		"firecracker":
			b = Synth.buf(3.0)
			var r := Util.rng(52)
			for k in 14:
				var t := k * 0.18 + r.randf() * 0.05
				Synth.noise(b, t, 0.06, 0.9, 0.9, 0.2, 0.0005, 0.03, k)
				Synth.tone(b, t, 0.08, 150.0, 0.5, 0, 0.001, 0.05, 60.0)
			Synth.echo(b, 0.3, 0.3, 0.5)
		"dog_bark":
			b = Synth.buf(1.0)
			for k in 2:
				Synth.voice(b, k * 0.35, 0.18, 520.0, 380.0, 0.8, 0.25, 0.3, k + 10)
			Synth.lowpass(b, 0.3)
			Synth.echo(b, 0.25, 0.3, 0.5)
		"distant_scream":
			b = Synth.buf(2.2)
			Synth.voice(b, 0.0, 1.6, 520.0, 780.0, 0.8, 0.25, 0.3, 12)
			Synth.lowpass(b, 0.12)
			Synth.echo(b, 0.4, 0.35, 0.6)
		"distant_shot":
			b = Synth.buf(2.0)
			Synth.noise(b, 0.0, 0.1, 0.8, 0.3, 0.02, 0.001, 0.05, 53)
			Synth.noise(b, 0.05, 1.8, 0.35, 0.03, 0.0, 0.02, 1.0, 54)
			Synth.echo(b, 0.5, 0.35, 0.6)
		"tape_click":
			b = Synth.buf(0.4)
			Synth.noise(b, 0.0, 0.03, 0.8, 0.8, 0.3, 0.0005, 0.01, 55)
			Synth.tone(b, 0.03, 0.35, 180.0, 0.05, 1, 0.02, 0.4, 180.0, 0.0, 0.0, 0.3)
		"flashlight_click":
			b = Synth.buf(0.08)
			Synth.noise(b, 0.0, 0.03, 0.6, 0.9, 0.4, 0.0005, 0.01, 56)
			Synth.tone(b, 0.0, 0.03, 3200.0, 0.2, 0, 0.001, 0.01)
		_:
			b = Synth.buf(0.2)
			Synth.noise(b, 0.0, 0.15, 0.3, 0.3, 0.05, 0.005, 0.08, 99)
	Synth.normalize(b, 0.85 if n.begins_with("mus") or n.begins_with("amb") else 0.95)
	return b
