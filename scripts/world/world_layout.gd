class_name WorldLayout
extends RefCounted
## Layout determinístico do mundo aberto de Santa Aurora (3 x 3 km).
##
## Apenas DADOS: distritos, malha viária, quarteirões, lotes, prédios,
## pontos de interesse, rio, lago, serra com túnel e grafo de navegação.
## A geometria é criada sob demanda pelo ChunkBuilder (streaming por regiões).
##
##  Norte (-Z): Serra da Aurora com o Túnel da Serra (chegada do Caio)
##  Centro: Centro, Praça da Matriz, Hospital São Lucas, Delegacia, Mercado
##  Noroeste: Jardim das Acácias (casa da família)   Sudoeste: Vila Operária
##  Norte: Bairro Alto (apto. da Dra. Helena, escola) Leste: Distrito Industrial
##        com o Complexo Corvalis (Projeto NEXUS)
##  Sul: Rio Aurora, Ponte Velha, zona rural, fazendas, Lago Azul
##  Oeste: Mata do Sabiá (bunker), acampamentos

const HALF := 1536.0
const CHUNK := 64.0
const URBAN := Rect2(-900.0, -800.0, 1900.0, 1300.0)
const SPACING := 100.0
const CURB := 0.12
const SIDEWALK := 3.5
const RIVER_HALF := 18.0
const RIVER_LEVEL := -2.2
const RIVER_BED := -5.6
const LAKE_CENTER := Vector2(1150.0, 1050.0)
const LAKE_R := Vector2(210.0, 150.0)
const LAKE_LEVEL := -1.2
const TUNNEL_Z_SOUTH := -1080.0
const TUNNEL_Z_NORTH := -1230.0
const TUNNEL_Y := 20.0
const TUNNEL_HW := 6.5
const TUNNEL_HEIGHT := 7.2

const SHOP_NAMES := ["PADARIA SOL NASCENTE", "FARMÁCIA VIDA", "MERCADINHO DA ESQUINA", "BAR DO ZECA",
	"AÇOUGUE BOI BOM", "FERRAGENS PREGO FORTE", "ELETRÔNICOS AURORA", "LANCHONETE DOIS IRMÃOS",
	"PAPELARIA ARCO-ÍRIS", "ÓTICA VISÃO CLARA", "SALÃO BELEZA PURA", "LOJA DE ROUPAS ESTAÇÃO",
	"PET SHOP AMIGO FIEL", "BANCO CENTRAL AURORA", "LIVRARIA PÁGINA", "SORVETERIA POLAR",
	"CASA DE RAÇÕES", "CHAVEIRO RÁPIDO", "BAZAR POPULAR", "PIZZARIA FORNO VELHO"]
const HOUSE_TINTS := [Color(0.93, 0.88, 0.76), Color(0.85, 0.72, 0.62), Color(0.78, 0.82, 0.74),
	Color(0.9, 0.9, 0.88), Color(0.72, 0.78, 0.85), Color(0.95, 0.8, 0.6), Color(0.8, 0.68, 0.72),
	Color(0.7, 0.66, 0.6), Color(0.88, 0.62, 0.48)]

var seed_value: int = 0
var noise := FastNoiseLite.new()
var noise2 := FastNoiseLite.new()
var x_lines: Array = []
var z_lines: Array = []
var blocks: Array = []
var buildings: Array = []
var roads: Array = []          # segmentos
var patches: Array = []        # cruzamentos (Rect2)
var river_pts := PackedVector2Array()
var pois: Dictionary = {}
var merged_regions: Array = []
var chunk_buildings: Dictionary = {}
var chunk_roads: Dictionary = {}
var chunk_patches: Dictionary = {}
var chunk_blocks: Dictionary = {}
var chunk_flatten: Dictionary = {}
var chunk_river: Dictionary = {}
var block_grid: Dictionary = {}
var nav := AStar3D.new()
var nav_count: int = 0
var _nav_grid_ids: Dictionary = {}
var hwy_polylines: Array = []  # para desenho no mapa


func generate(world_seed: int) -> void:
	seed_value = world_seed
	noise.seed = world_seed
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = 0.0022
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves = 4
	noise2.seed = world_seed + 17
	noise2.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise2.frequency = 0.02
	_river()
	_grid_lines()
	_merged_regions()
	_city_roads()
	_highways()
	_blocks()
	_rural()
	_index()
	_nav_graph()


# ---------------------------------------------------------------------------
# Distritos
# ---------------------------------------------------------------------------
func district_at(x: float, z: float) -> String:
	if URBAN.has_point(Vector2(x, z)):
		if x >= -350.0 and x < 350.0:
			if z < -350.0:
				return "bairro_alto"
			if z < 350.0:
				return "centro"
			return "centro_sul"
		if x < -350.0:
			return "acacias" if z < -100.0 else "vila_operaria"
		if z < -400.0:
			return "parque_norte"
		return "industrial"
	if z < -880.0:
		return "serra"
	if x < -1000.0 and z < 520.0:
		return "floresta"
	if river_distance(x, z) < 60.0:
		return "rio"
	if z > 520.0:
		return "rural"
	if x > 1000.0:
		return "rural"
	return "periferia"


static func district_name(d: String) -> String:
	match d:
		"centro": return "Centro"
		"centro_sul": return "Centro Sul"
		"bairro_alto": return "Bairro Alto"
		"acacias": return "Jardim das Acácias"
		"vila_operaria": return "Vila Operária"
		"industrial": return "Distrito Industrial"
		"parque_norte": return "Parque Norte"
		"serra": return "Serra da Aurora"
		"floresta": return "Mata do Sabiá"
		"rio": return "Rio Aurora"
		"rural": return "Zona Rural"
		_: return "Periferia"


# ---------------------------------------------------------------------------
# Terreno
# ---------------------------------------------------------------------------
func _urban_out_dist(x: float, z: float) -> float:
	var dx := maxf(URBAN.position.x - x, x - URBAN.end.x)
	var dz := maxf(URBAN.position.y - z, z - URBAN.end.y)
	if dx <= 0.0 and dz <= 0.0:
		return 0.0
	return Vector2(maxf(dx, 0.0), maxf(dz, 0.0)).length()


func natural_height(x: float, z: float) -> float:
	var d_out := _urban_out_dist(x, z)
	var h := 0.0
	if d_out > 0.0:
		var amp := smoothstep(0.0, 380.0, d_out)
		h = (noise.get_noise_2d(x, z) * 0.5 + 0.5) * 24.0 * amp + noise2.get_noise_2d(x, z) * 0.7 * amp
		var rz := -z
		if rz > 900.0:
			h += exp(-pow((rz - 1155.0) / 115.0, 2.0)) * (56.0 + noise.get_noise_2d(x * 2.0, 77.0) * 14.0)
		var dh := Vector2(x - 950.0, z + 1000.0).length()
		if dh < 600.0:
			h += exp(-pow(dh / 210.0, 2.0)) * 36.0
	return h


