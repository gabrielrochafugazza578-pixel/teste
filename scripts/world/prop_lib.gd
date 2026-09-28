class_name PropLib
extends RefCounted
## Biblioteca de props modulares (móveis, mobiliário urbano, barricadas…).
##
## Cada prop é gerado uma vez (MeshBuf em coordenadas locais: origem no chão,
## frente para -Z) e reutilizado: interiores mesclam cópias numa única malha;
## ruas usam MultiMesh (instancing) com tinta por instância.

static var _bufs: Dictionary = {}
static var _meshes: Dictionary = {}
static var _sizes: Dictionary = {}
static var _warm: bool = false

const NAMES := ["bed", "bed_single", "bunk", "hospital_bed", "sofa", "armchair", "table", "table_small", "chair",
	"wardrobe", "cabinet_low", "nightstand", "kitchen_counter", "fridge", "stove", "toilet", "sink_bath", "bathtub",
	"shelf", "tv_stand", "desk", "computer", "locker", "filing_cabinet", "med_cart", "curtain", "checkout", "gondola",
	"freezer", "workbench", "tool_cabinet", "car_lift", "tires", "barrel", "crate", "pallet", "rack", "pew", "altar",
	"blackboard", "school_desk", "lab_bench", "fume_hood", "server_rack", "lab_equipment", "counter",
	"lamp_post", "traffic_light", "bench", "trash_bin", "dumpster", "hydrant", "bus_stop", "sign_post", "mailbox",
	"planter", "fence_wood", "fence_metal", "wall_low", "sandbags", "barricade_wood", "concrete_barrier", "tent",
	"campfire", "hay_bale", "gas_pump", "water_tank", "ac_unit", "antenna", "container", "forklift", "debris_pile",
	"trash_bags", "cardboard", "radio_tower", "floodlight", "power_pole", "billboard", "log", "crib", "rug",
	"generator", "radio_set", "bookshelf", "stair_ramp", "tarp_shelter", "fence_chain_post", "gate_bar", "washing_machine"]


static func warm() -> void:
	if _warm:
		return
	for n in NAMES:
		buf(n)
	_warm = true


static func buf(name: String) -> MeshBuf:
	if _bufs.has(name):
		return _bufs[name]
	var b := MeshBuf.new()
	_build(name, b)
	_bufs[name] = b
	return b


static func mesh(name: String) -> ArrayMesh:
	if _meshes.has(name):
		return _meshes[name]
	var m := buf(name).to_mesh(Assets.world_material("props"))
	_meshes[name] = m
	return m


## Tamanho aproximado (para colisão). Vector3.ZERO = sem colisão.
static func collision_size(name: String) -> Vector3:
	match name:
		"bed": return Vector3(1.5, 0.6, 2.05)
		"bed_single", "hospital_bed": return Vector3(0.95, 0.6, 2.05)
		"bunk": return Vector3(0.95, 1.7, 2.05)
		"sofa": return Vector3(2.0, 0.85, 0.9)
		"armchair": return Vector3(0.9, 0.85, 0.85)
		"table": return Vector3(1.4, 0.78, 0.85)
		"table_small": return Vector3(0.8, 0.78, 0.8)
		"wardrobe": return Vector3(1.2, 2.0, 0.6)
		"cabinet_low", "kitchen_counter", "counter": return Vector3(2.4 if name != "cabinet_low" else 1.0, 0.92, 0.62)
		"fridge": return Vector3(0.72, 1.8, 0.72)
		"stove", "washing_machine": return Vector3(0.62, 0.92, 0.62)
		"bathtub": return Vector3(0.8, 0.6, 1.7)
		"shelf", "bookshelf": return Vector3(1.0, 1.95, 0.42)
		"desk": return Vector3(1.4, 0.78, 0.72)
		"locker": return Vector3(1.5, 1.9, 0.5)
		"filing_cabinet": return Vector3(0.5, 1.3, 0.62)
		"checkout": return Vector3(1.8, 0.92, 0.75)
		"gondola": return Vector3(2.4, 1.65, 0.95)
		"freezer": return Vector3(2.0, 0.92, 0.85)
		"workbench", "lab_bench": return Vector3(2.0 if name == "workbench" else 3.0, 0.95, 0.82)
		"tool_cabinet": return Vector3(0.8, 1.05, 0.5)
		"rack": return Vector3(2.7, 3.0, 1.0)
		"pew": return Vector3(3.0, 0.9, 0.55)
		"altar": return Vector3(2.0, 1.0, 0.9)
		"fume_hood": return Vector3(1.5, 2.3, 0.9)
		"server_rack": return Vector3(0.62, 2.0, 1.0)
		"dumpster": return Vector3(1.9, 1.35, 1.15)
		"bus_stop": return Vector3(3.2, 2.6, 0.2)
		"wall_low": return Vector3(2.0, 1.8, 0.2)
		"fence_wood": return Vector3(2.0, 1.2, 0.12)
		"fence_metal": return Vector3(2.0, 1.6, 0.08)
		"sandbags": return Vector3(2.0, 0.95, 0.7)
		"barricade_wood": return Vector3(2.4, 1.6, 0.35)
		"concrete_barrier": return Vector3(2.0, 0.85, 0.6)
		"container": return Vector3(6.0, 2.6, 2.44)
		"forklift": return Vector3(1.2, 2.2, 2.4)
		"hay_bale": return Vector3(1.2, 0.9, 0.9)
		"gas_pump": return Vector3(0.9, 1.9, 0.6)
		"crate": return Vector3(0.82, 0.82, 0.82)
		"barrel": return Vector3(0.62, 0.92, 0.62)
		"generator": return Vector3(1.2, 0.9, 0.7)
		"tent": return Vector3(2.2, 1.3, 2.4)
	return Vector3.ZERO


static func _c(layer: int) -> float:
	return Assets.uv2_code(layer, 0)


static func _legs(b: MeshBuf, w: float, d: float, h: float, t: float, code: float, col: Color, inset: float = 0.05) -> void:
	for sx: float in [-1.0, 1.0]:
		for sz: float in [-1.0, 1.0]:
			b.box(Vector3(sx * (w * 0.5 - inset - t * 0.5), h * 0.5, sz * (d * 0.5 - inset - t * 0.5)), Vector3(t, h, t), code, 0.0, col)


