class_name HeadTemplate
extends RefCounted
## Molde anatômico de cabeça + pescoço, gerado a partir de um campo de
## distância (SDF) montado com primitivas suaves: crânio, massa facial,
## mandíbula e ângulo da mandíbula, queixo, maçãs do rosto, arco das
## sobrancelhas, órbitas escavadas, nariz (dorso, ponta e asas), lábios,
## orelhas, pescoço com esternocleidomastoides e pomo de adão.
##
## A superfície é amostrada por raios a partir do centro da cabeça numa grade
## lat/long NÃO uniforme (mais densa no rosto), então cada personagem só
## aplica deformações baratas (mandíbula, nariz, queixo, bochechas, lábios)
## usando as máscaras de região guardadas aqui. Também guarda oclusão
## ambiente calculada no SDF (órbitas, sob o nariz, sob o queixo, orelhas).
##
## Unidades: metros de uma cabeça de referência (adulto de 1,78 m), origem no
## centro da cabeça, rosto voltado para -Z. Um molde por sexo e por LOD, em
## memória e em cache no disco (user://cache).

enum { MK_JAW, MK_LIPS, MK_MOUTH, MK_BROW, MK_BEARD, MK_NOSE, MK_CHIN, MK_CHEEK, MK_JAWLAT, MK_SOCKET, MK_EAR, MK_NECK, MK_FACE, MK_COUNT }

const VERSION := 12
const CROWN := 0.116      # topo da cabeça acima do centro
const PHI_FACE := 1.72
const TH_FRONT := PI * 1.5
const TH_START := PI * 0.5   # costura atrás da cabeça

var fem: bool = false
var lat: int = 0
var lon: int = 0
var phis := PackedFloat32Array()
var ths := PackedFloat32Array()
var pos := PackedVector3Array()
var nrm := PackedVector3Array()
var ao := PackedFloat32Array()
var masks: Array = []           # MK_COUNT × PackedFloat32Array
var eye_c := Vector3.ZERO       # olho direito (+X); o esquerdo é espelhado
var eye_r: float = 0.012

# primitivas (preenchidas por sexo em _setup)
var CRAN_C: Vector3; var CRAN_R: Vector3
var FACE_C: Vector3; var FACE_R: Vector3
var JAW_C: Vector3; var JAW_R: Vector3
var CHIN_C: Vector3; var CHIN_R: Vector3
var GON_C: Vector3; var GON_R: Vector3
var ZYG_C: Vector3; var ZYG_R: Vector3
var BUC_C: Vector3; var BUC_R: Vector3
var MZ_C: Vector3; var MZ_R: Vector3
var BROW_C: Vector3; var BROW_R: Vector3
var SOCK_C: Vector3; var SOCK_R: Vector3
var NB_A: Vector3; var NB_B: Vector3; var NB_RAD: float
var NT_C: Vector3; var NT_R: Vector3
var NA_C: Vector3; var NA_R: Vector3
var UL_C: Vector3; var UL_R: Vector3
var LL_C: Vector3; var LL_R: Vector3
var EAR_C: Vector3; var EAR_R: Vector3
var NK_A: Vector3; var NK_B: Vector3; var NK_RAD: float
var SCM_A: Vector3; var SCM_B: Vector3; var SCM_RAD: float
var NKB_C: Vector3; var NKB_R: Vector3
var ADAM_C: Vector3; var ADAM_R: Vector3
var MOUTH_Y: float

static var _cache: Dictionary = {}


static func get_tpl(female: bool, lod_level: int) -> HeadTemplate:
	var key := "%d_%d" % [int(female), mini(lod_level, 1)]
	if _cache.has(key):
		return _cache[key]
	var t := HeadTemplate.new()
	t.fem = female
	t._setup()
	if not t._load(key):
		t._generate(mini(lod_level, 1))
		t._save(key)
	_cache[key] = t
	return t


## Gera (ou carrega do disco) todos os moldes; chamado no boot.
static func warm() -> void:
	for f: bool in [false, true]:
		for l in 2:
			get_tpl(f, l)