## Altura visual do terreno (m). Custo: ~20 µs — use em threads/cache.
func height(x: float, z: float) -> float:
	var h := natural_height(x, z)
	var c := Vector2i(floori(x / CHUNK), floori(z / CHUNK))
	var p := Vector2(x, z)
	# rodovias achatam o terreno ao redor
	var fl: Array = chunk_flatten.get(c, [])
	if not fl.is_empty():
		var best_w := 0.0
		var best_y := 0.0
		for si in fl:
			var seg: Dictionary = roads[si]
			var a: Vector2 = seg["a"]
			var b: Vector2 = seg["b"]
			var ab := b - a
			var t := clampf((p - a).dot(ab) / maxf(ab.length_squared(), 0.001), 0.0, 1.0)
			var d := p.distance_to(a + ab * t)
			var hw: float = seg["hw"]
			var w := 1.0 - smoothstep(hw + 1.0, hw + 24.0, d)
			if w > best_w:
				best_w = w
				best_y = lerpf(float(seg["ya"]), float(seg["yb"]), t) - 0.06
		if best_w > 0.0:
			h = lerpf(h, best_y, best_w)
	# rio
	var rv: Array = chunk_river.get(c, [])
	if not rv.is_empty():
		var rd := INF
		for i in rv:
			var d := Util.dist_point_segment_2d(p, river_pts[i], river_pts[i + 1])
			rd = minf(rd, d)
		if rd < RIVER_HALF + 30.0:
			h = lerpf(RIVER_BED, h, smoothstep(RIVER_HALF - 8.0, RIVER_HALF + 30.0, rd))
	# lago
	var le := ((p - LAKE_CENTER) / LAKE_R).length()
	if le < 1.4:
		h = lerpf(-5.0, h, smoothstep(0.75, 1.4, le))
	return h


## Altura física (colisão/NPCs). Igual à visual exceto calçadas/quarteirões.
func ground_height(x: float, z: float) -> float:
	if URBAN.has_point(Vector2(x, z)):
		return CURB if block_at(x, z) >= 0 else 0.0
	if absf(x) < TUNNEL_HW + 2.0 and z < TUNNEL_Z_SOUTH and z > TUNNEL_Z_NORTH:
		return TUNNEL_Y
	return height(x, z)


func river_distance(x: float, z: float) -> float:
	return Util.dist_point_polyline_2d(Vector2(x, z), river_pts)


func is_water(x: float, z: float) -> bool:
	if river_distance(x, z) < RIVER_HALF + 8.0:
		return true
	return ((Vector2(x, z) - LAKE_CENTER) / LAKE_R).length() < 0.92


func in_tunnel(pos: Vector3) -> bool:
	return absf(pos.x) < TUNNEL_HW + 0.5 and pos.z < TUNNEL_Z_SOUTH and pos.z > TUNNEL_Z_NORTH and pos.y < TUNNEL_Y + TUNNEL_HEIGHT


## Buracos no terreno (fachadas dos portais do túnel cobrem esses retângulos).
func terrain_holes() -> Array:
	return [Rect2(-16.0, TUNNEL_Z_SOUTH - 2.0, 32.0, 4.0), Rect2(-16.0, TUNNEL_Z_NORTH - 2.0, 32.0, 4.0)]


# ---------------------------------------------------------------------------
# Rio
# ---------------------------------------------------------------------------
func _river() -> void:
	var ctrl := [Vector2(-1560, 620), Vector2(-1100, 655), Vector2(-700, 598), Vector2(-300, 640),
		Vector2(100, 700), Vector2(500, 680), Vector2(900, 742), Vector2(1300, 800), Vector2(1560, 782)]
	river_pts = PackedVector2Array()
	for i in ctrl.size() - 1:
		var a: Vector2 = ctrl[i]
		var b: Vector2 = ctrl[i + 1]
		var steps := int(a.distance_to(b) / 40.0)
		for k in steps:
			var t := float(k) / float(steps)
			var p := a.lerp(b, t)
			# meandro suave
			p.y += sin(p.x * 0.012) * 14.0
			river_pts.append(p)
	river_pts.append(ctrl[ctrl.size() - 1])


# ---------------------------------------------------------------------------
# Malha viária
# ---------------------------------------------------------------------------
func _grid_lines() -> void:
	x_lines.clear()
	z_lines.clear()
	var x := URBAN.position.x
	while x <= URBAN.end.x + 0.1:
		x_lines.append(x)
		x += SPACING
	var z := URBAN.position.y
	while z <= URBAN.end.y + 0.1:
		z_lines.append(z)
		z += SPACING


func hw_x(x: float) -> float:
	return 7.0 if absf(x) < 0.1 else 4.5


func hw_z(z: float) -> float:
	return 6.0 if absf(z) < 0.1 else 4.5


func _merged_regions() -> void:
	merged_regions = [
		{"rect": Rect2(-800, 300, 200, 200), "kind": "stadium"},
		{"rect": Rect2(600, -100, 200, 200), "kind": "corvalis"},
	]


func _in_merged(p: Vector2) -> int:
	for i in merged_regions.size():
		var r: Rect2 = merged_regions[i]["rect"]
		if r.grow(-2.0).has_point(p):
			return i
	return -1


func _add_road(a: Vector2, b: Vector2, hw: float, kind: String, marks: int, ya: float = 0.02, yb: float = 0.02) -> int:
	roads.append({"a": a, "b": b, "hw": hw, "kind": kind, "marks": marks, "ya": ya, "yb": yb})
	return roads.size() - 1


func _city_roads() -> void:
	# segmentos verticais (x constante)
	for xi in x_lines:
		var x: float = xi
		for k in z_lines.size() - 1:
			var z0: float = z_lines[k]
			var z1: float = z_lines[k + 1]
			var a := Vector2(x, z0 + hw_z(z0))
			var b := Vector2(x, z1 - hw_z(z1))
			if _in_merged((a + b) * 0.5) >= 0:
				continue
			_add_road(a, b, hw_x(x), "avenue" if hw_x(x) > 5.0 else "street", 2 if hw_x(x) > 5.0 else 1)
	for zi in z_lines:
		var z: float = zi
		for k in x_lines.size() - 1:
			var x0: float = x_lines[k]
			var x1: float = x_lines[k + 1]
			var a := Vector2(x0 + hw_x(x0), z)
			var b := Vector2(x1 - hw_x(x1), z)
			if _in_merged((a + b) * 0.5) >= 0:
				continue
			_add_road(a, b, hw_z(z), "avenue" if hw_z(z) > 5.0 else "street", 2 if hw_z(z) > 5.0 else 1)
	patches.clear()
	for xi in x_lines:
		for zi in z_lines:
			var x: float = xi
			var z: float = zi
			if _in_merged(Vector2(x, z)) >= 0:
				continue
			patches.append(Rect2(x - hw_x(x), z - hw_z(z), hw_x(x) * 2.0, hw_z(z) * 2.0))


