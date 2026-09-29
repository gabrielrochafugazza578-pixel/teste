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
	"desk": "desk", "freezer": "freezer", "crate": "crate", "gondola": "shelf", "gondola_hw": "shelf", "gondola_ph": "shelf", "rack": "rack", "barrel": "barrel",
	"tv_stand": "drawer", "cardboard": "box", "lab_bench": "lab_cabinet", "fume_hood": "lab_cabinet", "checkout": "counter",
	"server_rack": "server", "stove": "stove",
}

## Tampos onde itens podem ficar apoiados: [altura, meia-largura X, meia-prof. Z, desloc. Z]
const SURFACES := {
	"table": [0.765, 0.6, 0.33, 0.0], "table_small": [0.765, 0.32, 0.32, 0.0], "desk": [0.76, 0.62, 0.28, 0.0],
	"kitchen_counter": [0.92, 1.1, 0.25, 0.0], "counter": [0.92, 1.1, 0.25, 0.0], "cabinet_low": [0.9, 0.42, 0.18, 0.0],
	"nightstand": [0.55, 0.17, 0.17, 0.0], "workbench": [0.9, 0.9, 0.3, 0.0], "school_desk": [0.715, 0.24, 0.16, -0.15],
	"lab_bench": [0.93, 1.35, 0.3, 0.0], "checkout": [0.92, 0.45, 0.18, 0.0], "med_cart": [0.94, 0.25, 0.18, 0.0],
	"tool_cabinet": [1.05, 0.34, 0.2, 0.0], "crate": [0.8, 0.3, 0.3, 0.0], "barrel": [0.905, 0.16, 0.16, 0.0],
	"bed": [0.525, 0.55, 0.6, 0.25], "bed_single": [0.525, 0.32, 0.6, 0.25], "sofa": [0.49, 0.7, 0.22, 0.02],
	"freezer": [0.86, 0.85, 0.3, 0.0], "stove": [0.92, 0.2, 0.2, 0.0], "washing_machine": [0.9, 0.22, 0.22, 0.0],
	"bench": [0.47, 0.75, 0.1, 0.0], "pallet": [0.145, 0.5, 0.5, 0.0], "hospital_bed": [0.74, 0.34, 0.5, 0.3],
	"filing_cabinet": [1.3, 0.18, 0.2, 0.0], "tv_stand": [0.5, 0.62, 0.08, -0.13], "pew": [0.475, 1.3, 0.14, 0.0],
	"altar": [1.04, 0.9, 0.35, 0.0], "armchair": [0.37, 0.25, 0.2, -0.05],
}

## Chance de haver uma arma largada no prédio (além do loot comum).
const WEAPON_CHANCE := {"house": 0.35, "apartment": 0.35, "farmhouse": 0.5, "cabin": 0.55, "police": 0.85, "bunker": 0.9,
	"hardware": 0.6, "workshop": 0.5, "barn": 0.6, "bar": 0.4, "warehouse": 0.35, "factory": 0.35, "gas_station": 0.3,
	"grocery": 0.25, "shop": 0.25, "market": 0.3, "office": 0.25, "school": 0.3, "hospital": 0.25, "clinic": 0.2,
	"camp": 0.5, "church": 0.2, "lab": 0.3, "radio": 0.5, "pharmacy": 0.15, "terminal": 0.3}

const RESIDENTIAL := ["living", "kitchen", "bedroom", "kids", "bathroom", "hall"]
const VERT_BUDGET := 150000
## Cômodos que enchem todas as paredes (lojas, depósitos); os demais param após uma volta na lista.
const FILL_WALLS := ["sales", "pharmacy", "hardware", "storage", "hall_big", "market_hall", "garage", "bar", "terminal", "bunker"]
## Só para medição (tests/bench_chunks): vértices por tipo de prop.
static var debug_counts = null

const GRAFFITI := ["SOCORRO", "NÃO ENTRE", "INFECTADOS LÁ DENTRO", "NÃO FAÇA BARULHO", "ELES OUVEM TUDO", "SEM COMIDA",
	"SAQUEADO", "FOMOS PRO ESTÁDIO", "DEUS NOS PERDOE", "CORVALIS MENTIU", "ONDE ESTÁ O EXÉRCITO?", "FUJA", "NÃO ABRA",
	"X", "LIMPO", "3 MORTOS", "|||| |||| ||", "ESTAMOS VIVOS", "NÃO CONFIE EM NINGUÉM", "RÁDIO 98.3", "AQUI NÃO", "FIM"]

