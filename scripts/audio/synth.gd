class_name Synth
extends RefCounted
## Síntese sonora procedural (sem arquivos de áudio externos).
## Buffers mono em PackedFloat32Array a 22 050 Hz, convertidos para
## AudioStreamWAV 16 bits. Executado em thread na primeira execução e
## guardado em cache em user://cache/audio.

const SR := 22050

static var _noise := PackedFloat32Array()


static func noise_table() -> PackedFloat32Array:
	if _noise.is_empty():
		var r := RandomNumberGenerator.new()
		r.seed = 12345
		_noise.resize(65536)
		for i in 65536:
			_noise[i] = r.randf() * 2.0 - 1.0
	return _noise


static func buf(seconds: float) -> PackedFloat32Array:
	var b := PackedFloat32Array()
	b.resize(int(seconds * SR))
	b.fill(0.0)
	return b


## Ruído filtrado com envelope ataque/decaimento exponencial.
## lp: coeficiente do passa-baixa (0..1, maior = mais agudo). hp: passa-alta (0..1).
static func noise(b: PackedFloat32Array, t0: float, dur: float, amp: float, lp: float, hp: float = 0.0,
		attack: float = 0.005, decay: float = -1.0, seed_value: int = 0, lp_end: float = -1.0) -> void:
	var nt := noise_table()
	var s0 := int(t0 * SR)
	var n := int(dur * SR)
	var y := 0.0
	var yh := 0.0
	var off := (seed_value * 7919) & 0xffff
	var dec := decay if decay > 0.0 else dur
	var att := maxf(attack, 0.0005)
	for i in n:
		var idx := s0 + i
		if idx >= b.size():
			break
		var t := float(i) / SR
		var env := minf(1.0, t / att) * exp(-t / dec * 3.0)
		var a := lp if lp_end < 0.0 else lerpf(lp, lp_end, float(i) / n)
		var x := nt[(off + i) & 0xffff]
		y += a * (x - y)
		var o := y
		if hp > 0.0:
			yh += hp * (o - yh)
			o = o - yh
		b[idx] += o * env * amp


## Oscilador com glissando, vibrato e envelope. wave: 0 seno, 1 serra, 2 quadrada, 3 triângulo
static func tone(b: PackedFloat32Array, t0: float, dur: float, f0: float, amp: float, wave: int = 0,
		attack: float = 0.01, decay: float = -1.0, f1: float = -1.0, vib_hz: float = 0.0, vib_amt: float = 0.0, lp: float = 1.0) -> void:
	var s0 := int(t0 * SR)
	var n := int(dur * SR)
	var ph := 0.0
	var y := 0.0
	var dec := decay if decay > 0.0 else dur
	var att := maxf(attack, 0.0005)
	var fe := f1 if f1 > 0.0 else f0
	for i in n:
		var idx := s0 + i
		if idx >= b.size():
			break
		var t := float(i) / SR
		var fr := lerpf(f0, fe, float(i) / n)
		if vib_amt > 0.0:
			fr *= 1.0 + sin(t * vib_hz * TAU) * vib_amt
		ph += fr / SR
		ph -= floorf(ph)
		var v := 0.0
		match wave:
			0: v = sin(ph * TAU)
			1: v = ph * 2.0 - 1.0
			2: v = 1.0 if ph < 0.5 else -1.0
			_: v = 1.0 - absf(ph * 4.0 - 2.0)
		if lp < 1.0:
			y += lp * (v - y)
			v = y
		var env := minf(1.0, t / att) * exp(-t / dec * 3.0)
		b[idx] += v * env * amp


## Pad sustentado (acorde): várias serras desafinadas, filtradas, com ataque lento.
static func pad(b: PackedFloat32Array, t0: float, dur: float, freqs: Array, amp: float, lp: float = 0.08, attack: float = 1.2, release: float = 1.5) -> void:
	var s0 := int(t0 * SR)
	var n := int(dur * SR)
	var phases: Array = []
	var incs: Array = []
	for f in freqs:
		for det: float in [-0.004, 0.0, 0.005]:
			phases.append(randf())
			incs.append(float(f) * (1.0 + det) / SR)
	var y := 0.0
	var y2 := 0.0
	var count := float(phases.size())
	for i in n:
		var idx := s0 + i
		if idx >= b.size():
			break
		var t := float(i) / SR
		var v := 0.0
		for k in phases.size():
			var p: float = phases[k] + incs[k]
			p -= floorf(p)
			phases[k] = p
			v += p * 2.0 - 1.0
		v /= count
		y += lp * (v - y)
		y2 += lp * (y - y2)
		var env := minf(1.0, t / attack) * minf(1.0, (dur - t) / release)
		b[idx] += y2 * env * amp * 3.0