func _north_profile(z: float) -> float:
	# perfil da rodovia norte (sobe a serra até o túnel)
	if z >= -800.0:
		return 0.02
	if z >= -1000.0:
		return lerpf(0.02, 12.0, smoothstep(-800.0, -1000.0, z))
	if z >= TUNNEL_Z_SOUTH:
		return lerpf(12.0, TUNNEL_Y, smoothstep(-1000.0, TUNNEL_Z_SOUTH, z))
	if z >= TUNNEL_Z_NORTH:
		return TUNNEL_Y
	if z >= -1340.0:
		return lerpf(TUNNEL_Y, 9.0, smoothstep(TUNNEL_Z_NORTH, -1340.0, z))
	return lerpf(9.0, 5.0, smoothstep(-1340.0, -1536.0, z))


func _polyline_road(ctrl: Array, hw: float, kind: String, marks: int, north_profile: bool = false) -> void:
	var pts: Array = []
	for i in ctrl.size() - 1:
		var a: Vector2 = ctrl[i]
		var b: Vector2 = ctrl[i + 1]
		var steps := maxi(1, int(a.distance_to(b) / 12.0))
		for k in steps:
			pts.append(a.lerp(b, float(k) / float(steps)))
	pts.append(ctrl[ctrl.size() - 1])
	hwy_polylines.append({"pts": pts, "kind": kind})
	# elevação: altura natural suavizada (ou perfil projetado)
	var raw: Array = []
	for p in pts:
		var v: Vector2 = p
		raw.append(_north_profile(v.y) if north_profile else natural_height(v.x, v.y))
	var elev: Array = []
	for i in pts.size():
		if north_profile:
			elev.append(raw[i])
			continue
		var s := 0.0
		var n := 0
		for k in range(maxi(0, i - 5), mini(pts.size(), i + 6)):
			s += float(raw[k])
			n += 1
		var y := s / float(n)
		var pv: Vector2 = pts[i]
		if URBAN.grow(2.0).has_point(pv):
			y = 0.02
		elev.append(y)
	for i in pts.size() - 1:
		var a: Vector2 = pts[i]
		var b: Vector2 = pts[i + 1]
		var mid := (a + b) * 0.5
		var ya: float = elev[i]
		var yb: float = elev[i + 1]
		var k := kind
		if river_distance(mid.x, mid.y) < RIVER_HALF + 16.0:
			k = "bridge"
			ya = maxf(ya, 1.8)
			yb = maxf(yb, 1.8)
		elif river_distance(a.x, a.y) < RIVER_HALF + 16.0:
			ya = maxf(ya, 1.8)
		elif river_distance(b.x, b.y) < RIVER_HALF + 16.0:
			yb = maxf(yb, 1.8)
		if north_profile and mid.y < TUNNEL_Z_SOUTH and mid.y > TUNNEL_Z_NORTH:
			k = "tunnel"
		if URBAN.grow(-1.0).has_point(mid):
			continue
		_add_road(a, b, hw, k, marks, ya, yb)


func _highways() -> void:
	hwy_polylines.clear()
	_polyline_road([Vector2(0, -800 - 7), Vector2(0, TUNNEL_Z_SOUTH), Vector2(0, TUNNEL_Z_NORTH), Vector2(-40, -1400), Vector2(-60, -1560)], 5.0, "highway", 3, true)
	_polyline_road([Vector2(0, 506), Vector2(0, 640), Vector2(4, 760), Vector2(20, 1000), Vector2(0, 1560)], 5.0, "highway", 3)
	_polyline_road([Vector2(20, 1000), Vector2(-180, 1080), Vector2(-350, 1130)], 3.2, "dirt", 0)
	_polyline_road([Vector2(-906, 0), Vector2(-1000, 20), Vector2(-1300, 60), Vector2(-1560, 80)], 5.0, "highway", 3)
	_polyline_road([Vector2(1006, 0), Vector2(1100, 80), Vector2(1300, 300), Vector2(1560, 350)], 5.0, "highway", 3)
	_polyline_road([Vector2(1300, 300), Vector2(1260, 600), Vector2(1170, 870)], 3.2, "dirt", 0)
	_polyline_road([Vector2(400, 506), Vector2(400, 640), Vector2(420, 760), Vector2(520, 1000), Vector2(600, 1220)], 4.0, "highway", 1)
	_polyline_road([Vector2(1006, -800), Vector2(980, -900), Vector2(950, -990)], 3.0, "dirt", 0)
	_polyline_road([Vector2(-906, -300), Vector2(-1080, -320), Vector2(-1240, -350)], 3.0, "dirt", 0)
	_polyline_road([Vector2(-906, 150), Vector2(-1100, 150)], 3.0, "dirt", 0)
	_polyline_road([Vector2(0, -900), Vector2(150, -930), Vector2(250, -950)], 3.0, "dirt", 0)


# ---------------------------------------------------------------------------
# Quarteirões, lotes e prédios
# ---------------------------------------------------------------------------
func _blocks() -> void:
	blocks.clear()
	buildings.clear()
	var r := Util.rng(seed_value + 101)
	# regiões mescladas viram quarteirões únicos
	for mi in merged_regions.size():
		var mr: Rect2 = merged_regions[mi]["rect"]
		var rect := Rect2(mr.position.x + 4.5, mr.position.y + 4.5, mr.size.x - 9.0, mr.size.y - 9.0)
		var bid := blocks.size()
		blocks.append({"rect": rect, "district": district_at(rect.get_center().x, rect.get_center().y), "kind": merged_regions[mi]["kind"], "id": bid})
	for i in x_lines.size() - 1:
		for k in z_lines.size() - 1:
			var x0: float = x_lines[i]
			var x1: float = x_lines[i + 1]
			var z0: float = z_lines[k]
			var z1: float = z_lines[k + 1]
			var center := Vector2((x0 + x1) * 0.5, (z0 + z1) * 0.5)
			if _in_merged(center) >= 0:
				continue
			var rect := Rect2(x0 + hw_x(x0), z0 + hw_z(z0), (x1 - hw_x(x1)) - (x0 + hw_x(x0)), (z1 - hw_z(z1)) - (z0 + hw_z(z0)))
			var bid := blocks.size()
			var dist := district_at(center.x, center.y)
			blocks.append({"rect": rect, "district": dist, "kind": _block_kind(center, dist, r), "id": bid})
	for b in blocks:
		_fill_block(b, r)
	for b in blocks:
		var rect: Rect2 = b["rect"]
		var key := _grid_key(rect.get_center().x, rect.get_center().y)
		block_grid[key] = b["id"]


