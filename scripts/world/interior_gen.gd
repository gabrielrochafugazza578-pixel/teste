class_name InteriorGen
extends RefCounted
## Interiores gerados sob demanda (apenas prédios próximos ao jogador).
##
## Cômodos por BSP (ou layout fixo para locais especiais como o laboratório
## NEXUS), paredes internas com vãos de porta, piso/teto por tipo de cômodo,
## mobília contextual encostada nas paredes e registro de contêineres
## (geladeira, armário de remédios, caixa de ferramentas…) para o loot.
## Toda a geometria vai para UM MeshBuf (1-3 draw calls por interior).

const WALL_T := 0.12
const DOOR_W := 0.95

const CONTAINER_KIND := {
	"fridge": "fridge", "kitchen_counter": "kitchen_cabinet", "cabinet_low": "drawer", "nightstand": "nightstand",
	"wardrobe": "wardrobe", "shelf": "shelf", "bookshelf": "bookshelf", "counter": "counter", "locker": "locker",
	"filing_cabinet": "filing", "med_cart": "med_cart", "tool_cabinet": "toolbox", "workbench": "workbench",
	"desk": "desk", "freezer": "freezer", "crate": "crate", "gondola": "shelf", "rack": "rack", "barrel": "barrel",
	"tv_stand": "drawer", "cardboard": "box", "lab_bench": "lab_cabinet", "fume_hood": "lab_cabinet", "checkout": "counter",
	"server_rack": "server", "stove": "stove",
}

const ROOM_SPECS := {
	"living": {"floor": 6, "wall": ["sofa", "tv_stand", "bookshelf", "armchair", "cabinet_low"], "center": ["rug", "table_small"]},
	"kitchen": {"floor": 10, "wall": ["kitchen_counter", "fridge", "stove", "cabinet_low", "washing_machine"], "center": ["table"], "chairs": true},
	"bedroom": {"floor": 6, "wall": ["bed", "wardrobe", "nightstand", "cabinet_low"], "center": ["rug"]},
	"kids": {"floor": 6, "wall": ["bed_single", "wardrobe", "crib", "bookshelf"], "center": []},
	"bathroom": {"floor": 10, "wall": ["toilet", "sink_bath", "bathtub"], "center": []},
	"hall": {"floor": 6, "wall": ["cabinet_low"], "center": []},
	"sales": {"floor": 10, "wall": ["shelf", "shelf", "counter", "shelf", "freezer"], "center": ["gondola"]},
	"storage": {"floor": 1, "wall": ["shelf", "crate", "cardboard", "barrel", "crate"], "center": ["pallet"]},
	"pharmacy": {"floor": 10, "wall": ["shelf", "shelf", "counter", "shelf"], "center": ["gondola"]},
	"hardware": {"floor": 1, "wall": ["shelf", "tool_cabinet", "shelf", "counter", "barrel"], "center": ["gondola"]},
	"bar": {"floor": 6, "wall": ["counter", "shelf", "fridge", "bench"], "center": ["table_small"], "chairs": true},
	"ward": {"floor": 15, "wall": ["hospital_bed", "curtain", "hospital_bed", "med_cart", "cabinet_low", "hospital_bed"], "center": []},
	"reception": {"floor": 15, "wall": ["counter", "bench", "filing_cabinet", "bench", "med_cart"], "center": []},
	"office": {"floor": 15, "wall": ["desk", "filing_cabinet", "bookshelf", "locker"], "center": ["desk"]},
	"med_storage": {"floor": 15, "wall": ["shelf", "shelf", "med_cart", "locker", "fridge"], "center": []},
	"classroom": {"floor": 15, "wall": ["blackboard", "bookshelf", "desk"], "center": [], "grid": "school_desk"},
	"hall_big": {"floor": 1, "wall": ["rack", "rack", "barrel", "crate", "pallet"], "center": [], "grid": "rack"},
	"garage": {"floor": 1, "wall": ["workbench", "tool_cabinet", "tires", "barrel", "shelf", "workbench"], "center": ["car_lift"]},
	"chapel": {"floor": 6, "wall": ["bench", "cabinet_low"], "center": [], "grid": "pew"},
	"armory": {"floor": 1, "wall": ["locker", "locker", "shelf", "crate"], "center": []},
	"cell": {"floor": 1, "wall": ["bunk", "toilet"], "center": []},
	"bunker": {"floor": 1, "wall": ["bunk", "shelf", "radio_set", "generator", "crate", "shelf"], "center": ["table"]},
	"barn": {"floor": 8, "wall": ["hay_bale", "crate", "workbench", "hay_bale", "barrel"], "center": ["hay_bale"]},
	"radio": {"floor": 1, "wall": ["desk", "radio_set", "shelf", "generator"], "center": []},
	"terminal": {"floor": 10, "wall": ["counter", "bench", "bench", "trash_bin", "bench"], "center": [], "grid": "bench"},
	"market_hall": {"floor": 10, "wall": ["freezer", "freezer", "shelf", "freezer", "shelf"], "center": [], "grid": "gondola"},
	"lobby": {"floor": 11, "wall": ["counter", "bench", "planter", "bench"], "center": []},
	"lab_room": {"floor": 15, "wall": ["lab_bench", "fume_hood", "shelf", "locker"], "center": []},
	"server": {"floor": 1, "wall": ["server_rack", "server_rack", "server_rack"], "center": [], "grid": "server_rack"},
}


class Frame:
	extends RefCounted
	var origin: Vector2
	var U: Vector2
	var W: Vector2
	var width: float
	var depth: float
	var base: float

	func p(u: float, w: float, y: float) -> Vector3:
		var q := origin + U * u + W * w
		return Vector3(q.x, base + y, q.y)

	func d3(du: float, dw: float) -> Vector3:
		var q := U * du + W * dw
		return Vector3(q.x, 0.0, q.y)

	## yaw de mundo para um prop cuja frente (-Z) aponte na direção local (du, dw)
	func yaw_for(du: float, dw: float) -> float:
		return Util.dir_to_yaw(d3(du, dw))


static func make_frame(b: Dictionary) -> Frame:
	var r: Rect2 = b["rect"]
	var f := Frame.new()
	f.base = b["base"]
	match int(b["facing"]):
		0:
			f.origin = Vector2(r.position.x, r.position.y)
			f.U = Vector2(1, 0)
			f.W = Vector2(0, 1)
			f.width = r.size.x
			f.depth = r.size.y
		2:
			f.origin = Vector2(r.end.x, r.end.y)
			f.U = Vector2(-1, 0)
			f.W = Vector2(0, -1)
			f.width = r.size.x
			f.depth = r.size.y
		1:
			f.origin = Vector2(r.end.x, r.position.y)
			f.U = Vector2(0, 1)
			f.W = Vector2(-1, 0)
			f.width = r.size.y
			f.depth = r.size.x
		_:
			f.origin = Vector2(r.position.x, r.end.y)
			f.U = Vector2(0, -1)
			f.W = Vector2(1, 0)
			f.width = r.size.y
			f.depth = r.size.x
	return f