const ROOM_SPECS := {
	"living": {"floor": 6, "wall": ["sofa", "tv_stand", "bookshelf", "armchair", "plant_pot", "cabinet_low", "floor_lamp"], "center": ["rug", "table_small"]},
	"kitchen": {"floor": 10, "wall": ["kitchen_counter", "fridge", "stove", "cabinet_low", "washing_machine"], "center": ["table"], "chairs": true},
	"bedroom": {"floor": 6, "wall": ["bed", "wardrobe", "nightstand", "cabinet_low"], "center": ["rug"]},
	"kids": {"floor": 6, "wall": ["bed_single", "wardrobe", "crib", "bookshelf"], "center": []},
	"bathroom": {"floor": 10, "wall": ["toilet", "sink_bath", "bathtub"], "center": []},
	"hall": {"floor": 6, "wall": ["cabinet_low", "coat_rack", "plant_pot"], "center": []},
	"sales": {"floor": 10, "wall": ["shelf", "shelf", "counter", "shelf", "freezer", "vending_machine", "shelf"], "center": ["gondola"], "grid": "gondola"},
	"storage": {"floor": 1, "wall": ["shelf", "crate", "cardboard", "barrel", "crate"], "center": ["pallet"]},
	"pharmacy": {"floor": 10, "wall": ["shelf", "shelf", "counter", "shelf", "plant_pot"], "center": ["gondola_ph"], "grid": "gondola_ph"},
	"hardware": {"floor": 1, "wall": ["shelf", "tool_cabinet", "shelf", "counter", "barrel", "shelf", "workbench"], "center": ["gondola_hw"], "grid": "gondola_hw"},
	"bar": {"floor": 6, "wall": ["counter", "shelf", "fridge", "bench", "vending_machine", "bench"], "center": ["table_small"], "chairs": true, "grid": "table_small"},
	"ward": {"floor": 15, "wall": ["hospital_bed", "curtain", "hospital_bed", "med_cart", "cabinet_low", "hospital_bed"], "center": []},
	"reception": {"floor": 15, "wall": ["counter", "bench", "filing_cabinet", "bench", "plant_pot", "vending_machine", "water_cooler"], "center": [], "grid": "lounge"},
	"office": {"floor": 15, "wall": ["desk", "filing_cabinet", "bookshelf", "locker", "water_cooler", "plant_pot", "filing_cabinet"], "center": ["desk"], "grid": "desk"},
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
	"terminal": {"floor": 10, "wall": ["counter", "bench", "vending_machine", "bench", "trash_bin", "bench"], "center": [], "grid": "bench"},
	"market_hall": {"floor": 10, "wall": ["freezer", "freezer", "shelf", "freezer", "shelf"], "center": [], "grid": "gondola"},
	"lobby": {"floor": 11, "wall": ["counter", "bench", "planter", "bench", "vending_machine"], "center": []},
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
## Prédio abandonado (depois do surto): sujeira, entulho, móveis tombados.
var ruined: bool = true
var _room_surf: Array = []
var _room_props: Array = []
var _col0: int = 0
var _door_u: float = -100.0
var _graffiti_n: int = 0
var _rooms0: Array = []


func _build(b: Dictionary) -> Dictionary:
	bld = b
	mesh = MeshBuf.new()
	glass = MeshBuf.new()
	panes = MeshBuf.new()
	out = {"mesh": mesh, "glass": glass, "panes": panes, "doors": [], "containers": [], "lights": [], "markers": {},
		"beds": [], "workbenches": [], "pickups": [], "screens": [], "labels": [], "spawns": [], "npc_spots": [], "elevator": {}, "windows": []}
	fr = make_frame(b)
	rng = Util.rng(int(b["seed"]) * 31 + 17)
	context = str(b.get("interior", b["type"]))
	ruined = GameState.world_phase != GameState.Phase.PRE
	out["phase"] = GameState.world_phase
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
	_door_u = door_u
	var layout: Dictionary
	match context:
		"lab":
			layout = _layout_lab()
		"market":
			layout = _layout_market(door_u)
		_:
			layout = _layout_bsp(door_u)
	_rooms0 = layout["rooms"]
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
	# malha em pedaços de ~8 m por andar (feito aqui, na thread): cada pedaço recebe só as
	# luzes perto dele (janelas, lanterna) — o Compatibility limita luzes por malha
	if mesh.vertex_count() > 12000:
		var base := fr.base
		out["mesh_parts"] = mesh.split_by(func(c: Vector3) -> Vector3i:
			return Vector3i(floori(c.x / 8.0), floori((c.y - base) / 2.8), floori(c.z / 8.0)))
	# limite de itens soltos por prédio (cada um é um nó; prédios enormes teriam centenas)
	var pk0: Array = out["pickups"]
	var cap := clampi(int(fr.width * fr.depth / 14.0), 10, 40)
	if pk0.size() > cap:
		for i in range(pk0.size() - 1, 0, -1):
			var j := rng.randi() % (i + 1)
			var tmp = pk0[i]
			pk0[i] = pk0[j]
			pk0[j] = tmp
		pk0.resize(cap)
	# arma largada em algum canto (chão ou em cima de um móvel)
	if ruined:
		var pk: Array = out["pickups"]
		var tries := 2 if context in ["police", "bunker", "hardware", "farmhouse", "cabin"] else 1
		for wt in tries:
			if not pk.is_empty() and rng.randf() < float(WEAPON_CHANCE.get(context, 0.3)) * (1.0 if wt == 0 else 0.5):
				var i := rng.randi() % pk.size()
				if str(pk[i].get("kind", "")) != "_weapon":
					pk[i]["kind"] = "_weapon"
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
			_wall_panes(wa, wb, n2, 0.0, _rooms0, door_u if i == 0 else -100.0, door_w)


## Janelas de uma parede externa: painel claro (o lado de fora) + registro para a
## luz real que entra por ela (World: luz do dia/luar, mancha de sol no piso).
func _wall_panes(wa: Vector2, wb: Vector2, n2: Vector2, y_off: float, rooms: Array, door_u: float, door_w: float) -> void:
	var n := fr.d3(n2.x, n2.y).normalized()
	var len := wa.distance_to(wb)
	var step := 3.1
	var u := step * 0.5 + fposmod(len, step) * 0.5
	var dir := (wb - wa).normalized()
	while u < len - 0.8:
		var c2 := wa + dir * u
		var skip := absf(c2.x - door_u) < door_w + 0.6 and absf(n2.y) > 0.5 and n2.y > 0.0
		if not skip and rng.randf() < 0.85:
			var pa := c2 - dir * 0.55
			var pb := c2 + dir * 0.55
			var p0 := fr.p(pa.x, pa.y, y_off) + n * 0.01
			var p1 := fr.p(pb.x, pb.y, y_off) + n * 0.01
			panes.quad(p0 + Vector3(0, 1.0, 0), p1 + Vector3(0, 1.0, 0), p1 + Vector3(0, 2.2, 0), p0 + Vector3(0, 2.2, 0), n,
				Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), 0.0, rng.randf(), Color(1, 1, 1))
			var boarded := false
			if ruined:
				boarded = _window_decay(fr.p(c2.x, c2.y, y_off), fr.d3(dir.x, dir.y).normalized(), n)
			# profundidade do cômodo atrás da janela (até onde a luz vai)
			var depth := 4.0
			var probe := c2 + n2 * 0.6
			for room in rooms:
				var rr: Rect2 = room["rect"]
				if rr.has_point(probe):
					depth = rr.size.y if absf(n2.y) > 0.5 else rr.size.x
					break
			out["windows"].append({"pos": fr.p(c2.x, c2.y, y_off + 1.6) + n * 0.12, "n": n, "along": fr.d3(dir.x, dir.y).normalized(),
				"depth": clampf(depth, 2.0, 9.0), "boarded": boarded})
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
		_wall_panes(wa, wb, n2, fh + 0.02, rooms, -100.0, 0.0)
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
	_room_surf = []
	_room_props = []
	_col0 = mesh.colliders.size()
	match tp:
		"lab_main":
			_furnish_lab_main(rr, y_off)
			_after_room(rr, tp, y_off, doors)
			return
		"observation":
			_furnish_observation(rr, y_off)
			_after_room(rr, tp, y_off, doors)
			return
		"isolation":
			_furnish_isolation(rr, y_off)
			_after_room(rr, tp, y_off, doors)
			return
		"office_helena":
			_furnish_helena(rr, y_off)
			_after_room(rr, tp, y_off, doors)
			return
		"cold_storage":
			_place_wall_props(rr, ["freezer", "freezer", "rack", "shelf", "freezer", "locker"], doors, y_off)
			_after_room(rr, tp, y_off, doors)
			return
		"corridor":
			out["npc_spots"].append(fr.p(rr.get_center().x, rr.get_center().y, y_off))
			out["markers"]["elevator"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(-1, 0)), fr.p(rr.end.x - 0.9, rr.get_center().y, y_off))
			out["markers"]["corridor_mid"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(1, 0)), fr.p(rr.get_center().x, rr.get_center().y, y_off))
			out["markers"]["corridor_west"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(1, 0)), fr.p(rr.position.x + 2.0, rr.get_center().y, y_off))
			mesh.box(fr.p(rr.end.x - 0.25, rr.get_center().y, y_off + 1.2), Vector3(0.3, 2.4, 2.2) if absf(fr.U.x) > 0.5 else Vector3(2.2, 2.4, 0.3), Assets.uv2_code(Assets.L_METAL), 0.0, Color(0.6, 0.62, 0.64))
			for i in 4:
				out["lights"].append({"pos": fr.p(rr.size.x * (0.15 + i * 0.23), rr.get_center().y, y_off + fh - 0.1), "range": 7.0, "room": "corridor", "type": "emergency"})
			_after_room(rr, tp, y_off, doors)
			return
		"lobby":
			_place_wall_props(rr, ["planter", "bench", "planter"], doors, y_off)
			var desk := fr.p(rr.get_center().x, rr.position.y + rr.size.y * 0.6, y_off)
			_place(PropLib.buf("counter"), "counter", desk, fr.yaw_for(0, -1), true)
			out["labels"].append({"xf": Transform3D(Basis(Vector3.UP, fr.yaw_for(0, -1)), fr.p(rr.get_center().x, rr.end.y - 0.08, y_off + 2.6)),
				"text": "CORVALIS BIOTECNOLOGIA", "size": 0.35, "color": Color(0.2, 0.3, 0.4)})
			out["markers"]["lobby"] = Transform3D(Basis(Vector3.UP, fr.yaw_for(0, 1)), fr.p(rr.get_center().x, rr.get_center().y, y_off))
			_after_room(rr, tp, y_off, doors)
			return
	var spec: Dictionary = ROOM_SPECS.get(tp, {})
	var wall_list: Array = spec.get("wall", [])
	_place_wall_props(rr, wall_list, doors, y_off, tp not in FILL_WALLS)
	var grid: String = spec.get("grid", "")
	var has_grid := grid != "" and _grid_fits(rr, grid)
	# centro
	var center: Array = spec.get("center", [])
	var cp := fr.p(rr.get_center().x, rr.get_center().y, y_off)
	for i in center.size():
		var pn: String = center[i]
		var cs := PropLib.collision_size(pn)
		if has_grid and pn != "rug":
			continue
		if pn == "rug" or (rr.size.x > cs.x + 2.2 and rr.size.y > cs.z + 2.2):
			var cyaw := fr.yaw_for(0, 1) + (PI * 0.5 if rr.size.x > rr.size.y else 0.0)
			if ruined and pn in ["table", "table_small"] and rng.randf() < 0.22:
				_place_tipped(pn, cp, cyaw, Basis(Vector3.RIGHT, PI * 0.5 * (1.0 if rng.randf() < 0.5 else -1.0)), true)
			else:
				_place(PropLib.buf(pn), pn, cp, cyaw, pn != "rug")
			if spec.get("chairs", false) and pn != "rug":
				for s: float in [-1.0, 1.0]:
					var off := fr.d3(0, s * (cs.z * 0.5 + 0.35))
					if rr.size.x > rr.size.y:
						off = fr.d3(s * (cs.x * 0.5 + 0.35), 0)
					_place_chair(cp + off, Util.dir_to_yaw(-off))
	# grade (salas de aula, galpões, mercados, capela, escritórios, bares)
	if has_grid:
		_grid(rr, grid, y_off)
	# pontos para NPCs/infectados
	out["spawns"].append(cp)
	if tp == "bedroom" or tp == "kids" or tp == "bunker":
		out["beds"].append(cp)
	if tp == "garage" or tp == "hardware":
		out["workbenches"].append(cp)
	_after_room(rr, tp, y_off, doors)


func _place_wall_props(rr: Rect2, list: Array, doors: Array, y_off: float, cap: bool = true) -> void:
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
			if cap and placed >= list.size() + 2:
				return


func _grid_dims(rr: Rect2, pn: String) -> Vector4:
	var cs := PropLib.collision_size(pn)
	if cs == Vector3.ZERO:
		cs = Vector3(0.7, 1.0, 0.7)
	if pn == "lounge":
		var lx := int((rr.size.x - 3.0) / 5.0)
		var lz := int((rr.size.y - 4.0) / 4.6)
		while lx * lz > 6:
			if lx >= lz:
				lx -= 1
			else:
				lz -= 1
		return Vector4(5.0, 4.6, lx, lz)
	var sx := cs.x + (1.8 if pn in ["gondola", "gondola_hw", "gondola_ph", "rack"] else 0.9)
	var sz := cs.z + (1.8 if pn in ["gondola", "gondola_hw", "gondola_ph", "rack", "pew"] else 0.8)
	if pn == "bench":
		sx = cs.x + 1.6
		sz = 2.2
	match pn:
		"school_desk":
			sx = 1.2
			sz = 1.3
		"desk":
			sx = cs.x + 1.2
			sz = cs.z + 1.5
		"table_small":
			sx = 2.2
			sz = 2.2
	var nx := int((rr.size.x - 2.0) / sx)
	var nz := int((rr.size.y - 3.0) / sz)
	# teto de peças por cômodo (malha única do interior)
	var cap := 12 if pn in ["server_rack", "rack"] else 24
	while nx * nz > cap:
		if nx >= nz:
			nx -= 1
		else:
			nz -= 1
	return Vector4(sx, sz, nx, nz)


func _grid_fits(rr: Rect2, pn: String) -> bool:
	var d := _grid_dims(rr, pn)
	return d.z >= 1 and d.w >= 1


func _grid(rr: Rect2, pn: String, y_off: float) -> void:
	var dm := _grid_dims(rr, pn)
	var sx := dm.x
	var sz := dm.y
	var nx := int(dm.z)
	var nz := int(dm.w)
	var yaw := fr.yaw_for(0, -1)
	for ix in nx:
		for iz in nz:
			var u := rr.position.x + 1.0 + sx * (ix + 0.5) + (rr.size.x - 2.0 - nx * sx) * 0.5
			var w := rr.position.y + 2.0 + sz * (iz + 0.5)
			var pos := fr.p(u, w, y_off)
			if pn == "lounge":
				_lounge(pos, yaw + (PI * 0.5 if (ix + iz) % 2 == 1 else 0.0))
				continue
			var shelfy := pn.begins_with("gondola")
			if ruined and (shelfy or pn in ["desk", "table_small", "school_desk"]) and rng.randf() < (0.12 if shelfy else 0.15):
				_place_tipped(pn, pos, yaw + rng.randf_range(-0.4, 0.4), Basis(Vector3.RIGHT, PI * 0.5 * (1.0 if rng.randf() < 0.5 else -1.0)), true)
				if shelfy:
					_spill_products(pos, 1.4)
				continue
			var gy := yaw + (rng.randf_range(-0.12, 0.12) if ruined and not shelfy and pn != "rack" else 0.0)
			_place(PropLib.buf(pn), pn, pos, gy, true)
			var bs := Basis(Vector3.UP, gy)
			match pn:
				"desk":
					_place_office_chair(pos + bs * Vector3(rng.randf_range(-0.2, 0.2), 0, -0.65), gy + PI + rng.randf_range(-0.6, 0.6))
					if not ruined or rng.randf() < 0.8:
						_place(PropLib.buf("computer"), "computer", pos + bs * Vector3(-0.15, 0.76, 0.12), gy, false)
					else:
						_place_tipped("computer", pos + bs * Vector3(0.4, 0, -0.9), gy + rng.randf_range(-1, 1), Basis(Vector3.RIGHT, -PI * 0.5), false)
				"table_small":
					for sd: float in [-1.0, 1.0]:
						_place_chair(pos + bs * Vector3(0, 0, sd * 0.62), gy + (0.0 if sd > 0 else PI))
				"gondola", "gondola_hw", "gondola_ph":
					if ruined and rng.randf() < 0.35:
						_spill_products(pos + bs * Vector3(0, 0, 0.8 * (1.0 if rng.randf() < 0.5 else -1.0)), 0.9)