func _grid_key(x: float, z: float) -> Vector2i:
	return Vector2i(floori((x - URBAN.position.x) / SPACING), floori((z - URBAN.position.y) / SPACING))


## Índice do quarteirão sob (x,z) ou -1 (rua).
func block_at(x: float, z: float) -> int:
	var key := _grid_key(x, z)
	var bid: int = block_grid.get(key, -1)
	if bid < 0:
		# regiões mescladas
		for i in merged_regions.size():
			var b: Dictionary = blocks[i]
			if (b["rect"] as Rect2).has_point(Vector2(x, z)):
				return i
		return -1
	var rect: Rect2 = blocks[bid]["rect"]
	if rect.has_point(Vector2(x, z)):
		return bid
	for i in merged_regions.size():
		var b: Dictionary = blocks[i]
		if (b["rect"] as Rect2).has_point(Vector2(x, z)):
			return i
	return -1


func _block_kind(c: Vector2, dist: String, r: RandomNumberGenerator) -> String:
	var specials := {
		Vector2(150, -150): "hospital", Vector2(-150, 150): "market", Vector2(-250, 50): "police",
		Vector2(-50, -50): "plaza", Vector2(50, 450): "terminal", Vector2(150, -550): "school",
		Vector2(-150, -650): "helena_block", Vector2(250, -450): "clinic_block", Vector2(-550, 250): "workshop_block",
		Vector2(650, -650): "church_block", Vector2(-550, -450): "family_block", Vector2(250, 150): "shops_tv",
		Vector2(-450, 450): "park", Vector2(50, -450): "park", Vector2(550, -550): "park", Vector2(850, -650): "park",
		Vector2(-850, 50): "gas_block",
	}
	for key in specials.keys():
		if c.distance_to(key) < 1.0:
			return specials[key]
	match dist:
		"centro":
			return "parking" if r.randf() < 0.07 else "downtown"
		"centro_sul":
			return "mixed"
		"bairro_alto":
			return "apartments"
		"acacias":
			return "houses"
		"vila_operaria":
			return "small_houses"
		"industrial":
			return "industrial"
		"parque_norte":
			return "park" if r.randf() < 0.5 else "houses"
	return "houses"


func _new_building(t: String, rect: Rect2, floors: int, facing: int, opts: Dictionary = {}) -> Dictionary:
	var b := {
		"id": buildings.size(), "type": t, "rect": rect, "floors": floors, "fh": float(opts.get("fh", 3.0)),
		"gfh": float(opts.get("gfh", opts.get("fh", 3.0))), "roof": opts.get("roof", "flat"), "facing": facing,
		"enterable": opts.get("enterable", false), "layer": int(opts.get("layer", Assets.L_PLASTER)),
		"roof_layer": int(opts.get("roof_layer", Assets.L_CONCRETE)), "tint": opts.get("tint", Color(0.9, 0.9, 0.88)),
		"wmode": int(opts.get("wmode", Assets.WM_RES)), "seed": int(opts.get("seed", buildings.size() * 13 + 7)),
		"name": opts.get("name", ""), "poi": opts.get("poi", ""), "district": district_at(rect.get_center().x, rect.get_center().y),
		"base": float(opts.get("base", CURB)), "interior": opts.get("interior", t),
	}
	buildings.append(b)
	if str(b["poi"]) != "":
		_poi(str(b["poi"]), door_position(b), str(opts.get("poi_name", b["name"])), t, b["id"])
	return b


## Posição da porta principal (no chão, do lado de fora).
func door_position(b: Dictionary) -> Vector3:
	var r: Rect2 = b["rect"]
	var c := r.get_center()
	var y: float = b["base"]
	match int(b["facing"]):
		0: return Vector3(c.x, y, r.position.y - 0.6)
		1: return Vector3(r.end.x + 0.6, y, c.y)
		2: return Vector3(c.x, y, r.end.y + 0.6)
		_: return Vector3(r.position.x - 0.6, y, c.y)


func _poi(id: String, pos: Vector3, poi_name: String, kind: String, building: int = -1, radius: float = 20.0) -> void:
	pois[id] = {"id": id, "pos": pos, "name": poi_name, "kind": kind, "building": building, "radius": radius}


func poi_pos(id: String) -> Vector3:
	if pois.has(id):
		return pois[id]["pos"]
	return Vector3.ZERO