# ---------------------------------------------------------------------------
# Construção
# ---------------------------------------------------------------------------
static func build(b: Dictionary) -> Dictionary:
	var gen := InteriorGen.new()
	return gen._build(b)


var out: Dictionary
var mesh: MeshBuf
var glass: MeshBuf
var panes: MeshBuf
var fr: Frame
var rng: RandomNumberGenerator
var bld: Dictionary
var fh: float = 2.9
var context: String = "house"
var _cont_i: int = 0
var _door_i: int = 0


func _build(b: Dictionary) -> Dictionary:
	bld = b
	mesh = MeshBuf.new()
	glass = MeshBuf.new()
	panes = MeshBuf.new()
	out = {"mesh": mesh, "glass": glass, "panes": panes, "doors": [], "containers": [], "lights": [], "markers": {},
		"beds": [], "workbenches": [], "pickups": [], "screens": [], "labels": [], "spawns": [], "npc_spots": [], "elevator": {}}
	fr = make_frame(b)
	rng = Util.rng(int(b["seed"]) * 31 + 17)
	context = str(b.get("interior", b["type"]))
	fh = BuildingGen.floor_h(b)
	var t: String = b["type"]
	if t in ["warehouse", "workshop", "barn", "factory", "market", "terminal", "church", "gas_station"]:
		fh = float(b["gfh"])
	if t in ["hospital", "office", "police", "school", "clinic", "lab"]:
		fh = BuildingGen.floor_h(b)
	var di := BuildingGen.door_info(b)
	var door_world: Vector3 = di[0]
	var door_u := (Vector2(door_world.x, door_world.z) - fr.origin).dot(fr.U)
	var door_w: float = di[2]
	var dh := BuildingGen.door_height(b)
	var layout: Dictionary
	match context:
		"lab":
			layout = _layout_lab()
		"market":
			layout = _layout_market(door_u)
		_:
			layout = _layout_bsp(door_u)
	_emit_shell_inner(door_u, door_w, dh)
	_emit_rooms(layout, 0.0)
	# porta principal (nó animado)
	var front_kind := "sliding" if t in ["market", "lab", "office", "hospital", "terminal", "clinic"] else "hinged"
	if t in ["warehouse", "workshop", "barn", "factory"]:
		front_kind = "roller"
	_add_door(fr.p(door_u, 0.0, 0.0), fr.yaw_for(0, 1), door_w, dh, front_kind, t in ["police", "lab", "office"] and rng.randf() < 0.0)
	out["markers"]["door_in"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(0, 1)), fr.p(door_u, 1.2, 0.0))
	out["markers"]["center"] = Transform3D(Basis.IDENTITY, fr.p(fr.width * 0.5, fr.depth * 0.5, 0.0))
	# segundo andar (casas)
	if (t == "house" or t == "farmhouse") and int(b["floors"]) >= 2 and context == "house":
		_upper_floor(layout)
	else:
		_ceiling(Rect2(), 0.0)
	return out


# ---------------------------------------------------------------------------
# Layouts
# ---------------------------------------------------------------------------
func _layout_bsp(door_u: float) -> Dictionary:
	var W := fr.width
	var D := fr.depth
	var rooms: Array = []
	var doors: Array = []
	var max_side := 7.5
	var min_side := 2.6
	match context:
		"hospital", "office", "police", "school", "clinic":
			max_side = 13.0
			min_side = 4.5
		"warehouse", "workshop", "barn", "church", "terminal", "stadium", "factory":
			max_side = 1000.0
		"shop", "pharmacy", "grocery", "hardware", "bar", "gas_station":
			max_side = 9.0
			min_side = 3.0
	var root := Rect2(0, 0, W, D)
	if context in ["shop", "pharmacy", "grocery", "hardware", "bar", "gas_station"] and D > 7.0:
		var back := minf(3.5, D * 0.3)
		rooms.append({"rect": Rect2(0, 0, W, D - back), "type": _front_type()})
		rooms.append({"rect": Rect2(0, D - back, W, back), "type": "storage"})
		doors.append({"a": Vector2(W * rng.randf_range(0.2, 0.8), D - back), "axis": "u", "w": DOOR_W})
		return {"rooms": rooms, "doors": doors}
	if max_side > 999.0:
		rooms.append({"rect": root, "type": _front_type()})
		return {"rooms": rooms, "doors": doors}
	_split(root, 0, rooms, doors, max_side, min_side)
	# atribui tipos: o cômodo da porta de entrada é sala/recepção
	var entry := -1
	for i in rooms.size():
		var rr: Rect2 = rooms[i]["rect"]
		if rr.position.y < 0.01 and door_u >= rr.position.x and door_u <= rr.end.x:
			entry = i
	if entry < 0:
		entry = 0
	var order: Array = []
	for i in rooms.size():
		if i != entry:
			order.append(i)
	order.sort_custom(func(x, y): return (rooms[x]["rect"] as Rect2).get_area() > (rooms[y]["rect"] as Rect2).get_area())
	rooms[entry]["type"] = _front_type()
	var seq: Array = _type_sequence()
	for k in order.size():
		var idx: int = order[k]
		var rr: Rect2 = rooms[idx]["rect"]
		var tp: String = seq[k % seq.size()]
		if context == "house" and rr.get_area() < 7.0:
			tp = "bathroom"
		rooms[idx]["type"] = tp
	return {"rooms": rooms, "doors": doors}


func _front_type() -> String:
	match context:
		"house", "farmhouse", "cabin", "apartment": return "living"
		"shop", "grocery": return "sales"
		"pharmacy": return "pharmacy"
		"hardware": return "hardware"
		"bar": return "bar"
		"hospital", "clinic", "police", "office": return "reception"
		"school": return "classroom"
		"warehouse", "factory": return "hall_big"
		"workshop": return "garage"
		"barn": return "barn"
		"church": return "chapel"
		"terminal": return "terminal"
		"gas_station": return "sales"
		"bunker": return "bunker"
		"radio": return "radio"
	return "living"


func _type_sequence() -> Array:
	match context:
		"house", "farmhouse", "apartment": return ["kitchen", "bedroom", "bathroom", "kids", "bedroom", "hall"]
		"cabin": return ["bedroom", "kitchen", "bathroom"]
		"hospital": return ["ward", "ward", "med_storage", "office", "ward", "lab_room", "bathroom", "ward"]
		"clinic": return ["office", "med_storage", "ward", "bathroom"]
		"police": return ["office", "armory", "cell", "office", "cell", "bathroom"]
		"office": return ["office", "office", "server", "office", "bathroom"]
		"school": return ["classroom", "classroom", "office", "bathroom", "classroom"]
		"bunker": return ["storage", "bunker", "radio"]
		"radio": return ["storage"]
	return ["storage"]


