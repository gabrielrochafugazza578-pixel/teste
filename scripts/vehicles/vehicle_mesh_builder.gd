class_name VehicleMeshBuilder
extends RefCounted
## Malhas procedurais de veículos (5 superfícies: pintura, vidro, acabamento,
## cromados/rodas, luzes). A mesma malha serve para o carro dirigível, os
## carros abandonados (MultiMesh com cor por instância) e o trânsito da abertura.

enum { S_PAINT, S_GLASS, S_TRIM, S_CHROME, S_LIGHTS }

const TYPES := {
	"compact": {"L": 3.7, "W": 1.64, "hood": 0.8, "trunk": 0.45, "roof": 1.45, "base": 0.3, "deck": 0.92, "wr": 0.29, "wb": 2.4},
	"hatch": {"L": 4.0, "W": 1.7, "hood": 0.95, "trunk": 0.35, "roof": 1.48, "base": 0.3, "deck": 0.93, "wr": 0.3, "wb": 2.55},
	"sedan": {"L": 4.5, "W": 1.76, "hood": 1.15, "trunk": 0.95, "roof": 1.44, "base": 0.3, "deck": 0.9, "wr": 0.31, "wb": 2.7},
	"suv": {"L": 4.6, "W": 1.86, "hood": 1.05, "trunk": 0.3, "roof": 1.78, "base": 0.45, "deck": 1.08, "wr": 0.37, "wb": 2.75},
	"pickup": {"L": 5.2, "W": 1.86, "hood": 1.25, "trunk": 2.0, "roof": 1.8, "base": 0.45, "deck": 1.1, "wr": 0.37, "wb": 3.1, "bed": true},
	"van": {"L": 5.0, "W": 1.95, "hood": 0.7, "trunk": 0.05, "roof": 2.15, "base": 0.35, "deck": 1.05, "wr": 0.33, "wb": 3.0, "boxy": true},
	"police": {"L": 4.5, "W": 1.76, "hood": 1.15, "trunk": 0.95, "roof": 1.44, "base": 0.3, "deck": 0.9, "wr": 0.31, "wb": 2.7, "lightbar": true},
	"ambulance": {"L": 5.3, "W": 2.0, "hood": 0.8, "trunk": 0.05, "roof": 2.5, "base": 0.4, "deck": 1.1, "wr": 0.35, "wb": 3.2, "boxy": true, "lightbar": true, "stripe": true},
	"taxi": {"L": 4.5, "W": 1.76, "hood": 1.15, "trunk": 0.95, "roof": 1.44, "base": 0.3, "deck": 0.9, "wr": 0.31, "wb": 2.7, "taxi_sign": true},
	"bus": {"L": 12.0, "W": 2.5, "hood": 0.2, "trunk": 0.05, "roof": 3.15, "base": 0.4, "deck": 1.2, "wr": 0.5, "wb": 6.2, "boxy": true, "bus": true},
	"truck": {"L": 7.5, "W": 2.4, "hood": 1.4, "trunk": 0.05, "roof": 2.5, "base": 0.5, "deck": 1.3, "wr": 0.48, "wb": 4.4, "box_cargo": true},
}

static var _cache: Dictionary = {}


static func dims(type: String) -> Dictionary:
	return TYPES.get(type, TYPES["sedan"])


## burned = carcaça queimada (sem vidros, sem luzes)
static func mesh(type: String, burned: bool = false) -> ArrayMesh:
	var key := "%s_%s" % [type, str(burned)]
	if _cache.has(key):
		return _cache[key]
	var t: Dictionary = dims(type)
	var S := [MeshBuf.new(), MeshBuf.new(), MeshBuf.new(), MeshBuf.new(), MeshBuf.new()]
	_build(t, S, burned)
	var m := ArrayMesh.new()
	var mats := surface_materials(burned)
	for i in S.size():
		var b: MeshBuf = S[i]
		if b.is_empty():
			continue
		m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, b.to_arrays())
		m.surface_set_material(m.get_surface_count() - 1, mats[i])
		m.surface_set_name(m.get_surface_count() - 1, ["paint", "glass", "trim", "chrome", "lights"][i])
	_cache[key] = m
	return m