func _fill_block(b: Dictionary, r: RandomNumberGenerator) -> void:
	var rect: Rect2 = b["rect"]
	var inner := rect.grow(-SIDEWALK)
	var kind: String = b["kind"]
	var c := rect.get_center()
	match kind:
		"hospital":
			var hr := Rect2(inner.position.x + 6, inner.position.y + 8, inner.size.x - 12, inner.size.y - 30)
			_new_building("hospital", hr, 5, 2, {"fh": 3.4, "gfh": 4.0, "layer": Assets.L_PANELS, "tint": Color(0.92, 0.93, 0.94), "wmode": Assets.WM_OFFICE,
				"enterable": true, "poi": "hospital", "name": "HOSPITAL SÃO LUCAS", "poi_name": "Hospital São Lucas"})
		"market":
			var mr := Rect2(inner.position.x + 4, inner.position.y + 4, inner.size.x - 8, inner.size.y * 0.55)
			_new_building("market", mr, 1, 2, {"gfh": 6.0, "fh": 6.0, "layer": Assets.L_PANELS, "tint": Color(0.85, 0.83, 0.78), "wmode": Assets.WM_SHOP,
				"enterable": true, "poi": "mercado", "name": "SUPERMERCADO VALE VERDE", "poi_name": "Supermercado Vale Verde"})
		"police":
			var pr := Rect2(inner.position.x + 3, inner.position.y + 3, inner.size.x * 0.6, inner.size.y * 0.45)
			_new_building("police", pr, 2, 3, {"fh": 3.4, "layer": Assets.L_PLASTER, "tint": Color(0.7, 0.75, 0.82), "wmode": Assets.WM_OFFICE,
				"enterable": true, "poi": "delegacia", "name": "DELEGACIA CENTRAL", "poi_name": "Delegacia Central (Guarda Aurora)"})
			_downtown_lot(Rect2(inner.position.x + inner.size.x * 0.62, inner.position.y, inner.size.x * 0.38, inner.size.y * 0.5), r, 1)
			_downtown_lot(Rect2(inner.position.x, inner.position.y + inner.size.y * 0.5, inner.size.x, inner.size.y * 0.5), r, 2)
		"plaza":
			var ch := Rect2(c.x - 9, inner.position.y + 4, 18, 30)
			_new_building("church", ch, 1, 2, {"gfh": 11.0, "fh": 11.0, "roof": "gable", "roof_layer": Assets.L_ROOF, "layer": Assets.L_PLASTER,
				"tint": Color(0.94, 0.92, 0.86), "wmode": Assets.WM_NONE, "enterable": true, "poi": "igreja_matriz", "name": "IGREJA MATRIZ", "poi_name": "Igreja Matriz"})
			_poi("praca", Vector3(c.x, CURB, c.y + 15), "Praça da Matriz", "plaza")
		"terminal":
			var tr := Rect2(inner.position.x + 5, inner.position.y + 20, inner.size.x - 10, inner.size.y - 30)
			_new_building("terminal", tr, 1, 0, {"gfh": 7.0, "fh": 7.0, "layer": Assets.L_PANELS, "tint": Color(0.8, 0.8, 0.82), "wmode": Assets.WM_SHOP,
				"enterable": true, "poi": "terminal", "name": "TERMINAL RODOVIÁRIO", "poi_name": "Terminal Rodoviário"})
		"school":
			var sr := Rect2(inner.position.x + 5, inner.position.y + 5, inner.size.x - 10, 30)
			_new_building("school", sr, 2, 0, {"fh": 3.5, "layer": Assets.L_BRICK, "tint": Color(1, 1, 1), "wmode": Assets.WM_OFFICE,
				"enterable": true, "poi": "escola", "name": "ESCOLA ESTADUAL AURORA", "poi_name": "Escola Estadual Aurora"})
		"helena_block":
			var ar := Rect2(inner.position.x + 4, inner.position.y + 4, 30, 22)
			_new_building("apartment", ar, 6, 0, {"layer": Assets.L_PLASTER, "tint": Color(0.86, 0.84, 0.8), "enterable": true,
				"poi": "apartamento_helena", "name": "EDIFÍCIO IPÊ", "poi_name": "Edifício Ipê (apto. da Dra. Helena)", "interior": "apartment"})
			_apartments_in(Rect2(inner.position.x, inner.position.y + 34, inner.size.x, inner.size.y - 34), r)
		"clinic_block":
			var cr := Rect2(inner.position.x + 5, inner.position.y + 5, 34, 20)
			_new_building("clinic", cr, 2, 0, {"layer": Assets.L_PLASTER, "tint": Color(0.9, 0.95, 0.92), "wmode": Assets.WM_OFFICE, "enterable": true,
				"poi": "clinica", "name": "CLÍNICA BAIRRO ALTO", "poi_name": "Clínica do Bairro Alto"})
			_apartments_in(Rect2(inner.position.x, inner.position.y + 32, inner.size.x, inner.size.y - 32), r)
		"workshop_block":
			var wr := Rect2(inner.position.x + 4, inner.position.y + 4, 26, 18)
			_new_building("workshop", wr, 1, 0, {"gfh": 5.0, "fh": 5.0, "roof": "gable", "roof_layer": Assets.L_METAL, "layer": Assets.L_BRICK,
				"tint": Color(0.9, 0.9, 0.9), "wmode": Assets.WM_NONE, "enterable": true, "poi": "oficina", "name": "OFICINA DO TONHO", "poi_name": "Oficina do Tonho"})
			_houses_in(Rect2(inner.position.x + 34, inner.position.y, inner.size.x - 34, inner.size.y), r, true)
		"church_block":
			var ch2 := Rect2(c.x - 10, c.y - 16, 20, 32)
			_new_building("church", ch2, 1, 2, {"gfh": 12.0, "fh": 12.0, "roof": "gable", "roof_layer": Assets.L_ROOF, "layer": Assets.L_PLASTER,
				"tint": Color(0.82, 0.8, 0.76), "wmode": Assets.WM_NONE, "enterable": true, "poi": "igreja_despertos", "name": "CAPELA SÃO JUDAS", "poi_name": "Capela São Judas (Os Despertos)"})
		"family_block":
			_houses_in(inner, r, false, true)
		"shops_tv":
			_downtown_lot(Rect2(inner.position.x, inner.position.y, inner.size.x * 0.5, inner.size.y * 0.5), r, 0, "ELETRÔNICOS AURORA", "loja_tv")
			_downtown_lot(Rect2(inner.position.x + inner.size.x * 0.5, inner.position.y, inner.size.x * 0.5, inner.size.y * 0.5), r, 0)
			_downtown_lot(Rect2(inner.position.x, inner.position.y + inner.size.y * 0.5, inner.size.x * 0.5, inner.size.y * 0.5), r, 2)
			_downtown_lot(Rect2(inner.position.x + inner.size.x * 0.5, inner.position.y + inner.size.y * 0.5, inner.size.x * 0.5, inner.size.y * 0.5), r, 2)
		"gas_block":
			var gr := Rect2(inner.position.x + 10, inner.position.y + 50, 14, 10)
			_new_building("gas_station", gr, 1, 1, {"gfh": 3.5, "fh": 3.5, "layer": Assets.L_PLASTER, "tint": Color(0.92, 0.9, 0.86), "wmode": Assets.WM_SHOP,
				"enterable": true, "name": "POSTO ESTRELA", "poi": "posto_vila", "poi_name": "Posto Estrela (Vila Operária)"})
			_houses_in(Rect2(inner.position.x, inner.position.y, inner.size.x, 40), r, true)
		"stadium":
			var sr2 := Rect2(inner.position.x + 20, inner.position.y + 25, inner.size.x - 40, inner.size.y - 50)
			_new_building("stadium", sr2, 1, 0, {"gfh": 14.0, "fh": 14.0, "layer": Assets.L_PANELS, "tint": Color(0.75, 0.74, 0.72), "wmode": Assets.WM_NONE,
				"enterable": true, "poi": "estadio", "name": "ESTÁDIO MUNICIPAL", "poi_name": "Estádio Municipal (Os Remanescentes)"})
		"corvalis":
			var hq := Rect2(inner.position.x + 10, inner.position.y + 10, 46, 30)
			_new_building("office", hq, 9, 0, {"fh": 3.5, "gfh": 5.0, "layer": Assets.L_PANELS, "tint": Color(0.7, 0.74, 0.78), "wmode": Assets.WM_OFFICE,
				"enterable": true, "poi": "corvalis_hq", "name": "CORVALIS BIOTECNOLOGIA", "poi_name": "Sede Corvalis Biotecnologia"})
			var lab := Rect2(inner.position.x + 70, inner.position.y + 60, 64, 44)
			_new_building("lab", lab, 2, 2, {"fh": 4.2, "gfh": 4.6, "layer": Assets.L_PANELS, "tint": Color(0.86, 0.88, 0.9), "wmode": Assets.WM_OFFICE,
				"enterable": true, "poi": "lab_nexus", "name": "CORVALIS — P&D", "poi_name": "Laboratório de P&D (Projeto NEXUS)", "interior": "lab"})
			var wh := Rect2(inner.position.x + 12, inner.position.y + 110, 48, 60)
			_new_building("warehouse", wh, 1, 1, {"gfh": 9.0, "fh": 9.0, "roof": "gable", "roof_layer": Assets.L_METAL, "layer": Assets.L_METAL,
				"tint": Color(0.75, 0.78, 0.8), "wmode": Assets.WM_NONE, "enterable": true, "name": "CORVALIS — LOGÍSTICA"})
			var guard := Rect2(inner.position.x + 90, inner.position.y + 2, 8, 6)
			_new_building("guardhouse", guard, 1, 0, {"gfh": 3.0, "layer": Assets.L_PLASTER, "tint": Color(0.8, 0.8, 0.8), "wmode": Assets.WM_SHOP, "enterable": false})
			_poi("corvalis", Vector3(c.x, CURB, c.y), "Complexo Corvalis", "complex", -1, 110.0)
		"downtown":
			var hx := inner.size.x * 0.5
			var hz := inner.size.y * 0.5
			for qi in 4:
				var qx := qi % 2
				var qz := qi / 2
				var lot := Rect2(inner.position.x + qx * hx, inner.position.y + qz * hz, hx, hz)
				var facing := 0 if qz == 0 else 2
				if r.randf() < 0.3:
					facing = 3 if qx == 0 else 1
				_downtown_lot(lot, r, facing)
		"mixed":
			var n := 3
			for li in n:
				var lot := Rect2(inner.position.x + inner.size.x * li / n, inner.position.y, inner.size.x / n, inner.size.y * 0.5)
				_downtown_lot(lot, r, 0, "", "", 2, 4)
				var lot2 := Rect2(inner.position.x + inner.size.x * li / n, inner.position.y + inner.size.y * 0.5, inner.size.x / n, inner.size.y * 0.5)
				_downtown_lot(lot2, r, 2, "", "", 1, 3)
		"apartments":
			_apartments_in(inner, r)
		"houses":
			_houses_in(inner, r, false)
		"small_houses":
			_houses_in(inner, r, true)
		"industrial":
			_industrial_in(inner, r)
		"park", "parking":
			pass