func _split(r: Rect2, depth: int, rooms: Array, doors: Array, max_side: float, min_side: float) -> void:
	var long_u := r.size.x >= r.size.y
	var long_side := r.size.x if long_u else r.size.y
	var must := long_side > max_side
	var can := long_side > min_side * 2.2 and depth < 6
	if not can or (not must and (depth >= 2 or rng.randf() < 0.25 * depth)):
		rooms.append({"rect": r, "type": ""})
		return
	var ratio := rng.randf_range(0.38, 0.62)
	if long_u:
		var cut := r.position.x + r.size.x * ratio
		var a := Rect2(r.position.x, r.position.y, cut - r.position.x, r.size.y)
		var b := Rect2(cut, r.position.y, r.end.x - cut, r.size.y)
		doors.append({"a": Vector2(cut, r.position.y + rng.randf_range(0.9, maxf(1.0, r.size.y - 0.9))), "axis": "w", "w": DOOR_W})
		_split(a, depth + 1, rooms, doors, max_side, min_side)
		_split(b, depth + 1, rooms, doors, max_side, min_side)
	else:
		var cut := r.position.y + r.size.y * ratio
		var a := Rect2(r.position.x, r.position.y, r.size.x, cut - r.position.y)
		var b := Rect2(r.position.x, cut, r.size.x, r.end.y - cut)
		doors.append({"a": Vector2(r.position.x + rng.randf_range(0.9, maxf(1.0, r.size.x - 0.9)), cut), "axis": "u", "w": DOOR_W})
		_split(a, depth + 1, rooms, doors, max_side, min_side)
		_split(b, depth + 1, rooms, doors, max_side, min_side)


func _layout_market(door_u: float) -> Dictionary:
	var W := fr.width
	var D := fr.depth
	var back := 5.0
	var rooms := [
		{"rect": Rect2(0, 0, W, D - back), "type": "market_hall"},
		{"rect": Rect2(0, D - back, W * 0.6, back), "type": "storage"},
		{"rect": Rect2(W * 0.6, D - back, W * 0.4, back), "type": "office"},
	]
	var doors := [
		{"a": Vector2(W * 0.3, D - back), "axis": "u", "w": 1.8},
		{"a": Vector2(W * 0.8, D - back), "axis": "u", "w": DOOR_W},
		{"a": Vector2(W * 0.6, D - back * 0.5), "axis": "w", "w": DOOR_W},
	]
	return {"rooms": rooms, "doors": doors}


## Laboratório de P&D da Corvalis — cenário das cenas 2, 3 e 4 da abertura
## e dos capítulos 3 e 7. Layout fixo para ser editável e estável.
func _layout_lab() -> Dictionary:
	var W := fr.width
	var D := fr.depth
	var cw := 3.0 # corredor
	var fz := 10.0
	var rooms := [
		{"rect": Rect2(W * 0.38, 0, W * 0.24, fz), "type": "lobby", "name": "lobby"},
		{"rect": Rect2(0, 0, W * 0.38, fz), "type": "office", "name": "offices_a"},
		{"rect": Rect2(W * 0.62, 0, W * 0.38, fz), "type": "armory", "name": "security"},
		{"rect": Rect2(0, fz, W, cw), "type": "corridor", "name": "corridor"},
		{"rect": Rect2(0, fz + cw, W * 0.47, D - fz - cw), "type": "lab_main", "name": "lab_main"},
		{"rect": Rect2(W * 0.47, fz + cw, W * 0.16, (D - fz - cw) * 0.42), "type": "observation", "name": "observation"},
		{"rect": Rect2(W * 0.47, fz + cw + (D - fz - cw) * 0.42, W * 0.16, (D - fz - cw) * 0.58), "type": "isolation", "name": "isolation"},
		{"rect": Rect2(W * 0.63, fz + cw, W * 0.13, (D - fz - cw) * 0.42), "type": "server", "name": "server"},
		{"rect": Rect2(W * 0.76, fz + cw, W * 0.24, (D - fz - cw) * 0.42), "type": "office_helena", "name": "office_helena"},
		{"rect": Rect2(W * 0.63, fz + cw + (D - fz - cw) * 0.42, W * 0.37, (D - fz - cw) * 0.58), "type": "cold_storage", "name": "cold_storage"},
	]
	var obs: Rect2 = rooms[5]["rect"]
	var iso: Rect2 = rooms[6]["rect"]
	var doors := [
		{"a": Vector2(W * 0.5, fz), "axis": "u", "w": 2.2, "kind": "sliding", "name": "lobby_corridor"},
		{"a": Vector2(W * 0.2, fz), "axis": "u", "w": DOOR_W},
		{"a": Vector2(W * 0.8, fz), "axis": "u", "w": DOOR_W, "locked": true},
		{"a": Vector2(W * 0.24, fz + cw), "axis": "u", "w": 2.0, "kind": "sliding", "name": "lab_door"},
		{"a": Vector2(obs.get_center().x, fz + cw), "axis": "u", "w": DOOR_W, "name": "obs_door"},
		{"a": Vector2(W * 0.695, fz + cw), "axis": "u", "w": DOOR_W},
		{"a": Vector2(W * 0.88, fz + cw), "axis": "u", "w": DOOR_W, "name": "helena_door"},
		{"a": Vector2(iso.end.x, iso.get_center().y + 2.0), "axis": "w", "w": 1.2, "kind": "sliding", "name": "iso_door", "locked": true},
		{"a": Vector2(W * 0.47, fz + cw + 6.0), "axis": "w", "w": DOOR_W},
	]
	# janela de observação (vidro) entre observação e isolamento
	var windows := [{"a": Vector2(obs.get_center().x, obs.end.y), "axis": "u", "w": obs.size.x - 1.4, "v0": 0.9, "v1": 2.4, "name": "iso_window"}]
	# parede de vidro do laboratório para o corredor
	windows.append({"a": Vector2(W * 0.12, fz + cw), "axis": "u", "w": 5.0, "v0": 1.0, "v1": 2.6, "name": "lab_glass"})
	return {"rooms": rooms, "doors": doors, "windows": windows}


