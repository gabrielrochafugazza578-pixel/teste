class_name VehicleMeshBuilder
extends RefCounted
## Malhas procedurais de veículos. Superfícies: pintura (sempre a 0), vidro,
## acabamento escuro (pneus, plásticos, interior), cromados, faróis, lanternas e
## placas. A mesma malha serve para o carro dirigível, os carros abandonados
## (MultiMesh com cor por instância) e o trânsito da abertura.
##
## Carroceria "loftada": seções transversais arredondadas ao longo do
## comprimento (nariz e traseira caídos, capô e porta-malas), com normais suaves.
## Estados: "clean" (antes do surto), "dusty" (parado há semanas), "wreck"
## (vidros quebrados, interior à mostra, capô aberto) e "burned" (carcaça).

enum { S_PAINT, S_GLASS, S_TRIM, S_CHROME, S_LIGHTS, S_TAIL, S_PLATE }

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
static var _mats: Dictionary = {}


static func dims(type: String) -> Dictionary:
	return TYPES.get(type, TYPES["sedan"])


## burned = carcaça queimada (compatibilidade); state: clean | dusty | wreck | burned
static func mesh(type: String, burned: bool = false, with_wheels: bool = true, state: String = "") -> ArrayMesh:
	var st := state if state != "" else ("burned" if burned else "clean")
	var key := "%s_%s_%s" % [type, st, str(with_wheels)]
	if _cache.has(key):
		return _cache[key]
	var t: Dictionary = dims(type)
	var S := []
	for i in 7:
		S.append(MeshBuf.new())
	var r := RandomNumberGenerator.new()
	r.seed = hash(key)
	_build(t, S, st, with_wheels, r)
	var m := ArrayMesh.new()
	var mats := surface_materials(st)
	var names := ["paint", "glass", "trim", "chrome", "lights", "tail", "plate"]
	for i in S.size():
		var b: MeshBuf = S[i]
		if b.is_empty():
			# a pintura precisa ser sempre a superfície 0
			if i == 0:
				b.box(Vector3.ZERO, Vector3(0.01, 0.01, 0.01), 0.0)
			else:
				continue
		m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, b.to_arrays())
		m.surface_set_material(m.get_surface_count() - 1, mats[i])
		m.surface_set_name(m.get_surface_count() - 1, names[i])
	_cache[key] = m
	return m


static func paint_material(state: String) -> ShaderMaterial:
	var key := "paint_" + state
	if _mats.has(key):
		return _mats[key]
	var m := ShaderMaterial.new()
	m.shader = Assets.shader("res://shaders/vehicle_paint.gdshader")
	# fotos das camadas (ferrugem, terra) e ruído, atualizados se a qualidade mudar
	Assets.track_textures(m)
	match state:
		"dusty":
			m.set_shader_parameter("dirt", 0.5)
			m.set_shader_parameter("rust", 0.12)
		"wreck":
			m.set_shader_parameter("dirt", 0.75)
			m.set_shader_parameter("rust", 0.45)
		"burned":
			m.set_shader_parameter("burn", 1.0)
			m.set_shader_parameter("rust", 0.3)
		_:
			m.set_shader_parameter("dirt", 0.06)
	_mats[key] = m
	return m


## Vidro empoeirado (película irregular e marcas de água seca).
static func _dirty_glass(amount: float) -> ShaderMaterial:
	var key := "glass_%.2f" % amount
	if _mats.has(key):
		return _mats[key]
	var m := ShaderMaterial.new()
	m.shader = Assets.shader("res://shaders/vehicle_glass.gdshader")
	m.set_shader_parameter("dirt", amount)
	Assets.track_textures(m)
	_mats[key] = m
	return m


static func surface_materials(state = "clean") -> Array:
	# compatibilidade: surface_materials(true) = queimado
	var st: String = ("burned" if state else "clean") if state is bool else str(state)
	var burned := st == "burned"
	var paint := paint_material(st)
	# vidro: tom azul-acinzentado com reflexo do céu (não preto chapado); sujo fica fosco
	var glass: Material = Assets.pbr(Color(0.2, 0.25, 0.29) if st == "clean" else Color(0.27, 0.28, 0.27), 0.1 if st == "clean" else 0.42, 0.35 if st == "clean" else 0.15)
	if st in ["dusty", "wreck"]:
		glass = _dirty_glass(0.55 if st == "dusty" else 0.85)
	var trim := Assets.pbr(Color(0.055, 0.055, 0.06) if not burned else Color(0.03, 0.028, 0.026), 0.75, 0.0)
	var chrome := Assets.pbr(Color(0.62, 0.63, 0.65) if not burned else Color(0.2, 0.17, 0.15), 0.3 if not burned else 0.85, 0.9 if not burned else 0.2)
	var lights := Assets.pbr(Color(0.85, 0.87, 0.88), 0.12, 0.3)
	var tail := Assets.pbr(Color(0.55, 0.03, 0.02), 0.2, 0.0)
	var plate := Assets.pbr(Color(0.86, 0.86, 0.84) if st == "clean" else Color(0.68, 0.66, 0.6), 0.6, 0.0)
	return [paint, glass, trim, chrome, lights, tail, plate]