static func _build(name: String, b: MeshBuf) -> void:
	var WOOD := _c(Assets.L_WOOD)
	var FAB := _c(Assets.L_FABRIC)
	var MET := _c(Assets.L_METAL)
	var CON := _c(Assets.L_CONCRETE)
	var TIL := _c(Assets.L_TILES)
	var PLA := _c(Assets.L_PLASTER)
	var LIN := _c(Assets.L_LINOLEUM)
	var PAN := _c(Assets.L_PANELS)
	var dark_wood := Color(0.55, 0.42, 0.32)
	var white := Color(0.95, 0.95, 0.93)
	var steel := Color(0.72, 0.74, 0.76)
	var black := Color(0.12, 0.12, 0.13)
	match name:
		"bed", "bed_single":
			var w := 1.45 if name == "bed" else 0.92
			b.box(Vector3(0, 0.2, 0), Vector3(w, 0.22, 2.0), WOOD, 0.1, dark_wood)
			_legs(b, w, 2.0, 0.1, 0.07, WOOD, dark_wood, 0.0)
			b.box(Vector3(0, 0.4, 0.02), Vector3(w - 0.06, 0.18, 1.94), FAB, 0.2, Color(0.9, 0.88, 0.84))
			b.box(Vector3(0, 0.5, 0.25), Vector3(w - 0.02, 0.05, 1.5), FAB, 0.3, Color(0.35, 0.42, 0.55))
			b.box(Vector3(0, 0.54, -0.75), Vector3(w * 0.7, 0.1, 0.35), FAB, 0.4, white)
			b.box(Vector3(0, 0.55, -1.0), Vector3(w, 0.7, 0.06), WOOD, 0.1, dark_wood)
		"bunk":
			for y: float in [0.0, 1.05]:
				b.box(Vector3(0, 0.3 + y, 0), Vector3(0.92, 0.08, 2.0), MET, 0.0, Color(0.35, 0.4, 0.35))
				b.box(Vector3(0, 0.4 + y, 0), Vector3(0.88, 0.12, 1.94), FAB, 0.2, Color(0.5, 0.52, 0.42))
			for sx: float in [-0.44, 0.44]:
				for sz: float in [-0.97, 0.97]:
					b.box(Vector3(sx, 0.85, sz), Vector3(0.05, 1.7, 0.05), MET, 0.0, Color(0.35, 0.4, 0.35))
		"hospital_bed":
			b.box(Vector3(0, 0.55, 0), Vector3(0.9, 0.08, 2.0), MET, 0.0, steel)
			_legs(b, 0.9, 2.0, 0.55, 0.04, MET, steel, 0.02)
			b.box(Vector3(0, 0.66, 0.2), Vector3(0.86, 0.14, 1.5), FAB, 0.2, Color(0.85, 0.9, 0.9))
			b.box_xf(Transform3D(Basis(Vector3.RIGHT, 0.45), Vector3(0, 0.82, -0.72)), Vector3(0.86, 0.12, 0.6), FAB, 0.2, Color(0.85, 0.9, 0.9))
			b.box(Vector3(0, 0.8, -1.0), Vector3(0.9, 0.5, 0.04), MET, 0.0, steel)
			for sx: float in [-0.47, 0.47]:
				b.box(Vector3(sx, 0.78, 0.1), Vector3(0.03, 0.2, 1.2), MET, 0.0, steel)
		"sofa":
			b.box(Vector3(0, 0.22, 0), Vector3(2.0, 0.3, 0.85), FAB, 0.5, Color(0.45, 0.38, 0.34))
			b.box(Vector3(0, 0.42, 0.05), Vector3(1.7, 0.14, 0.72), FAB, 0.5, Color(0.5, 0.42, 0.37))
			b.box(Vector3(0, 0.6, 0.36), Vector3(2.0, 0.55, 0.16), FAB, 0.5, Color(0.45, 0.38, 0.34))
			for sx: float in [-0.92, 0.92]:
				b.box(Vector3(sx, 0.45, 0), Vector3(0.18, 0.4, 0.85), FAB, 0.5, Color(0.42, 0.36, 0.32))
		"armchair":
			b.box(Vector3(0, 0.22, 0), Vector3(0.85, 0.3, 0.8), FAB, 0.6, Color(0.55, 0.3, 0.25))
			b.box(Vector3(0, 0.62, 0.33), Vector3(0.85, 0.55, 0.15), FAB, 0.6, Color(0.55, 0.3, 0.25))
			for sx: float in [-0.36, 0.36]:
				b.box(Vector3(sx, 0.45, 0), Vector3(0.14, 0.35, 0.8), FAB, 0.6, Color(0.5, 0.28, 0.23))
		"table", "table_small":
			var w := 1.4 if name == "table" else 0.8
			var d := 0.82 if name == "table" else 0.8
			b.box(Vector3(0, 0.74, 0), Vector3(w, 0.05, d), WOOD, 0.3, Color(0.62, 0.48, 0.34))
			_legs(b, w, d, 0.72, 0.05, WOOD, dark_wood)
		"chair":
			b.box(Vector3(0, 0.45, 0), Vector3(0.44, 0.05, 0.44), WOOD, 0.2, dark_wood)
			_legs(b, 0.44, 0.44, 0.45, 0.035, WOOD, dark_wood, 0.01)
			b.box(Vector3(0, 0.72, 0.2), Vector3(0.44, 0.5, 0.04), WOOD, 0.2, dark_wood)
		"wardrobe":
			b.box(Vector3(0, 1.0, 0), Vector3(1.2, 2.0, 0.6), WOOD, 0.4, Color(0.6, 0.46, 0.33))
			b.box(Vector3(0, 1.0, -0.305), Vector3(0.02, 1.9, 0.01), WOOD, 0.4, Color(0.3, 0.22, 0.15))
			for sx: float in [-0.08, 0.08]:
				b.box(Vector3(sx, 1.0, -0.32), Vector3(0.03, 0.12, 0.03), MET, 0.0, steel)
		"cabinet_low", "nightstand":
			var w := 1.0 if name == "cabinet_low" else 0.45
			var h := 0.9 if name == "cabinet_low" else 0.55
			b.box(Vector3(0, h * 0.5, 0), Vector3(w, h, 0.45), WOOD, 0.3, Color(0.65, 0.5, 0.36))
			b.box(Vector3(0, h * 0.72, -0.23), Vector3(w * 0.9, 0.02, 0.01), WOOD, 0.3, Color(0.3, 0.22, 0.15))
		"kitchen_counter", "counter":
			var col := Color(0.85, 0.83, 0.78) if name == "kitchen_counter" else Color(0.55, 0.42, 0.32)
			b.box(Vector3(0, 0.44, 0), Vector3(2.4, 0.88, 0.6), WOOD if name == "counter" else PLA, 0.3, col)
			b.box(Vector3(0, 0.9, 0), Vector3(2.44, 0.04, 0.64), CON if name == "kitchen_counter" else WOOD, 0.1, Color(0.4, 0.38, 0.36) if name == "kitchen_counter" else dark_wood)
			if name == "kitchen_counter":
				b.box(Vector3(0.5, 0.905, 0), Vector3(0.5, 0.02, 0.4), MET, 0.0, steel)
				for i in 4:
					b.box(Vector3(-1.2 + 0.3 + i * 0.6, 0.6, -0.305), Vector3(0.55, 0.5, 0.01), PLA, 0.3, Color(0.75, 0.73, 0.68))
		"fridge":
			b.box(Vector3(0, 0.9, 0), Vector3(0.7, 1.8, 0.7), MET, 0.1, white)
			b.box(Vector3(0, 1.25, -0.355), Vector3(0.68, 0.01, 0.01), MET, 0.1, Color(0.5, 0.5, 0.5))
			b.box(Vector3(0.28, 1.0, -0.37), Vector3(0.03, 0.4, 0.03), MET, 0.0, steel)
		"stove", "washing_machine":
			b.box(Vector3(0, 0.45, 0), Vector3(0.6, 0.9, 0.6), MET, 0.2, white)
			if name == "stove":
				for p in [Vector2(-0.14, -0.12), Vector2(0.14, -0.12), Vector2(-0.14, 0.14), Vector2(0.14, 0.14)]:
					b.cylinder(Transform3D(Basis.IDENTITY, Vector3(p.x, 0.9, p.y)), 0.08, 0.02, 8, MET, 0.0, black)
				b.box(Vector3(0, 0.45, -0.305), Vector3(0.5, 0.4, 0.01), MET, 0.0, Color(0.15, 0.15, 0.16))
			else:
				b.cylinder(Transform3D(Basis(Vector3.RIGHT, PI * 0.5), Vector3(0, 0.5, -0.3)), 0.2, 0.02, 12, MET, 0.0, Color(0.3, 0.33, 0.36))
		"toilet":
			b.box(Vector3(0, 0.2, 0.05), Vector3(0.38, 0.4, 0.55), TIL, 0.0, white)
			b.box(Vector3(0, 0.62, 0.3), Vector3(0.4, 0.45, 0.18), TIL, 0.0, white)
		"sink_bath":
			b.box(Vector3(0, 0.4, 0.05), Vector3(0.16, 0.8, 0.16), TIL, 0.0, white)
			b.box(Vector3(0, 0.84, 0), Vector3(0.55, 0.12, 0.42), TIL, 0.0, white)
		"bathtub":
			b.box(Vector3(0, 0.28, 0), Vector3(0.8, 0.56, 1.7), TIL, 0.0, white)
			b.box(Vector3(0, 0.565, 0), Vector3(0.62, 0.02, 1.5), TIL, 0.0, Color(0.7, 0.72, 0.72))
		"shelf", "bookshelf":
			var col := Color(0.62, 0.64, 0.66) if name == "shelf" else Color(0.55, 0.4, 0.28)
			var code := MET if name == "shelf" else WOOD
			for sx: float in [-0.48, 0.48]:
				b.box(Vector3(sx, 0.95, 0), Vector3(0.04, 1.9, 0.4), code, 0.0, col)
			for i in 5:
				b.box(Vector3(0, 0.05 + i * 0.45, 0), Vector3(0.96, 0.03, 0.4), code, 0.0, col)
			var r := RandomNumberGenerator.new()
			r.seed = hash(name)
			for i in 4:
				var x := -0.4
				while x < 0.4:
					var w := r.randf_range(0.06, 0.16)
					var h := r.randf_range(0.15, 0.35)
					var c := Color.from_hsv(r.randf(), r.randf_range(0.2, 0.6), r.randf_range(0.35, 0.8))
					b.box(Vector3(x + w * 0.5, 0.07 + i * 0.45 + h * 0.5, 0.0), Vector3(w * 0.95, h, 0.28), PLA if name == "shelf" else FAB, r.randf(), c)
					x += w + r.randf_range(0.0, 0.06)
		"tv_stand":
			b.box(Vector3(0, 0.25, 0), Vector3(1.4, 0.5, 0.45), WOOD, 0.2, dark_wood)
			b.box(Vector3(0, 0.83, 0.05), Vector3(1.1, 0.62, 0.06), MET, 0.0, black)
			b.box(Vector3(0, 0.83, 0.018), Vector3(1.04, 0.56, 0.01), TIL, 0.0, Color(0.05, 0.05, 0.06))
		"desk":
			b.box(Vector3(0, 0.74, 0), Vector3(1.4, 0.04, 0.7), WOOD, 0.3, Color(0.58, 0.46, 0.34))
			b.box(Vector3(0.48, 0.37, 0), Vector3(0.42, 0.72, 0.66), WOOD, 0.3, Color(0.55, 0.43, 0.32))
			b.box(Vector3(-0.66, 0.37, 0), Vector3(0.04, 0.72, 0.66), WOOD, 0.3, Color(0.55, 0.43, 0.32))
		"computer":
			b.box(Vector3(0, 0.02, 0.05), Vector3(0.2, 0.02, 0.15), MET, 0.0, black)
			b.box(Vector3(0, 0.12, 0.08), Vector3(0.04, 0.2, 0.04), MET, 0.0, black)
			b.box(Vector3(0, 0.3, 0.06), Vector3(0.52, 0.32, 0.04), MET, 0.0, black)
			b.box(Vector3(0, 0.015, -0.2), Vector3(0.44, 0.02, 0.14), MET, 0.0, Color(0.2, 0.2, 0.22))
		"locker":
			for i in 3:
				b.box(Vector3(-0.5 + i * 0.5, 0.95, 0), Vector3(0.48, 1.9, 0.5), MET, float(i) * 0.3, Color(0.35, 0.45, 0.52))
				for k in 3:
					b.box(Vector3(-0.5 + i * 0.5, 1.6 - k * 0.05, -0.255), Vector3(0.3, 0.015, 0.01), MET, 0.0, Color(0.2, 0.25, 0.3))
		"filing_cabinet":
			b.box(Vector3(0, 0.65, 0), Vector3(0.5, 1.3, 0.6), MET, 0.2, Color(0.55, 0.57, 0.55))
			for k in 4:
				b.box(Vector3(0, 0.18 + k * 0.32, -0.305), Vector3(0.12, 0.03, 0.02), MET, 0.0, steel)
		"med_cart":
			b.box(Vector3(0, 0.5, 0), Vector3(0.6, 0.8, 0.45), MET, 0.1, Color(0.8, 0.82, 0.85))
			b.box(Vector3(0, 0.92, 0), Vector3(0.62, 0.04, 0.47), MET, 0.1, Color(0.6, 0.7, 0.8))
			_legs(b, 0.6, 0.45, 0.12, 0.05, MET, black)
		"curtain":
			b.box(Vector3(0, 2.2, 0), Vector3(2.2, 0.04, 0.04), MET, 0.0, steel)
			b.box(Vector3(0, 1.25, 0), Vector3(2.1, 1.85, 0.03), FAB, 0.3, Color(0.62, 0.75, 0.72))
		"checkout":
			b.box(Vector3(0, 0.45, 0), Vector3(1.8, 0.9, 0.7), PLA, 0.3, Color(0.7, 0.72, 0.72))
			b.box(Vector3(-0.3, 0.91, 0), Vector3(1.1, 0.02, 0.45), MET, 0.0, black)
			b.box(Vector3(0.65, 1.05, 0), Vector3(0.35, 0.25, 0.3), MET, 0.0, Color(0.2, 0.2, 0.2))
		"gondola":
			b.box(Vector3(0, 0.8, 0), Vector3(2.4, 1.6, 0.08), MET, 0.0, Color(0.85, 0.85, 0.83))
			b.box(Vector3(0, 0.06, 0), Vector3(2.4, 0.12, 0.9), MET, 0.0, Color(0.6, 0.6, 0.62))
			var r := RandomNumberGenerator.new()
			r.seed = 77
			for side: float in [-1.0, 1.0]:
				for i in 4:
					var y := 0.15 + i * 0.38
					b.box(Vector3(0, y, side * 0.24), Vector3(2.36, 0.02, 0.42), MET, 0.0, Color(0.78, 0.78, 0.78))
					var x := -1.15
					while x < 1.1:
						var w := r.randf_range(0.08, 0.2)
						var h := r.randf_range(0.12, 0.3)
						var c := Color.from_hsv(r.randf(), r.randf_range(0.5, 0.9), r.randf_range(0.5, 0.95))
						b.box(Vector3(x + w * 0.5, y + 0.01 + h * 0.5, side * 0.24), Vector3(w * 0.9, h, 0.3), PLA, r.randf(), c)
						x += w + 0.01
		"freezer":
			b.box(Vector3(0, 0.42, 0), Vector3(2.0, 0.84, 0.82), MET, 0.1, white)
			b.box(Vector3(0, 0.85, 0), Vector3(1.9, 0.02, 0.74), TIL, 0.0, Color(0.2, 0.3, 0.35))
		"workbench":
			b.box(Vector3(0, 0.86, 0), Vector3(2.0, 0.08, 0.8), WOOD, 0.1, Color(0.55, 0.4, 0.26))
			_legs(b, 2.0, 0.8, 0.82, 0.08, WOOD, dark_wood)
			b.box(Vector3(0, 0.25, 0), Vector3(1.9, 0.03, 0.7), WOOD, 0.1, dark_wood)
			b.box(Vector3(0, 1.4, 0.38), Vector3(2.0, 1.0, 0.04), WOOD, 0.2, Color(0.5, 0.45, 0.35))
			b.box(Vector3(-0.5, 0.95, -0.1), Vector3(0.3, 0.1, 0.2), MET, 0.0, Color(0.5, 0.15, 0.1))
			b.box(Vector3(0.6, 0.93, 0.05), Vector3(0.25, 0.06, 0.08), MET, 0.0, steel)
		"tool_cabinet":
			b.box(Vector3(0, 0.52, 0), Vector3(0.8, 0.95, 0.5), MET, 0.3, Color(0.6, 0.1, 0.08))
			for k in 5:
				b.box(Vector3(0, 0.2 + k * 0.17, -0.255), Vector3(0.7, 0.02, 0.01), MET, 0.0, Color(0.3, 0.05, 0.03))
			_legs(b, 0.8, 0.5, 0.06, 0.05, MET, black)
		"car_lift":
			for sx: float in [-1.5, 1.5]:
				b.box(Vector3(sx, 1.5, 0), Vector3(0.3, 3.0, 0.3), MET, 0.0, Color(0.3, 0.35, 0.6))
				b.box(Vector3(sx * 0.7, 0.3, -0.5), Vector3(1.0, 0.08, 0.12), MET, 0.0, Color(0.4, 0.4, 0.4))
				b.box(Vector3(sx * 0.7, 0.3, 0.5), Vector3(1.0, 0.08, 0.12), MET, 0.0, Color(0.4, 0.4, 0.4))
		"tires":
			for i in 4:
				b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, i * 0.22, 0)), 0.33, 0.21, 12, MET, 0.0, black)
		"barrel":
			b.cylinder(Transform3D.IDENTITY, 0.3, 0.9, 12, MET, 0.0, Color(0.3, 0.42, 0.55))
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, 0.3, 0)), 0.305, 0.03, 12, MET, 0.0, Color(0.2, 0.3, 0.4), false)
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, 0.6, 0)), 0.305, 0.03, 12, MET, 0.0, Color(0.2, 0.3, 0.4), false)
		"crate":
			b.box(Vector3(0, 0.4, 0), Vector3(0.8, 0.8, 0.8), WOOD, 0.4, Color(0.7, 0.55, 0.36))
			for y: float in [0.1, 0.7]:
				b.box(Vector3(0, y, -0.405), Vector3(0.8, 0.1, 0.01), WOOD, 0.1, Color(0.5, 0.38, 0.24))
		"pallet":
			for i in 5:
				b.box(Vector3(-0.5 + i * 0.25, 0.13, 0), Vector3(0.14, 0.025, 1.2), WOOD, 0.0, Color(0.65, 0.52, 0.36))
			for sz: float in [-0.5, 0.0, 0.5]:
				b.box(Vector3(0, 0.06, sz), Vector3(1.2, 0.1, 0.1), WOOD, 0.0, Color(0.55, 0.43, 0.3))
		"rack":
			for sx: float in [-1.3, 1.3]:
				for sz: float in [-0.45, 0.45]:
					b.box(Vector3(sx, 1.5, sz), Vector3(0.08, 3.0, 0.08), MET, 0.0, Color(0.2, 0.35, 0.6))
			for i in 3:
				b.box(Vector3(0, 0.15 + i * 1.1, 0), Vector3(2.7, 0.08, 1.0), MET, 0.0, Color(0.85, 0.5, 0.1))
				for k in 3:
					b.box(Vector3(-0.85 + k * 0.85, 0.55 + i * 1.1, 0), Vector3(0.75, 0.7, 0.75), WOOD, float(k) * 0.2, Color(0.72, 0.58, 0.38))
		"pew":
			b.box(Vector3(0, 0.45, 0), Vector3(3.0, 0.05, 0.42), WOOD, 0.2, dark_wood)
			b.box(Vector3(0, 0.75, 0.2), Vector3(3.0, 0.55, 0.05), WOOD, 0.2, dark_wood)
			for sx: float in [-1.45, 1.45]:
				b.box(Vector3(sx, 0.45, 0.05), Vector3(0.06, 0.9, 0.5), WOOD, 0.2, dark_wood)
		"altar":
			b.box(Vector3(0, 0.5, 0), Vector3(2.0, 1.0, 0.9), PLA, 0.1, white)
			b.box(Vector3(0, 1.02, 0), Vector3(2.1, 0.04, 1.0), FAB, 0.2, Color(0.7, 0.62, 0.35))
		"blackboard":
			b.box(Vector3(0, 1.5, 0), Vector3(3.2, 1.2, 0.05), WOOD, 0.1, Color(0.15, 0.25, 0.2))
			b.box(Vector3(0, 0.88, -0.05), Vector3(3.2, 0.04, 0.1), WOOD, 0.1, dark_wood)
		"school_desk":
			b.box(Vector3(0, 0.7, -0.15), Vector3(0.6, 0.03, 0.45), WOOD, 0.2, Color(0.7, 0.58, 0.4))
			_legs(b, 0.6, 0.45, 0.7, 0.03, MET, Color(0.3, 0.3, 0.32))
			b.box(Vector3(0, 0.42, 0.35), Vector3(0.4, 0.03, 0.38), WOOD, 0.2, Color(0.7, 0.58, 0.4))
			b.box(Vector3(0, 0.65, 0.52), Vector3(0.4, 0.3, 0.03), WOOD, 0.2, Color(0.7, 0.58, 0.4))
		"lab_bench":
			b.box(Vector3(0, 0.45, 0), Vector3(3.0, 0.88, 0.8), PAN, 0.1, Color(0.85, 0.87, 0.88))
			b.box(Vector3(0, 0.91, 0), Vector3(3.02, 0.04, 0.82), TIL, 0.0, Color(0.15, 0.16, 0.17))
			b.box(Vector3(0, 1.35, 0.35), Vector3(3.0, 0.02, 0.28), MET, 0.0, steel)
			for i in 3:
				b.box(Vector3(-1.0 + i * 1.0, 0.45, -0.405), Vector3(0.9, 0.7, 0.01), PAN, 0.1, Color(0.7, 0.73, 0.75))
		"fume_hood":
			b.box(Vector3(0, 0.45, 0), Vector3(1.5, 0.9, 0.9), PAN, 0.1, Color(0.85, 0.87, 0.88))
			b.box(Vector3(0, 1.95, 0.1), Vector3(1.5, 0.7, 0.7), PAN, 0.1, Color(0.85, 0.87, 0.88))
			b.box(Vector3(-0.73, 1.25, 0), Vector3(0.04, 0.7, 0.9), PAN, 0.1, Color(0.8, 0.82, 0.83))
			b.box(Vector3(0.73, 1.25, 0), Vector3(0.04, 0.7, 0.9), PAN, 0.1, Color(0.8, 0.82, 0.83))
			b.box(Vector3(0, 1.35, -0.4), Vector3(1.42, 0.5, 0.02), TIL, 0.0, Color(0.25, 0.3, 0.32))
		"server_rack":
			b.box(Vector3(0, 1.0, 0), Vector3(0.6, 2.0, 1.0), MET, 0.1, Color(0.1, 0.1, 0.11))
			for k in 10:
				b.box(Vector3(0, 0.2 + k * 0.17, -0.505), Vector3(0.52, 0.1, 0.01), MET, 0.0, Color(0.2, 0.22, 0.24))
		"lab_equipment":
			b.box(Vector3(-0.2, 0.18, 0), Vector3(0.45, 0.36, 0.4), MET, 0.0, white)
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(-0.2, 0.36, 0)), 0.15, 0.04, 10, MET, 0.0, Color(0.4, 0.45, 0.5))
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0.3, 0.0, 0.05)), 0.05, 0.25, 8, TIL, 0.0, Color(0.6, 0.8, 0.9))
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0.42, 0.0, -0.08)), 0.04, 0.18, 8, TIL, 0.0, Color(0.8, 0.5, 0.4))
		"lamp_post":
			b.cylinder(Transform3D.IDENTITY, 0.1, 7.2, 8, MET, 0.0, Color(0.3, 0.32, 0.33), true, 0.07)
			b.box(Vector3(0, 7.15, -0.75), Vector3(0.08, 0.08, 1.5), MET, 0.0, Color(0.3, 0.32, 0.33))
			b.box(Vector3(0, 7.05, -1.45), Vector3(0.3, 0.12, 0.55), MET, 0.0, Color(0.25, 0.26, 0.27))
		"traffic_light":
			b.cylinder(Transform3D.IDENTITY, 0.08, 3.4, 8, MET, 0.0, Color(0.2, 0.2, 0.2))
			b.box(Vector3(0, 3.0, -0.12), Vector3(0.3, 0.9, 0.22), MET, 0.0, Color(0.12, 0.12, 0.12))
		"bench":
			for i in 3:
				b.box(Vector3(0, 0.45, -0.15 + i * 0.13), Vector3(1.8, 0.04, 0.1), WOOD, 0.2, Color(0.55, 0.4, 0.26))
			for i in 2:
				b.box(Vector3(0, 0.62 + i * 0.13, 0.25), Vector3(1.8, 0.1, 0.03), WOOD, 0.2, Color(0.55, 0.4, 0.26))
			for sx: float in [-0.8, 0.8]:
				b.box(Vector3(sx, 0.35, 0.05), Vector3(0.06, 0.7, 0.5), MET, 0.0, Color(0.15, 0.15, 0.15))
		"trash_bin":
			b.cylinder(Transform3D.IDENTITY, 0.28, 0.95, 10, MET, 0.0, Color(0.22, 0.38, 0.25))
		"dumpster":
			b.box(Vector3(0, 0.65, 0), Vector3(1.85, 1.2, 1.1), MET, 0.3, Color(0.18, 0.35, 0.22))
			b.box_xf(Transform3D(Basis(Vector3.RIGHT, -0.12), Vector3(0, 1.3, 0)), Vector3(1.9, 0.06, 1.15), MET, 0.3, Color(0.12, 0.25, 0.15))
			_legs(b, 1.7, 1.0, 0.1, 0.12, MET, black)
		"hydrant":
			b.cylinder(Transform3D.IDENTITY, 0.12, 0.6, 8, MET, 0.0, Color(0.7, 0.12, 0.08))
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, 0.6, 0)), 0.14, 0.12, 8, MET, 0.0, Color(0.7, 0.12, 0.08))
		"bus_stop":
			for sx: float in [-1.5, 1.5]:
				b.box(Vector3(sx, 1.25, 0.45), Vector3(0.08, 2.5, 0.08), MET, 0.0, Color(0.4, 0.42, 0.44))
			b.box(Vector3(0, 2.55, 0.1), Vector3(3.3, 0.08, 1.4), MET, 0.0, Color(0.5, 0.52, 0.54))
			b.box(Vector3(0, 1.3, 0.48), Vector3(3.0, 1.6, 0.03), TIL, 0.0, Color(0.3, 0.35, 0.38))
			b.box(Vector3(0, 0.45, 0.25), Vector3(2.4, 0.05, 0.4), WOOD, 0.1, Color(0.5, 0.38, 0.26))
			b.box(Vector3(1.2, 1.3, 0.45), Vector3(0.9, 1.4, 0.06), PLA, 0.7, Color(0.9, 0.75, 0.4))
		"sign_post":
			b.cylinder(Transform3D.IDENTITY, 0.04, 2.6, 6, MET, 0.0, Color(0.5, 0.5, 0.5))
			b.box(Vector3(0, 2.3, -0.03), Vector3(0.6, 0.6, 0.02), MET, 0.0, Color(0.85, 0.85, 0.85))
		"mailbox":
			b.box(Vector3(0, 0.55, 0), Vector3(0.1, 1.1, 0.1), WOOD, 0.0, dark_wood)
			b.box(Vector3(0, 1.15, 0), Vector3(0.3, 0.25, 0.4), MET, 0.0, Color(0.75, 0.6, 0.2))
		"planter":
			b.box(Vector3(0, 0.3, 0), Vector3(1.2, 0.6, 1.2), CON, 0.0, Color(0.6, 0.6, 0.58))
			b.box(Vector3(0, 0.605, 0), Vector3(1.05, 0.01, 1.05), _c(Assets.L_DIRT), 0.0, Color(0.5, 0.45, 0.4))
		"fence_wood":
			for i in 5:
				b.box(Vector3(-0.8 + i * 0.4, 0.55, 0), Vector3(0.1, 1.1, 0.03), WOOD, 0.0, Color(0.6, 0.48, 0.35))
			for y: float in [0.3, 0.85]:
				b.box(Vector3(0, y, 0.03), Vector3(2.0, 0.08, 0.03), WOOD, 0.0, Color(0.5, 0.4, 0.3))
		"fence_metal":
			for sx: float in [-1.0, 1.0]:
				b.box(Vector3(sx, 0.8, 0), Vector3(0.05, 1.6, 0.05), MET, 0.0, Color(0.35, 0.36, 0.36))
			for i in 9:
				b.box(Vector3(-0.8 + i * 0.2, 0.8, 0), Vector3(0.02, 1.5, 0.02), MET, 0.0, Color(0.3, 0.31, 0.31))
			b.box(Vector3(0, 1.55, 0), Vector3(2.0, 0.04, 0.04), MET, 0.0, Color(0.35, 0.36, 0.36))
			b.box(Vector3(0, 0.1, 0), Vector3(2.0, 0.04, 0.04), MET, 0.0, Color(0.35, 0.36, 0.36))
		"wall_low":
			b.box(Vector3(0, 0.9, 0), Vector3(2.0, 1.8, 0.18), PLA, 0.3, Color(0.85, 0.82, 0.76))
			b.box(Vector3(0, 1.82, 0), Vector3(2.02, 0.05, 0.24), CON, 0.0, Color(0.6, 0.6, 0.58))
		"sandbags":
			var r := RandomNumberGenerator.new()
			r.seed = 5
			for row in 3:
				for i in 4:
					var x := -0.75 + i * 0.5 + (0.25 if row % 2 == 1 else 0.0)
					if x > 0.9:
						continue
					b.box_xf(Transform3D(Basis(Vector3.UP, r.randf_range(-0.1, 0.1)), Vector3(x, 0.15 + row * 0.28, 0)), Vector3(0.52, 0.28, 0.65), FAB, r.randf(), Color(0.55, 0.5, 0.38))
		"barricade_wood":
			b.box_xf(Transform3D(Basis(Vector3.BACK, 0.55), Vector3(0, 0.8, 0)), Vector3(2.6, 0.2, 0.05), WOOD, 0.2, Color(0.5, 0.4, 0.3))
			b.box_xf(Transform3D(Basis(Vector3.BACK, -0.55), Vector3(0, 0.8, 0.06)), Vector3(2.6, 0.2, 0.05), WOOD, 0.4, Color(0.55, 0.43, 0.32))
			b.box(Vector3(0, 1.2, 0.12), Vector3(2.4, 0.2, 0.05), WOOD, 0.6, Color(0.48, 0.38, 0.28))
			b.box(Vector3(0, 0.5, 0.12), Vector3(2.4, 0.2, 0.05), WOOD, 0.7, Color(0.52, 0.4, 0.3))
		"concrete_barrier":
			b.box(Vector3(0, 0.15, 0), Vector3(2.0, 0.3, 0.6), CON, 0.0, Color(0.7, 0.7, 0.68))
			b.box(Vector3(0, 0.55, 0), Vector3(2.0, 0.5, 0.25), CON, 0.0, Color(0.7, 0.7, 0.68))
		"tent":
			var col := Color(0.25, 0.4, 0.3)
			b.quad(Vector3(-1.1, 0, -1.2), Vector3(-1.1, 0, 1.2), Vector3(0, 1.3, 1.2), Vector3(0, 1.3, -1.2), Vector3(-1.3, 1.1, 0).normalized(),
				Vector2(0, 0), Vector2(2.4, 0), Vector2(2.4, 1.7), Vector2(0, 1.7), FAB, 0.2, col)
			b.quad(Vector3(1.1, 0, 1.2), Vector3(1.1, 0, -1.2), Vector3(0, 1.3, -1.2), Vector3(0, 1.3, 1.2), Vector3(1.3, 1.1, 0).normalized(),
				Vector2(0, 0), Vector2(2.4, 0), Vector2(2.4, 1.7), Vector2(0, 1.7), FAB, 0.2, col)
			b.tri(Vector3(1.1, 0, 1.2), Vector3(0, 1.3, 1.2), Vector3(-1.1, 0, 1.2), Vector3.BACK, Vector2(0, 0), Vector2(1.1, 1.3), Vector2(2.2, 0), FAB, 0.3, col * 0.9)
			b.tri(Vector3(-1.1, 0, -1.2), Vector3(-0.3, 0.9, -1.25), Vector3(-0.2, 0, -1.2), Vector3.FORWARD, Vector2(0, 0), Vector2(0.8, 0.9), Vector2(0.9, 0), FAB, 0.3, col * 0.9)
		"campfire":
			for i in 8:
				var a := TAU * i / 8.0
				b.box_xf(Transform3D(Basis(Vector3.UP, a), Vector3(cos(a) * 0.45, 0.08, sin(a) * 0.45)), Vector3(0.22, 0.16, 0.18), _c(Assets.L_ROCK), float(i) * 0.1, Color(0.5, 0.48, 0.45))
			for i in 3:
				var a := TAU * i / 3.0
				b.box_xf(Transform3D(Basis(Vector3.UP, a) * Basis(Vector3.RIGHT, 0.5), Vector3(cos(a) * 0.1, 0.12, sin(a) * 0.1)), Vector3(0.08, 0.08, 0.6), _c(Assets.L_BARK), 0.0, Color(0.3, 0.2, 0.15))
		"hay_bale":
			b.box(Vector3(0, 0.45, 0), Vector3(1.2, 0.9, 0.9), _c(Assets.L_GRASS), 0.5, Color(1.6, 1.4, 0.7))
		"gas_pump":
			b.box(Vector3(0, 0.1, 0), Vector3(1.0, 0.2, 0.7), CON, 0.0, Color(0.6, 0.6, 0.58))
			b.box(Vector3(0, 1.0, 0), Vector3(0.8, 1.6, 0.45), MET, 0.0, Color(0.85, 0.2, 0.15))
			b.box(Vector3(0, 1.4, -0.23), Vector3(0.5, 0.35, 0.01), TIL, 0.0, Color(0.1, 0.1, 0.1))
			b.box(Vector3(0.42, 0.95, 0), Vector3(0.05, 0.3, 0.12), MET, 0.0, black)
		"water_tank":
			b.cylinder(Transform3D.IDENTITY, 0.75, 1.0, 14, MET, 0.0, Color(0.3, 0.45, 0.75), true, 0.7)
		"ac_unit":
			b.box(Vector3(0, 0.3, 0), Vector3(0.8, 0.55, 0.3), MET, 0.0, Color(0.85, 0.85, 0.83))
			b.cylinder(Transform3D(Basis(Vector3.RIGHT, PI * 0.5), Vector3(0.12, 0.3, -0.16)), 0.2, 0.01, 10, MET, 0.0, Color(0.3, 0.3, 0.3))
		"antenna":
			b.cylinder(Transform3D.IDENTITY, 0.02, 2.5, 5, MET, 0.0, Color(0.5, 0.5, 0.5))
			for i in 4:
				b.box(Vector3(0, 1.6 + i * 0.25, 0), Vector3(1.0 - i * 0.2, 0.02, 0.02), MET, 0.0, Color(0.5, 0.5, 0.5))
		"container":
			b.box(Vector3(0, 1.3, 0), Vector3(6.0, 2.6, 2.44), MET, 0.5, Color(1, 1, 1))
		"forklift":
			b.box(Vector3(0, 0.6, 0.3), Vector3(1.1, 0.9, 1.6), MET, 0.0, Color(0.9, 0.7, 0.1))
			b.box(Vector3(0, 1.6, 0.4), Vector3(1.0, 0.06, 1.0), MET, 0.0, Color(0.2, 0.2, 0.2))
			for sx: float in [-0.45, 0.45]:
				b.box(Vector3(sx, 1.1, 0.85), Vector3(0.06, 1.0, 0.06), MET, 0.0, Color(0.2, 0.2, 0.2))
				b.box(Vector3(sx, 1.1, -0.1), Vector3(0.06, 1.0, 0.06), MET, 0.0, Color(0.2, 0.2, 0.2))
			b.box(Vector3(0, 1.1, -0.6), Vector3(0.9, 2.0, 0.1), MET, 0.0, Color(0.2, 0.2, 0.2))
			for sx: float in [-0.3, 0.3]:
				b.box(Vector3(sx, 0.1, -1.1), Vector3(0.12, 0.05, 1.0), MET, 0.0, Color(0.3, 0.3, 0.3))
		"debris_pile":
			var r := RandomNumberGenerator.new()
			r.seed = 31
			for i in 12:
				var s := Vector3(r.randf_range(0.2, 0.8), r.randf_range(0.1, 0.4), r.randf_range(0.2, 0.7))
				var p := Vector3(r.randf_range(-0.9, 0.9), s.y * 0.4 + r.randf() * 0.2, r.randf_range(-0.9, 0.9))
				b.box_xf(Transform3D(Basis.from_euler(Vector3(r.randf_range(-0.4, 0.4), r.randf() * TAU, r.randf_range(-0.4, 0.4))), p), s,
					CON if r.randf() < 0.7 else _c(Assets.L_BRICK), r.randf(), Color(0.7, 0.68, 0.64))
		"trash_bags":
			var r := RandomNumberGenerator.new()
			r.seed = 13
			for i in 5:
				var p := Vector3(r.randf_range(-0.6, 0.6), 0.0, r.randf_range(-0.5, 0.5))
				b.cylinder(Transform3D(Basis.from_euler(Vector3(0, r.randf() * 3, 0)).scaled(Vector3(1, r.randf_range(0.7, 1.0), 1.2)), p), 0.3, 0.55, 7, FAB, r.randf(), Color(0.1, 0.1, 0.11), true, 0.18)
		"cardboard":
			var r := RandomNumberGenerator.new()
			r.seed = 17
			for i in 4:
				var s := Vector3(r.randf_range(0.3, 0.6), r.randf_range(0.2, 0.45), r.randf_range(0.3, 0.5))
				b.box_xf(Transform3D(Basis(Vector3.UP, r.randf() * TAU), Vector3(r.randf_range(-0.4, 0.4), s.y * 0.5 + (0.3 if i == 3 else 0.0), r.randf_range(-0.4, 0.4))), s, _c(Assets.L_FABRIC), r.randf(), Color(0.62, 0.48, 0.32))
		"radio_tower":
			var hgt := 42.0
			for i in 4:
				var a := TAU * i / 4.0 + PI * 0.25
				var bot := Vector3(cos(a) * 3.0, 0, sin(a) * 3.0)
				var top := Vector3(cos(a) * 0.5, hgt, sin(a) * 0.5)
				var mid := (bot + top) * 0.5
				var dir := (top - bot).normalized()
				var lb := Basis.looking_at(dir, Vector3.RIGHT if absf(dir.y) > 0.99 else Vector3.UP)
				b.box_xf(Transform3D(lb, mid), Vector3(0.15, 0.15, bot.distance_to(top)), MET, 0.0, Color(0.7, 0.3, 0.2))
			for k in 10:
				var y := 3.0 + k * 3.8
				var w := lerpf(5.5, 1.2, y / hgt)
				b.box(Vector3(0, y, 0), Vector3(w, 0.1, 0.1), MET, 0.0, Color(0.75, 0.75, 0.75))
				b.box(Vector3(0, y, 0), Vector3(0.1, 0.1, w), MET, 0.0, Color(0.75, 0.75, 0.75))
			b.box(Vector3(0, hgt + 1.0, 0), Vector3(0.1, 2.0, 0.1), MET, 0.0, Color(0.8, 0.2, 0.2))
		"floodlight":
			b.cylinder(Transform3D.IDENTITY, 0.25, 22.0, 8, MET, 0.0, Color(0.5, 0.5, 0.52), true, 0.18)
			b.box(Vector3(0, 22.5, 0), Vector3(3.0, 1.5, 0.3), MET, 0.0, Color(0.4, 0.4, 0.42))
		"power_pole":
			b.box(Vector3(0, 4.5, 0), Vector3(0.22, 9.0, 0.22), CON, 0.0, Color(0.7, 0.7, 0.68))
			b.box(Vector3(0, 8.4, 0), Vector3(1.8, 0.12, 0.12), CON, 0.0, Color(0.65, 0.65, 0.63))
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0.3, 6.8, 0.2)), 0.22, 0.7, 8, MET, 0.0, Color(0.5, 0.52, 0.5))
		"billboard":
			for sx: float in [-2.5, 2.5]:
				b.box(Vector3(sx, 3.5, 0), Vector3(0.25, 7.0, 0.25), MET, 0.0, Color(0.4, 0.4, 0.4))
			b.box(Vector3(0, 7.5, 0), Vector3(8.0, 3.5, 0.2), PLA, 0.8, Color(0.9, 0.85, 0.75))
		"log":
			b.cylinder(Transform3D(Basis(Vector3.BACK, PI * 0.5), Vector3(1.5, 0.25, 0)), 0.25, 3.0, 8, _c(Assets.L_BARK), 0.0, Color(0.6, 0.5, 0.4))
		"crib":
			b.box(Vector3(0, 0.45, 0), Vector3(0.7, 0.1, 1.3), WOOD, 0.1, white)
			for sx: float in [-0.34, 0.34]:
				for i in 6:
					b.box(Vector3(sx, 0.7, -0.6 + i * 0.24), Vector3(0.03, 0.5, 0.03), WOOD, 0.1, white)
		"rug":
			b.box(Vector3(0, 0.005, 0), Vector3(2.0, 0.01, 1.4), FAB, 0.9, Color(0.55, 0.25, 0.2))
		"generator":
			b.box(Vector3(0, 0.45, 0), Vector3(1.2, 0.7, 0.7), MET, 0.0, Color(0.85, 0.6, 0.1))
			b.box(Vector3(0, 0.05, 0), Vector3(1.3, 0.1, 0.8), MET, 0.0, black)
		"radio_set":
			b.box(Vector3(0, 0.15, 0), Vector3(0.5, 0.3, 0.3), MET, 0.0, Color(0.25, 0.28, 0.24))
			b.box(Vector3(0, 0.2, -0.155), Vector3(0.4, 0.12, 0.01), TIL, 0.0, Color(0.8, 0.6, 0.3))
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0.2, 0.3, 0.1)), 0.01, 0.6, 4, MET, 0.0, Color(0.6, 0.6, 0.6))
		"stair_ramp":
			# degraus visuais de 0 a 2.9 m em 4.2 m (colisão é rampa)
			for i in 15:
				b.box(Vector3(0, 0.1 + i * 0.193, -2.1 + i * 0.28 + 0.14), Vector3(1.0, 0.2, 0.28), WOOD, 0.0, Color(0.55, 0.42, 0.3))
		"tarp_shelter":
			for sx: float in [-1.5, 1.5]:
				for sz: float in [-1.2, 1.2]:
					b.box(Vector3(sx, 1.1, sz), Vector3(0.08, 2.2, 0.08), WOOD, 0.0, dark_wood)
			b.box_xf(Transform3D(Basis(Vector3.RIGHT, 0.12), Vector3(0, 2.25, 0)), Vector3(3.4, 0.03, 2.8), FAB, 0.4, Color(0.2, 0.3, 0.55))
		"fence_chain_post":
			b.box(Vector3(0, 1.1, 0), Vector3(0.06, 2.2, 0.06), MET, 0.0, Color(0.5, 0.5, 0.5))
		"gate_bar":
			b.box(Vector3(0, 0.5, 0), Vector3(0.3, 1.0, 0.3), MET, 0.0, Color(0.9, 0.9, 0.2))
			b.box(Vector3(2.5, 0.95, 0), Vector3(5.0, 0.12, 0.12), MET, 0.0, Color(0.9, 0.2, 0.15))
		_:
			b.box(Vector3(0, 0.25, 0), Vector3(0.5, 0.5, 0.5), WOOD, 0.0, Color(0.6, 0.5, 0.4))