# ---------------------------------------------------------------------------
# Emissão de geometria
# ---------------------------------------------------------------------------
func _emit_shell_inner(door_u: float, door_w: float, dh: float) -> void:
	var W := fr.width
	var D := fr.depth
	var H := fh
	var t := 0.3
	var wall_code := Assets.uv2_code(Assets.L_PLASTER)
	var tint := Color(0.86, 0.84, 0.8)
	if context in ["warehouse", "workshop", "barn", "factory", "bunker"]:
		wall_code = Assets.uv2_code(Assets.L_CONCRETE if context != "barn" else Assets.L_WOOD)
		tint = Color(0.75, 0.74, 0.72)
	if context in ["lab", "hospital", "clinic"]:
		tint = Color(0.9, 0.92, 0.93)
	var seedf := fposmod(float(bld["seed"]) * 0.3, 1.0)
	# 4 paredes internas (faces voltadas para dentro)
	var walls := [
		[Vector2(0, t), Vector2(W, t), Vector2(0, 1)],
		[Vector2(W - t, 0), Vector2(W - t, D), Vector2(-1, 0)],
		[Vector2(W, D - t), Vector2(0, D - t), Vector2(0, -1)],
		[Vector2(t, D), Vector2(t, 0), Vector2(1, 0)],
	]
	for i in walls.size():
		var wa: Vector2 = walls[i][0]
		var wb: Vector2 = walls[i][1]
		var n2: Vector2 = walls[i][2]
		var a := fr.p(wa.x, wa.y, 0.0)
		var bb := fr.p(wb.x, wb.y, 0.0)
		var n := fr.d3(n2.x, n2.y).normalized()
		var holes: Array = []
		if i == 0:
			holes.append([door_u - door_w * 0.5, door_u + door_w * 0.5, 0.0, dh])
		mesh.wall_with_holes(Vector2(a.x, a.z), Vector2(bb.x, bb.z), fr.base, H, n, holes, wall_code, seedf, tint, fr.base)
		# "painéis de janela" (luz do dia entrando) nas paredes externas
		if context != "bunker" and context != "lab":
			var len := wa.distance_to(wb)
			var step := 3.1
			var u := step * 0.5 + fposmod(len, step) * 0.5
			while u < len - 0.8:
				var skip := i == 0 and absf(u - (door_u if i == 0 else 0.0)) < door_w + 0.6
				if not skip and rng.randf() < 0.85:
					var dir := (wb - wa).normalized()
					var c2 := wa + dir * u
					var pa := c2 - dir * 0.55
					var pb := c2 + dir * 0.55
					var p0 := fr.p(pa.x, pa.y, 0.0) + n * 0.01
					var p1 := fr.p(pb.x, pb.y, 0.0) + n * 0.01
					panes.quad(p0 + Vector3(0, 1.0, 0), p1 + Vector3(0, 1.0, 0), p1 + Vector3(0, 2.2, 0), p0 + Vector3(0, 2.2, 0), n,
						Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0, rng.randf(), Color(1, 1, 1))
				u += step


func _emit_rooms(layout: Dictionary, y_off: float) -> void:
	var rooms: Array = layout["rooms"]
	var doors: Array = layout.get("doors", [])
	var windows: Array = layout.get("windows", [])
	var wall_code := Assets.uv2_code(Assets.L_PLASTER)
	var seedf := fposmod(float(bld["seed"]) * 0.3, 1.0)
	var H := fh
	# pisos
	for room in rooms:
		var rr: Rect2 = room["rect"]
		var tp: String = room["type"]
		var spec: Dictionary = ROOM_SPECS.get(tp, {})
		var fl := int(spec.get("floor", Assets.L_WOOD))
		if tp in ["corridor", "lab_main", "observation", "isolation", "office_helena", "cold_storage"]:
			fl = Assets.L_LINOLEUM
		var code := Assets.uv2_code(fl)
		var c0 := fr.p(rr.position.x, rr.position.y, y_off + 0.015)
		var c1 := fr.p(rr.end.x, rr.position.y, y_off + 0.015)
		var c2 := fr.p(rr.end.x, rr.end.y, y_off + 0.015)
		var c3 := fr.p(rr.position.x, rr.end.y, y_off + 0.015)
		mesh.quad(c0, c1, c2, c3, Vector3.UP, Vector2(c0.x, c0.z), Vector2(c1.x, c1.z), Vector2(c2.x, c2.z), Vector2(c3.x, c3.z), code, seedf, Color(0.95, 0.93, 0.9))
		# luminária de teto
		out["lights"].append({"pos": fr.p(rr.get_center().x, rr.get_center().y, y_off + H - 0.15), "range": maxf(rr.size.x, rr.size.y) * 0.9 + 2.0,
			"room": room.get("name", tp), "type": tp})
	# paredes internas: segmentos únicos a partir das bordas dos cômodos
	var segs := _collect_segments(rooms)
	for sg in segs:
		var axis: String = sg[0]
		var line: float = sg[1]
		var a0: float = sg[2]
		var a1: float = sg[3]
		var holes: Array = []
		var glass_holes: Array = []
		for d in doors:
			if str(d["axis"]) != axis:
				continue
			var dp: Vector2 = d["a"]
			var dl := dp.y if axis == "u" else dp.x
			var along := dp.x if axis == "u" else dp.y
			if absf(dl - line) < 0.05 and along > a0 - 0.01 and along < a1 + 0.01:
				var dw: float = d["w"]
				holes.append([along - a0 - dw * 0.5, along - a0 + dw * 0.5, 0.0, 2.15])
		for wdef in windows:
			if str(wdef["axis"]) != axis:
				continue
			var wp: Vector2 = wdef["a"]
			var wl := wp.y if axis == "u" else wp.x
			var walong := wp.x if axis == "u" else wp.y
			if absf(wl - line) < 0.05 and walong > a0 and walong < a1:
				var ww: float = wdef["w"]
				var hole := [walong - a0 - ww * 0.5, walong - a0 + ww * 0.5, float(wdef["v0"]), float(wdef["v1"])]
				holes.append(hole)
				glass_holes.append([hole, str(wdef.get("name", "window"))])
		# duas faces
		var la := Vector2(a0, line) if axis == "u" else Vector2(line, a0)
		var lb := Vector2(a1, line) if axis == "u" else Vector2(line, a1)
		var nloc := Vector2(0, 1) if axis == "u" else Vector2(1, 0)
		for sgn: float in [-1.0, 1.0]:
			var off := nloc * (WALL_T * 0.5 * sgn)
			var wa := fr.p(la.x + off.x, la.y + off.y, y_off)
			var wb := fr.p(lb.x + off.x, lb.y + off.y, y_off)
			var n := fr.d3(nloc.x * sgn, nloc.y * sgn).normalized()
			mesh.wall_with_holes(Vector2(wa.x, wa.z), Vector2(wb.x, wb.z), fr.base + y_off, H, n, holes, wall_code, seedf, Color(0.88, 0.86, 0.82), fr.base + y_off)
		# colisão: partes sólidas
		var solid := _solid_ranges(a1 - a0, holes)
		for rng_ in solid:
			var s0: float = rng_[0]
			var s1: float = rng_[1]
			var v0: float = rng_[2]
			var v1: float = rng_[3]
			var mid := (s0 + s1) * 0.5 + a0
			var cpos := fr.p(mid if axis == "u" else line, line if axis == "u" else mid, y_off + (v0 + v1) * 0.5)
			var sz_loc := Vector2(s1 - s0, WALL_T) if axis == "u" else Vector2(WALL_T, s1 - s0)
			var szw := fr.d3(sz_loc.x, sz_loc.y).abs()
			mesh.add_box_collider(cpos, Vector3(maxf(szw.x, 0.05), v1 - v0, maxf(szw.z, 0.05)))
		# vidro nas janelas internas
		for gh in glass_holes:
			var hole: Array = gh[0]
			var u0: float = float(hole[0]) + a0
			var u1: float = float(hole[1]) + a0
			var gv0: float = hole[2]
			var gv1: float = hole[3]
			var g0 := fr.p(u0 if axis == "u" else line, line if axis == "u" else u0, y_off + gv0)
			var g1 := fr.p(u1 if axis == "u" else line, line if axis == "u" else u1, y_off + gv0)
			var n := fr.d3(nloc.x, nloc.y).normalized()
			glass.quad(g0, g1, g1 + Vector3(0, gv1 - gv0, 0), g0 + Vector3(0, gv1 - gv0, 0), n, Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0, 0.0)
			var cpos := (g0 + g1) * 0.5 + Vector3(0, (gv1 - gv0) * 0.5, 0)
			var szw := fr.d3(u1 - u0 if axis == "u" else WALL_T, WALL_T if axis == "u" else u1 - u0).abs()
			mesh.add_box_collider(cpos, Vector3(maxf(szw.x, 0.05), gv1 - gv0, maxf(szw.z, 0.05)))
			out["markers"][str(gh[1])] = Transform3D(Basis(Vector3.UP, Util.dir_to_yaw(n)), cpos)
	# portas internas (nós)
	for d in doors:
		var dp: Vector2 = d["a"]
		var axis: String = d["axis"]
		var kind: String = d.get("kind", "hinged")
		if kind == "opening":
			continue
		if rng.randf() < 0.25 and not d.has("name") and context != "lab":
			continue
		var yaw := fr.yaw_for(0, 1) if axis == "u" else fr.yaw_for(1, 0)
		var door := _add_door(fr.p(dp.x, dp.y, y_off), yaw, float(d["w"]), 2.15, kind, bool(d.get("locked", false)))
		if d.has("name"):
			door["name"] = d["name"]
	# mobília
	for room in rooms:
		_furnish(room, doors, y_off)