## Área de espera: sofá, poltronas, mesinha de centro e planta.
func _lounge(pos: Vector3, yaw: float) -> void:
	var bs := Basis(Vector3.UP, yaw)
	_place(PropLib.buf("rug"), "rug", pos, yaw, false)
	if ruined and rng.randf() < 0.3:
		_place_tipped("table_small", pos + bs * Vector3(0.3, 0, 0.2), yaw + 0.5, Basis(Vector3.RIGHT, PI * 0.5), true)
	else:
		_place(PropLib.buf("table_small"), "table_small", pos, yaw, true)
	_place(PropLib.buf("sofa"), "sofa", pos + bs * Vector3(0, 0, 1.25), yaw + PI, true)
	for sd: float in [-1.0, 1.0]:
		var ay := yaw + sd * PI * 0.5 + (rng.randf_range(-0.5, 0.5) if ruined else 0.0)
		_place(PropLib.buf("armchair"), "armchair", pos + bs * Vector3(sd * 1.3, 0, 0.1), ay, true)
	_place(PropLib.buf("plant_pot"), "plant_pot", pos + bs * Vector3(1.6, 0, 1.4), yaw, true)


func _place_office_chair(pos: Vector3, yaw: float) -> void:
	if ruined and rng.randf() < 0.3:
		_place_tipped("office_chair", pos, yaw, Basis(Vector3.BACK, PI * 0.5), false)
	else:
		_place(PropLib.buf("office_chair"), "office_chair", pos, yaw, false)


## Produtos caídos das prateleiras (caixinhas coloridas espalhadas).
func _spill_products(c: Vector3, r: float) -> void:
	var PLA := Assets.uv2_code(Assets.L_PLASTER)
	for i in rng.randi_range(6, 14):
		var o := c + Vector3(rng.randf_range(-r, r), 0, rng.randf_range(-r * 0.6, r * 0.6))
		var sz := Vector3(rng.randf_range(0.07, 0.18), rng.randf_range(0.05, 0.22), rng.randf_range(0.05, 0.14))
		var lying := rng.randf() < 0.6
		var bs := Basis(Vector3.UP, rng.randf() * TAU)
		if lying:
			bs = bs * Basis(Vector3.BACK, PI * 0.5)
		var h := (sz.x if lying else sz.y) * 0.5
		mesh.box_xf(Transform3D(bs, o + Vector3(0, h + 0.018, 0)), sz, PLA, rng.randf(), Color.from_hsv(rng.randf(), rng.randf_range(0.5, 0.9), rng.randf_range(0.5, 0.95)))


## Registra um prop: mescla geometria, colisão e contêiner (se aplicável).
func _place(pb: MeshBuf, pn: String, pos: Vector3, yaw: float, collide: bool) -> void:
	var xf := Transform3D(Basis(Vector3.UP, yaw), pos)
	mesh.append(pb, xf)
	if debug_counts != null:
		debug_counts[pn] = int(debug_counts.get(pn, 0)) + pb.vertex_count()
	_room_props.append([pn, xf])
	if SURFACES.has(pn):
		var sd: Array = SURFACES[pn]
		_room_surf.append({"xf": xf, "h": float(sd[0]), "ext": Vector2(float(sd[1]), float(sd[2])), "zoff": float(sd[3]), "prop": pn,
			"kind": CONTAINER_KIND.get(pn, "")})
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


# ---------------------------------------------------------------------------
# Itens soltos (em cima de móveis e no chão)
# ---------------------------------------------------------------------------
func _after_room(rr: Rect2, tp: String, y_off: float, doors: Array) -> void:
	if not out.has("room_views"):
		out["room_views"] = []
	out["room_views"].append({"type": tp, "area": rr.get_area(), "a": fr.p(rr.position.x + 0.45, rr.position.y + 0.45, y_off),
		"b": fr.p(rr.end.x - 0.45, rr.end.y - 0.45, y_off)})
	# orçamento de vértices por interior (malha única; GPUs antigas e subida da malha no quadro)
	var left := VERT_BUDGET - mesh.vertex_count()
	_room_fixtures(rr, tp, y_off, doors, left > 25000)
	if left > 40000:
		for sd in _room_surf:
			if rng.randf() < 0.7:
				_surface_decor(sd, tp)
	_scatter_items(rr, tp, y_off)
	if ruined:
		_decay(rr, tp, y_off, doors, clampf(float(left) / 60000.0, 0.25, 1.0))


# ---------------------------------------------------------------------------
# Acabamentos: rodapé, luminárias, quadros, relógios, cartazes
# ---------------------------------------------------------------------------
const WALL_DECOR := {
	"living": ["picture", "picture", "wall_clock", "wall_shelf", "picture"], "kitchen": ["wall_clock", "wall_shelf"],
	"bedroom": ["picture", "mirror", "picture"], "kids": ["poster", "picture", "poster"], "bathroom": ["mirror"],
	"hall": ["picture", "mirror"], "office": ["notice_board", "wall_clock", "poster", "picture"], "reception": ["notice_board", "wall_clock", "poster"],
	"classroom": ["notice_board", "wall_clock", "poster"], "sales": ["poster", "poster", "wall_clock"], "pharmacy": ["poster", "wall_clock"],
	"hardware": ["poster", "notice_board"], "bar": ["poster", "picture", "wall_clock", "poster"], "ward": ["wall_clock", "notice_board"],
	"med_storage": ["notice_board"], "garage": ["poster", "notice_board", "wall_shelf"], "storage": ["notice_board"],
	"armory": ["notice_board"], "radio": ["notice_board", "poster"], "lobby": ["poster", "wall_clock"], "terminal": ["poster", "wall_clock", "poster"],
	"market_hall": ["poster", "poster"], "lab_room": ["notice_board"], "chapel": ["picture"], "bunker": ["poster"],
}
const NO_BASEBOARD := ["storage", "hall_big", "barn", "garage", "cell", "bunker", "server", "armory", "radio", "market_hall"]


func _room_fixtures(rr: Rect2, tp: String, y_off: float, doors: Array, rich: bool = true) -> void:
	var walls := _room_walls(rr)
	# rodapé (quebra nas portas)
	if tp not in NO_BASEBOARD:
		var bcol := Color(0.42, 0.32, 0.24) if tp in RESIDENTIAL else Color(0.55, 0.55, 0.53)
		var bcode := Assets.uv2_code(Assets.L_WOOD if tp in RESIDENTIAL else Assets.L_PANELS)
		for wd in walls:
			for seg in _wall_segments(wd, doors):
				var a: float = seg[0]
				var b: float = seg[1]
				if b - a < 0.15:
					continue
				var o: Vector2 = wd["o"]
				var dir: Vector2 = wd["dir"]
				var n2: Vector2 = wd["n"]
				var mid := o + dir * ((a + b) * 0.5) + n2 * 0.009
				var sz := fr.d3(dir.x * (b - a), dir.y * (b - a)).abs() + fr.d3(n2.x * 0.018, n2.y * 0.018).abs()
				mesh.box(fr.p(mid.x, mid.y, y_off + 0.055), Vector3(maxf(sz.x, 0.018), 0.09, maxf(sz.z, 0.018)), bcode, 0.2, bcol)
	# luminárias de teto (desligadas ou penduradas depois do surto)
	var top := y_off + fh - 0.012
	if not rich:
		_ceiling_lamp("pendant_lamp" if tp in RESIDENTIAL else "fluoro_lamp", rr.get_center(), top, y_off)
		return
	if tp in RESIDENTIAL:
		_ceiling_lamp("pendant_lamp", rr.get_center(), top, y_off)
	elif tp not in ["corridor", "isolation", "observation"]:
		var nx := clampi(int(rr.size.x / 3.6), 1, 4)
		var nz := clampi(int(rr.size.y / 3.6), 1, 4)
		for ix in nx:
			for iz in nz:
				_ceiling_lamp("fluoro_lamp", Vector2(rr.position.x + rr.size.x * (ix + 0.5) / nx, rr.position.y + rr.size.y * (iz + 0.5) / nz), top, y_off)
	# quadros, relógios, cartazes, espelhos
	var deco: Array = WALL_DECOR.get(tp, [])
	if deco.is_empty():
		return
	var want := mini(deco.size(), 1 + int(rr.get_area() / 10.0))
	var placed := 0
	for t in want * 3:
		if placed >= want:
			break
		var wd: Dictionary = walls[rng.randi() % walls.size()]
		var len: float = wd["len"]
		if len < 1.2:
			continue
		var pn: String = deco[placed % deco.size()]
		var s := rng.randf_range(0.6, len - 0.6)
		if _wall_has_door(wd, s, 0.5, doors):
			continue
		var h := 1.55 if pn != "notice_board" else 1.45
		if pn == "mirror":
			h = 1.5
		if pn == "wall_clock":
			h = 2.1
		var o: Vector2 = wd["o"]
		var dir: Vector2 = wd["dir"]
		var n2: Vector2 = wd["n"]
		var q := o + dir * s
		var front := fr.p(q.x + n2.x * 0.3, q.y + n2.y * 0.3, y_off)
		if not _wall_front_free(front, h):
			continue
		var yaw := fr.yaw_for(n2.x, n2.y)
		var bs := Basis(Vector3.UP, yaw)
		if ruined and pn in ["picture", "poster", "mirror"] and rng.randf() < 0.25:
			# caiu da parede: deitado no chão, com cacos
			var fp := fr.p(q.x + n2.x * 0.35, q.y + n2.y * 0.35, y_off + 0.03)
			mesh.append(PropLib.buf(pn), Transform3D(bs * Basis(Vector3.RIGHT, -PI * 0.5 + rng.randf_range(-0.1, 0.1)), fp))
			if pn != "poster":
				_glass_shards(fp, 0.25, fr.d3(dir.x, dir.y).normalized(), fr.d3(n2.x, n2.y).normalized())
		else:
			var roll := rng.randf_range(-0.22, 0.22) if ruined and pn != "notice_board" else rng.randf_range(-0.02, 0.02)
			var wp := fr.p(q.x + n2.x * 0.017, q.y + n2.y * 0.017, y_off + h)
			mesh.append(PropLib.buf(pn), Transform3D(bs * Basis(Vector3.BACK, roll), wp))
		placed += 1