# ---------------------------------------------------------------------------
# Primitivas
# ---------------------------------------------------------------------------
func _setup() -> void:
	if not fem:
		CRAN_C = Vector3(0, 0.029, 0.008); CRAN_R = Vector3(0.074, 0.089, 0.097)
		FACE_C = Vector3(0, -0.017, -0.036); FACE_R = Vector3(0.062, 0.06, 0.064)
		JAW_C = Vector3(0, -0.066, -0.026); JAW_R = Vector3(0.054, 0.033, 0.06)
		CHIN_C = Vector3(0, -0.092, -0.076); CHIN_R = Vector3(0.025, 0.017, 0.016)
		GON_C = Vector3(0.05, -0.064, 0.004); GON_R = Vector3(0.013, 0.023, 0.026)
		ZYG_C = Vector3(0.052, -0.003, -0.054); ZYG_R = Vector3(0.02, 0.014, 0.027)
		BROW_C = Vector3(0.0, 0.03, -0.083); BROW_R = Vector3(0.057, 0.0105, 0.0145)
		SOCK_C = Vector3(0.031, 0.007, -0.1); SOCK_R = Vector3(0.0175, 0.0125, 0.016)
		NB_A = Vector3(0, 0.01, -0.094); NB_B = Vector3(0, -0.031, -0.113); NB_RAD = 0.0075
		NT_C = Vector3(0, -0.037, -0.111); NT_R = Vector3(0.0125, 0.0112, 0.0122)
		NA_C = Vector3(0.0135, -0.0405, -0.102); NA_R = Vector3(0.0088, 0.0078, 0.0085)
		UL_C = Vector3(0, -0.0585, -0.0855); UL_R = Vector3(0.0255, 0.0082, 0.0095)
		LL_C = Vector3(0, -0.0735, -0.0845); LL_R = Vector3(0.0225, 0.0092, 0.0098)
		EAR_C = Vector3(0.074, -0.008, 0.012); EAR_R = Vector3(0.011, 0.03, 0.02)
		NK_A = Vector3(0, -0.07, 0.022); NK_B = Vector3(0, -0.29, 0.028); NK_RAD = 0.0615
		SCM_A = Vector3(0.052, -0.045, 0.02); SCM_B = Vector3(0.014, -0.225, -0.028); SCM_RAD = 0.0135
		NKB_C = Vector3(0, -0.225, 0.014); NKB_R = Vector3(0.088, 0.045, 0.078)
		ADAM_C = Vector3(0, -0.128, -0.037); ADAM_R = Vector3(0.011, 0.014, 0.01)
		MOUTH_Y = -0.0655
	else:
		CRAN_C = Vector3(0, 0.03, 0.007); CRAN_R = Vector3(0.071, 0.087, 0.093)
		FACE_C = Vector3(0, -0.015, -0.035); FACE_R = Vector3(0.059, 0.057, 0.061)
		JAW_C = Vector3(0, -0.062, -0.028); JAW_R = Vector3(0.047, 0.03, 0.057)
		CHIN_C = Vector3(0, -0.086, -0.068); CHIN_R = Vector3(0.021, 0.015, 0.014)
		GON_C = Vector3(0.045, -0.06, 0.0); GON_R = Vector3(0.01, 0.019, 0.022)
		ZYG_C = Vector3(0.05, 0.002, -0.053); ZYG_R = Vector3(0.018, 0.013, 0.025)
		BROW_C = Vector3(0.0, 0.032, -0.079); BROW_R = Vector3(0.049, 0.0085, 0.0115)
		SOCK_C = Vector3(0.03, 0.009, -0.097); SOCK_R = Vector3(0.0175, 0.0128, 0.0155)
		NB_A = Vector3(0, 0.011, -0.091); NB_B = Vector3(0, -0.027, -0.107); NB_RAD = 0.0062
		NT_C = Vector3(0, -0.033, -0.104); NT_R = Vector3(0.0105, 0.01, 0.0108)
		NA_C = Vector3(0.0115, -0.0365, -0.096); NA_R = Vector3(0.0072, 0.0064, 0.0072)
		UL_C = Vector3(0, -0.0545, -0.0825); UL_R = Vector3(0.0235, 0.0088, 0.0098)
		LL_C = Vector3(0, -0.0695, -0.0815); LL_R = Vector3(0.0205, 0.0098, 0.01)
		EAR_C = Vector3(0.071, -0.006, 0.01); EAR_R = Vector3(0.0095, 0.027, 0.018)
		NK_A = Vector3(0, -0.066, 0.02); NK_B = Vector3(0, -0.28, 0.026); NK_RAD = 0.0555
		SCM_A = Vector3(0.047, -0.042, 0.018); SCM_B = Vector3(0.013, -0.215, -0.024); SCM_RAD = 0.0095
		NKB_C = Vector3(0, -0.215, 0.013); NKB_R = Vector3(0.077, 0.04, 0.07)
		ADAM_C = Vector3(0, -0.12, -0.03); ADAM_R = Vector3.ZERO
		MOUTH_Y = -0.0615
	BUC_C = Vector3(0.04 if not fem else 0.037, -0.047 if not fem else -0.043, -0.056)
	BUC_R = Vector3(0.022, 0.026, 0.025) if not fem else Vector3(0.018, 0.021, 0.02)
	# plano do meio do rosto (entre nariz, bochechas e queixo): tira o aspecto de focinho
	MZ_C = Vector3(0, -0.05, -0.058) if not fem else Vector3(0, -0.047, -0.056)
	MZ_R = Vector3(0.052, 0.03, 0.03) if not fem else Vector3(0.047, 0.027, 0.028)
	eye_c = SOCK_C + Vector3(0, 0, 0.0255)
	eye_r = 0.0135 if not fem else 0.0132