## Retorna segmentos [axis, linha, a0, a1] de paredes internas (sem duplicar).
func _collect_segments(rooms: Array) -> Array:
	var W := fr.width
	var D := fr.depth
	var lines := {}
	for room in rooms:
		var r: Rect2 = room["rect"]
		var edges := [["u", r.position.y, r.position.x, r.end.x], ["u", r.end.y, r.position.x, r.end.x],
			["w", r.position.x, r.position.y, r.end.y], ["w", r.end.x, r.position.y, r.end.y]]
		for e in edges:
			var axis: String = e[0]
			var line: float = e[1]
			if axis == "u" and (line < 0.35 or line > D - 0.35):
				continue
			if axis == "w" and (line < 0.35 or line > W - 0.35):
				continue
			var key := "%s_%.2f" % [axis, line]
			if not lines.has(key):
				lines[key] = [axis, line, []]
			(lines[key][2] as Array).append([float(e[2]), float(e[3])])
	var segs: Array = []
	for key in lines.keys():
		var entry: Array = lines[key]
		var ivs: Array = entry[2]
		ivs.sort_custom(func(x, y): return float(x[0]) < float(y[0]))
		var cur0: float = ivs[0][0]
		var cur1: float = ivs[0][1]
		for i in range(1, ivs.size()):
			var s0: float = ivs[i][0]
			var s1: float = ivs[i][1]
			if s0 <= cur1 + 0.01:
				cur1 = maxf(cur1, s1)
			else:
				segs.append([entry[0], entry[1], cur0, cur1])
				cur0 = s0
				cur1 = s1
		segs.append([entry[0], entry[1], cur0, cur1])
	return segs


## Faixas sólidas de uma parede com buracos: [[u0,u1,v0,v1], ...]
func _solid_ranges(length: float, holes: Array) -> Array:
	var outr: Array = []
	var hs := holes.duplicate()
	hs.sort_custom(func(x, y): return float(x[0]) < float(y[0]))
	var u := 0.0
	for h in hs:
		var h0: float = maxf(h[0], 0.0)
		var h1: float = minf(h[1], length)
		if h0 > u + 0.02:
			outr.append([u, h0, 0.0, fh])
		var hv0: float = h[2]
		var hv1: float = h[3]
		if hv1 < fh - 0.02:
			outr.append([h0, h1, hv1, fh])
		if hv0 > 0.02:
			outr.append([h0, h1, 0.0, hv0])
		u = maxf(u, h1)
	if u < length - 0.02:
		outr.append([u, length, 0.0, fh])
	return outr


func _ceiling(hole: Rect2, y_off: float) -> void:
	var code := Assets.uv2_code(Assets.L_PLASTER)
	var y := y_off + fh - 0.01
	var rects: Array = []
	var full := Rect2(0, 0, fr.width, fr.depth)
	if hole.size == Vector2.ZERO:
		rects.append(full)
	else:
		rects.append(Rect2(0, 0, fr.width, hole.position.y))
		rects.append(Rect2(0, hole.end.y, fr.width, fr.depth - hole.end.y))
		rects.append(Rect2(0, hole.position.y, hole.position.x, hole.size.y))
		rects.append(Rect2(hole.end.x, hole.position.y, fr.width - hole.end.x, hole.size.y))
	for r in rects:
		var rr: Rect2 = r
		if rr.size.x <= 0.01 or rr.size.y <= 0.01:
			continue
		var c0 := fr.p(rr.position.x, rr.position.y, y)
		var c1 := fr.p(rr.end.x, rr.position.y, y)
		var c2 := fr.p(rr.end.x, rr.end.y, y)
		var c3 := fr.p(rr.position.x, rr.end.y, y)
		mesh.quad(c0, c1, c2, c3, Vector3.DOWN, Vector2(c0.x, c0.z), Vector2(c1.x, c1.z), Vector2(c2.x, c2.z), Vector2(c3.x, c3.z), code, 0.0, Color(0.9, 0.9, 0.88))