## Trechos contínuos de parede (sem portas): [[a, b], ...] ao longo do lado.
func _wall_segments(wd: Dictionary, doors: Array) -> Array:
	var len: float = wd["len"]
	var o: Vector2 = wd["o"]
	var dir: Vector2 = wd["dir"]
	var n: Vector2 = wd["n"]
	var cuts: Array = []
	for d in doors:
		var rel: Vector2 = (d["a"] as Vector2) - o
		if absf(rel.dot(n)) < 0.4:
			var al := rel.dot(dir)
			var hw := float(d.get("w", DOOR_W)) * 0.5 + 0.03
			cuts.append([al - hw, al + hw])
	if bool(wd["ext"]) and n.y > 0.5:
		var al2 := _door_u - o.x
		cuts.append([al2 - 0.85, al2 + 0.85])
	cuts.sort_custom(func(x, y): return float(x[0]) < float(y[0]))
	var segs: Array = []
	var u := 0.0
	for c in cuts:
		var c0: float = clampf(c[0], 0.0, len)
		var c1: float = clampf(c[1], 0.0, len)
		if c0 > u:
			segs.append([u, c0])
		u = maxf(u, c1)
	if u < len:
		segs.append([u, len])
	return segs


## Nada alto (armário, estante) encostado na parede neste ponto?
func _wall_front_free(wp: Vector3, h: float) -> bool:
	var cols: Array = mesh.colliders
	for ci in range(_col0, cols.size()):
		var xf: Transform3D = cols[ci][0]
		var sz: Vector3 = cols[ci][1]
		if xf.origin.y + sz.y * 0.5 < h - 0.35:
			continue
		var lp := xf.affine_inverse() * Vector3(wp.x, xf.origin.y, wp.z)
		if absf(lp.x) < sz.x * 0.5 + 0.35 and absf(lp.z) < sz.z * 0.5 + 0.35:
			return false
	return true


func _ceiling_lamp(pn: String, q: Vector2, top: float, y_off: float) -> void:
	var yaw := fr.yaw_for(1, 0)
	var p := fr.p(q.x, q.y, 0.0)
	p.y = top
	if ruined and rng.randf() < 0.1:
		# caiu no chão
		var fp := fr.p(q.x + rng.randf_range(-0.4, 0.4), q.y + rng.randf_range(-0.4, 0.4), y_off)
		var src := PropLib.buf(pn)
		mesh.append(src, Transform3D(Basis(Vector3.UP, yaw + rng.randf_range(-1, 1)), fp + Vector3(0, 0.07 if pn == "fluoro_lamp" else 0.75, 0)))
		if pn == "fluoro_lamp":
			_glass_shards(fp, 0.35, fr.d3(1, 0).normalized(), fr.d3(0, 1).normalized())
		return
	var tilt := Basis.IDENTITY
	if ruined and pn == "fluoro_lamp" and rng.randf() < 0.18:
		# pendurada por uma ponta
		var ta := rng.randf_range(0.5, 0.9) * (1.0 if rng.randf() < 0.5 else -1.0)
		tilt = Basis(Vector3.BACK, ta)
		p.y -= 0.62 * absf(sin(ta))
	mesh.append(PropLib.buf(pn), Transform3D(Basis(Vector3.UP, yaw) * tilt, p))


func _scatter_items(rr: Rect2, tp: String, y_off: float) -> void:
	var max_items := 2 if rr.get_area() < 12.0 else (3 if rr.get_area() < 35.0 else 5)
	var n := 0
	# embaralha de forma determinística (mesmo prédio = mesmos pontos)
	var surf := _room_surf.duplicate()
	for i in range(surf.size() - 1, 0, -1):
		var j := rng.randi() % (i + 1)
		var t = surf[i]
		surf[i] = surf[j]
		surf[j] = t
	for sd in surf:
		if n >= max_items:
			break
		if rng.randf() > 0.5:
			continue
		var ext: Vector2 = sd["ext"]
		var lp := Vector3(rng.randf_range(-ext.x, ext.x) * 0.75, float(sd["h"]) + 0.004, float(sd["zoff"]) + rng.randf_range(-ext.y, ext.y) * 0.7)
		var xf: Transform3D = sd["xf"]
		out["pickups"].append({"pos": xf * lp, "context": context, "room": tp, "kind": _surface_kind(sd, tp), "yaw": rng.randf() * TAU})
		n += 1
	var nf := 1 + (1 if rng.randf() < 0.4 else 0) + (1 if rr.get_area() > 40.0 else 0)
	for i in nf:
		var p2 := _free_floor_spot(rr)
		if p2.x == INF:
			continue
		out["pickups"].append({"pos": fr.p(p2.x, p2.y, y_off + 0.02), "context": context, "room": tp, "kind": "_floor", "yaw": rng.randf() * TAU})


## Que tabela de loot vale para um item apoiado neste móvel.
func _surface_kind(sd: Dictionary, tp: String) -> String:
	var k: String = sd["kind"]
	if k != "":
		return k
	match tp:
		"kitchen": return "kitchen_cabinet"
		"bedroom", "kids": return "nightstand"
		"living", "hall": return "drawer"
		"bar": return "counter"
		"office", "reception", "classroom", "radio": return "desk"
		"garage", "hardware": return "workbench"
		"ward", "med_storage": return "med_cart"
	return "_floor"


## Ponto livre no piso do cômodo (fora dos móveis e longe de outros itens), em (u, w).
func _free_floor_spot(rr: Rect2, margin: float = 0.45) -> Vector2:
	if rr.size.x < margin * 2.2 or rr.size.y < margin * 2.2:
		return Vector2(INF, INF)
	for t in 10:
		var q := Vector2(rng.randf_range(rr.position.x + margin, rr.end.x - margin), rng.randf_range(rr.position.y + margin, rr.end.y - margin))
		var wp := fr.p(q.x, q.y, 0.0)
		if not _spot_free(wp, 0.12):
			continue
		var near := false
		for pk in out["pickups"]:
			var pp: Vector3 = pk["pos"]
			if Vector2(pp.x - wp.x, pp.z - wp.z).length() < 0.5:
				near = true
				break
		if not near:
			return q
	return Vector2(INF, INF)


func _spot_free(wp: Vector3, pad: float) -> bool:
	var cols: Array = mesh.colliders
	for ci in range(_col0, cols.size()):
		var xf: Transform3D = cols[ci][0]
		var sz: Vector3 = cols[ci][1]
		var lp := xf.affine_inverse() * Vector3(wp.x, xf.origin.y, wp.z)
		if absf(lp.x) < sz.x * 0.5 + pad and absf(lp.z) < sz.z * 0.5 + pad:
			return false
	return true


# ---------------------------------------------------------------------------
# Abandono: móveis tombados, sujeira, entulho, pichações, teto caído
# ---------------------------------------------------------------------------
func _place_chair(pos: Vector3, yaw: float) -> void:
	if ruined and rng.randf() < 0.35:
		_place_tipped("chair", pos + fr.d3(rng.randf_range(-0.3, 0.3), rng.randf_range(-0.3, 0.3)), yaw + rng.randf_range(-0.6, 0.6),
			Basis(Vector3.BACK, PI * 0.5 * (1.0 if rng.randf() < 0.5 else -1.0)), false)
	else:
		_place(PropLib.buf("chair"), "chair", pos, yaw + (rng.randf_range(-0.35, 0.35) if ruined else 0.0), false)


## Móvel deitado/virado: `tip` gira o prop no espaço local; apoia o ponto mais baixo no piso.
func _place_tipped(pn: String, pos: Vector3, yaw: float, tip: Basis, collide: bool) -> void:
	var src := PropLib.buf(pn)
	var lo := INF
	for v in src.verts:
		lo = minf(lo, (tip * v).y)
	if lo == INF:
		return
	var bs := Basis(Vector3.UP, yaw) * tip
	var xf := Transform3D(bs, pos + Vector3(0, -lo + 0.003, 0))
	mesh.append(src, xf)
	if collide:
		var cs := PropLib.collision_size(pn)
		if cs != Vector3.ZERO:
			mesh.add_collider(Transform3D(bs, xf * Vector3(0, cs.y * 0.5, 0)), cs)


## Tábuas pregadas e cacos de vidro sob algumas janelas.
func _window_decay(base: Vector3, along: Vector3, n: Vector3) -> bool:
	var WOOD := Assets.uv2_code(Assets.L_WOOD)
	var r := rng.randf()
	if r < 0.3:
		var cnt := rng.randi_range(2, 4)
		for i in cnt:
			var h := 1.05 + (float(i) + 0.5) / float(cnt) * 1.1 + rng.randf_range(-0.08, 0.08)
			var tilt := rng.randf_range(-0.25, 0.25)
			var bs := Basis(along, n.cross(along).normalized(), n).orthonormalized() * Basis(Vector3.BACK, tilt)
			mesh.box_xf(Transform3D(bs, base + Vector3(0, h, 0) + n * (0.03 + i * 0.022)), Vector3(1.45, 0.12, 0.02), WOOD, rng.randf(),
				Color(0.62, 0.5, 0.36).darkened(rng.randf() * 0.25))
		return true
	elif r < 0.55:
		_glass_shards(base + n * 0.35, 0.45, along, n)
	return false


func _glass_shards(c: Vector3, spread: float, along: Vector3, n: Vector3) -> void:
	var TIL := Assets.uv2_code(Assets.L_TILES)
	for i in rng.randi_range(5, 11):
		var o := c + along * rng.randf_range(-spread, spread) + n * rng.randf_range(-0.2, spread * 0.8)
		o.y = c.y + 0.018 + i * 0.0004
		var s := rng.randf_range(0.02, 0.07)
		var a := rng.randf() * TAU
		var p0 := o + Vector3(cos(a), 0, sin(a)) * s
		var p1 := o + Vector3(cos(a + 2.2), 0, sin(a + 2.2)) * s * rng.randf_range(0.5, 1.0)
		var p2 := o + Vector3(cos(a + 4.1), 0, sin(a + 4.1)) * s * rng.randf_range(0.4, 0.9)
		mesh.tri(p0, p1, p2, Vector3.UP, Vector2(p0.x, p0.z), Vector2(p1.x, p1.z), Vector2(p2.x, p2.z), TIL, 0.0, Color(0.75, 0.85, 0.88))