static func _ell(p: Vector3, c: Vector3, r: Vector3) -> float:
	var q := (p - c) / r
	var k0 := q.length()
	var k1 := (q / r).length()
	return k0 * (k0 - 1.0) / maxf(k1, 0.000001)


static func _capsule(p: Vector3, pa: Vector3, pb: Vector3, r: float) -> float:
	var ap := p - pa
	var ab := pb - pa
	var h := clampf(ap.dot(ab) / ab.dot(ab), 0.0, 1.0)
	return (ap - ab * h).length() - r


static func _smin(d1: float, d2: float, k: float) -> float:
	var h := clampf(0.5 + 0.5 * (d2 - d1) / k, 0.0, 1.0)
	return lerpf(d2, d1, h) - k * h * (1.0 - h)


static func _smax(d1: float, d2: float, k: float) -> float:
	return -_smin(-d1, -d2, k)


func sdf(p: Vector3) -> float:
	# |x| suave: espelha os traços sem vinco na linha central do rosto
	var q := Vector3(sqrt(p.x * p.x + 0.00002), p.y, p.z)
	var d := _ell(p, CRAN_C, CRAN_R)
	d = _smin(d, _ell(p, FACE_C, FACE_R), 0.03)
	d = _smin(d, _ell(q, MZ_C, MZ_R), 0.03)
	d = _smin(d, _ell(p, JAW_C, JAW_R), 0.025)
	d = _smin(d, _ell(p, CHIN_C, CHIN_R), 0.022)
	d = _smin(d, _ell(q, GON_C, GON_R), 0.02)
	d = _smin(d, _ell(q, ZYG_C, ZYG_R), 0.016)
	d = _smin(d, _ell(q, BUC_C, BUC_R), 0.028)
	d = _smin(d, _ell(p, BROW_C, BROW_R), 0.026)
	# órbitas
	d = _smax(d, -_ell(q, SOCK_C, SOCK_R), 0.009)
	# nariz
	var dn := _capsule(p, NB_A, NB_B, NB_RAD)
	dn = _smin(dn, _ell(p, NT_C, NT_R), 0.009)
	dn = _smin(dn, _ell(q, NA_C, NA_R), 0.008)
	d = _smin(d, dn, 0.011)
	# lábios e sulco entre eles
	d = _smin(d, _ell(p, UL_C, UL_R), 0.007)
	d = _smin(d, _ell(p, LL_C, LL_R), 0.008)
	d = _smax(d, -_ell(p, Vector3(0, MOUTH_Y, -0.093), Vector3(0.017, 0.00075, 0.011)), 0.0016)
	# orelhas
	d = _smin(d, _ell(q, EAR_C, EAR_R), 0.007)
	# pescoço (levemente elíptico) + esternocleidomastoides + base
	var pk := Vector3(p.x / 1.03, p.y, (p.z - NK_A.z) / 1.06 + NK_A.z)
	var dk := _capsule(pk, NK_A, NK_B, NK_RAD)
	dk = _smin(dk, _capsule(q, SCM_A, SCM_B, SCM_RAD), 0.02)
	dk = _smin(dk, _ell(p, NKB_C, NKB_R), 0.045)
	if not fem:
		dk = _smin(dk, _ell(p, ADAM_C, ADAM_R), 0.012)
	d = _smin(d, dk, 0.022)
	return d