func _upper_floor(ground: Dictionary) -> void:
	# escada encostada na parede lateral da sala
	var sw := 1.0
	var sl := 4.2
	var su := fr.width - 0.45 - sw
	var sw0 := 1.2
	var stair := Rect2(su, sw0, sw, sl)
	_ceiling(stair, 0.0)
	var yaw := fr.yaw_for(0, -1)
	var sp := fr.p(stair.get_center().x, stair.get_center().y, 0.0)
	mesh.append(PropLib.buf("stair_ramp"), Transform3D(Basis(Vector3.UP, yaw), sp))
	var ang := atan2(fh, sl)
	var ramp_len := Vector2(sl, fh).length()
	var ramp_basis := Basis(Vector3.UP, yaw) * Basis(Vector3.RIGHT, ang)
	mesh.add_collider(Transform3D(ramp_basis, sp + Vector3(0, fh * 0.5 - 0.05, 0)), Vector3(sw, 0.1, ramp_len))
	# laje do piso superior (colisão ao redor do vão)
	var slab_y := fh + 0.02
	var parts := [Rect2(0, 0, fr.width, stair.position.y), Rect2(0, stair.end.y, fr.width, fr.depth - stair.end.y),
		Rect2(0, stair.position.y, stair.position.x, stair.size.y), Rect2(stair.end.x, stair.position.y, fr.width - stair.end.x, stair.size.y)]
	for pr in parts:
		var rr: Rect2 = pr
		if rr.size.x < 0.05 or rr.size.y < 0.05:
			continue
		var c := fr.p(rr.get_center().x, rr.get_center().y, slab_y - 0.1)
		var s := fr.d3(rr.size.x, rr.size.y).abs()
		mesh.add_box_collider(c, Vector3(s.x, 0.2, s.z))
	# cômodos do andar de cima
	var rooms: Array = []
	var doors: Array = []
	_split(Rect2(0, 0, fr.width, fr.depth), 1, rooms, doors, 6.0, 2.6)
	var seq := ["bedroom", "kids", "bathroom", "bedroom"]
	var k := 0
	for room in rooms:
		var rr: Rect2 = room["rect"]
		if rr.intersects(stair.grow(0.5)):
			room["type"] = "hall"
		else:
			room["type"] = seq[k % seq.size()] if rr.get_area() > 6.5 else "bathroom"
			k += 1
	var upper := {"rooms": rooms, "doors": doors}
	_emit_rooms(upper, fh + 0.02)
	# paredes externas por dentro no 2º andar
	var saved := fh
	var wall_code := Assets.uv2_code(Assets.L_PLASTER)
	var t := 0.3
	var walls := [[Vector2(0, t), Vector2(fr.width, t), Vector2(0, 1)], [Vector2(fr.width - t, 0), Vector2(fr.width - t, fr.depth), Vector2(-1, 0)],
		[Vector2(fr.width, fr.depth - t), Vector2(0, fr.depth - t), Vector2(0, -1)], [Vector2(t, fr.depth), Vector2(t, 0), Vector2(1, 0)]]
	for wdef in walls:
		var wa: Vector2 = wdef[0]
		var wb: Vector2 = wdef[1]
		var n2: Vector2 = wdef[2]
		var a := fr.p(wa.x, wa.y, 0.0)
		var bb := fr.p(wb.x, wb.y, 0.0)
		mesh.wall(Vector2(a.x, a.z), Vector2(bb.x, bb.z), fr.base + fh + 0.02, fh, fr.d3(n2.x, n2.y).normalized(), wall_code, 0.1, Color(0.86, 0.84, 0.8), 0.0, fr.base)
	fh = saved
	_ceiling(Rect2(), fh + 0.02)
	out["markers"]["upstairs"] = Transform3D(Basis.IDENTITY, fr.p(fr.width * 0.5, fr.depth * 0.5, fh + 0.05))


# ---------------------------------------------------------------------------
# Mobília
# ---------------------------------------------------------------------------
func _furnish(room: Dictionary, doors: Array, y_off: float) -> void:
	var rr: Rect2 = room["rect"]
	var tp: String = room["type"]
	var name_: String = room.get("name", "")
	match tp:
		"lab_main":
			_furnish_lab_main(rr, y_off)
			return
		"observation":
			_furnish_observation(rr, y_off)
			return
		"isolation":
			_furnish_isolation(rr, y_off)
			return
		"office_helena":
			_furnish_helena(rr, y_off)
			return
		"cold_storage":
			_place_wall_props(rr, ["freezer", "freezer", "rack", "shelf", "freezer", "locker"], doors, y_off)
			return
		"corridor":
			out["npc_spots"].append(fr.p(rr.get_center().x, rr.get_center().y, y_off))
			out["markers"]["elevator"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(-1, 0)), fr.p(rr.end.x - 0.9, rr.get_center().y, y_off))
			out["markers"]["corridor_mid"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(1, 0)), fr.p(rr.get_center().x, rr.get_center().y, y_off))
			out["markers"]["corridor_west"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(1, 0)), fr.p(rr.position.x + 2.0, rr.get_center().y, y_off))
			mesh.box(fr.p(rr.end.x - 0.25, rr.get_center().y, y_off + 1.2), Vector3(0.3, 2.4, 2.2) if absf(fr.U.x) > 0.5 else Vector3(2.2, 2.4, 0.3), Assets.uv2_code(Assets.L_METAL), 0.0, Color(0.6, 0.62, 0.64))
			for i in 4:
				out["lights"].append({"pos": fr.p(rr.size.x * (0.15 + i * 0.23), rr.get_center().y, y_off + fh - 0.1), "range": 7.0, "room": "corridor", "type": "emergency"})
			return
		"lobby":
			_place_wall_props(rr, ["planter", "bench", "planter"], doors, y_off)
			var desk := fr.p(rr.get_center().x, rr.position.y + rr.size.y * 0.6, y_off)
			_place(PropLib.buf("counter"), "counter", desk, fr.yaw_for(0, -1), true)
			out["labels"].append({"xf": Transform3D(Basis(Vector3.UP, fr.yaw_for(0, -1)), fr.p(rr.get_center().x, rr.end.y - 0.08, y_off + 2.6)),
				"text": "CORVALIS BIOTECNOLOGIA", "size": 0.35, "color": Color(0.2, 0.3, 0.4)})
			out["markers"]["lobby"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(0, 1)), fr.p(rr.get_center().x, rr.get_center().y, y_off))
			return
	var spec: Dictionary = ROOM_SPECS.get(tp, {})
	var wall_list: Array = spec.get("wall", [])
	_place_wall_props(rr, wall_list, doors, y_off)
	# centro
	var center: Array = spec.get("center", [])
	var cp := fr.p(rr.get_center().x, rr.get_center().y, y_off)
	for i in center.size():
		var pn: String = center[i]
		var cs := PropLib.collision_size(pn)
		if pn == "rug" or (rr.size.x > cs.x + 2.2 and rr.size.y > cs.z + 2.2):
			_place(PropLib.buf(pn), pn, cp + Vector3(0, 0.0, 0), fr.yaw_for(0, 1) + (PI * 0.5 if rr.size.x > rr.size.y else 0.0), pn != "rug")
			if spec.get("chairs", false) and pn != "rug":
				for s: float in [-1.0, 1.0]:
					var off := fr.d3(0, s * (cs.z * 0.5 + 0.35))
					if rr.size.x > rr.size.y:
						off = fr.d3(s * (cs.x * 0.5 + 0.35), 0)
					_place(PropLib.buf("chair"), "chair", cp + off, Util.dir_to_yaw(-off), false)
	# grade (salas de aula, galpões, mercados, capela)
	var grid: String = spec.get("grid", "")
	if grid != "":
		_grid(rr, grid, y_off)
	# pontos para NPCs/infectados
	out["spawns"].append(cp)
	if tp == "bedroom" or tp == "kids" or tp == "bunker":
		out["beds"].append(cp)
	if tp == "garage" or tp == "hardware":
		out["workbenches"].append(cp)
	# itens soltos em cômodos
	if rng.randf() < 0.55:
		out["pickups"].append({"pos": fr.p(rr.position.x + rr.size.x * rng.randf_range(0.3, 0.7), rr.position.y + rr.size.y * rng.randf_range(0.3, 0.7), y_off + 0.05),
			"context": context, "room": tp})