## Roda avulsa (eixo X, face externa em +X), para veículos dirigíveis com rodas animadas.
static func wheel_mesh(type: String) -> ArrayMesh:
	var key := "wheel_" + type
	if _cache.has(key):
		return _cache[key]
	var t: Dictionary = dims(type)
	var wr: float = t["wr"]
	var trim := MeshBuf.new()
	var chrome := MeshBuf.new()
	_wheel(trim, chrome, Vector3.ZERO, wr, 1.0, false)
	var mats := surface_materials("clean")
	var m := ArrayMesh.new()
	m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, trim.to_arrays())
	m.surface_set_material(0, mats[S_TRIM])
	m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, chrome.to_arrays())
	m.surface_set_material(1, mats[S_CHROME])
	_cache[key] = m
	return m


## Pneu + aro + disco de freio centrados em `c` (eixo X); `sgn` = lado (+1 face para +X).
static func _wheel(trim: MeshBuf, chrome: MeshBuf, c: Vector3, wr: float, sgn: float, burned: bool) -> void:
	var tw := 0.22
	var x_out := c.x + tw * 0.5 * sgn
	var x_in := c.x - tw * 0.5 * sgn
	var X := Vector3(1, 0, 0)
	var rim_r := wr * 0.64
	if not burned:
		# banda de rodagem e flancos arredondados (normais suaves)
		trim.tube(Vector3(x_in + 0.02 * sgn, c.y, c.z), Vector3(x_out - 0.02 * sgn, c.y, c.z), wr, wr, 20, 0.0, 0.0, Color(1, 1, 1), false)
		trim.tube(Vector3(x_out - 0.02 * sgn, c.y, c.z), Vector3(x_out, c.y, c.z), wr, wr * 0.93, 20, 0.0, 0.0, Color(1, 1, 1), false)
		trim.tube(Vector3(x_out, c.y, c.z), Vector3(x_out + 0.003 * sgn, c.y, c.z), wr * 0.93, rim_r * 1.02, 20, 0.0, 0.0, Color(1, 1, 1), false)
		trim.tube(Vector3(x_in, c.y, c.z), Vector3(x_in + 0.02 * sgn, c.y, c.z), wr * 0.93, wr, 20, 0.0, 0.0, Color(1, 1, 1), false)
		trim.cylinder(Transform3D(Basis(Vector3.BACK, -PI * 0.5), Vector3(x_in, c.y, c.z)) if sgn > 0 else Transform3D(Basis(Vector3.BACK, PI * 0.5), Vector3(x_in, c.y, c.z)),
			wr * 0.93, 0.001, 16, 0.0, 0.0, Color(1, 1, 1), true)
	# aro: prato levemente côncavo, 5 raios e calota
	var face := Vector3(x_out + 0.004 * sgn, c.y, c.z)
	chrome.tube(face - X * (0.035 * sgn), face, rim_r, rim_r * 0.96, 18, 0.0, 0.0, Color(0.85, 0.85, 0.86), false)
	chrome.tube(face - X * (0.06 * sgn), face - X * (0.035 * sgn), rim_r * 0.9, rim_r, 18, 0.0, 0.0, Color(0.6, 0.6, 0.62), false)
	for k in 5:
		var a := float(k) * TAU / 5.0
		var dirv := Vector3(0, cos(a), sin(a))
		chrome.box_xf(Transform3D(Basis(Vector3.RIGHT, a), face + dirv * rim_r * 0.48 - X * (0.01 * sgn)), Vector3(0.02, rim_r * 0.82, 0.06), 0.0, 0.0,
			Color(0.8, 0.8, 0.82))
	chrome.tube(face - X * (0.012 * sgn), face + X * (0.012 * sgn), rim_r * 0.24, rim_r * 0.2, 10, 0.0, 0.0, Color(0.9, 0.9, 0.9))
	# disco de freio atrás dos raios
	trim.tube(face - X * (0.05 * sgn), face - X * (0.04 * sgn), rim_r * 0.82, rim_r * 0.82, 16, 0.0, 0.0, Color(2.2, 2.2, 2.3), true)