func _grad(p: Vector3) -> Vector3:
	var e := 0.0008
	return Vector3(
		sdf(p + Vector3(e, 0, 0)) - sdf(p - Vector3(e, 0, 0)),
		sdf(p + Vector3(0, e, 0)) - sdf(p - Vector3(0, e, 0)),
		sdf(p + Vector3(0, 0, e)) - sdf(p - Vector3(0, 0, e))).normalized()


static func dir(phi: float, th: float) -> Vector3:
	return Vector3(sin(phi) * cos(th), cos(phi), sin(phi) * sin(th))


# ---------------------------------------------------------------------------
# Geração
# ---------------------------------------------------------------------------
## Amostras não uniformes: densidade maior perto do rosto.
static func _warp(n: int, lo: float, hi: float, dens: Callable) -> PackedFloat32Array:
	var fine := 600
	var cum := PackedFloat32Array()
	cum.resize(fine + 1)
	cum[0] = 0.0
	for i in fine:
		var x := lerpf(lo, hi, (float(i) + 0.5) / fine)
		cum[i + 1] = cum[i] + float(dens.call(x))
	var out := PackedFloat32Array()
	out.resize(n + 1)
	var j := 0
	for i in n + 1:
		var target := cum[fine] * float(i) / float(n)
		while j < fine - 1 and cum[j + 1] < target:
			j += 1
		var f := (target - cum[j]) / maxf(cum[j + 1] - cum[j], 0.000001)
		out[i] = lerpf(lo, hi, (float(j) + clampf(f, 0.0, 1.0)) / fine)
	out[0] = lo
	out[n] = hi
	return out


func _generate(lod_level: int) -> void:
	lat = 52 if lod_level == 0 else 16
	lon = 60 if lod_level == 0 else 20
	phis = _warp(lat, 0.0, PI, func(x: float) -> float:
		return 1.0 + 1.8 * exp(-pow((x - PHI_FACE) / 0.45, 2.0)) - 0.4 * smoothstep(2.5, 3.0, x) - 0.3 * smoothstep(0.8, 0.0, x))
	ths = _warp(lon, TH_START, TH_START + TAU, func(x: float) -> float:
		var dd := absf(x - TH_FRONT)
		return 0.55 + 2.2 * exp(-pow(dd / 0.75, 2.0)))
	var n := (lat + 1) * (lon + 1)
	pos.resize(n)
	nrm.resize(n)
	ao.resize(n)
	masks.clear()
	for m in MK_COUNT:
		var arr := PackedFloat32Array()
		arr.resize(n)
		masks.append(arr)
	for i in lat + 1:
		for k in lon + 1:
			var idx := i * (lon + 1) + k
			var d := dir(phis[i], ths[k])
			var p := _raycast(d)
			pos[idx] = p
			var g := _grad(p)
			if g.dot(d) < 0.0 or g.length_squared() < 0.5:
				g = d
			nrm[idx] = g
			ao[idx] = _ao(p, g)
			_fill_masks(idx, p)
	# costura: última coluna = primeira
	for i in lat + 1:
		var a0 := i * (lon + 1)
		var a1 := a0 + lon
		pos[a1] = pos[a0]
		nrm[a1] = nrm[a0]
		ao[a1] = ao[a0]
		for m in MK_COUNT:
			(masks[m] as PackedFloat32Array)[a1] = (masks[m] as PackedFloat32Array)[a0]