func _downtown_lot(lot: Rect2, r: RandomNumberGenerator, facing: int, force_name: String = "", poi_id: String = "", min_f: int = 3, max_f: int = 14) -> void:
	var inset := r.randf_range(0.5, 2.5)
	var br := lot.grow(-inset)
	var near_avenue := absf(br.get_center().x) < 120.0
	var floors := r.randi_range(min_f, max_f)
	if near_avenue and max_f > 6:
		floors += r.randi_range(2, 8)
	var tall := floors >= 7
	var name_ := force_name
	if name_ == "" and r.randf() < 0.75:
		name_ = SHOP_NAMES[r.randi() % SHOP_NAMES.size()]
	var layers := [Assets.L_PANELS, Assets.L_PLASTER, Assets.L_BRICK, Assets.L_PANELS]
	var layer: int = layers[r.randi() % 4]
	var tint := Color(1, 1, 1)
	if layer != Assets.L_BRICK:
		var base_tint: Color = HOUSE_TINTS[r.randi() % HOUSE_TINTS.size()]
		tint = base_tint.lerp(Color(0.8, 0.8, 0.8), 0.5)
	var interior := "shop"
	if name_.begins_with("FARMÁCIA"):
		interior = "pharmacy"
	elif name_.begins_with("FERRAGENS"):
		interior = "hardware"
	elif name_.begins_with("MERCADINHO") or name_.begins_with("PADARIA") or name_.begins_with("AÇOUGUE"):
		interior = "grocery"
	elif name_.begins_with("BAR") or name_.begins_with("LANCHONETE") or name_.begins_with("PIZZARIA"):
		interior = "bar"
	var opts := {"fh": 3.2, "gfh": 4.2, "layer": layer, "tint": tint, "wmode": Assets.WM_SHOP if name_ != "" else (Assets.WM_OFFICE if tall else Assets.WM_RES),
		"enterable": name_ != "", "name": name_, "interior": interior}
	if poi_id != "":
		opts["poi"] = poi_id
		opts["poi_name"] = name_.capitalize()
	_new_building("tower" if tall else "commercial", br, floors, facing, opts)


func _apartments_in(inner: Rect2, r: RandomNumberGenerator) -> void:
	var count := r.randi_range(2, 3)
	var w := inner.size.x / count
	for i in count:
		var bw := w - r.randf_range(8.0, 14.0)
		var bd := r.randf_range(14.0, 20.0)
		var x := inner.position.x + w * i + (w - bw) * 0.5
		var facing := 0 if i % 2 == 0 else 2
		var z := inner.position.y + 5.0 if facing == 0 else inner.end.y - 5.0 - bd
		if inner.size.y < 45.0:
			z = inner.position.y + (inner.size.y - bd) * 0.5
		_new_building("apartment", Rect2(x, z, bw, bd), r.randi_range(4, 8), facing, {"layer": [Assets.L_PLASTER, Assets.L_BRICK, Assets.L_PANELS][r.randi() % 3],
			"tint": HOUSE_TINTS[r.randi() % HOUSE_TINTS.size()], "wmode": Assets.WM_RES, "enterable": r.randf() < 0.5, "interior": "apartment"})


func _houses_in(inner: Rect2, r: RandomNumberGenerator, small: bool, family: bool = false) -> void:
	var per_row := 6 if small else 5
	var lot_w := inner.size.x / per_row
	var row_d := inner.size.y * 0.5
	for row in 2:
		for i in per_row:
			var lx := inner.position.x + lot_w * i
			var hw := lot_w - r.randf_range(3.0, 5.0)
			var hd := r.randf_range(7.5, 9.5) if small else r.randf_range(9.0, 12.5)
			hw = minf(hw, 10.0 if small else 13.0)
			var setback := r.randf_range(3.5, 6.0)
			var hx := lx + (lot_w - hw) * 0.5
			var hz := inner.position.y + setback if row == 0 else inner.end.y - setback - hd
			var facing := 0 if row == 0 else 2
			var floors := 1 if small or r.randf() < 0.55 else 2
			var is_family := family and row == 0 and i == 2
			var opts := {"fh": 2.9, "roof": "gable" if r.randf() < 0.8 else "flat", "roof_layer": Assets.L_ROOF,
				"layer": Assets.L_BRICK if r.randf() < 0.25 else Assets.L_PLASTER, "tint": HOUSE_TINTS[r.randi() % HOUSE_TINTS.size()],
				"wmode": Assets.WM_RES, "enterable": true, "interior": "house", "lot": Rect2(lx, inner.position.y + row * row_d, lot_w, row_d)}
			if is_family:
				floors = 2
				opts["poi"] = "casa_familia"
				opts["poi_name"] = "Casa da família (Rua das Acácias, 112)"
				opts["name"] = "112"
				opts["tint"] = Color(0.93, 0.85, 0.66)
				opts["roof"] = "gable"
			elif r.randf() < 0.06:
				opts["name"] = ["FARMÁCIA POPULAR", "MERCADINHO DA ESQUINA", "BAR DO ZECA", "PADARIA SOL NASCENTE"][r.randi() % 4]
				opts["wmode"] = Assets.WM_SHOP
				opts["interior"] = "pharmacy" if str(opts["name"]).begins_with("FARM") else ("bar" if str(opts["name"]).begins_with("BAR") else "grocery")
				opts["roof"] = "flat"
			var b := _new_building("house", Rect2(hx, hz, hw, hd), floors, facing, opts)
			b["lot"] = opts["lot"]