func _decay(rr: Rect2, tp: String, y_off: float, doors: Array, amount: float = 1.0) -> void:
	var area := rr.get_area()
	var k := clampf(area / 14.0, 0.6, 3.0) * amount
	var PLA := Assets.uv2_code(Assets.L_PLASTER)
	var FAB := Assets.uv2_code(Assets.L_FABRIC)
	var MET := Assets.uv2_code(Assets.L_METAL)
	var spec: Dictionary = ROOM_SPECS.get(tp, {})
	var fl := int(spec.get("floor", Assets.L_WOOD))
	if tp in ["corridor", "lab_main", "observation", "isolation", "office_helena", "cold_storage"]:
		fl = Assets.L_LINOLEUM
	var floor_code := Assets.uv2_code(fl)
	var fy := y_off + 0.017
	# 1) manchas no piso: sujeira, infiltração, sangue seco
	for i in int(2.0 * k) + rng.randi_range(0, 2):
		var q := _rand_in(rr, 0.4)
		var blood := rng.randf() < 0.16
		var col := Color(0.42, 0.12, 0.08) if blood else Color(0.62, 0.56, 0.48).darkened(rng.randf() * 0.25)
		_stain(fr.p(q.x, q.y, fy + i * 0.0003), rng.randf_range(0.25, 0.85), floor_code, col)
	if rng.randf() < 0.12:
		_blood_trail(rr, fy + 0.004, floor_code)
	# 2) papéis espalhados
	var np := int(float(rng.randi_range(2, 6)) * k * (1.8 if tp in ["office", "reception", "classroom", "lobby", "radio"] else 1.0))
	for i in np:
		var q := _rand_in(rr, 0.3)
		var paper := Color(0.97, 0.95, 0.88).lerp(Color(0.78, 0.7, 0.52), rng.randf())
		mesh.box_xf(Transform3D(Basis(Vector3.UP, rng.randf() * TAU) * Basis(Vector3.RIGHT, rng.randf_range(-0.05, 0.05)), fr.p(q.x, q.y, fy + 0.003 + i * 0.0005)),
			Vector3(0.21, 0.0015, 0.297), PLA, rng.randf(), paper)
	# 3) entulho de reboco caído perto das paredes
	for i in int(float(rng.randi_range(2, 6)) * k):
		var q := _rand_near_wall(rr)
		var sz := Vector3(rng.randf_range(0.03, 0.17), rng.randf_range(0.012, 0.045), rng.randf_range(0.03, 0.14))
		mesh.box_xf(Transform3D(Basis.from_euler(Vector3(rng.randf_range(-0.3, 0.3), rng.randf() * TAU, rng.randf_range(-0.3, 0.3))),
			fr.p(q.x, q.y, fy + sz.y * 0.35)), sz, PLA, rng.randf(), Color(0.86, 0.84, 0.8))
	# 4) lixo: latas, garrafas, sacolas, embalagens amassadas
	for i in int(float(rng.randi_range(2, 6)) * k):
		var q := _rand_in(rr, 0.35)
		var wp := fr.p(q.x, q.y, fy)
		if not _spot_free(wp, 0.0):
			continue
		_trash_piece(wp)
	# 5) cantos: sacos de lixo / caixas de papelão
	if rng.randf() < 0.3 * k and tp not in ["bathroom", "corridor", "isolation"]:
		var q := _rand_near_wall(rr, 0.55)
		var wp := fr.p(q.x, q.y, y_off)
		if _spot_free(wp, 0.35):
			mesh.append(PropLib.buf("trash_bags" if rng.randf() < 0.6 else "cardboard"), Transform3D(Basis(Vector3.UP, rng.randf() * TAU).scaled(Vector3.ONE * 0.75), wp))
	# 6) paredes: infiltração, mofo, rachaduras, reboco caído (tijolo exposto), pichação
	var walls := _room_walls(rr)
	for wd in walls:
		var len: float = wd["len"]
		if len < 1.2:
			continue
		if rng.randf() < 0.55:
			_wall_streak(wd, rng.randf_range(0.4, len - 0.4), y_off, doors)
		if rng.randf() < 0.3:
			_wall_crack(wd, rng.randf_range(0.5, len - 0.5), y_off, doors)
		if bool(wd["ext"]) and rng.randf() < 0.25:
			_wall_brick(wd, rng.randf_range(0.6, len - 0.6), y_off, doors)
		if rng.randf() < 0.18:
			_wall_blood(wd, rng.randf_range(0.5, len - 0.5), y_off, doors)
		if rng.randf() < (0.2 if tp in ["cell", "armory", "lobby", "reception", "ward", "corridor"] else 0.06):
			var bs := rng.randf_range(0.6, len - 0.6)
			if not _wall_has_door(wd, bs, 0.6, doors):
				var n2: Vector2 = wd["n"]
				var q: Vector2 = (wd["o"] as Vector2) + (wd["dir"] as Vector2) * bs + n2 * 0.012
				mesh.append(PropLib.buf("bullet_holes"), Transform3D(Basis(Vector3.UP, fr.yaw_for(n2.x, n2.y)) * Basis(Vector3.BACK, rng.randf() * TAU),
					fr.p(q.x, q.y, y_off + rng.randf_range(0.9, 1.7))))
	# restos humanos: raros (um corpo coberto, ossada ou saco num canto)
	if tp not in ["bathroom", "corridor", "kids", "closet"] and area > 6.0 and rng.randf() < (0.1 if tp in ["ward", "cell", "cold_storage", "isolation"] else 0.03):
		var q := _rand_in(rr, 0.9)
		var wp := fr.p(q.x, q.y, fy)
		if _spot_free(wp, 0.9):
			var pick := rng.randf()
			var pn := "body_bag" if tp in ["ward", "cold_storage", "isolation"] and pick < 0.6 else ("covered_body" if pick < 0.45 else ("remains" if pick < 0.8 else "bones"))
			mesh.append(PropLib.buf(pn), Transform3D(Basis(Vector3.UP, rng.randf() * TAU), wp))
			if pn != "body_bag" and rng.randf() < 0.7:
				_stain(fr.p(q.x + 0.2, q.y, fy + 0.001), rng.randf_range(0.5, 0.8), floor_code, Color(0.36, 0.08, 0.06))
	if _graffiti_n < 3 and rng.randf() < (0.22 if tp not in ["bathroom", "kids"] else 0.08):
		var wd: Dictionary = walls[rng.randi() % walls.size()]
		if float(wd["len"]) > 1.6:
			_graffiti(wd, rng.randf_range(0.8, float(wd["len"]) - 0.8), y_off, doors)
	# 7) teto desabado (placas e fiação caídas)
	if tp not in ["corridor", "isolation", "observation"] and area > 7.0 and rng.randf() < 0.2:
		_ceiling_collapse(rr, y_off, floor_code)
	# 8) detalhes por cômodo
	match tp:
		"bedroom", "kids":
			for i in rng.randi_range(1, 4):
				var q := _rand_in(rr, 0.45)
				var wp := fr.p(q.x, q.y, fy)
				if _spot_free(wp, 0.05):
					_clothes(wp)
		"kitchen", "bar":
			for i in rng.randi_range(3, 8):
				var q := _rand_in(rr, 0.4)
				var sz := rng.randf_range(0.02, 0.07)
				mesh.box_xf(Transform3D(Basis(Vector3.UP, rng.randf() * TAU), fr.p(q.x, q.y, fy + 0.004)), Vector3(sz, 0.006, sz * rng.randf_range(0.5, 1.2)),
					Assets.uv2_code(Assets.L_TILES), 0.0, Color(0.95, 0.95, 0.93))
			if rng.randf() < 0.5:
				var q := _rand_in(rr, 0.5)
				var wp := fr.p(q.x, q.y, y_off + 0.12)
				mesh.cylinder(Transform3D(Basis(Vector3.BACK, PI * 0.5) * Basis(Vector3.UP, rng.randf()), wp), 0.12, 0.14, 10, MET, 0.0, Color(0.55, 0.55, 0.58))
		"bathroom":
			if rng.randf() < 0.6:
				var q := _rand_in(rr, 0.4)
				_clothes(fr.p(q.x, q.y, fy), Color(0.9, 0.9, 0.88))
	# livros caídos na frente das estantes, gavetas no chão
	for pr in _room_props:
		var pn: String = pr[0]
		var pxf: Transform3D = pr[1]
		if (pn == "bookshelf" or pn == "shelf") and rng.randf() < 0.65:
			for i in rng.randi_range(2, 6):
				var lp := Vector3(rng.randf_range(-0.45, 0.45), 0.0, rng.randf_range(-0.35, -0.85))
				var wp := pxf * lp
				wp.y = fy + 0.015 + i * 0.002
				var bc := Color.from_hsv(rng.randf(), rng.randf_range(0.3, 0.6), rng.randf_range(0.3, 0.7))
				mesh.box_xf(Transform3D(Basis(Vector3.UP, rng.randf() * TAU) * Basis(Vector3.BACK, rng.randf_range(-0.2, 0.2)), wp),
					Vector3(0.15, 0.03, 0.22) if pn == "bookshelf" else Vector3(0.14, 0.09, 0.1), FAB, rng.randf(), bc)
		elif pn in ["cabinet_low", "nightstand", "desk", "kitchen_counter"] and rng.randf() < 0.3:
			var wp := pxf * Vector3(rng.randf_range(-0.2, 0.2), 0.0, -0.6)
			wp.y = y_off + 0.07
			mesh.box_xf(Transform3D(Basis(Vector3.UP, pxf.basis.get_euler().y + rng.randf_range(-0.8, 0.8)), wp), Vector3(0.4, 0.12, 0.36),
				Assets.uv2_code(Assets.L_WOOD), rng.randf(), Color(0.6, 0.46, 0.33))
	# ninho de sobrevivente (colchão no chão, latas, vela)
	if tp in ["living", "office", "hall", "storage", "classroom", "reception", "bunker"] and rng.randf() < 0.12:
		_survivor_nest(rr, y_off)