# ---------------------------------------------------------------------------
# Carroceria
# ---------------------------------------------------------------------------
## Linha de cintura (topo da carroceria) ao longo do comprimento.
static func _top_at(z: float, t: Dictionary) -> float:
	var L: float = t["L"]
	var zf := -L * 0.5
	var zr := L * 0.5
	var deck: float = t["deck"]
	var hood: float = t["hood"]
	var trunk: float = t["trunk"]
	var za := zf + hood
	var zb := zr - trunk
	if t.get("bed", false):
		zb = za + 1.7
	if t.get("boxy", false):
		var nose := clampf((z - zf) / 0.28, 0.0, 1.0)
		return deck - 0.18 * (1.0 - sin(nose * PI * 0.5))
	var nose_len := minf(0.3, hood * 0.35)
	if z < zf + nose_len:
		var f := (z - zf) / nose_len
		return lerpf(deck - 0.26, deck - 0.07, sin(f * PI * 0.5))
	if z < za:
		return lerpf(deck - 0.07, deck, (z - zf - nose_len) / maxf(za - zf - nose_len, 0.01))
	if z <= zb:
		return deck
	var tail_len := minf(0.22, maxf(trunk * 0.4, 0.1))
	if z > zr - tail_len:
		var f2 := (z - (zr - tail_len)) / tail_len
		return lerpf(deck + 0.02, deck - 0.2, f2 * f2)
	return deck + 0.02


static func _bot_at(z: float, t: Dictionary, drop: float) -> float:
	var L: float = t["L"]
	var base: float = t["base"]
	var e := clampf(1.0 - minf(z + L * 0.5, L * 0.5 - z) / 0.35, 0.0, 1.0)
	return base + 0.07 * e * e - drop


static func _w_at(z: float, t: Dictionary) -> float:
	var L: float = t["L"]
	var hw: float = float(t["W"]) * 0.5
	var e := clampf(1.0 - minf(z + L * 0.5, L * 0.5 - z) / (0.3 if not t.get("boxy", false) else 0.14), 0.0, 1.0)
	return hw * (1.0 - 0.07 * e * e)


## Superfície loftada (seções arredondadas) com normais suaves, fechada nas pontas.
static func _loft(b: MeshBuf, t: Dictionary, drop: float, col: Color) -> void:
	var L: float = t["L"]
	var zf := -L * 0.5
	var zr := L * 0.5
	var N := 26
	# perfil da meia seção: (fração da largura, fração da altura), de baixo (centro) até em cima (centro)
	var sec := [Vector2(0.0, 0.0), Vector2(0.86, 0.0), Vector2(0.965, 0.07), Vector2(1.0, 0.28), Vector2(1.0, 0.6),
		Vector2(0.98, 0.83), Vector2(0.93, 0.96), Vector2(0.8, 1.0), Vector2(0.4, 1.012), Vector2(0.0, 1.016)]
	if t.get("boxy", false):
		sec = [Vector2(0.0, 0.0), Vector2(0.9, 0.0), Vector2(0.985, 0.06), Vector2(1.0, 0.25), Vector2(1.0, 0.85),
			Vector2(0.985, 0.96), Vector2(0.92, 1.0), Vector2(0.0, 1.0)]
	var K := sec.size()
	var zs: Array = []
	for i in N:
		var f := float(i) / float(N - 1)
		zs.append(lerpf(zf, zr, 0.5 - 0.5 * cos(f * PI)))
	for sgn: float in [-1.0, 1.0]:
		var grid: Array = []
		for i in N:
			var z: float = zs[i]
			var top := _top_at(z, t) - drop
			var bot := _bot_at(z, t, drop)
			var w := _w_at(z, t)
			var row: Array = []
			for k in K:
				var sp: Vector2 = sec[k]
				row.append(Vector3(sp.x * w * sgn, lerpf(bot, top, sp.y), z))
			grid.append(row)
		# normais por diferenças centrais (apontando para fora)
		var norms: Array = []
		for i in N:
			var nrow: Array = []
			for k in K:
				var ti: Vector3 = (grid[mini(i + 1, N - 1)][k] as Vector3) - (grid[maxi(i - 1, 0)][k] as Vector3)
				var tk: Vector3 = (grid[i][mini(k + 1, K - 1)] as Vector3) - (grid[i][maxi(k - 1, 0)] as Vector3)
				var n := ti.cross(tk).normalized()
				var p: Vector3 = grid[i][k]
				var mid_y := lerpf(_bot_at(p.z, t, drop), _top_at(p.z, t) - drop, 0.5)
				var outward := Vector3(p.x, p.y - mid_y, 0.0)
				if outward.length_squared() < 0.0001:
					outward = Vector3(sgn, 0, 0)
				if n.dot(outward) < 0.0:
					n = -n
				nrow.append(n)
			norms.append(nrow)
		for i in N - 1:
			for k in K - 1:
				var a: Vector3 = grid[i][k]
				var bq: Vector3 = grid[i + 1][k]
				var c: Vector3 = grid[i + 1][k + 1]
				var d: Vector3 = grid[i][k + 1]
				_tri_s(b, a, bq, c, norms[i][k], norms[i + 1][k], norms[i + 1][k + 1], col)
				_tri_s(b, a, c, d, norms[i][k], norms[i + 1][k + 1], norms[i][k + 1], col)
		# tampas das pontas (planas)
		for end in [0, N - 1]:
			var row: Array = grid[end]
			var nz := Vector3(0, 0, -1) if end == 0 else Vector3(0, 0, 1)
			var cen := Vector3(0, ((row[0] as Vector3).y + (row[K - 1] as Vector3).y) * 0.5, (row[0] as Vector3).z)
			for k in K - 1:
				b.tri(cen, row[k], row[k + 1], nz, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, 0.0, 0.0, col)