func _industrial_in(inner: Rect2, r: RandomNumberGenerator) -> void:
	var two := r.randf() < 0.6
	var parts := 2 if two else 1
	for i in parts:
		var w := inner.size.x / parts - r.randf_range(6.0, 12.0)
		var d := inner.size.y - r.randf_range(20.0, 34.0)
		var x := inner.position.x + inner.size.x * i / parts + 3.0
		var z := inner.position.y + r.randf_range(4.0, 10.0)
		var factory := r.randf() < 0.35
		_new_building("factory" if factory else "warehouse", Rect2(x, z, w, d), 1, 0 if r.randf() < 0.5 else 2,
			{"gfh": r.randf_range(8.0, 12.0), "fh": 10.0, "roof": "gable", "roof_layer": Assets.L_METAL,
			"layer": Assets.L_METAL if r.randf() < 0.6 else Assets.L_BRICK, "tint": [Color(0.7, 0.72, 0.74), Color(0.6, 0.65, 0.55), Color(0.75, 0.62, 0.5), Color(1, 1, 1)][r.randi() % 4],
			"wmode": Assets.WM_NONE, "enterable": r.randf() < 0.55, "interior": "warehouse", "chimney": factory})


func _rural() -> void:
	var r := Util.rng(seed_value + 303)
	# fazendas
	var farms := [["fazenda_santa_clara", Vector2(-350, 1150), "Fazenda Santa Clara (Centro de Triagem)"], ["fazenda_boa_vista", Vector2(600, 1250), "Fazenda Boa Vista"],
		["sitio_oeste", Vector2(-1250, 700), "Sítio dos Ramos"]]
	for f in farms:
		var fc: Vector2 = f[1]
		var y := natural_height(fc.x, fc.y)
		_new_building("farmhouse", Rect2(fc.x - 7, fc.y - 6, 14, 12), 1, 2, {"base": y + 0.3, "fh": 3.2, "roof": "gable", "roof_layer": Assets.L_ROOF,
			"layer": Assets.L_PLASTER, "tint": Color(0.95, 0.9, 0.8), "wmode": Assets.WM_RES, "enterable": true, "poi": f[0], "poi_name": f[2], "interior": "house"})
		var bx := fc + Vector2(24, -4)
		_new_building("barn", Rect2(bx.x - 9, bx.y - 12, 18, 24), 1, 3, {"base": natural_height(bx.x, bx.y) + 0.2, "gfh": 7.0, "fh": 7.0, "roof": "gable",
			"roof_layer": Assets.L_METAL, "layer": Assets.L_WOOD, "tint": Color(0.75, 0.3, 0.2), "wmode": Assets.WM_NONE, "enterable": true, "interior": "barn"})
	# postos de gasolina nas rodovias
	var stations := [["posto_norte", Vector2(22, -880), "Posto Serra"], ["posto_oeste", Vector2(-1000, 44), "Posto Estrela Oeste"],
		["posto_sul", Vector2(36, 960), "Posto Rota Sul"]]
	for s in stations:
		var sc: Vector2 = s[1]
		_new_building("gas_station", Rect2(sc.x - 6, sc.y - 5, 12, 10), 1, 3, {"base": natural_height(sc.x, sc.y) + 0.2, "gfh": 3.5, "fh": 3.5,
			"layer": Assets.L_PLASTER, "tint": Color(0.92, 0.9, 0.86), "wmode": Assets.WM_SHOP, "enterable": true, "name": "POSTO", "poi": s[0], "poi_name": s[2], "interior": "gas_station"})
	# cabanas do lago
	for i in 4:
		var ang := 3.6 + i * 0.35
		var p := LAKE_CENTER + Vector2(cos(ang) * LAKE_R.x * 1.35, sin(ang) * LAKE_R.y * 1.45)
		_new_building("cabin", Rect2(p.x - 4, p.y - 3.5, 8, 7), 1, 1, {"base": height(p.x, p.y) + 0.4, "fh": 2.8, "roof": "gable", "roof_layer": Assets.L_WOOD,
			"layer": Assets.L_WOOD, "tint": Color(0.9, 0.8, 0.7), "wmode": Assets.WM_RES, "enterable": true, "interior": "cabin",
			"poi": "cabanas_lago" if i == 0 else "", "poi_name": "Cabanas do Lago Azul"})
	_poi("lago_azul", Vector3(LAKE_CENTER.x, LAKE_LEVEL, LAKE_CENTER.y), "Lago Azul", "lake", -1, 200.0)
	# bunker na mata
	var bk := Vector2(-1250, -352)
	_new_building("bunker", Rect2(bk.x - 3, bk.y - 3, 6, 6), 1, 1, {"base": natural_height(bk.x, bk.y) + 0.1, "gfh": 2.8, "layer": Assets.L_CONCRETE,
		"tint": Color(0.6, 0.62, 0.6), "wmode": Assets.WM_NONE, "enterable": true, "poi": "bunker", "poi_name": "Bunker da Mata do Sabiá", "interior": "bunker"})
	# torre de rádio
	var rt := Vector2(952, -1000)
	_new_building("radio_hut", Rect2(rt.x - 3, rt.y - 2.5, 6, 5), 1, 2, {"base": natural_height(rt.x, rt.y) + 0.2, "gfh": 3.0, "layer": Assets.L_CONCRETE,
		"tint": Color(0.8, 0.8, 0.78), "wmode": Assets.WM_RES, "enterable": true, "poi": "torre_radio", "poi_name": "Torre de Rádio da Serra", "interior": "radio"})
	# túnel
	_poi("tunel", Vector3(0, TUNNEL_Y, (TUNNEL_Z_SOUTH + TUNNEL_Z_NORTH) * 0.5), "Túnel da Serra", "tunnel", -1, 80.0)
	_poi("tunel_manutencao", Vector3(-TUNNEL_HW - 0.2, TUNNEL_Y, -1150.0), "Sala de manutenção do túnel", "secret", -1, 6.0)
	_poi("mirante", Vector3(6.0, _north_profile(-1060.0), -1060.0), "Mirante da Serra", "overlook", -1, 30.0)
	_poi("chegada_caio", Vector3(1.5, _north_profile(-1100.0), -1100.0), "Túnel (saída sul)", "spawn", -1, 5.0)
	_poi("inicio_gameplay", Vector3(2.0, _north_profile(-1030.0), -1030.0), "Descida da serra", "spawn", -1, 5.0)
	# acampamentos
	_poi("acampamento_rio", Vector3(430, height(430, 610), 610), "Acampamento do Rio (Saqueadores)", "camp", -1, 40.0)
	_poi("acampamento_floresta", Vector3(-1110, natural_height(-1110, 170), 170), "Acampamento abandonado", "camp", -1, 25.0)
	_poi("acampamento_estrada", Vector3(255, natural_height(255, -960), -960), "Acampamento da estrada", "camp", -1, 25.0)
	_poi("ponte_velha", Vector3(400, 1.8, 660), "Ponte Velha", "bridge", -1, 30.0)
	_poi("checkpoint_ponte", Vector3(0, 1.8, 600), "Barreira da Ponte Sul (Guarda Aurora)", "checkpoint", -1, 30.0)
	_poi("avenida_central", Vector3(0, 0.02, 0), "Avenida Central", "street", -1, 40.0)
	_poi("centro", Vector3(0, 0.02, 0), "Centro", "district", -1, 300.0)