func _rand_in(rr: Rect2, margin: float) -> Vector2:
	return Vector2(rng.randf_range(rr.position.x + margin, maxf(rr.position.x + margin, rr.end.x - margin)),
		rng.randf_range(rr.position.y + margin, maxf(rr.position.y + margin, rr.end.y - margin)))


func _rand_near_wall(rr: Rect2, inset: float = 0.45) -> Vector2:
	var side := rng.randi() % 4
	var q := _rand_in(rr, inset)
	match side:
		0: q.y = rr.position.y + inset
		1: q.x = rr.end.x - inset
		2: q.y = rr.end.y - inset
		_: q.x = rr.position.x + inset
	return q


## Mancha irregular no piso (três anéis: borda quase da cor do piso até o miolo escuro).
func _stain(c: Vector3, r: float, code: float, col: Color) -> void:
	var n := 16
	var rs: Array = []
	var ph := rng.randf() * TAU
	for i in n:
		var a := TAU * float(i) / float(n)
		rs.append(r * (0.72 + 0.18 * sin(a * 3.0 + ph) + rng.randf_range(-0.12, 0.12)))
	var ex := rng.randf_range(0.55, 1.0)
	var rot := rng.randf() * TAU
	var off := Vector2(rng.randf_range(-0.15, 0.15), rng.randf_range(-0.15, 0.15)) * r
	for ring in 3:
		var sc := [1.0, 0.72, 0.42][ring] as float
		var cc := col.lerp(Color(1, 1, 1), [0.62, 0.3, 0.0][ring] as float)
		var y := c.y + ring * 0.0007
		var cen := Vector3(c.x + off.x * ring * 0.5, y, c.z + off.y * ring * 0.5)
		var pts: Array = []
		for i in n:
			var a := TAU * float(i) / float(n)
			var v := Vector2(cos(a) * float(rs[i]) * sc, sin(a) * float(rs[i]) * sc * ex).rotated(rot)
			pts.append(Vector3(cen.x + v.x, y, cen.z + v.y))
		for i in n:
			var p0: Vector3 = pts[i]
			var p1: Vector3 = pts[(i + 1) % n]
			mesh.tri(cen, p0, p1, Vector3.UP, Vector2(cen.x, cen.z), Vector2(p0.x, p0.z), Vector2(p1.x, p1.z), code, 0.37, cc)


func _blood_trail(rr: Rect2, y: float, code: float) -> void:
	var a := _rand_in(rr, 0.5)
	var b := _rand_in(rr, 0.5)
	var steps := int(a.distance_to(b) / 0.35)
	for i in steps:
		var q := a.lerp(b, float(i) / float(maxi(steps, 1))) + Vector2(rng.randf_range(-0.08, 0.08), rng.randf_range(-0.08, 0.08))
		_stain(fr.p(q.x, q.y, y + i * 0.0002), rng.randf_range(0.06, 0.16), code, Color(0.4, 0.1, 0.07))


func _trash_piece(wp: Vector3) -> void:
	var MET := Assets.uv2_code(Assets.L_METAL)
	var TIL := Assets.uv2_code(Assets.L_TILES)
	var FAB := Assets.uv2_code(Assets.L_FABRIC)
	var PLA := Assets.uv2_code(Assets.L_PLASTER)
	var yaw := rng.randf() * TAU
	var r := rng.randf()
	if r < 0.3:   # lata deitada
		mesh.cylinder(Transform3D(Basis(Vector3.UP, yaw) * Basis(Vector3.BACK, PI * 0.5), wp + Vector3(0, 0.034, 0)), 0.034, 0.11, 8, MET, rng.randf(),
			Color.from_hsv(rng.randf(), 0.6, 0.7))
	elif r < 0.5:   # garrafa deitada
		mesh.cylinder(Transform3D(Basis(Vector3.UP, yaw) * Basis(Vector3.BACK, PI * 0.5), wp + Vector3(0, 0.035, 0)), 0.035, 0.22, 8, TIL, 0.0,
			Color(0.35, 0.55, 0.3) if rng.randf() < 0.5 else Color(0.55, 0.4, 0.2))
	elif r < 0.75:   # papel/embalagem amassada
		var s := rng.randf_range(0.04, 0.08)
		mesh.box_xf(Transform3D(Basis.from_euler(Vector3(rng.randf(), yaw, rng.randf())), wp + Vector3(0, s * 0.4, 0)), Vector3(s, s * 0.8, s * 0.9), PLA, rng.randf(),
			Color(0.95, 0.93, 0.88) if rng.randf() < 0.6 else Color.from_hsv(rng.randf(), 0.6, 0.8))
	else:   # sacola plástica achatada
		mesh.box_xf(Transform3D(Basis(Vector3.UP, yaw), wp + Vector3(0, 0.01, 0)), Vector3(rng.randf_range(0.18, 0.3), 0.02, rng.randf_range(0.15, 0.25)), FAB, rng.randf(),
			Color.from_hsv(rng.randf(), 0.3, 0.85))


func _clothes(wp: Vector3, col: Color = Color(-1, 0, 0)) -> void:
	var FAB := Assets.uv2_code(Assets.L_FABRIC)
	var c := col if col.r >= 0.0 else Color.from_hsv(rng.randf(), rng.randf_range(0.2, 0.6), rng.randf_range(0.3, 0.75))
	var yaw := rng.randf() * TAU
	mesh.box_xf(Transform3D(Basis(Vector3.UP, yaw), wp + Vector3(0, 0.012, 0)), Vector3(rng.randf_range(0.35, 0.55), 0.024, rng.randf_range(0.3, 0.5)), FAB, rng.randf(), c)
	mesh.box_xf(Transform3D(Basis(Vector3.UP, yaw + rng.randf_range(0.4, 1.2)), wp + Vector3(0.12, 0.03, 0.05)), Vector3(0.1, 0.03, 0.4), FAB, rng.randf(), c.darkened(0.1))


## Lados internos de um cômodo: origem (u, w), direção, normal para dentro, comprimento, se é parede externa.
func _room_walls(rr: Rect2) -> Array:
	var W := fr.width
	var D := fr.depth
	var o: Array = []
	var e0 := rr.position.y < 0.05
	var e1 := rr.end.x > W - 0.05
	var e2 := rr.end.y > D - 0.05
	var e3 := rr.position.x < 0.05
	var t := WALL_T * 0.5
	o.append({"o": Vector2(rr.position.x, rr.position.y + (0.3 if e0 else t)), "dir": Vector2(1, 0), "n": Vector2(0, 1), "len": rr.size.x, "ext": e0, "line": rr.position.y, "a0": rr.position.x})
	o.append({"o": Vector2(rr.end.x - (0.3 if e1 else t), rr.position.y), "dir": Vector2(0, 1), "n": Vector2(-1, 0), "len": rr.size.y, "ext": e1, "line": rr.end.x, "a0": rr.position.y})
	o.append({"o": Vector2(rr.end.x, rr.end.y - (0.3 if e2 else t)), "dir": Vector2(-1, 0), "n": Vector2(0, -1), "len": rr.size.x, "ext": e2, "line": rr.end.y, "a0": rr.end.x})
	o.append({"o": Vector2(rr.position.x + (0.3 if e3 else t), rr.end.y), "dir": Vector2(0, -1), "n": Vector2(1, 0), "len": rr.size.y, "ext": e3, "line": rr.position.x, "a0": rr.end.y})
	return o


## Há porta/abertura nesta parede perto da posição `s` (ao longo)?
func _wall_has_door(wd: Dictionary, s: float, half: float, doors: Array) -> bool:
	var o: Vector2 = wd["o"]
	var dir: Vector2 = wd["dir"]
	var n: Vector2 = wd["n"]
	var q := o + dir * s
	for d in doors:
		var dp: Vector2 = d["a"]
		var rel := dp - q
		if absf(rel.dot(n)) < 0.4 and absf(rel.dot(dir)) < half + float(d.get("w", DOOR_W)) * 0.5 + 0.15:
			return true
	if bool(wd["ext"]) and n.y > 0.5:
		if absf(q.x - _door_u) < half + 1.0:
			return true
	return false


## Polígono (s = ao longo, v = altura) desenhado rente à parede.
func _wall_poly(wd: Dictionary, pts: PackedVector2Array, y_off: float, code: float, col: Color, off: float = 0.006) -> void:
	var o: Vector2 = wd["o"]
	var dir: Vector2 = wd["dir"]
	var n2: Vector2 = wd["n"]
	var n := fr.d3(n2.x, n2.y).normalized()
	var tris := Geometry2D.triangulate_polygon(pts)
	if tris.is_empty():
		return
	var w3: Array = []
	for p in pts:
		var q := o + dir * p.x + n2 * off
		w3.append(fr.p(q.x, q.y, y_off + p.y))
	for t in range(0, tris.size(), 3):
		var i0 := tris[t]
		var i1 := tris[t + 1]
		var i2 := tris[t + 2]
		mesh.tri(w3[i0], w3[i1], w3[i2], n, pts[i0], pts[i1], pts[i2], code, 0.53, col)


func _wall_streak(wd: Dictionary, s: float, y_off: float, doors: Array) -> void:
	var w := rng.randf_range(0.25, 1.0)
	if _wall_has_door(wd, s, w * 0.5, doors):
		return
	var top := fh - 0.03
	var ln := rng.randf_range(0.5, 1.5)
	var mold := rng.randf() < 0.35
	# duas camadas: auréola clara e miolo mais escuro e curto (infiltração escorrendo)
	for layer in 2:
		var ww := w * (1.0 if layer == 0 else 0.6)
		var ll := ln * (1.0 if layer == 0 else 0.62)
		var pts := PackedVector2Array()
		var nn := 9
		pts.append(Vector2(s - ww * 0.5, top))
		pts.append(Vector2(s + ww * 0.5, top))
		for i in nn:
			var f := 1.0 - float(i) / float(nn - 1)
			var drip := rng.randf_range(0.35, 1.0) * (1.0 - 0.5 * absf(f - 0.5))
			pts.append(Vector2(s - ww * 0.5 + ww * f, top - ll * drip))
		var col := Color(0.86, 0.82, 0.72) if layer == 0 else Color(0.7, 0.64, 0.52)
		if mold:
			col = Color(0.82, 0.84, 0.76) if layer == 0 else Color(0.62, 0.66, 0.56)
		_wall_poly(wd, pts, y_off, Assets.uv2_code(Assets.L_PLASTER), col, 0.006 + layer * 0.0008)