## Ponto mais externo da superfície na direção d (raio de fora para dentro).
func _raycast(d: Vector3) -> Vector3:
	var r_out := 0.36
	var t := 0.0
	var inside_r := 0.0
	for it in 64:
		var r := r_out - t
		if r <= 0.004:
			break
		var v := sdf(d * r)
		if v < 0.0:
			inside_r = r
			break
		t += maxf(v * 0.7, 0.0008)
	if inside_r <= 0.0:
		return d * 0.05
	# bisseção entre dentro (inside_r) e um passo para fora
	var lo := inside_r
	var hi := minf(inside_r + 0.006, r_out)
	for it in 10:
		var mid := (lo + hi) * 0.5
		if sdf(d * mid) < 0.0:
			lo = mid
		else:
			hi = mid
	return d * ((lo + hi) * 0.5)


func _ao(p: Vector3, n: Vector3) -> float:
	var occ := 0.0
	var w := 1.0
	for i in 5:
		var h := 0.004 + 0.006 * float(i)
		occ += (h - sdf(p + n * h)) / h * w
		w *= 0.7
	return clampf(1.0 - occ * 0.24, 0.0, 1.0)


func _ellmask(p: Vector3, c: Vector3, r: Vector3, inner: float, outer: float) -> float:
	var e := ((p - c) / r).length()
	return 1.0 - smoothstep(inner, outer, e)


func _fill_masks(idx: int, p: Vector3) -> void:
	var ax := absf(p.x)
	var q := Vector3(ax, p.y, p.z)
	var front := smoothstep(-0.02, -0.07, p.z)
	# mandíbula (peso de osso): abaixo da boca, na frente, sem pescoço
	var neckness := smoothstep(-0.1, -0.125, p.y) * smoothstep(-0.07, -0.035, p.z)
	var jaw := smoothstep(MOUTH_Y + 0.004, MOUTH_Y - 0.012, p.y) * smoothstep(0.03, -0.012, p.z) * (1.0 - neckness)
	jaw *= 1.0 - smoothstep(-0.13, -0.15, p.y)
	# lábios e linha da boca
	var lips := maxf(_ellmask(p, UL_C, UL_R * Vector3(1.0, 1.25, 1.6), 0.85, 1.35), _ellmask(p, LL_C, LL_R * Vector3(1.0, 1.25, 1.6), 0.85, 1.35))
	var mouth := exp(-pow((p.y - MOUTH_Y) / 0.0032, 2.0)) * (1.0 - smoothstep(0.018, 0.024, ax)) * front
	# sobrancelhas em arco (pelos)
	var xb := clampf((ax - 0.034) / 0.022, -1.0, 1.0)
	var yb := 0.026 + 0.0055 * (1.0 - xb * xb) + (0.002 if fem else 0.0)
	var brow := exp(-pow((p.y - yb) / (0.0055 if not fem else 0.0042), 2.0)) * smoothstep(0.007, 0.013, ax) * (1.0 - smoothstep(0.05, 0.058, ax)) * smoothstep(-0.06, -0.075, p.z)
	# barba: abaixo da linha da bochecha, frente/lados, e bigode
	var yline := -0.046 + maxf(ax - 0.028, 0.0) * 1.15
	var beard := smoothstep(0.002, -0.008, p.y - yline) * smoothstep(0.035, 0.0, p.z)
	beard *= smoothstep(-0.16, -0.13, p.y) if p.z < -0.03 else smoothstep(-0.12, -0.1, p.y)
	var stache := (1.0 - smoothstep(0.024, 0.03, ax)) * smoothstep(-0.043, -0.047, p.y) * smoothstep(MOUTH_Y + 0.004, MOUTH_Y + 0.008, p.y) * front
	beard = maxf(beard, stache) * (1.0 - lips)
	var nose := _ellmask(p, Vector3(0, -0.018, -0.104), Vector3(0.022, 0.036, 0.022), 0.6, 1.1)
	var chin := _ellmask(p, CHIN_C + Vector3(0, -0.004, -0.004), CHIN_R * 1.9, 0.5, 1.1)
	var cheek := _ellmask(q, Vector3(0.045, -0.032, -0.056), Vector3(0.026, 0.026, 0.03), 0.3, 1.1)
	var jawlat := smoothstep(-0.015, -0.055, p.y) * smoothstep(0.018, 0.045, ax) * (1.0 - smoothstep(-0.11, -0.125, p.y))
	var socket := _ellmask(q, SOCK_C + Vector3(0, -0.002, 0.006), SOCK_R * Vector3(1.35, 1.45, 1.3), 0.6, 1.25)
	var ear := _ellmask(q, EAR_C, EAR_R * 1.35, 0.6, 1.1)
	var neck := smoothstep(-0.085, -0.17, p.y) * smoothstep(-0.07, -0.03, p.z)
	neck = maxf(neck, smoothstep(-0.14, -0.2, p.y))
	var face := front * smoothstep(0.05, 0.0, p.y) * smoothstep(-0.13, -0.1, p.y)
	var vals := [jaw, lips, mouth, brow, beard, nose, chin, cheek, jawlat, socket, ear, neck, face]
	for m in MK_COUNT:
		(masks[m] as PackedFloat32Array)[idx] = float(vals[m])