func _place_wall_props(rr: Rect2, list: Array, doors: Array, y_off: float) -> void:
	if list.is_empty():
		return
	# lados: [início, direção ao longo, normal para dentro, comprimento]
	var sides := [
		[Vector2(rr.position.x, rr.position.y), Vector2(1, 0), Vector2(0, 1), rr.size.x],
		[Vector2(rr.end.x, rr.position.y), Vector2(0, 1), Vector2(-1, 0), rr.size.y],
		[Vector2(rr.end.x, rr.end.y), Vector2(-1, 0), Vector2(0, -1), rr.size.x],
		[Vector2(rr.position.x, rr.end.y), Vector2(0, -1), Vector2(1, 0), rr.size.y],
	]
	var li := rng.randi() % list.size()
	var placed := 0
	var start_side := rng.randi() % 4
	for si in 4:
		var s: Array = sides[(si + start_side) % 4]
		var o: Vector2 = s[0]
		var dir: Vector2 = s[1]
		var inward: Vector2 = s[2]
		var slen: float = s[3]
		var cursor := 0.35
		var tries := 0
		while cursor < slen - 0.5 and tries < 6:
			tries += 1
			var pn: String = list[li % list.size()]
			var cs := PropLib.collision_size(pn)
			var w := maxf(cs.x, 0.5)
			var d := maxf(cs.z, 0.4)
			if pn in ["toilet", "sink_bath", "chair"]:
				w = 0.6
				d = 0.6
			if pn in ["curtain"]:
				w = 2.2
				d = 0.1
			if cursor + w > slen - 0.25:
				break
			var mid_along := cursor + w * 0.5
			var pos2 := o + dir * mid_along + inward * (d * 0.5 + 0.34)
			# evita bloquear portas
			var blocked := false
			for dd in doors:
				var dp: Vector2 = dd["a"]
				if dp.distance_to(o + dir * mid_along) < w * 0.5 + 1.0:
					blocked = true
			if pos2.x < 0.4 or pos2.y < 0.4 or pos2.x > fr.width - 0.4 or pos2.y > fr.depth - 0.4:
				blocked = true
			if blocked:
				cursor += 0.9
				continue
			var yaw := fr.yaw_for(inward.x, inward.y)
			_place(PropLib.buf(pn), pn, fr.p(pos2.x, pos2.y, y_off), yaw, true)
			cursor += w + rng.randf_range(0.1, 0.6)
			li += 1
			placed += 1
			if placed >= list.size() + 2:
				return


func _grid(rr: Rect2, pn: String, y_off: float) -> void:
	var cs := PropLib.collision_size(pn)
	if cs == Vector3.ZERO:
		cs = Vector3(0.7, 1.0, 0.7)
	var sx := cs.x + (1.8 if pn in ["gondola", "rack"] else 0.9)
	var sz := cs.z + (1.8 if pn in ["gondola", "rack", "pew"] else 0.8)
	if pn == "school_desk":
		sx = 1.2
		sz = 1.3
	var nx := int((rr.size.x - 2.0) / sx)
	var nz := int((rr.size.y - 3.0) / sz)
	for ix in nx:
		for iz in nz:
			var u := rr.position.x + 1.0 + sx * (ix + 0.5) + (rr.size.x - 2.0 - nx * sx) * 0.5
			var w := rr.position.y + 2.0 + sz * (iz + 0.5)
			_place(PropLib.buf(pn), pn, fr.p(u, w, y_off), fr.yaw_for(0, -1), true)


## Registra um prop: mescla geometria, colisão e contêiner (se aplicável).
func _place(pb: MeshBuf, pn: String, pos: Vector3, yaw: float, collide: bool) -> void:
	var xf := Transform3D(Basis(Vector3.UP, yaw), pos)
	mesh.append(pb, xf)
	var cs := PropLib.collision_size(pn)
	if collide and cs != Vector3.ZERO:
		mesh.add_collider(Transform3D(xf.basis, pos + Vector3(0, cs.y * 0.5, 0)), cs)
	if CONTAINER_KIND.has(pn):
		_cont_i += 1
		var kind: String = CONTAINER_KIND[pn]
		if pn == "sink_bath" or (pn == "cabinet_low" and context == "hospital"):
			kind = "medicine_cabinet"
		out["containers"].append({"pos": pos + Vector3(0, maxf(cs.y * 0.6, 0.5), 0), "yaw": yaw, "kind": kind, "context": context,
			"uid": "%d_c%d" % [int(bld["id"]), _cont_i], "size": cs, "prop": pn})
	if pn == "workbench":
		out["workbenches"].append(pos)
	if pn == "bed" or pn == "bed_single" or pn == "bunk":
		out["beds"].append(pos)
	if pn == "computer":
		out["screens"].append({"xf": Transform3D(xf.basis, pos + xf.basis * Vector3(0, 0.3, 0.035)), "size": Vector2(0.48, 0.28), "style": 0})
	if pn == "tv_stand":
		out["screens"].append({"xf": Transform3D(xf.basis, pos + xf.basis * Vector3(0, 0.83, 0.012)), "size": Vector2(1.02, 0.54), "style": 4})


func _last_screen_style(style: int) -> void:
	var arr: Array = out["screens"]
	if not arr.is_empty():
		var d: Dictionary = arr[arr.size() - 1]
		d["style"] = style


func _add_door(pos: Vector3, yaw: float, width: float, height: float, kind: String, locked: bool) -> Dictionary:
	_door_i += 1
	var d := {"pos": pos, "yaw": yaw, "width": width, "height": height, "kind": kind, "locked": locked,
		"uid": "%d_d%d" % [int(bld["id"]), _door_i], "context": context}
	out["doors"].append(d)
	return d