func _wall_crack(wd: Dictionary, s: float, y_off: float, doors: Array) -> void:
	if _wall_has_door(wd, s, 0.6, doors):
		return
	var p := Vector2(s, rng.randf_range(0.6, fh - 0.4))
	var ang := rng.randf_range(-PI, PI)
	for i in rng.randi_range(4, 8):
		ang += rng.randf_range(-0.7, 0.7)
		var q := p + Vector2(cos(ang), sin(ang)) * rng.randf_range(0.08, 0.22)
		q.y = clampf(q.y, 0.1, fh - 0.1)
		var nrm := (q - p).orthogonal().normalized() * rng.randf_range(0.004, 0.009)
		_wall_poly(wd, PackedVector2Array([p - nrm, q - nrm * 0.6, q + nrm * 0.6, p + nrm]), y_off, Assets.uv2_code(Assets.L_PLASTER), Color(0.22, 0.2, 0.18), 0.007)
		p = q


func _wall_brick(wd: Dictionary, s: float, y_off: float, doors: Array) -> void:
	var w := rng.randf_range(0.3, 0.8)
	if _wall_has_door(wd, s, w * 0.5 + 0.1, doors):
		return
	var cy := rng.randf_range(0.5, fh - 0.6)
	var h := rng.randf_range(0.25, 0.55)
	var pts := PackedVector2Array()
	var nn := 10
	for i in nn:
		var a := TAU * float(i) / float(nn)
		pts.append(Vector2(s + cos(a) * w * 0.5 * rng.randf_range(0.7, 1.0), cy + sin(a) * h * 0.5 * rng.randf_range(0.7, 1.0)))
	var rim := PackedVector2Array()
	for p in pts:
		rim.append(Vector2(s, cy) + (p - Vector2(s, cy)) * 1.12)
	_wall_poly(wd, rim, y_off, Assets.uv2_code(Assets.L_PLASTER), Color(0.62, 0.6, 0.56), 0.005)
	_wall_poly(wd, pts, y_off, Assets.uv2_code(Assets.L_BRICK), Color(0.8, 0.75, 0.72), 0.0065)


func _wall_blood(wd: Dictionary, s: float, y_off: float, doors: Array) -> void:
	if _wall_has_door(wd, s, 0.4, doors):
		return
	var cy := rng.randf_range(0.7, 1.5)
	# marca de mão arrastada: faixas verticais escorrendo
	for i in rng.randi_range(2, 4):
		var x := s + i * 0.045 + rng.randf_range(-0.01, 0.01)
		var ln := rng.randf_range(0.2, 0.6)
		_wall_poly(wd, PackedVector2Array([Vector2(x - 0.018, cy + 0.08), Vector2(x + 0.018, cy + 0.08), Vector2(x + 0.01, cy - ln), Vector2(x - 0.008, cy - ln + 0.03)]),
			y_off, Assets.uv2_code(Assets.L_PLASTER), Color(0.35, 0.05, 0.04), 0.0068)


func _graffiti(wd: Dictionary, s: float, y_off: float, doors: Array) -> void:
	if _wall_has_door(wd, s, 0.8, doors):
		return
	_graffiti_n += 1
	var o: Vector2 = wd["o"]
	var dir: Vector2 = wd["dir"]
	var n2: Vector2 = wd["n"]
	var q := o + dir * s + n2 * 0.012
	var cols := [Color(0.62, 0.07, 0.05), Color(0.07, 0.07, 0.08), Color(0.85, 0.85, 0.82), Color(0.1, 0.25, 0.55)]
	var text: String = GRAFFITI[rng.randi() % GRAFFITI.size()]
	var size := rng.randf_range(0.2, 0.34) * (1.6 if text.length() <= 2 else 1.0)
	out["labels"].append({"xf": Transform3D(Basis(Vector3.UP, fr.yaw_for(n2.x, n2.y)) * Basis(Vector3.BACK, rng.randf_range(-0.09, 0.09)),
		fr.p(q.x, q.y, y_off + rng.randf_range(1.2, 1.8))), "text": text, "size": size, "color": (cols[rng.randi() % cols.size()] as Color) * Color(1, 1, 1, 0.82)})


func _ceiling_collapse(rr: Rect2, y_off: float, floor_code: float) -> void:
	var PLA := Assets.uv2_code(Assets.L_PLASTER)
	var WOOD := Assets.uv2_code(Assets.L_WOOD)
	var q := _rand_in(rr, 1.0)
	var cy := y_off + fh - 0.018
	var r := rng.randf_range(0.45, 0.9)
	# buraco escuro no forro (borda quebrada mais clara)
	for ring in 2:
		var sc := 1.0 if ring == 0 else 0.82
		var cc := Color(0.45, 0.43, 0.4) if ring == 0 else Color(0.06, 0.055, 0.05)
		var yy := cy - ring * 0.002
		var cen := fr.p(q.x, q.y, yy - y_off)
		cen.y = yy
		var pts: Array = []
		for i in 12:
			var a := TAU * float(i) / 12.0
			var rr2 := r * sc * rng.randf_range(0.65, 1.0)
			var w := fr.p(q.x + cos(a) * rr2, q.y + sin(a) * rr2 * 0.8, 0.0)
			w.y = yy
			pts.append(w)
		for i in 12:
			var p0: Vector3 = pts[i]
			var p1: Vector3 = pts[(i + 1) % 12]
			mesh.tri(cen, p0, p1, Vector3.DOWN, Vector2(cen.x, cen.z), Vector2(p0.x, p0.z), Vector2(p1.x, p1.z), PLA, 0.0, cc)
	# ripas do forro à mostra
	for i in 2:
		var off := (float(i) - 0.5) * r * 0.7
		var a0 := fr.p(q.x - r * 0.75, q.y + off, 0.0)
		var a1 := fr.p(q.x + r * 0.75, q.y + off, 0.0)
		a0.y = cy - 0.035
		a1.y = cy - 0.035
		mesh.tube(a0, a1, 0.025, 0.025, 4, WOOD, 0.0, Color(0.5, 0.4, 0.3))
	# placa pendurada e fios
	var hang := fr.p(q.x + r * 0.6, q.y, 0.0)
	hang.y = cy - 0.3
	mesh.box_xf(Transform3D(Basis(fr.d3(1, 0).normalized(), rng.randf_range(0.9, 1.2)), hang), Vector3(0.6, 0.012, 0.5), PLA, 0.2, Color(0.88, 0.87, 0.84))
	for i in 2:
		var top := fr.p(q.x + rng.randf_range(-0.3, 0.3), q.y + rng.randf_range(-0.3, 0.3), 0.0)
		top.y = cy
		mesh.tube(top, top + Vector3(rng.randf_range(-0.1, 0.1), -rng.randf_range(0.5, 1.1), rng.randf_range(-0.1, 0.1)), 0.004, 0.004, 4,
			Assets.uv2_code(Assets.L_METAL), 0.0, Color(0.1, 0.1, 0.1))
	# placas e pó no chão embaixo
	_stain(fr.p(q.x, q.y, 0.021 + y_off), r * 1.3, floor_code, Color(1.25, 1.22, 1.15))
	for i in rng.randi_range(3, 6):
		var o := fr.p(q.x + rng.randf_range(-r, r), q.y + rng.randf_range(-r, r), y_off + 0.03)
		mesh.box_xf(Transform3D(Basis.from_euler(Vector3(rng.randf_range(-0.25, 0.25), rng.randf() * TAU, rng.randf_range(-0.25, 0.25))), o),
			Vector3(rng.randf_range(0.2, 0.6), 0.014, rng.randf_range(0.2, 0.5)), PLA, rng.randf(), Color(0.9, 0.89, 0.86))
	for i in rng.randi_range(4, 9):
		var o := fr.p(q.x + rng.randf_range(-r, r), q.y + rng.randf_range(-r, r), y_off + 0.03)
		var sz := rng.randf_range(0.03, 0.1)
		mesh.box_xf(Transform3D(Basis.from_euler(Vector3(rng.randf(), rng.randf() * TAU, rng.randf())), o), Vector3(sz, sz * 0.6, sz * 0.8), PLA, rng.randf(), Color(0.85, 0.84, 0.8))


func _survivor_nest(rr: Rect2, y_off: float) -> void:
	var q := _free_floor_spot(rr, 1.2)
	if q.x == INF:
		return
	var FAB := Assets.uv2_code(Assets.L_FABRIC)
	var MET := Assets.uv2_code(Assets.L_METAL)
	var yaw := fr.yaw_for(0, 1) + (PI * 0.5 if rng.randf() < 0.5 else 0.0)
	var bs := Basis(Vector3.UP, yaw)
	var c := fr.p(q.x, q.y, y_off)
	mesh.box_xf(Transform3D(bs, c + Vector3(0, 0.08, 0)), Vector3(0.9, 0.15, 1.9), FAB, 0.3, Color(0.75, 0.72, 0.62))
	mesh.box_xf(Transform3D(bs * Basis(Vector3.UP, 0.1), c + Vector3(0, 0.17, 0) + bs * Vector3(0.05, 0, 0.25)), Vector3(0.85, 0.04, 1.1), FAB, 0.6, Color(0.35, 0.25, 0.4))
	mesh.box_xf(Transform3D(bs, c + Vector3(0, 0.2, 0) + bs * Vector3(0, 0, -0.75)), Vector3(0.5, 0.1, 0.3), FAB, 0.1, Color(0.9, 0.9, 0.86))
	for i in rng.randi_range(3, 6):
		var lp := Vector3(rng.randf_range(0.6, 0.95), 0.0, rng.randf_range(-0.8, 0.8))
		var wp := c + bs * lp + Vector3(0, 0.017, 0)
		if rng.randf() < 0.6:
			mesh.cylinder(Transform3D(Basis.IDENTITY, wp), 0.037, 0.11, 8, MET, rng.randf(), Color.from_hsv(rng.randf(), 0.5, 0.7))
		else:
			_trash_piece(wp)
	# vela derretida num pires
	var cw := c + bs * Vector3(0.7, 0, -0.95) + Vector3(0, 0.017, 0)
	mesh.cylinder(Transform3D(Basis.IDENTITY, cw), 0.07, 0.01, 10, Assets.uv2_code(Assets.L_TILES), 0.0, Color(0.9, 0.9, 0.88))
	mesh.cylinder(Transform3D(Basis.IDENTITY, cw + Vector3(0, 0.01, 0)), 0.02, 0.06, 8, Assets.uv2_code(Assets.L_PLASTER), 0.0, Color(0.95, 0.92, 0.8))