# ---------------------------------------------------------------------------
# Amostragem (cabelo, chapéu, máscara)
# ---------------------------------------------------------------------------
static func _find(arr: PackedFloat32Array, x: float) -> Vector2:
	var n := arr.size()
	if x <= arr[0]:
		return Vector2(0, 0.0)
	if x >= arr[n - 1]:
		return Vector2(n - 2, 1.0)
	var lo := 0
	var hi := n - 1
	while hi - lo > 1:
		var mid := (lo + hi) >> 1
		if arr[mid] <= x:
			lo = mid
		else:
			hi = mid
	return Vector2(lo, (x - arr[lo]) / maxf(arr[lo + 1] - arr[lo], 0.000001))


## Posição, normal e peso de mandíbula da pele na direção (phi, th).
func sample(phi: float, th: float) -> Array:
	var tt := fposmod(th - TH_START, TAU) + TH_START
	var a := _find(phis, phi)
	var b := _find(ths, tt)
	var i0 := int(a.x)
	var k0 := int(b.x)
	var i00 := i0 * (lon + 1) + k0
	var i01 := i00 + 1
	var i10 := i00 + lon + 1
	var i11 := i10 + 1
	var p := (pos[i00].lerp(pos[i01], b.y)).lerp(pos[i10].lerp(pos[i11], b.y), a.y)
	var nn := (nrm[i00].lerp(nrm[i01], b.y)).lerp(nrm[i10].lerp(nrm[i11], b.y), a.y).normalized()
	var mj: PackedFloat32Array = masks[MK_JAW]
	var jw := lerpf(lerpf(mj[i00], mj[i01], b.y), lerpf(mj[i10], mj[i11], b.y), a.y)
	return [p, nn, jw]


# ---------------------------------------------------------------------------
# Cache em disco
# ---------------------------------------------------------------------------
func _path(key: String) -> String:
	return "user://cache/head_v%d_%s.bin" % [VERSION, key]


func _save(key: String) -> void:
	DirAccess.make_dir_recursive_absolute("user://cache")
	var f := FileAccess.open(_path(key), FileAccess.WRITE)
	if f == null:
		return
	f.store_var({"lat": lat, "lon": lon, "phis": phis, "ths": ths, "pos": pos, "nrm": nrm, "ao": ao, "masks": masks})
	f.close()


func _load(key: String) -> bool:
	var p := _path(key)
	if not FileAccess.file_exists(p):
		return false
	var f := FileAccess.open(p, FileAccess.READ)
	if f == null:
		return false
	var d: Variant = f.get_var()
	f.close()
	if not (d is Dictionary) or int((d as Dictionary).get("lat", 0)) <= 0:
		return false
	var dd: Dictionary = d
	lat = int(dd["lat"])
	lon = int(dd["lon"])
	phis = dd["phis"]
	ths = dd["ths"]
	pos = dd["pos"]
	nrm = dd["nrm"]
	ao = dd["ao"]
	masks = dd["masks"]
	return masks.size() == MK_COUNT and pos.size() == (lat + 1) * (lon + 1)