func _index() -> void:
	chunk_buildings.clear()
	chunk_roads.clear()
	chunk_patches.clear()
	chunk_blocks.clear()
	chunk_flatten.clear()
	chunk_river.clear()
	for b in buildings:
		var rect: Rect2 = b["rect"]
		_index_rect(chunk_buildings, rect, b["id"])
	for i in roads.size():
		var seg: Dictionary = roads[i]
		var a: Vector2 = seg["a"]
		var bb: Vector2 = seg["b"]
		var hw: float = seg["hw"]
		var rect := Rect2(minf(a.x, bb.x) - hw, minf(a.y, bb.y) - hw, absf(a.x - bb.x) + hw * 2.0, absf(a.y - bb.y) + hw * 2.0)
		_index_rect(chunk_roads, rect, i)
		var k: String = seg["kind"]
		if k in ["highway", "dirt"]:
			_index_rect(chunk_flatten, rect.grow(26.0), i)
	for i in patches.size():
		_index_rect(chunk_patches, patches[i], i)
	for b in blocks:
		_index_rect(chunk_blocks, b["rect"], b["id"])
	for i in river_pts.size() - 1:
		var a: Vector2 = river_pts[i]
		var bb: Vector2 = river_pts[i + 1]
		var rect := Rect2(minf(a.x, bb.x), minf(a.y, bb.y), absf(a.x - bb.x), absf(a.y - bb.y)).grow(RIVER_HALF + 34.0)
		_index_rect(chunk_river, rect, i)


func _index_rect(dict: Dictionary, rect: Rect2, value: int) -> void:
	var c0 := Vector2i(floori(rect.position.x / CHUNK), floori(rect.position.y / CHUNK))
	var c1 := Vector2i(floori(rect.end.x / CHUNK), floori(rect.end.y / CHUNK))
	for cx in range(c0.x, c1.x + 1):
		for cz in range(c0.y, c1.y + 1):
			var key := Vector2i(cx, cz)
			if not dict.has(key):
				dict[key] = []
			var arr: Array = dict[key]
			if not arr.has(value):
				arr.append(value)


## Prédios cujo CENTRO está no chunk (dono único => geometria sem duplicar).
func buildings_owned_by(c: Vector2i) -> Array:
	var out: Array = []
	for bi in chunk_buildings.get(c, []):
		var b: Dictionary = buildings[bi]
		var center: Vector2 = (b["rect"] as Rect2).get_center()
		if Vector2i(floori(center.x / CHUNK), floori(center.y / CHUNK)) == c:
			out.append(bi)
	return out


func building_at(pos: Vector3, margin: float = 0.0) -> int:
	var c := Vector2i(floori(pos.x / CHUNK), floori(pos.z / CHUNK))
	for bi in chunk_buildings.get(c, []):
		var b: Dictionary = buildings[bi]
		if (b["rect"] as Rect2).grow(margin).has_point(Vector2(pos.x, pos.z)):
			return bi
	return -1


# ---------------------------------------------------------------------------
# Navegação (AStar3D sobre a malha viária)
# ---------------------------------------------------------------------------
func _nav_graph() -> void:
	nav.clear()
	nav_count = 0
	_nav_grid_ids.clear()
	for xi in x_lines.size():
		for zi in z_lines.size():
			var p := Vector3(x_lines[xi], 0.02, z_lines[zi])
			if _in_merged(Vector2(p.x, p.z)) >= 0:
				continue
			nav.add_point(nav_count, p)
			_nav_grid_ids[Vector2i(xi, zi)] = nav_count
			nav_count += 1
	for key in _nav_grid_ids.keys():
		var k: Vector2i = key
		var id: int = _nav_grid_ids[k]
		for d in [Vector2i(1, 0), Vector2i(0, 1)]:
			var n: Vector2i = k + d
			if _nav_grid_ids.has(n):
				var mid := (nav.get_point_position(id) + nav.get_point_position(_nav_grid_ids[n])) * 0.5
				if _in_merged(Vector2(mid.x, mid.z)) < 0:
					nav.connect_points(id, _nav_grid_ids[n])
	for pl in hwy_polylines:
		var pts: Array = pl["pts"]
		var prev := -1
		for i in range(0, pts.size(), 3):
			var v: Vector2 = pts[i]
			if URBAN.grow(-2.0).has_point(v):
				continue
			var p := Vector3(v.x, ground_height(v.x, v.y), v.y)
			nav.add_point(nav_count, p)
			if prev >= 0:
				nav.connect_points(prev, nav_count)
			else:
				var near := nav.get_closest_point(p)
				if near >= 0 and near != nav_count:
					nav.connect_points(near, nav_count)
			prev = nav_count
			nav_count += 1


func find_path(from: Vector3, to: Vector3) -> PackedVector3Array:
	var a := nav.get_closest_point(from)
	var b := nav.get_closest_point(to)
	if a < 0 or b < 0:
		return PackedVector3Array([to])
	var path := nav.get_point_path(a, b)
	path.append(to)
	return path


func random_street_point(r: RandomNumberGenerator, near: Vector3, radius: float) -> Vector3:
	var best := near
	for i in 6:
		var p := near + Vector3(r.randf_range(-radius, radius), 0.0, r.randf_range(-radius, radius))
		if block_at(p.x, p.z) < 0 and URBAN.has_point(Vector2(p.x, p.z)):
			return Vector3(p.x, 0.02, p.z)
		best = p
	return Vector3(best.x, ground_height(best.x, best.z), best.z)