## Triângulo com normais por vértice, no sentido que o MeshBuf usa (frente oposta ao produto vetorial).
static func _tri_s(b: MeshBuf, p0: Vector3, p1: Vector3, p2: Vector3, n0: Vector3, n1: Vector3, n2: Vector3, col: Color) -> void:
	var fn := (p1 - p0).cross(p2 - p0)
	var navg := n0 + n1 + n2
	var tg := (p1 - p0).normalized()
	var i0 := b._vert(p0, n0, tg, 1.0, Vector2(p0.z, p0.y), 0.0, 0.0, col)
	var i1 := b._vert(p1, n1, tg, 1.0, Vector2(p1.z, p1.y), 0.0, 0.0, col)
	var i2 := b._vert(p2, n2, tg, 1.0, Vector2(p2.z, p2.y), 0.0, 0.0, col)
	if fn.dot(navg) > 0.0:
		b.idx.append(i0); b.idx.append(i2); b.idx.append(i1)
	else:
		b.idx.append(i0); b.idx.append(i1); b.idx.append(i2)


static func _build(t: Dictionary, S: Array, state: String, with_wheels: bool, r: RandomNumberGenerator) -> void:
	var paint: MeshBuf = S[S_PAINT]
	var glass: MeshBuf = S[S_GLASS]
	var trim: MeshBuf = S[S_TRIM]
	var chrome: MeshBuf = S[S_CHROME]
	var lights: MeshBuf = S[S_LIGHTS]
	var tail: MeshBuf = S[S_TAIL]
	var plate: MeshBuf = S[S_PLATE]
	var burned := state == "burned"
	var wreck := state == "wreck"
	var L: float = t["L"]
	var W: float = t["W"]
	var hood: float = t["hood"]
	var trunk: float = t["trunk"]
	var boxy: bool = t.get("boxy", false)
	# carcaça queimada: sem pneus, apoiada nos aros
	var drop := 0.11 if burned else 0.0
	var roof: float = float(t["roof"]) - drop
	var base: float = float(t["base"]) - drop
	var deck: float = float(t["deck"]) - drop
	var wr: float = t["wr"]
	var wb: float = t["wb"]
	var hw := W * 0.5
	var zf := -L * 0.5
	var zr := L * 0.5
	var white := Color(1, 1, 1)
	# --- carroceria ------------------------------------------------------------------
	_loft(paint, t, drop, white)
	# assoalho escuro
	trim.quad(Vector3(-hw * 0.9, base + 0.01, zf + 0.2), Vector3(hw * 0.9, base + 0.01, zf + 0.2), Vector3(hw * 0.9, base + 0.01, zr - 0.2),
		Vector3(-hw * 0.9, base + 0.01, zr - 0.2), Vector3.DOWN, Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0)
	# --- cabine ----------------------------------------------------------------------
	var za := zf + hood
	var zb := zr - trunk
	if t.get("bed", false):
		zb = za + 1.7
	if t.get("box_cargo", false):
		zb = za + 1.5
	var rise := roof - deck
	var ws := rise * (0.95 if not boxy else 0.35)
	var rs := rise * (0.55 if not boxy else 0.02)
	if t.get("bus", false):
		ws = 0.3
		rs = 0.0
	elif t.get("box_cargo", false):
		# cabine curta de caminhão: para-brisa pouco inclinado, traseira reta
		ws = rise * 0.38
		rs = 0.04
	var ra := za + ws
	var rb := zb - rs
	var ciw := _w_at(za + 0.3, t) * 0.93
	var ctw := hw * (0.8 if not boxy else 0.93)
	var no_glass := burned
	var p00 := Vector3(-ciw, deck, za)
	var p01 := Vector3(ciw, deck, za)
	var p10 := Vector3(-ctw, roof, ra)
	var p11 := Vector3(ctw, roof, ra)
	var q00 := Vector3(-ciw, deck, zb)
	var q01 := Vector3(ciw, deck, zb)
	var q10 := Vector3(-ctw, roof, rb)
	var q11 := Vector3(ctw, roof, rb)
	var missing_side := r.randi() % 2 if wreck else -1
	var missing_rear := wreck and r.randf() < 0.5
	if not no_glass:
		glass.quad(p00, p01, p11, p10, _nrm(p00, p01, p11, Vector3(0, 0.5, -1)), Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0)
		if boxy and not t.get("bus", false):
			paint.quad(q01, q00, q10, q11, _nrm(q01, q00, q10, Vector3(0, 0.5, 1)), Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0, 0.0, white)
			if not missing_rear:
				var rq := (q00 + q01 + q10 + q11) * 0.25
				glass.quad(rq + Vector3(ciw * 0.8, -rise * 0.05, 0.006), rq + Vector3(-ciw * 0.8, -rise * 0.05, 0.006), rq + Vector3(-ciw * 0.8, rise * 0.35, 0.006),
					rq + Vector3(ciw * 0.8, rise * 0.35, 0.006), Vector3(0, 0, 1), Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0)
		elif not missing_rear:
			glass.quad(q01, q00, q10, q11, _nrm(q01, q00, q10, Vector3(0, 0.5, 1)), Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0)
		if wreck:
			# trincas no para-brisa
			var wc := (p00 + p01 + p10 + p11) * 0.25 + Vector3(r.randf_range(-0.3, 0.3), 0, 0)
			var wn := _nrm(p00, p01, p11, Vector3(0, 0.5, -1))
			for k in 7:
				var a := r.randf() * TAU
				var dv := (Vector3(cos(a), sin(a) * 0.5, 0.0)).normalized()
				chrome.box_xf(Transform3D(Basis.looking_at(dv.cross(wn).normalized() if absf(dv.cross(wn).length()) > 0.01 else Vector3.FORWARD, wn), wc + dv * 0.18 - wn * 0.004),
					Vector3(0.006, 0.004, 0.36), 0.0, 0.0, Color(0.9, 0.92, 0.95))
	# teto com leve abaulado
	var crown := Vector3(0, 0.025, 0)
	paint.quad(p10, (p10 + p11) * 0.5 + crown, (q10 + q11) * 0.5 + crown, q10, Vector3(-0.1, 1, 0).normalized(), Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0, 0.0, white)
	paint.quad((p10 + p11) * 0.5 + crown, p11, q11, (q10 + q11) * 0.5 + crown, Vector3(0.1, 1, 0).normalized(), Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0, 0.0, white)
	# interior (visível pelos vidros quebrados/ausentes)
	if wreck or burned:
		var seat_col := Color(0.8, 0.78, 0.74) if wreck else Color(0.4, 0.38, 0.36)
		for sx: float in [-0.45, 0.45]:
			trim.box(Vector3(sx * hw, base + 0.42, za + 0.9), Vector3(hw * 0.7, 0.14, 0.5), 0.0, 0.0, seat_col)
			trim.box_xf(Transform3D(Basis(Vector3.RIGHT, -0.25), Vector3(sx * hw, base + 0.75, za + 1.2)), Vector3(hw * 0.7, 0.6, 0.12), 0.0, 0.0, seat_col)
		if zb - za > 2.0:
			trim.box(Vector3(0, base + 0.42, zb - 0.45), Vector3(hw * 1.7, 0.14, 0.5), 0.0, 0.0, seat_col)
			trim.box_xf(Transform3D(Basis(Vector3.RIGHT, -0.2), Vector3(0, base + 0.75, zb - 0.2), ), Vector3(hw * 1.7, 0.6, 0.12), 0.0, 0.0, seat_col)
		trim.box(Vector3(0, deck - 0.05, za + 0.25), Vector3(hw * 1.8, 0.2, 0.35), 0.0, 0.0, Color(0.6, 0.6, 0.6))
		# volante
		var sw := Vector3(-hw * 0.45, deck + 0.08, za + 0.5)
		for k in 10:
			var a0 := TAU * float(k) / 10.0
			var a1 := TAU * float(k + 1) / 10.0
			var bs := Basis(Vector3.RIGHT, -0.9)
			trim.tube(sw + bs * Vector3(cos(a0) * 0.18, sin(a0) * 0.18, 0), sw + bs * Vector3(cos(a1) * 0.18, sin(a1) * 0.18, 0), 0.015, 0.015, 5, 0.0, 0.0, Color(0.5, 0.5, 0.5), false)
	# laterais: vidros, colunas, molduras, maçanetas, frisos das portas
	var four_door: bool = not boxy and float(t["L"]) > 3.9 and not bool(t.get("bed", false))
	for sgn: float in [-1.0, 1.0]:
		var a0 := Vector3(ciw * sgn, deck, za)
		var a1 := Vector3(ciw * sgn, deck, zb)
		var b1 := Vector3(ctw * sgn, roof, rb)
		var b0 := Vector3(ctw * sgn, roof, ra)
		var n := Vector3(sgn, 0.25, 0).normalized()
		var side_i := 0 if sgn < 0.0 else 1
		var van_like: bool = boxy and not bool(t.get("bus", false))
		if van_like:
			# furgão: janelas só na cabine, o resto é lataria
			var zg := za + 1.15
			var g1 := a0.lerp(a1, (zg - za) / maxf(zb - za, 0.01))
			var h1 := b0.lerp(b1, (zg - za) / maxf(zb - za, 0.01))
			if not no_glass and side_i != missing_side:
				glass.quad(a0, g1, h1, b0, n, Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0)
			paint.quad(g1, a1, b1, h1, n, Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0, 0.0, white)
		elif not no_glass and side_i != missing_side:
			glass.quad(a0, a1, b1, b0, n, Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0)
		elif not no_glass:
			# resto de vidro no canto da moldura
			glass.tri(a0, a0.lerp(a1, 0.25), a0.lerp(b0, 0.4), n, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, 0.0)
		var off := Vector3(0.012 * sgn, 0, 0)
		for k in 3:
			var f: float = [0.0, 0.5, 1.0][k]
			var zb_ := lerpf(za, zb, f)
			var zt := lerpf(ra, rb, f)
			var w := 0.09 if k != 1 else 0.06
			var pb := trim if k == 1 else paint
			pb.quad(Vector3(ciw * sgn, deck, zb_ - w) + off, Vector3(ciw * sgn, deck, zb_ + w) + off, Vector3(ctw * sgn, roof, zt + w) + off, Vector3(ctw * sgn, roof, zt - w) + off,
				n, Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0, 0.0, white)
		# moldura de borracha em volta do vidro
		trim.box(Vector3(ciw * sgn, deck + 0.015, (za + zb) * 0.5), Vector3(0.035, 0.03, zb - za), 0.0)
		trim.box(Vector3(ctw * sgn, roof - 0.01, (ra + rb) * 0.5), Vector3(0.03, 0.025, rb - ra), 0.0)
		# frisos das portas (linhas finas escuras) e maçanetas
		var doors := [za - 0.04, (za + zb) * 0.5 + 0.02, zb + 0.02] if four_door else [za - 0.04, zb - 0.1]
		for zd: float in doors:
			var wz := _w_at(zd, t)
			trim.box(Vector3((wz + 0.002) * sgn, (base + deck) * 0.5 + 0.06, zd), Vector3(0.008, deck - base - 0.2, 0.008), 0.0)
		var hz: Array = [za + 0.45, (za + zb) * 0.5 + 0.4] if four_door else [za + 0.5]
		for z_h: float in hz:
			chrome.box(Vector3((_w_at(z_h, t) + 0.012) * sgn, deck - 0.13, z_h), Vector3(0.02, 0.028, 0.15), 0.0)
		if not boxy:
			trim.box(Vector3((hw + 0.004) * sgn, base + 0.32, (za + zb) * 0.5 + 0.1), Vector3(0.012, 0.05, (zb - za) + 0.6), 0.0)
		# retrovisor: braço + carcaça + espelho
		var mp := Vector3((hw + 0.12) * sgn, deck + 0.12, za + 0.12)
		trim.box(Vector3((hw + 0.05) * sgn, deck + 0.08, za + 0.12), Vector3(0.1, 0.03, 0.05), 0.0)
		paint.box(mp, Vector3(0.16, 0.11, 0.08), 0.0, 0.0, white)
		chrome.box(mp + Vector3(0, 0, 0.041), Vector3(0.14, 0.09, 0.004), 0.0, 0.0, Color(0.7, 0.75, 0.8))
		# faixa da ambulância e janelas do ônibus
		if t.get("stripe", false) and not burned:
			tail.box(Vector3((_w_at(0.3, t) + 0.006) * sgn, deck + 0.45, 0.6), Vector3(0.01, 0.2, L * 0.55), 0.0)
			tail.box(Vector3((_w_at(0.3, t) + 0.006) * sgn, deck - 0.2, 0.3), Vector3(0.01, 0.12, L * 0.8), 0.0)
		if t.get("bus", false):
			for k in 6:
				trim.box(Vector3((hw + 0.004) * sgn, deck + 0.9, zf + 1.6 + k * 1.75), Vector3(0.01, 1.3, 0.08), 0.0)
		# caixas de roda: arco escuro sobre a lataria + friso do para-lama
		for wz: float in [-wb * 0.5, wb * 0.5]:
			var cy := wr - drop * 0.4
			var xw := (_w_at(wz, t) + 0.004) * sgn
			var cen := Vector3(xw, cy, wz)
			var ar := wr + 0.06
			var segs := 12
			for k in segs:
				var t0 := lerpf(-0.12, PI + 0.12, float(k) / float(segs))
				var t1 := lerpf(-0.12, PI + 0.12, float(k + 1) / float(segs))
				var e0 := cen + Vector3(0, sin(t0) * ar, cos(t0) * ar)
				var e1 := cen + Vector3(0, sin(t1) * ar, cos(t1) * ar)
				trim.tri(cen, e0, e1, Vector3(sgn, 0, 0), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, 0.0, 0.0, Color(0.25, 0.25, 0.25))
				var fl := paint if not (t.get("bed", false) or float(t["base"]) > 0.4) else trim
				fl.tube(e0 + Vector3(0.008 * sgn, 0, 0), e1 + Vector3(0.008 * sgn, 0, 0), 0.02, 0.02, 5, 0.0, 0.0, white, false)
	# caçamba da picape
	if t.get("bed", false):
		for sgn: float in [-1.0, 1.0]:
			paint.box(Vector3(hw * 0.95 * sgn, deck + 0.22, (zb + zr) * 0.5), Vector3(0.06, 0.45, zr - zb - 0.1), 0.0, 0.0, white)
		paint.box(Vector3(0, deck + 0.22, zr - 0.08), Vector3(W * 0.95, 0.45, 0.06), 0.0, 0.0, white)
		paint.box(Vector3(0, deck + 0.22, zb + 0.03), Vector3(W * 0.9, 0.45, 0.06), 0.0, 0.0, white)
		trim.box(Vector3(0, deck + 0.01, (zb + zr) * 0.5), Vector3(W * 0.88, 0.02, zr - zb - 0.1), 0.0)
	if t.get("box_cargo", false):
		var z0 := zb + 0.15
		var bh := roof + 0.55 - deck
		paint.box(Vector3(0, deck + bh * 0.5, (z0 + zr) * 0.5), Vector3(W * 1.02, bh, zr - z0), 0.0, 0.0, Color(0.9, 0.9, 0.88) if not burned else white)
		for k in 6:
			trim.box(Vector3(0, deck + 0.05 + k * bh / 5.0, zr + 0.005), Vector3(W * 0.98, 0.02, 0.01), 0.0)
		trim.box(Vector3(0, deck + bh * 0.5, zr + 0.008), Vector3(0.02, bh * 0.95, 0.01), 0.0)
	# rack de teto do SUV
	if float(t["base"]) > 0.4 and not boxy and not t.get("bed", false):
		for sgn: float in [-1.0, 1.0]:
			trim.box(Vector3(ctw * 0.85 * sgn, roof + 0.05, (ra + rb) * 0.5), Vector3(0.04, 0.04, (rb - ra) * 0.85), 0.0)
	# capô levantado nos destruídos (batida)
	if wreck and not boxy and hood > 0.7 and r.randf() < 0.45:
		var hz := zf + 0.25
		paint.box_xf(Transform3D(Basis(Vector3.RIGHT, 0.32), Vector3(0, _top_at(hz + hood * 0.45, t) + 0.14, zf + hood * 0.5)), Vector3(W * 0.82, 0.03, hood * 0.85), 0.0, 0.0, white)
		trim.box(Vector3(0, deck - 0.12, zf + hood * 0.5), Vector3(W * 0.7, 0.2, hood * 0.6), 0.0)
	# --- frente e traseira: para-choques, grade, faróis, lanternas, placas -----------
	var yf := _top_at(zf + 0.01, t) - drop
	var yr := _top_at(zr - 0.01, t) - drop
	var wf := _w_at(zf, t)
	var wr_ := _w_at(zr, t)
	trim.box(Vector3(0, base + 0.08, zf - 0.02), Vector3(wf * 1.9, 0.12, 0.1), 0.0)
	trim.box(Vector3(0, base + 0.08, zr + 0.02), Vector3(wr_ * 1.9, 0.12, 0.1), 0.0)
	# grade
	var gy := yf - 0.13
	trim.box(Vector3(0, gy, zf - 0.004), Vector3(wf * 0.9, 0.13, 0.02), 0.0)
	for k in 3:
		chrome.box(Vector3(0, gy - 0.04 + k * 0.04, zf - 0.016), Vector3(wf * 0.86, 0.012, 0.012), 0.0)
	chrome.box(Vector3(0, gy + 0.005, zf - 0.024), Vector3(0.1, 0.06, 0.01), 0.0)
	for sgn: float in [-1.0, 1.0]:
		# faróis: carcaça cromada + lente + luz de posição
		var hx := wf * 0.72 * sgn
		chrome.box(Vector3(hx, gy + 0.01, zf - 0.006), Vector3(wf * 0.42, 0.15, 0.02), 0.0, 0.0, Color(0.7, 0.72, 0.74))
		if not burned:
			lights.box(Vector3(hx, gy + 0.01, zf - 0.018), Vector3(wf * 0.38, 0.12, 0.012), 0.0)
			tail.box(Vector3(wf * 0.93 * sgn, gy - 0.02, zf + 0.04), Vector3(0.02, 0.05, 0.1), 0.0, 0.0, Color(1.6, 1.0, 0.2))
			# lanternas: vermelho + ré branca
			tail.box(Vector3(wr_ * 0.76 * sgn, yr - 0.12, zr + 0.006), Vector3(wr_ * 0.38, 0.13, 0.02), 0.0)
			lights.box(Vector3(wr_ * 0.6 * sgn, yr - 0.2, zr + 0.01), Vector3(0.08, 0.04, 0.012), 0.0)
		else:
			trim.box(Vector3(wr_ * 0.76 * sgn, yr - 0.12, zr + 0.006), Vector3(wr_ * 0.38, 0.13, 0.02), 0.0)
		# neblina
		lights.box(Vector3(wf * 0.7 * sgn, base + 0.12, zf - 0.075), Vector3(0.1, 0.05, 0.012), 0.0)
	# placas
	for end in [[zf - 0.075, base + 0.13], [zr + 0.075, base + 0.26]]:
		var pz: float = end[0]
		var py: float = end[1]
		plate.box(Vector3(0, py, pz), Vector3(0.4, 0.13, 0.008), 0.0)
		trim.box(Vector3(0, py + 0.045, pz + (0.005 if pz > 0.0 else -0.005)), Vector3(0.4, 0.02, 0.004), 0.0, 0.0, Color(0.2, 0.3, 0.6))
		for k in 7:
			trim.box(Vector3(-0.15 + k * 0.05, py - 0.012, pz + (0.005 if pz > 0.0 else -0.005)), Vector3(0.03, 0.055, 0.004), 0.0)
	# limpadores, antena, escapamento
	if not boxy:
		for sx: float in [-0.25, 0.25]:
			trim.box_xf(Transform3D(Basis(Vector3.UP, 0.12), Vector3(sx * W, deck + 0.03, za + 0.06)), Vector3(0.5, 0.012, 0.02), 0.0)
		if not t.get("bed", false):
			trim.tube(Vector3(hw * 0.6, _top_at(zr - trunk * 0.5, t) - drop, zr - trunk * 0.3), Vector3(hw * 0.6, _top_at(zr - trunk * 0.5, t) - drop + 0.45, zr - trunk * 0.3 + 0.08), 0.004, 0.003, 4, 0.0)
	chrome.tube(Vector3(hw * 0.55, base + 0.04, zr - 0.25), Vector3(hw * 0.55, base + 0.04, zr + 0.06), 0.03, 0.03, 8, 0.0, 0.0, Color(0.5, 0.48, 0.45))
	if t.get("lightbar", false) and not burned:
		trim.box(Vector3(0, roof + 0.06, (ra + rb) * 0.5 - 0.2), Vector3(W * 0.7, 0.1, 0.25), 0.0)
		lights.box(Vector3(-W * 0.18, roof + 0.13, (ra + rb) * 0.5 - 0.2), Vector3(W * 0.3, 0.08, 0.22), 0.0, 0.0)
		tail.box(Vector3(W * 0.18, roof + 0.13, (ra + rb) * 0.5 - 0.2), Vector3(W * 0.3, 0.08, 0.22), 0.0)
	if t.get("taxi_sign", false):
		plate.box(Vector3(0, roof + 0.1, (ra + rb) * 0.5), Vector3(0.5, 0.16, 0.18), 0.0)
	# --- rodas ---------------------------------------------------------------------
	if with_wheels:
		for wz: float in [-wb * 0.5, wb * 0.5]:
			for sgn: float in [-1.0, 1.0]:
				var c := Vector3((hw - 0.09) * sgn, wr - (0.36 * wr if burned else 0.0), wz)
				_wheel(trim, chrome, c, wr, sgn, burned)


static func _nrm(a: Vector3, b: Vector3, c: Vector3, hint: Vector3) -> Vector3:
	var n := (b - a).cross(c - a).normalized()
	if n.dot(hint) < 0.0:
		n = -n
	return n