# ---------------------------------------------------------------------------
# Laboratório NEXUS (mobília fixa + marcadores para a cinemática)
# ---------------------------------------------------------------------------
func _furnish_lab_main(rr: Rect2, y_off: float) -> void:
	var rows := 3
	for i in rows:
		var w := rr.position.y + 4.0 + i * 4.2
		for k in 2:
			var u := rr.position.x + 5.0 + k * 7.5
			var pos := fr.p(u, w, y_off)
			_place(PropLib.buf("lab_bench"), "lab_bench", pos, fr.yaw_for(0, -1), true)
			var comp_pos := fr.p(u - 0.8, w - 0.05, y_off + 0.93)
			_place(PropLib.buf("computer"), "computer", comp_pos, fr.yaw_for(0, -1), false)
			_last_screen_style(1 if (i + k) % 2 == 0 else 0)
			_place(PropLib.buf("lab_equipment"), "lab_equipment", fr.p(u + 0.7, w, y_off + 0.93), fr.yaw_for(0, -1), false)
			out["markers"]["researcher_%d" % (i * 2 + k)] = Transform3D(Basis(Vector3.UP, fr.yaw_for(0, 1)), fr.p(u - 0.8, w - 0.9, y_off))
	# capelas de exaustão na parede do fundo
	for k in 3:
		_place(PropLib.buf("fume_hood"), "fume_hood", fr.p(rr.position.x + 3.0 + k * 3.0, rr.end.y - 0.8, y_off), fr.yaw_for(0, -1), true)
	_place(PropLib.buf("server_rack"), "server_rack", fr.p(rr.end.x - 1.2, rr.end.y - 1.0, y_off), fr.yaw_for(-1, 0), true)
	# estação da Dra. Helena (perto do vidro da observação)
	var hu := rr.end.x - 3.0
	var hw := rr.position.y + 3.0
	_place(PropLib.buf("desk"), "desk", fr.p(hu, hw, y_off), fr.yaw_for(0, -1), true)
	_place(PropLib.buf("computer"), "computer", fr.p(hu - 0.2, hw + 0.05, y_off + 0.76), fr.yaw_for(0, -1), false)
	_last_screen_style(1)
	_place(PropLib.buf("computer"), "computer", fr.p(hu + 0.4, hw + 0.05, y_off + 0.76), fr.yaw_for(0, -1), false)
	_last_screen_style(3)
	out["markers"]["helena_desk"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(0, 1)), fr.p(hu, hw - 0.95, y_off))
	out["markers"]["lab_center"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(0, 1)), fr.p(rr.get_center().x, rr.get_center().y, y_off))
	out["markers"]["lab_entrance"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(0, 1)), fr.p(fr.width * 0.24, rr.position.y + 0.8, y_off))
	out["markers"]["lab_corner_cam"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(1, 1)), fr.p(rr.position.x + 1.2, rr.position.y + 1.2, y_off + 2.6))
	out["labels"].append({"xf": Transform3D(Basis(Vector3.UP, fr.yaw_for(0, 1)), fr.p(fr.width * 0.24, rr.position.y + 0.07, y_off + 2.45)),
		"text": "PROJECT NEXUS", "size": 0.14, "color": Color(0.55, 0.62, 0.68)})
	out["labels"].append({"xf": Transform3D(Basis(Vector3.UP, fr.yaw_for(0, 1)), fr.p(fr.width * 0.24, rr.position.y + 0.07, y_off + 2.28)),
		"text": "ACESSO RESTRITO — NÍVEL 4", "size": 0.07, "color": Color(0.7, 0.2, 0.15)})
	out["labels"].append({"xf": Transform3D(Basis(Vector3.UP, fr.yaw_for(0, -1)), fr.p(rr.get_center().x, rr.end.y - 0.07, y_off + 3.1)),
		"text": "NEXUS-2  ·  PROTOCOLO DE REGENERAÇÃO", "size": 0.12, "color": Color(0.35, 0.45, 0.55)})
	for i in 4:
		out["lights"].append({"pos": fr.p(rr.position.x + rr.size.x * (0.2 + (i % 2) * 0.6), rr.position.y + rr.size.y * (0.25 + (i / 2) * 0.5), y_off + fh - 0.1),
			"range": 9.0, "room": "lab_main", "type": "emergency"})
	for i in 6:
		out["spawns"].append(fr.p(rr.position.x + rng.randf_range(2, rr.size.x - 2), rr.position.y + rng.randf_range(2, rr.size.y - 2), y_off))


func _furnish_observation(rr: Rect2, y_off: float) -> void:
	var w := rr.end.y - 1.0
	_place(PropLib.buf("desk"), "desk", fr.p(rr.get_center().x, w, y_off), fr.yaw_for(0, 1), true)
	_place(PropLib.buf("computer"), "computer", fr.p(rr.get_center().x - 0.35, w - 0.05, y_off + 0.76), fr.yaw_for(0, 1), false)
	_last_screen_style(3)
	_place(PropLib.buf("computer"), "computer", fr.p(rr.get_center().x + 0.35, w - 0.05, y_off + 0.76), fr.yaw_for(0, 1), false)
	_last_screen_style(1)
	_place(PropLib.buf("chair"), "chair", fr.p(rr.get_center().x, w - 0.9, y_off), fr.yaw_for(0, 1), false)
	out["markers"]["observer"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(0, 1)), fr.p(rr.get_center().x + 0.9, w - 1.2, y_off))
	out["markers"]["obs_cam"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(0, 1)), fr.p(rr.get_center().x - 1.1, rr.position.y + 1.4, y_off + 1.6))
	_place_wall_props(Rect2(rr.position.x, rr.position.y, rr.size.x, rr.size.y * 0.5), ["filing_cabinet", "locker"], [], y_off)


func _furnish_isolation(rr: Rect2, y_off: float) -> void:
	var bed_pos := fr.p(rr.get_center().x, rr.end.y - 1.4, y_off)
	_place(PropLib.buf("hospital_bed"), "hospital_bed", bed_pos, fr.yaw_for(0, -1), true)
	_place(PropLib.buf("med_cart"), "med_cart", fr.p(rr.position.x + 0.8, rr.end.y - 1.0, y_off), fr.yaw_for(1, 0), true)
	var mon := fr.p(rr.end.x - 0.6, rr.end.y - 1.6, y_off + 1.4)
	out["screens"].append({"xf": Transform3D(Basis(Vector3.UP, fr.yaw_for(-1, 0)), mon), "size": Vector2(0.45, 0.32), "style": 3, "name": "heart_monitor"})
	mesh.box(mon + fr.d3(0.05, 0), Vector3(0.1, 0.36, 0.5), Assets.uv2_code(Assets.L_METAL), 0.0, Color(0.2, 0.2, 0.22))
	out["markers"]["patient_bed"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(0, -1)), bed_pos + fr.d3(0, 0.3) + Vector3(0, 0.62, 0))
	out["markers"]["patient_sit"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(0, -1)), fr.p(rr.get_center().x + 0.55, rr.end.y - 1.5, y_off))
	out["markers"]["patient_glass"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(0, -1)), fr.p(rr.get_center().x, rr.position.y + 0.45, y_off))
	out["lights"].append({"pos": fr.p(rr.get_center().x, rr.get_center().y, y_off + fh - 0.1), "range": 6.0, "room": "isolation", "type": "isolation"})


func _furnish_helena(rr: Rect2, y_off: float) -> void:
	var dp := fr.p(rr.get_center().x, rr.end.y - 1.2, y_off)
	_place(PropLib.buf("desk"), "desk", dp, fr.yaw_for(0, -1), true)
	_place(PropLib.buf("computer"), "computer", dp + Vector3(0, 0.76, 0) + fr.d3(0, 0.05), fr.yaw_for(0, -1), false)
	_place(PropLib.buf("chair"), "chair", dp + fr.d3(0, -0.8), fr.yaw_for(0, 1), false)
	_place_wall_props(Rect2(rr.position.x, rr.position.y, rr.size.x, rr.size.y * 0.6), ["bookshelf", "filing_cabinet", "bookshelf", "cabinet_low"], [], y_off)
	out["markers"]["helena_office_desk"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(0, 1)), dp + fr.d3(0, -0.2) + Vector3(0, 0.8, 0))