# ---------------------------------------------------------------------------
# Objetos de cena em cima dos móveis (não coletáveis): louça, micro-ondas,
# abajures, canecas, livros, caixa registradora, vasos…
# ---------------------------------------------------------------------------
func _surface_decor(sd: Dictionary, tp: String) -> void:
	var MET := Assets.uv2_code(Assets.L_METAL)
	var TIL := Assets.uv2_code(Assets.L_TILES)
	var PLA := Assets.uv2_code(Assets.L_PLASTER)
	var FAB := Assets.uv2_code(Assets.L_FABRIC)
	var WOOD := Assets.uv2_code(Assets.L_WOOD)
	var xf: Transform3D = sd["xf"]
	var ext: Vector2 = sd["ext"]
	var h: float = sd["h"]
	var pn: String = sd["prop"]
	var spot := func(fx: float, fz: float) -> Vector3:
		return xf * Vector3(ext.x * fx, h, float(sd["zoff"]) + ext.y * fz)
	var bs := xf.basis
	var white := Color(0.93, 0.93, 0.9)
	var knocked := ruined and rng.randf() < 0.35
	match pn:
		"kitchen_counter":
			var p0: Vector3 = spot.call(-0.6, 0.2)
			mesh.box_xf(Transform3D(bs, p0 + Vector3(0, 0.15, 0)), Vector3(0.5, 0.3, 0.36), MET, 0.1, white)
			mesh.box_xf(Transform3D(bs, p0 + Vector3(0, 0.15, 0) + bs * Vector3(-0.06, 0, -0.181)), Vector3(0.32, 0.2, 0.004), TIL, 0.0, Color(0.08, 0.08, 0.09))
			var p1: Vector3 = spot.call(0.35, -0.1)
			if knocked:
				mesh.cylinder(Transform3D(bs * Basis(Vector3.BACK, PI * 0.5), p1 + Vector3(0, 0.1, 0)), 0.1, 0.13, 10, MET, 0.0, Color(0.5, 0.5, 0.52))
			else:
				mesh.cylinder(Transform3D(bs, p1), 0.11, 0.13, 12, MET, 0.0, Color(0.5, 0.5, 0.52))
				mesh.cylinder(Transform3D(bs, p1 + Vector3(0, 0.13, 0)), 0.115, 0.012, 12, MET, 0.0, Color(0.35, 0.35, 0.36))
			var p2: Vector3 = spot.call(0.85, 0.1)
			for i in rng.randi_range(2, 5):
				mesh.cylinder(Transform3D(bs, p2 + Vector3(0, i * 0.014, 0)), 0.11, 0.012, 14, TIL, 0.0, white)
		"desk", "school_desk":
			var p0: Vector3 = spot.call(rng.randf_range(-0.7, 0.7), rng.randf_range(-0.5, 0.4))
			for i in rng.randi_range(1, 4):
				mesh.box_xf(Transform3D(bs * Basis(Vector3.UP, rng.randf_range(-0.3, 0.3)), p0 + Vector3(0, 0.002 + i * 0.003, 0)), Vector3(0.21, 0.002, 0.297), PLA, rng.randf(), Color(0.96, 0.95, 0.9))
			var p1: Vector3 = spot.call(rng.randf_range(-0.8, 0.8), rng.randf_range(-0.6, 0.6))
			if knocked:
				mesh.cylinder(Transform3D(bs * Basis(Vector3.BACK, PI * 0.5), p1 + Vector3(0, 0.04, 0)), 0.04, 0.1, 10, TIL, 0.0, Color.from_hsv(rng.randf(), 0.4, 0.8))
			else:
				mesh.cylinder(Transform3D(bs, p1), 0.04, 0.1, 10, TIL, 0.0, Color.from_hsv(rng.randf(), 0.4, 0.8))
			if pn == "desk" and rng.randf() < 0.6:
				var p2: Vector3 = spot.call(0.8, 0.5)
				mesh.cylinder(Transform3D(bs, p2), 0.08, 0.02, 10, MET, 0.0, Color(0.15, 0.15, 0.16))
				mesh.tube(p2 + Vector3(0, 0.02, 0), p2 + Vector3(0, 0.34, 0) + bs * Vector3(0, 0, -0.08), 0.01, 0.01, 5, MET, 0.0, Color(0.15, 0.15, 0.16))
				mesh.cylinder(Transform3D(bs, p2 + Vector3(0, 0.3, 0) + bs * Vector3(0, 0, -0.1)), 0.1, 0.1, 10, MET, 0.0, Color(0.2, 0.35, 0.25), false, 0.05)
		"nightstand":
			var p0: Vector3 = spot.call(0.0, 0.0)
			if knocked:
				mesh.cylinder(Transform3D(bs * Basis(Vector3.BACK, PI * 0.5), p0 + Vector3(0, 0.07, 0)), 0.06, 0.28, 10, FAB, 0.2, Color(0.9, 0.85, 0.7))
			else:
				mesh.cylinder(Transform3D(bs, p0), 0.06, 0.2, 10, TIL, 0.0, Color(0.7, 0.55, 0.4))
				mesh.cylinder(Transform3D(bs, p0 + Vector3(0, 0.2, 0)), 0.14, 0.16, 12, FAB, 0.2, Color(0.9, 0.85, 0.7), false, 0.09)
		"table", "table_small":
			for i in rng.randi_range(1, 3):
				var pp: Vector3 = spot.call(rng.randf_range(-0.7, 0.7), rng.randf_range(-0.6, 0.6))
				if rng.randf() < 0.55:
					mesh.cylinder(Transform3D(bs, pp), 0.11, 0.012, 14, TIL, 0.0, white)
				elif knocked:
					mesh.cylinder(Transform3D(bs * Basis(Vector3.BACK, PI * 0.5), pp + Vector3(0, 0.035, 0)), 0.035, 0.09, 10, TIL, 0.0, Color(0.8, 0.85, 0.88))
				else:
					mesh.cylinder(Transform3D(bs, pp), 0.035, 0.09, 10, TIL, 0.0, Color(0.8, 0.85, 0.88))
			if rng.randf() < 0.35:
				var pv: Vector3 = spot.call(0.0, 0.0)
				mesh.cylinder(Transform3D(bs, pv), 0.07, 0.22, 10, TIL, 0.0, Color.from_hsv(rng.randf(), 0.35, 0.6), true, 0.05)
				for k in 5:
					var a := TAU * k / 5.0
					mesh.tube(pv + Vector3(0, 0.2, 0), pv + Vector3(cos(a) * 0.1, 0.42 + rng.randf() * 0.1, sin(a) * 0.1), 0.004, 0.003, 4,
						Assets.uv2_code(Assets.L_BARK), 0.0, Color(0.45, 0.35, 0.22))
		"counter", "checkout":
			var p0: Vector3 = spot.call(0.5, 0.0)
			mesh.box_xf(Transform3D(bs, p0 + Vector3(0, 0.08, 0)), Vector3(0.4, 0.16, 0.38), MET, 0.0, Color(0.2, 0.2, 0.22))
			mesh.box_xf(Transform3D(bs * Basis(Vector3.RIGHT, -0.5), p0 + Vector3(0, 0.22, 0) + bs * Vector3(0, 0, 0.1)), Vector3(0.3, 0.16, 0.02), MET, 0.0, Color(0.15, 0.15, 0.16))
			if tp == "bar":
				for i in rng.randi_range(2, 5):
					var pb: Vector3 = spot.call(rng.randf_range(-0.9, 0.1), rng.randf_range(-0.5, 0.5))
					mesh.cylinder(Transform3D(bs, pb), 0.035, 0.28, 8, TIL, 0.0, Color(0.3, 0.45, 0.25) if rng.randf() < 0.5 else Color(0.5, 0.33, 0.15))
		"workbench":
			var p0: Vector3 = spot.call(-0.4, 0.2)
			mesh.box_xf(Transform3D(bs * Basis(Vector3.UP, 0.2), p0 + Vector3(0, 0.08, 0)), Vector3(0.42, 0.16, 0.2), MET, 0.0, Color(0.7, 0.15, 0.1))
			var p1: Vector3 = spot.call(0.5, -0.2)
			for i in 2:
				mesh.cylinder(Transform3D(bs, p1 + bs * Vector3(i * 0.14, 0, 0)), 0.06, 0.16, 10, MET, 0.0, Color.from_hsv(rng.randf(), 0.5, 0.6))
			mesh.box_xf(Transform3D(bs * Basis(Vector3.UP, 0.7), spot.call(0.1, -0.4) + Vector3(0, 0.01, 0)), Vector3(0.3, 0.02, 0.22), FAB, 0.4, Color(0.4, 0.35, 0.3))
		"cabinet_low", "tv_stand":
			var p0: Vector3 = spot.call(rng.randf_range(-0.6, 0.6), 0.0)
			if rng.randf() < 0.5:
				for i in rng.randi_range(2, 5):
					mesh.box_xf(Transform3D(bs * Basis(Vector3.BACK, 0.0 if not knocked else PI * 0.5), p0 + bs * Vector3(i * 0.04, 0.11, 0)),
						Vector3(0.03, 0.22, 0.16), FAB, rng.randf(), Color.from_hsv(rng.randf(), 0.4, 0.55))
			else:
				mesh.box_xf(Transform3D(bs * Basis(Vector3.RIGHT, -0.2 if not knocked else -PI * 0.5), p0 + Vector3(0, 0.1, 0)), Vector3(0.18, 0.22, 0.015), WOOD, 0.0, Color(0.4, 0.3, 0.22))
		"bed", "bed_single":
			if ruined:
				mesh.box_xf(Transform3D(bs * Basis(Vector3.UP, rng.randf_range(-0.8, 0.8)), spot.call(rng.randf_range(-0.6, 0.6), rng.randf_range(-0.2, 0.8)) + Vector3(0, 0.03, 0)),
					Vector3(0.45, 0.05, 0.4), FAB, rng.randf(), Color.from_hsv(rng.randf(), 0.3, 0.6))