static func surface_materials(burned: bool = false) -> Array:
	var paint := StandardMaterial3D.new()
	paint.vertex_color_use_as_albedo = true
	paint.albedo_color = Color(1, 1, 1)
	paint.metallic = 0.35 if not burned else 0.1
	paint.roughness = 0.32 if not burned else 0.9
	paint.metallic_specular = 0.6
	var glass := Assets.pbr(Color(0.05, 0.07, 0.08), 0.05, 0.6)
	var trim := Assets.pbr(Color(0.06, 0.06, 0.065), 0.7, 0.0)
	var chrome := Assets.pbr(Color(0.62, 0.63, 0.65), 0.3, 0.9)
	var lights := StandardMaterial3D.new()
	lights.vertex_color_use_as_albedo = true
	lights.emission_enabled = true
	lights.emission = Color(0.0, 0.0, 0.0)
	lights.roughness = 0.2
	return [paint, glass, trim, chrome, lights]


static func _build(t: Dictionary, S: Array, burned: bool) -> void:
	var paint: MeshBuf = S[S_PAINT]
	var glass: MeshBuf = S[S_GLASS]
	var trim: MeshBuf = S[S_TRIM]
	var chrome: MeshBuf = S[S_CHROME]
	var lights: MeshBuf = S[S_LIGHTS]
	var L: float = t["L"]
	var W: float = t["W"]
	var hood: float = t["hood"]
	var trunk: float = t["trunk"]
	var roof: float = t["roof"]
	var base: float = t["base"]
	var deck: float = t["deck"]
	var wr: float = t["wr"]
	var wb: float = t["wb"]
	var boxy: bool = t.get("boxy", false)
	var hw := W * 0.5
	var zf := -L * 0.5
	var zr := L * 0.5
	var white := Color(1, 1, 1)
	var pc := Color(0.08, 0.08, 0.08) if burned else white
	# --- carroceria inferior (perfil lateral convexo extrudado em X) --------------
	var prof: Array = [Vector2(zf, base), Vector2(zf, deck - 0.2), Vector2(zf + 0.22, deck - 0.1), Vector2(zf + hood, deck),
		Vector2(zr - trunk, deck + 0.02), Vector2(zr - 0.08, deck - 0.05), Vector2(zr, deck - 0.2), Vector2(zr, base)]
	if boxy:
		prof = [Vector2(zf, base), Vector2(zf, deck - 0.15), Vector2(zf + hood, deck), Vector2(zr, deck), Vector2(zr, base)]
	_extrude(paint, prof, -hw, hw, pc)
	# assoalho
	paint.quad(Vector3(-hw, base, zf), Vector3(hw, base, zf), Vector3(hw, base, zr), Vector3(-hw, base, zr), Vector3.DOWN,
		Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0, 0.0, pc * 0.3)
	# --- cabine ------------------------------------------------------------------
	var za := zf + hood
	var zb := zr - trunk
	if t.get("bed", false):
		zb = za + 1.7
	var rise := roof - deck
	var ws := rise * (0.95 if not boxy else 0.35)
	var rs := rise * (0.55 if not boxy else 0.02)
	if t.get("bus", false):
		ws = 0.3
		rs = 0.0
	var ra := za + ws
	var rb := zb - rs
	var ciw := hw * 0.94
	var ctw := hw * (0.86 if not boxy else 0.94)
	var g := glass if not burned else trim
	var p00 := Vector3(-ciw, deck, za)
	var p01 := Vector3(ciw, deck, za)
	var p10 := Vector3(-ctw, roof, ra)
	var p11 := Vector3(ctw, roof, ra)
	var q00 := Vector3(-ciw, deck, zb)
	var q01 := Vector3(ciw, deck, zb)
	var q10 := Vector3(-ctw, roof, rb)
	var q11 := Vector3(ctw, roof, rb)
	# para-brisa e vidro traseiro
	g.quad(p00, p01, p11, p10, _nrm(p00, p01, p11, Vector3(0, 0.5, -1)), Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0)
	g.quad(q01, q00, q10, q11, _nrm(q01, q00, q10, Vector3(0, 0.5, 1)), Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0)
	# teto
	paint.quad(p10, p11, q11, q10, Vector3.UP, Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0, 0.0, pc)
	# laterais (vidro) + colunas
	for sgn: float in [-1.0, 1.0]:
		var a0 := Vector3(ciw * sgn, deck, za)
		var a1 := Vector3(ciw * sgn, deck, zb)
		var b1 := Vector3(ctw * sgn, roof, rb)
		var b0 := Vector3(ctw * sgn, roof, ra)
		var n := Vector3(sgn, 0.25, 0).normalized()
		g.quad(a0, a1, b1, b0, n, Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0)
		# colunas A, B, C (tiras de pintura um pouco para fora)
		var off := Vector3(0.012 * sgn, 0, 0)
		for k in 3:
			var f: float = [0.0, 0.5, 1.0][k]
			var zb_ := lerpf(za, zb, f)
			var zt := lerpf(ra, rb, f)
			var w := 0.09 if k != 1 else 0.07
			paint.quad(Vector3(ciw * sgn, deck, zb_ - w) + off, Vector3(ciw * sgn, deck, zb_ + w) + off, Vector3(ctw * sgn, roof, zt + w) + off, Vector3(ctw * sgn, roof, zt - w) + off,
				n, Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0, 0.0, pc)
		# moldura inferior das janelas
		trim.box(Vector3(ciw * sgn, deck + 0.015, (za + zb) * 0.5), Vector3(0.03, 0.03, zb - za), 0.0)
		# friso das portas e maçanetas
		trim.box(Vector3(hw * sgn, (base + deck) * 0.5 + 0.05, (za + zb) * 0.5), Vector3(0.012, deck - base - 0.15, 0.012), 0.0)
		chrome.box(Vector3(hw * sgn + 0.01 * sgn, deck - 0.12, za + 0.35), Vector3(0.02, 0.03, 0.14), 0.0)
		chrome.box(Vector3(hw * sgn + 0.01 * sgn, deck - 0.12, (za + zb) * 0.5 + 0.3), Vector3(0.02, 0.03, 0.14), 0.0)
		# retrovisores
		paint.box(Vector3((hw + 0.1) * sgn, deck + 0.12, za + 0.15), Vector3(0.14, 0.1, 0.07), 0.0, 0.0, pc)
		# faixa da ambulância
		if t.get("stripe", false):
			lights.box(Vector3((hw + 0.005) * sgn, deck + 0.35, 0.3), Vector3(0.01, 0.18, L * 0.7), 0.0, 0.0, Color(0.9, 0.2, 0.15))
		if t.get("bus", false):
			for k in 6:
				trim.box(Vector3((hw + 0.004) * sgn, deck + 0.9, zf + 1.6 + k * 1.75), Vector3(0.01, 1.3, 0.08), 0.0)
	# caçamba da picape
	if t.get("bed", false):
		for sgn: float in [-1.0, 1.0]:
			paint.box(Vector3(hw * 0.95 * sgn, deck + 0.22, (zb + zr) * 0.5), Vector3(0.06, 0.45, zr - zb), 0.0, 0.0, pc)
		paint.box(Vector3(0, deck + 0.22, zr - 0.03), Vector3(W * 0.95, 0.45, 0.06), 0.0, 0.0, pc)
		paint.box(Vector3(0, deck + 0.22, zb + 0.03), Vector3(W * 0.9, 0.45, 0.06), 0.0, 0.0, pc)
		trim.box(Vector3(0, deck + 0.01, (zb + zr) * 0.5), Vector3(W * 0.88, 0.02, zr - zb - 0.1), 0.0)
	if t.get("box_cargo", false):
		paint.box(Vector3(0, (deck + roof) * 0.5 + 0.2, (za + 0.3 + zr) * 0.5 + 0.9), Vector3(W, roof - deck + 0.4, zr - za - 1.2), 0.0, 0.0, Color(0.9, 0.9, 0.88) if not burned else pc)
	# --- para-choques, grade, faróis --------------------------------------------------
	trim.box(Vector3(0, base + 0.12, zf - 0.04), Vector3(W * 0.98, 0.22, 0.12), 0.0)
	trim.box(Vector3(0, base + 0.12, zr + 0.04), Vector3(W * 0.98, 0.22, 0.12), 0.0)
	trim.box(Vector3(0, deck - 0.3, zf - 0.005), Vector3(W * 0.45, 0.16, 0.02), 0.0)
	chrome.box(Vector3(0, base + 0.14, zr + 0.105), Vector3(0.42, 0.12, 0.01), 0.0, 0.0, Color(1.2, 1.2, 1.2))
	if not burned:
		for sgn: float in [-1.0, 1.0]:
			lights.box(Vector3(hw * 0.72 * sgn, deck - 0.3, zf - 0.01), Vector3(0.32, 0.12, 0.03), 0.0, 0.0, Color(0.95, 0.95, 0.85))
			lights.box(Vector3(hw * 0.78 * sgn, deck - 0.25, zr + 0.01), Vector3(0.26, 0.12, 0.03), 0.0, 0.0, Color(0.7, 0.05, 0.03))
	if t.get("lightbar", false) and not burned:
		trim.box(Vector3(0, roof + 0.06, (ra + rb) * 0.5 - 0.2), Vector3(W * 0.7, 0.1, 0.25), 0.0)
		lights.box(Vector3(-W * 0.18, roof + 0.13, (ra + rb) * 0.5 - 0.2), Vector3(W * 0.3, 0.08, 0.22), 0.0, 0.0, Color(0.1, 0.2, 1.0))
		lights.box(Vector3(W * 0.18, roof + 0.13, (ra + rb) * 0.5 - 0.2), Vector3(W * 0.3, 0.08, 0.22), 0.0, 0.0, Color(1.0, 0.1, 0.1))
	if t.get("taxi_sign", false):
		lights.box(Vector3(0, roof + 0.1, (ra + rb) * 0.5), Vector3(0.5, 0.16, 0.18), 0.0, 0.0, Color(0.95, 0.85, 0.3))
	# --- rodas ----------------------------------------------------------------------
	for wz: float in [-wb * 0.5, wb * 0.5]:
		for sgn: float in [-1.0, 1.0]:
			var c := Vector3((hw - 0.12) * sgn, wr, wz)
			var xf := Transform3D(Basis(Vector3.BACK, -PI * 0.5 * sgn), c - Vector3(0.11 * sgn, 0, 0))
			if not burned:
				trim.cylinder(xf, wr, 0.22, 12, 0.0, 0.0, white, true)
			chrome.cylinder(Transform3D(xf.basis, c + Vector3(0.115 * sgn, 0, 0)), wr * 0.58, 0.01, 10, 0.0, 0.0, Color(0.8, 0.8, 0.8) if not burned else Color(0.2, 0.18, 0.16), true)
			# caixa de roda escura
			trim.box(Vector3((hw - 0.02) * sgn, wr + 0.05, wz), Vector3(0.05, wr * 1.1, wr * 2.3), 0.0, 0.0, Color(0.02, 0.02, 0.02))