## Nota "pluck" tipo piano/harpa (Karplus-Strong simplificado).
static func pluck(b: PackedFloat32Array, t0: float, freq: float, amp: float, dur: float = 2.5, bright: float = 0.5) -> void:
	var nt := noise_table()
	var period := maxi(2, int(SR / freq))
	var ring := PackedFloat32Array()
	ring.resize(period)
	for i in period:
		ring[i] = nt[(i * 31 + int(freq)) & 0xffff]
	var s0 := int(t0 * SR)
	var n := int(dur * SR)
	var k := 0
	var damp := 0.996 - (1.0 - bright) * 0.006
	for i in n:
		var idx := s0 + i
		if idx >= b.size():
			break
		var nxt := (k + 1) % period
		var v := (ring[k] + ring[nxt]) * 0.5 * damp
		ring[k] = v
		b[idx] += v * amp
		k = nxt


## Voz gutural (infectados): serra com vibrato irregular + dois formantes.
static func voice(b: PackedFloat32Array, t0: float, dur: float, f0: float, f1: float, amp: float, formant: float = 0.08, rough: float = 0.3, seed_value: int = 0) -> void:
	var nt := noise_table()
	var s0 := int(t0 * SR)
	var n := int(dur * SR)
	var ph := 0.0
	var y1 := 0.0
	var y2 := 0.0
	var off := (seed_value * 3571) & 0xffff
	for i in n:
		var idx := s0 + i
		if idx >= b.size():
			break
		var t := float(i) / SR
		var u := float(i) / n
		var jitter := nt[(off + i / 200) & 0xffff] * 0.08
		var fr := lerpf(f0, f1, u) * (1.0 + jitter + sin(t * 6.3) * 0.03)
		ph += fr / SR
		ph -= floorf(ph)
		var v := (ph * 2.0 - 1.0) + nt[(off + i) & 0xffff] * rough
		y1 += formant * (v - y1)
		y2 += formant * 1.9 * (v - y2)
		var o := y1 * 0.7 + (y2 - y1) * 0.6
		var env := sin(minf(u, 1.0) * PI) * (0.8 + 0.2 * sin(t * 11.0))
		b[idx] += o * env * amp


## Eco simples (linhas de atraso com realimentação).
static func echo(b: PackedFloat32Array, delay: float, feedback: float, mix: float) -> void:
	var d := int(delay * SR)
	if d <= 0:
		return
	for i in range(d, b.size()):
		b[i] += b[i - d] * feedback * mix


static func lowpass(b: PackedFloat32Array, a: float) -> void:
	var y := 0.0
	for i in b.size():
		y += a * (b[i] - y)
		b[i] = y


static func normalize(b: PackedFloat32Array, peak: float = 0.9) -> void:
	var m := 0.0001
	for v in b:
		m = maxf(m, absf(v))
	var g := peak / m
	for i in b.size():
		b[i] *= g


## Torna o buffer um loop contínuo (crossfade do fim sobre o começo).
static func make_loop(b: PackedFloat32Array, xfade: float = 0.25) -> PackedFloat32Array:
	var x := int(xfade * SR)
	var n := b.size() - x
	if n <= x:
		return b
	var out := PackedFloat32Array()
	out.resize(n)
	for i in n:
		out[i] = b[i]
	for i in x:
		var f := float(i) / x
		out[i] = b[i] * f + b[n + i] * (1.0 - f)
	return out


static func to_pcm(b: PackedFloat32Array) -> PackedByteArray:
	var bytes := PackedByteArray()
	bytes.resize(b.size() * 2)
	for i in b.size():
		bytes.encode_s16(i * 2, int(clampf(b[i], -1.0, 1.0) * 32000.0))
	return bytes


static func to_stream(pcm: PackedByteArray, loop: bool) -> AudioStreamWAV:
	var s := AudioStreamWAV.new()
	s.format = AudioStreamWAV.FORMAT_16_BITS
	s.mix_rate = SR
	s.stereo = false
	s.data = pcm
	if loop:
		s.loop_mode = AudioStreamWAV.LOOP_FORWARD
		s.loop_begin = 0
		s.loop_end = pcm.size() / 2
	return s


static func note(n: int) -> float:
	# nota MIDI -> Hz
	return 440.0 * pow(2.0, float(n - 69) / 12.0)