static func _nrm(a: Vector3, b: Vector3, c: Vector3, hint: Vector3) -> Vector3:
	var n := (b - a).cross(c - a).normalized()
	if n.dot(hint) < 0.0:
		n = -n
	return n


## Extrusão de um perfil convexo (z,y) ao longo de X.
static func _extrude(b: MeshBuf, prof: Array, x0: float, x1: float, col: Color) -> void:
	var n := prof.size()
	# faces laterais (leque)
	for sgn: float in [-1.0, 1.0]:
		var x := x0 if sgn < 0.0 else x1
		var p0: Vector2 = prof[0]
		for i in range(1, n - 1):
			var p1: Vector2 = prof[i]
			var p2: Vector2 = prof[i + 1]
			b.tri(Vector3(x, p0.y, p0.x), Vector3(x, p1.y, p1.x), Vector3(x, p2.y, p2.x), Vector3(sgn, 0, 0),
				Vector2(p0.x, p0.y), Vector2(p1.x, p1.y), Vector2(p2.x, p2.y), 0.0, 0.0, col)
	# faixas ao redor do perfil
	for i in n:
		var a: Vector2 = prof[i]
		var c: Vector2 = prof[(i + 1) % n]
		if a.distance_to(c) < 0.001:
			continue
		var d := c - a
		var nrm := Vector3(0, -d.x, d.y).normalized()
		# normal para fora: o perfil é percorrido no sentido horário (z,y)
		var mid := (a + c) * 0.5
		var center := Vector2.ZERO
		for p in prof:
			center += p
		center /= float(n)
		var out2 := mid - center
		if Vector2(nrm.z, nrm.y).dot(out2) < 0.0:
			nrm = -nrm
		b.quad(Vector3(x0, a.y, a.x), Vector3(x1, a.y, a.x), Vector3(x1, c.y, c.x), Vector3(x0, c.y, c.x), nrm,
			Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0, 0.0, col)
