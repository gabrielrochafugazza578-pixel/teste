class_name BuildingGen
extends RefCounted
## Casca externa dos prédios (fachadas, telhados, detalhes, colisão).
## Tudo em coordenadas de mundo, escrito em MeshBuf => mesclado por chunk.
## Função pura (sem nós) => pode rodar em thread de trabalho.

const FOUND := 1.2
## beiral do telhado da igreja (curto: o frontão e a cimalha cobrem a empena)
const CHURCH_EAVE := 0.15


static func cell_h(wmode: int, fallback: float) -> float:
	match wmode:
		Assets.WM_RES: return 2.9
		Assets.WM_OFFICE: return 3.4
		Assets.WM_SHOP: return 3.6
	return fallback


static func floor_h(b: Dictionary) -> float:
	var t: String = b["type"]
	if t in ["house", "apartment", "tower", "commercial", "clinic", "school", "police", "office", "cabin", "farmhouse", "hospital"]:
		return cell_h(int(b["wmode"]), float(b["fh"]))
	return float(b["fh"])


static func total_height(b: Dictionary) -> float:
	var fh := floor_h(b)
	var floors := int(b["floors"])
	var t: String = b["type"]
	if t in ["house", "apartment", "tower", "commercial", "clinic", "school", "police", "office", "cabin", "farmhouse", "hospital"]:
		return fh * floors
	return float(b["gfh"]) + fh * float(floors - 1)


## Informações da porta principal: [centro Vector3, direção para fora Vector3, largura]
static func door_info(b: Dictionary) -> Array:
	var r: Rect2 = b["rect"]
	var c := r.get_center()
	var y: float = b["base"]
	var w := 1.0
	var t: String = b["type"]
	if t in ["market", "hospital", "terminal", "lab", "office", "shop", "commercial", "tower", "gas_station", "church", "police", "school", "clinic"]:
		w = 2.2
	if t in ["warehouse", "workshop", "barn", "factory"]:
		w = 3.6
	if t == "stadium":
		w = 6.0
	var off := 0.0
	if t == "house" or t == "farmhouse" or t == "cabin":
		off = float(Util.hash2(int(b["seed"]), 3) % 100) / 100.0 * 0.4 - 0.2
	match int(b["facing"]):
		0: return [Vector3(c.x + off * r.size.x, y, r.position.y), Vector3.FORWARD, w]
		1: return [Vector3(r.end.x, y, c.y + off * r.size.y), Vector3.RIGHT, w]
		2: return [Vector3(c.x - off * r.size.x, y, r.end.y), Vector3.BACK, w]
		_: return [Vector3(r.position.x, y, c.y - off * r.size.y), Vector3.LEFT, w]


static func door_height(b: Dictionary) -> float:
	var t: String = b["type"]
	if t in ["warehouse", "workshop", "barn", "factory"]:
		return 3.4
	if t == "stadium":
		return 4.5
	if t in ["market", "terminal", "church", "lab", "office"]:
		return 2.8
	return 2.2


static func build(b: Dictionary, shell: MeshBuf, detail: MeshBuf, lod: int, open_door: bool, relief: int = 2) -> void:
	var t: String = b["type"]
	if t == "stadium":
		_stadium(b, shell, detail, lod)
		return
	var r: Rect2 = b["rect"]
	var base: float = b["base"]
	var H := total_height(b)
	var wm := int(b["wmode"])
	var layer := int(b["layer"])
	var seedf := fposmod(float(b["seed"]) * 0.61803, 1.0)
	var tint: Color = b["tint"]
	var code := Assets.uv2_code(layer, wm if lod == 0 or wm != Assets.WM_SHOP else Assets.WM_RES)
	var roof_code := Assets.uv2_code(int(b["roof_layer"]), 0)
	var y0 := base - FOUND
	var hh := H + FOUND
	var x0 := r.position.x
	var x1 := r.end.x
	var z0 := r.position.y
	var z1 := r.end.y
	var cellw := 3.1 if wm == Assets.WM_RES else (2.4 if wm == Assets.WM_OFFICE else 3.6)
	var di := door_info(b)
	var door_c: Vector3 = di[0]
	var door_w: float = di[2]
	var dh := door_height(b)
	var facing := int(b["facing"])
	# fachadas: [a, b, normal, índice de lado]
	var sides := [
		[Vector2(x1, z0), Vector2(x0, z0), Vector3.FORWARD, 0],
		[Vector2(x1, z1), Vector2(x1, z0), Vector3.RIGHT, 1],
		[Vector2(x0, z1), Vector2(x1, z1), Vector3.BACK, 2],
		[Vector2(x0, z0), Vector2(x0, z1), Vector3.LEFT, 3],
	]
	for s in sides:
		var a: Vector2 = s[0]
		var bb: Vector2 = s[1]
		var n: Vector3 = s[2]
		var side_i: int = s[3]
		var len := a.distance_to(bb)
		var u_off := -fposmod(len, cellw) * 0.5
		if side_i == facing and (open_door or lod == 0):
			var du := a.distance_to(Vector2(door_c.x, door_c.z))
			if open_door:
				shell.wall_with_holes(a, bb, y0, hh, n, [[du - door_w * 0.5, du + door_w * 0.5, FOUND, FOUND + dh]], code, seedf, tint, base)
			else:
				shell.wall(a, bb, y0, hh, n, code, seedf, tint, u_off, base)
				# porta falsa (recuada visualmente)
				var dp := Vector3(door_c.x, base + dh * 0.5, door_c.z) + n * 0.03
				var dsz := Vector3(door_w if absf(n.z) > 0.5 else 0.05, dh, 0.05 if absf(n.z) > 0.5 else door_w)
				detail.box(dp, dsz, Assets.uv2_code(Assets.L_WOOD), seedf, Color(0.45, 0.33, 0.24))
			# degrau / soleira
			if lod == 0:
				var sp := Vector3(door_c.x, base - 0.06, door_c.z) + n * 0.45
				var ssz := Vector3(door_w + 0.6 if absf(n.z) > 0.5 else 0.9, 0.12, 0.9 if absf(n.z) > 0.5 else door_w + 0.6)
				detail.box(sp, ssz, Assets.uv2_code(Assets.L_CONCRETE), seedf, Color(0.7, 0.7, 0.68))
		else:
			shell.wall(a, bb, y0, hh, n, code, seedf, tint, u_off, base)
	# telhado
	var roof: String = b["roof"]
	var top := base + H
	if roof == "gable":
		var ridge_x := r.size.x >= r.size.y
		var span := r.size.y if ridge_x else r.size.x
		var rise := span * (0.18 if int(b["roof_layer"]) == Assets.L_METAL else 0.32)
		var eave := CHURCH_EAVE if t == "church" else (0.45 if lod == 0 else 0.3)
		shell.gable_roof(r, top, rise, eave, ridge_x, roof_code, code, seedf, Color(1, 1, 1), tint)
		# laje interna (tampa o topo da parede sob o telhado)
		shell.quad(Vector3(x0, top, z0), Vector3(x1, top, z0), Vector3(x1, top, z1), Vector3(x0, top, z1), Vector3.UP,
			Vector2(x0, z0), Vector2(x1, z0), Vector2(x1, z1), Vector2(x0, z1), roof_code, seedf, Color(0.6, 0.6, 0.6))
	else:
		shell.quad(Vector3(x0, top, z0), Vector3(x1, top, z0), Vector3(x1, top, z1), Vector3(x0, top, z1), Vector3.UP,
			Vector2(x0, z0), Vector2(x1, z0), Vector2(x1, z1), Vector2(x0, z1), roof_code, seedf, Color(0.75, 0.74, 0.72))
		if lod == 0:
			var pc := Assets.uv2_code(layer, 0)
			var ph := 0.6 if int(b["floors"]) > 1 else 0.35
			detail.box(Vector3((x0 + x1) * 0.5, top + ph * 0.5, z0 + 0.12), Vector3(r.size.x, ph, 0.24), pc, seedf, tint * 0.95)
			detail.box(Vector3((x0 + x1) * 0.5, top + ph * 0.5, z1 - 0.12), Vector3(r.size.x, ph, 0.24), pc, seedf, tint * 0.95)
			detail.box(Vector3(x0 + 0.12, top + ph * 0.5, (z0 + z1) * 0.5), Vector3(0.24, ph, r.size.y - 0.48), pc, seedf, tint * 0.95)
			detail.box(Vector3(x1 - 0.12, top + ph * 0.5, (z0 + z1) * 0.5), Vector3(0.24, ph, r.size.y - 0.48), pc, seedf, tint * 0.95)
	if t == "church":
		_church(b, detail, top, seedf, relief if lod == 0 else 0)
	if lod == 0:
		_details(b, detail, top, seedf)
		if roof != "gable" and t not in ["church", "gas_station", "guardhouse"]:
			_roof_clutter(b, detail, top, seedf, relief >= 2)
		if relief > 0:
			_relief(b, detail, shell, top, seedf, relief >= 2)
		if relief >= 2:
			_facade_kit(b, detail, shell, top, seedf)
	# colisão
	if lod == 0:
		if open_door:
			_wall_colliders(b, shell, top, door_c, door_w, dh)
		else:
			shell.add_box_collider(Vector3((x0 + x1) * 0.5, (y0 + top) * 0.5, (z0 + z1) * 0.5), Vector3(r.size.x, top - y0, r.size.y))
		if roof == "gable":
			shell.add_box_collider(Vector3((x0 + x1) * 0.5, top + 0.4, (z0 + z1) * 0.5), Vector3(r.size.x, 0.8, r.size.y))


static func _wall_colliders(b: Dictionary, out: MeshBuf, top: float, door_c: Vector3, door_w: float, dh: float) -> void:
	var r: Rect2 = b["rect"]
	var base: float = b["base"]
	var t := 0.3
	var y0 := base - 0.5
	var h := top - y0
	var cy := y0 + h * 0.5
	var facing := int(b["facing"])
	# norte/sul (paredes ao longo de X)
	for side: int in [0, 2]:
		var z := r.position.y + t * 0.5 if side == 0 else r.end.y - t * 0.5
		if facing == side:
			var l0 := door_c.x - door_w * 0.5 - r.position.x
			var l1 := r.end.x - (door_c.x + door_w * 0.5)
			out.add_box_collider(Vector3(r.position.x + l0 * 0.5, cy, z), Vector3(l0, h, t))
			out.add_box_collider(Vector3(r.end.x - l1 * 0.5, cy, z), Vector3(l1, h, t))
			var over := top - (base + dh)
			out.add_box_collider(Vector3(door_c.x, base + dh + over * 0.5, z), Vector3(door_w, over, t))
		else:
			out.add_box_collider(Vector3(r.get_center().x, cy, z), Vector3(r.size.x, h, t))
	for side: int in [1, 3]:
		var x := r.end.x - t * 0.5 if side == 1 else r.position.x + t * 0.5
		if facing == side:
			var l0 := door_c.z - door_w * 0.5 - r.position.y
			var l1 := r.end.y - (door_c.z + door_w * 0.5)
			out.add_box_collider(Vector3(x, cy, r.position.y + l0 * 0.5), Vector3(t, h, l0))
			out.add_box_collider(Vector3(x, cy, r.end.y - l1 * 0.5), Vector3(t, h, l1))
			var over := top - (base + dh)
			out.add_box_collider(Vector3(x, base + dh + over * 0.5, door_c.z), Vector3(t, over, door_w))
		else:
			out.add_box_collider(Vector3(x, cy, r.get_center().y), Vector3(t, h, r.size.y))
	# teto/laje superior
	out.add_box_collider(Vector3(r.get_center().x, top + 0.1, r.get_center().y), Vector3(r.size.x, 0.2, r.size.y))


static func _details(b: Dictionary, d: MeshBuf, top: float, seedf: float) -> void:
	var t: String = b["type"]
	var r: Rect2 = b["rect"]
	var base: float = b["base"]
	var rng := Util.rng(int(b["seed"]) * 7 + 1)
	var c := r.get_center()
	var facing := int(b["facing"])
	var MET := Assets.uv2_code(Assets.L_METAL)
	var CON := Assets.uv2_code(Assets.L_CONCRETE)
	var FAB := Assets.uv2_code(Assets.L_FABRIC)
	var fh := floor_h(b)
	# caixas d'água (telhados residenciais brasileiros)
	if t in ["house", "apartment", "farmhouse"] and rng.randf() < 0.85:
		var p := Vector3(c.x + rng.randf_range(-r.size.x, r.size.x) * 0.2, top + (0.0 if b["roof"] == "flat" else r.size.y * 0.05), c.y + rng.randf_range(-r.size.y, r.size.y) * 0.2)
		if b["roof"] == "gable":
			p.y = top + 0.2
		d.append(PropLib.buf("water_tank"), Transform3D(Basis.IDENTITY.scaled(Vector3.ONE * (1.0 if t == "house" else 1.6)), p))
	# faixas entre andares em prédios altos
	if t in ["apartment", "tower", "office", "hospital", "commercial"] and int(b["floors"]) > 1:
		var bc := Assets.uv2_code(Assets.L_CONCRETE)
		var col := Color(0.72, 0.71, 0.69)
		var floors := int(b["floors"])
		for f in range(1, floors):
			var y := base + f * fh - 0.06
			if f % (1 if floors < 6 else 2) != 0:
				continue
			d.box(Vector3(c.x, y, r.position.y - 0.07), Vector3(r.size.x + 0.28, 0.14, 0.14), bc, seedf, col)
			d.box(Vector3(c.x, y, r.end.y + 0.07), Vector3(r.size.x + 0.28, 0.14, 0.14), bc, seedf, col)
			d.box(Vector3(r.position.x - 0.07, y, c.y), Vector3(0.14, 0.14, r.size.y), bc, seedf, col)
			d.box(Vector3(r.end.x + 0.07, y, c.y), Vector3(0.14, 0.14, r.size.y), bc, seedf, col)
	# ar-condicionado nas fachadas
	if t in ["apartment", "tower", "commercial", "office", "house"]:
		var n := rng.randi_range(1, 6)
		for i in n:
			var f := rng.randi_range(0, maxi(0, int(b["floors"]) - 1))
			var y := base + f * fh + 0.6
			var side := rng.randi() % 4
			var p := Vector3.ZERO
			var rot := 0.0
			match side:
				0:
					p = Vector3(rng.randf_range(r.position.x + 1.0, r.end.x - 1.0), y, r.position.y - 0.16)
					rot = 0.0
				1:
					p = Vector3(r.end.x + 0.16, y, rng.randf_range(r.position.y + 1.0, r.end.y - 1.0))
					rot = -PI * 0.5
				2:
					p = Vector3(rng.randf_range(r.position.x + 1.0, r.end.x - 1.0), y, r.end.y + 0.16)
					rot = PI
				_:
					p = Vector3(r.position.x - 0.16, y, rng.randf_range(r.position.y + 1.0, r.end.y - 1.0))
					rot = PI * 0.5
			d.append(PropLib.buf("ac_unit"), Transform3D(Basis(Vector3.UP, rot), p))
	# antenas / casa de máquinas
	if t in ["tower", "office", "apartment"]:
		d.box(Vector3(c.x + r.size.x * 0.2, top + 1.3, c.y), Vector3(4.0, 2.6, 3.5), CON, seedf, Color(0.7, 0.7, 0.68))
		if rng.randf() < 0.6:
			d.append(PropLib.buf("antenna"), Transform3D(Basis.IDENTITY, Vector3(c.x - r.size.x * 0.25, top, c.y + 1.0)))
	# toldo de loja sobre a vitrine
	var named: bool = str(b["name"]) != "" and int(b["wmode"]) == Assets.WM_SHOP
	if named and t in ["commercial", "tower", "house", "gas_station", "market", "terminal"]:
		var awn_col := Color.from_hsv(rng.randf(), 0.6, 0.55)
		var y := base + 3.2
		match facing:
			0: d.box_xf(Transform3D(Basis(Vector3.RIGHT, -0.35), Vector3(c.x, y, r.position.y - 0.7)), Vector3(minf(r.size.x - 1.0, 10.0), 0.05, 1.5), FAB, seedf, awn_col)
			2: d.box_xf(Transform3D(Basis(Vector3.RIGHT, 0.35), Vector3(c.x, y, r.end.y + 0.7)), Vector3(minf(r.size.x - 1.0, 10.0), 0.05, 1.5), FAB, seedf, awn_col)
			1: d.box_xf(Transform3D(Basis(Vector3.BACK, -0.35), Vector3(r.end.x + 0.7, y, c.y)), Vector3(1.5, 0.05, minf(r.size.y - 1.0, 10.0)), FAB, seedf, awn_col)
			_: d.box_xf(Transform3D(Basis(Vector3.BACK, 0.35), Vector3(r.position.x - 0.7, y, c.y)), Vector3(1.5, 0.05, minf(r.size.y - 1.0, 10.0)), FAB, seedf, awn_col)
	# chaminé industrial
	if b.get("chimney", false):
		d.cylinder(Transform3D(Basis.IDENTITY, Vector3(r.end.x - 4.0, top - 1.0, r.end.y - 4.0)), 1.6, 24.0, 12, Assets.uv2_code(Assets.L_BRICK), seedf, Color(1, 1, 1), true, 1.1)
	# posto: cobertura sobre as bombas (testeira com faixas, forro de painéis com
	# luminárias), ilhas de concreto com protetores e piso de concreto em placas
	if t == "gas_station":
		var cp := _front_point(b, 7.0)
		var along_x := facing == 0 or facing == 2
		var csz := Vector3(12.0, 0.9, 8.0) if along_x else Vector3(8.0, 0.9, 12.0)
		var PAN := Assets.uv2_code(Assets.L_PANELS)
		d.box(cp + Vector3(0, 5.05, 0), csz, MET, seedf, Color(0.9, 0.9, 0.88))
		d.box(cp + Vector3(0, 4.82, 0), Vector3(csz.x + 0.04, 0.2, csz.z + 0.04), MET, seedf, Color(0.82, 0.15, 0.1))
		d.box(cp + Vector3(0, 5.3, 0), Vector3(csz.x + 0.04, 0.1, csz.z + 0.04), MET, seedf, Color(0.16, 0.2, 0.28))
		d.box(cp + Vector3(0, 4.58, 0), Vector3(csz.x - 0.3, 0.04, csz.z - 0.3), PAN, seedf, Color(0.86, 0.86, 0.84), 8)
		for lx in 3:
			for lz in 2:
				var lo := Vector3((lx - 1) * csz.x * 0.3, 0, (lz - 0.5) * csz.z * 0.4) if along_x else Vector3((lz - 0.5) * csz.x * 0.4, 0, (lx - 1) * csz.z * 0.3)
				d.box(cp + lo + Vector3(0, 4.53, 0), Vector3(1.3, 0.06, 0.4) if along_x else Vector3(0.4, 0.06, 1.3), MET, seedf, Color(0.95, 0.95, 0.9))
		# piso de concreto em placas de 3 m (modo 7, sem guia: UV.y começa em 0,5)
		var fx := csz.x + 5.0
		var fz := csz.z + 5.0
		var f0 := Vector3(cp.x - fx * 0.5, base + 0.02, cp.z - fz * 0.5)
		var fc := Assets.uv2_code(Assets.L_CONCRETE, 7)
		d.quad(f0, f0 + Vector3(fx, 0, 0), f0 + Vector3(fx, 0, fz), f0 + Vector3(0, 0, fz), Vector3.UP,
			Vector2(0, 0.5), Vector2(fx, 0.5), Vector2(fx, fz + 0.5), Vector2(0, fz + 0.5), fc, 0.95 / 8.0, Color(0.85, 0.84, 0.8))
		for sx: float in [-1.0, 1.0]:
			var off := Vector3(sx * 3.5, 0, 0) if along_x else Vector3(0, 0, sx * 3.5)
			d.box(cp + off + Vector3(0, 2.4, 0), Vector3(0.35, 4.8, 0.35), MET, seedf, Color(0.8, 0.8, 0.8))
			# ilha da bomba com protetores amarelos nas pontas
			var isz := Vector3(1.3, 0.16, 4.2) if along_x else Vector3(4.2, 0.16, 1.3)
			d.box(cp + off * 0.6 + Vector3(0, base - cp.y + 0.1, 0), isz, CON, seedf, Color(0.68, 0.67, 0.64))
			for e: float in [-1.0, 1.0]:
				var eo := Vector3(0, 0, e * 1.85) if along_x else Vector3(e * 1.85, 0, 0)
				d.cylinder(Transform3D(Basis.IDENTITY, Vector3(cp.x, base + 0.18, cp.z) + off * 0.6 + eo), 0.08, 0.85, 8, MET, seedf, Color(0.92, 0.72, 0.1), true)
			d.append(PropLib.buf("gas_pump"), Transform3D(Basis(Vector3.UP, 0.0 if along_x else PI * 0.5), cp + off * 0.6 + Vector3(0, 0.18, 0)))
			d.add_box_collider(cp + off + Vector3(0, 2.4, 0), Vector3(0.35, 4.8, 0.35))
			d.add_box_collider(cp + off * 0.6 + Vector3(0, 0.95, 0), Vector3(0.9, 1.9, 0.9))
	# hospital: marquise da entrada de ambulâncias
	if t in ["hospital", "terminal", "lab", "office"]:
		var cp := _front_point(b, 3.0)
		var along_x := facing == 0 or facing == 2
		var w := 14.0 if t == "terminal" else 8.0
		d.box(cp + Vector3(0, 3.6, 0), Vector3(w, 0.3, 5.0) if along_x else Vector3(5.0, 0.3, w), CON, seedf, Color(0.85, 0.85, 0.85))
		for sx: float in [-1.0, 1.0]:
			var off := Vector3(sx * (w * 0.5 - 0.5), 0, 1.8) if along_x else Vector3(1.8, 0, sx * (w * 0.5 - 0.5))
			if facing == 0:
				off.z = -off.z
			if facing == 3:
				off.x = -off.x
			d.box(cp + off + Vector3(0, 1.8, 0), Vector3(0.3, 3.6, 0.3), CON, seedf, Color(0.8, 0.8, 0.8))
			d.add_box_collider(cp + off + Vector3(0, 1.8, 0), Vector3(0.3, 3.6, 0.3))


## Laje de cobertura: manchas de impermeabilização, condensadoras de ar,
## caixas d'água, dutos, respiros e claraboias — vista de cima (tomadas aéreas,
## mirante) a cidade deixa de ser um tabuleiro de caixas lisas.
static func _roof_clutter(b: Dictionary, d: MeshBuf, top: float, seedf: float, fine: bool = true) -> void:
	var t: String = b["type"]
	var r: Rect2 = b["rect"]
	if r.size.x < 5.0 or r.size.y < 5.0:
		return
	var rng := Util.rng(int(b["seed"]) * 13 + 5)
	var MET := Assets.uv2_code(Assets.L_METAL)
	var CON := Assets.uv2_code(Assets.L_CONCRETE)
	var ROOF := Assets.uv2_code(int(b["roof_layer"]))
	var inner := r.grow(-0.9)
	var c := r.get_center()
	# a casa de máquinas de _details ocupa este canto
	var taken: Array = []
	if t in ["tower", "office", "apartment"]:
		taken.append(Rect2(c.x + r.size.x * 0.2 - 2.4, c.y - 2.2, 4.8, 4.4))
		taken.append(Rect2(c.x - r.size.x * 0.25 - 0.8, c.y + 0.2, 1.6, 1.6))
	var free := func(q: Rect2) -> bool:
		if not inner.encloses(q):
			return false
		for o: Rect2 in taken:
			if o.intersects(q):
				return false
		taken.append(q)
		return true
	var spot := func(sz: Vector2) -> Vector2:
		for k in 8:
			var p := Vector2(rng.randf_range(inner.position.x + sz.x * 0.5, inner.end.x - sz.x * 0.5),
				rng.randf_range(inner.position.y + sz.y * 0.5, inner.end.y - sz.y * 0.5))
			if free.call(Rect2(p - sz * 0.5 - Vector2(0.4, 0.4), sz + Vector2(0.8, 0.8))):
				return p
		return Vector2.INF
	# manchas/remendos da manta (tons diferentes; 5 cm de espessura evita briga de depth de longe)
	for i in rng.randi_range(2, 4):
		var sz := Vector2(rng.randf_range(0.2, 0.5) * r.size.x, rng.randf_range(0.2, 0.5) * r.size.y)
		var p := Vector2(rng.randf_range(inner.position.x + sz.x * 0.5, inner.end.x - sz.x * 0.5),
			rng.randf_range(inner.position.y + sz.y * 0.5, inner.end.y - sz.y * 0.5))
		var k := rng.randf_range(0.72, 1.08)
		# cada remendo numa altura: dois que se cruzam não ficam coplanares
		var ph := 0.04 + i * 0.03
		d.box(Vector3(p.x, top + ph * 0.5, p.y), Vector3(sz.x, ph, sz.y), ROOF, seedf, Color(0.75 * k, 0.74 * k, 0.72 * k), 55)
	var tall := int(b["floors"]) >= 3
	var comm := t in ["commercial", "office", "tower", "hospital", "market", "terminal", "school", "clinic", "police", "lab"]
	# condensadoras de ar em fileira
	if comm or rng.randf() < 0.5:
		var n := rng.randi_range(2, 5 if comm else 3)
		var along_x := rng.randf() < 0.5
		var sz := Vector2(n * 1.5, 1.0) if along_x else Vector2(1.0, n * 1.5)
		var p0: Vector2 = spot.call(sz)
		if p0 != Vector2.INF:
			for i in n:
				var o := (i - (n - 1) * 0.5) * 1.5
				var q := p0 + (Vector2(o, 0) if along_x else Vector2(0, o))
				d.box(Vector3(q.x, top + 0.08, q.y), Vector3(1.2, 0.16, 0.7), MET, seedf, Color(0.4, 0.4, 0.4))
				d.append(PropLib.buf("ac_unit"), Transform3D(Basis(Vector3.UP, 0.0 if along_x else PI * 0.5).scaled(Vector3.ONE * 1.5), Vector3(q.x, top + 0.16, q.y)))
	# central de ar (caixa grande com ventilador) nos comerciais
	if comm and r.size.x > 12.0 and r.size.y > 12.0:
		for i in rng.randi_range(1, 2):
			var p: Vector2 = spot.call(Vector2(3.2, 2.2))
			if p == Vector2.INF:
				continue
			d.box(Vector3(p.x, top + 0.75, p.y), Vector3(3.0, 1.5, 2.0), MET, seedf, Color(0.78, 0.79, 0.78))
			d.cylinder(Transform3D(Basis.IDENTITY, Vector3(p.x - 0.6, top + 1.5, p.y)), 0.55, 0.12, 12, MET, seedf, Color(0.25, 0.26, 0.27))
			d.cylinder(Transform3D(Basis.IDENTITY, Vector3(p.x + 0.8, top + 1.5, p.y)), 0.4, 0.1, 10, MET, seedf, Color(0.25, 0.26, 0.27))
			# duto que desce para dentro da laje
			d.box(Vector3(p.x, top + 0.3, p.y + 1.5), Vector3(0.6, 0.6, 1.0), MET, seedf, Color(0.7, 0.71, 0.7))
	# caixa d'água: de fibra (azul) nos baixos, reservatório de concreto nos altos
	if t not in ["market", "terminal", "warehouse", "stadium"] and rng.randf() < 0.75:
		if tall and r.size.x > 10.0 and r.size.y > 10.0:
			var p: Vector2 = spot.call(Vector2(4.0, 3.4))
			if p != Vector2.INF:
				for sx: float in [-1.4, 1.4]:
					for sz: float in [-1.1, 1.1]:
						d.box(Vector3(p.x + sx, top + 0.6, p.y + sz), Vector3(0.3, 1.2, 0.3), CON, seedf, Color(0.62, 0.62, 0.6))
				d.box(Vector3(p.x, top + 2.2, p.y), Vector3(3.6, 2.0, 3.0), CON, seedf, Color(0.7, 0.69, 0.66))
		else:
			for i in rng.randi_range(1, 2):
				var p: Vector2 = spot.call(Vector2(2.0, 2.0))
				if p != Vector2.INF:
					d.append(PropLib.buf("water_tank"), Transform3D(Basis.IDENTITY.scaled(Vector3.ONE * rng.randf_range(1.2, 1.6)), Vector3(p.x, top, p.y)))
	# claraboias (mercado, terminal, galpões e escolas)
	if t in ["market", "terminal", "school", "warehouse"] or (comm and rng.randf() < 0.3):
		var n := clampi(int(r.size.x / 6.0), 1, 5)
		var wz := c.y + rng.randf_range(-0.2, 0.2) * r.size.y
		for i in n:
			var q := Vector2(r.position.x + r.size.x * (i + 0.5) / n, wz)
			if not free.call(Rect2(q - Vector2(1.4, 1.8), Vector2(2.8, 3.6))):
				continue
			d.box(Vector3(q.x, top + 0.2, q.y), Vector3(2.2, 0.4, 3.0), MET, seedf, Color(0.55, 0.56, 0.57))
			d.box_xf(Transform3D(Basis(Vector3.RIGHT, 0.12), Vector3(q.x, top + 0.47, q.y)), Vector3(2.0, 0.06, 2.8), MET, seedf, Color(0.16, 0.2, 0.24))
	# saída da escada (casinha com porta) quando não há casa de máquinas
	if tall and t not in ["tower", "office", "apartment"]:
		var p: Vector2 = spot.call(Vector2(2.4, 2.2))
		if p != Vector2.INF:
			d.box(Vector3(p.x, top + 1.2, p.y), Vector3(2.2, 2.4, 2.0), CON, seedf, (b["tint"] as Color) * 0.95)
			d.box(Vector3(p.x, top + 1.0, p.y - 1.02), Vector3(0.9, 2.0, 0.05), MET, seedf, Color(0.35, 0.37, 0.4))
	# miúdos (somem de longe: no LOD 1 só cintilariam)
	if not fine:
		return
	# respiros e tubos
	for i in rng.randi_range(2, 6):
		var p: Vector2 = spot.call(Vector2(0.4, 0.4))
		if p == Vector2.INF:
			continue
		var h := rng.randf_range(0.4, 1.1)
		d.cylinder(Transform3D(Basis.IDENTITY, Vector3(p.x, top, p.y)), rng.randf_range(0.06, 0.14), h, 6, MET, seedf, Color(0.5, 0.5, 0.5))
	# parabólica / antena de TV
	if rng.randf() < 0.35:
		var p: Vector2 = spot.call(Vector2(1.2, 1.2))
		if p != Vector2.INF:
			d.cylinder(Transform3D(Basis.IDENTITY, Vector3(p.x, top, p.y)), 0.04, 0.9, 5, MET, seedf, Color(0.45, 0.45, 0.45))
			d.cylinder(Transform3D(Basis(Vector3.RIGHT, -1.0) * Basis(Vector3.UP, rng.randf() * TAU), Vector3(p.x, top + 1.0, p.y)), 0.45, 0.08, 12, MET, seedf, Color(0.82, 0.82, 0.8), true, 0.05)


## Relevo das fachadas (só no LOD 0, mesclado na malha de detalhe do chunk):
## embasamento, pilares de canto, cornija, marquise do térreo comercial,
## sacadas alinhadas às janelas dos residenciais, brises dos escritórios e
## varanda coberta nas casas. Quebra a "caixa lisa" com poucas caixas.
static func _relief(b: Dictionary, d: MeshBuf, col_out: MeshBuf, top: float, seedf: float, fine: bool = true) -> void:
	var t: String = b["type"]
	var r: Rect2 = b["rect"]
	var base: float = b["base"]
	var floors := int(b["floors"])
	var wm := int(b["wmode"])
	var tint: Color = b["tint"]
	var layer := int(b["layer"])
	var plain := Assets.uv2_code(layer, 0)
	var CON := Assets.uv2_code(Assets.L_CONCRETE)
	var MET := Assets.uv2_code(Assets.L_METAL)
	var rng := Util.rng(int(b["seed"]) * 13 + 5)
	var facing := int(b["facing"])
	var di := door_info(b)
	var door_c: Vector3 = di[0]
	var door_w: float = di[2]
	var fh := floor_h(b)
	var big := t in ["apartment", "tower", "office", "hospital", "commercial", "clinic", "school", "police", "lab", "terminal", "market"]
	var house := t in ["house", "farmhouse", "cabin"]
	if not big and not house:
		return
	var light := tint.lightened(0.18)
	var dark := tint.darkened(0.35)
	# lados: [a, b, normal para fora, índice]
	var sides := [
		[Vector2(r.end.x, r.position.y), Vector2(r.position.x, r.position.y), Vector3.FORWARD, 0],
		[Vector2(r.end.x, r.end.y), Vector2(r.end.x, r.position.y), Vector3.RIGHT, 1],
		[Vector2(r.position.x, r.end.y), Vector2(r.end.x, r.end.y), Vector3.BACK, 2],
		[Vector2(r.position.x, r.position.y), Vector2(r.position.x, r.end.y), Vector3.LEFT, 3],
	]
	# --- embasamento (rodapé mais escuro), com vão na porta
	var ph := 0.9 if big else 0.55
	for sd in sides:
		var a: Vector2 = sd[0]
		var e: Vector2 = sd[1]
		var n: Vector3 = sd[2]
		var len := a.distance_to(e)
		var dir := (e - a) / maxf(len, 0.001)
		var spans: Array = [[0.0, len]]
		if int(sd[3]) == facing:
			var du := a.distance_to(Vector2(door_c.x, door_c.z))
			spans = [[0.0, du - door_w * 0.5 - 0.05], [du + door_w * 0.5 + 0.05, len]]
		for sp in spans:
			var u0: float = sp[0]
			var u1: float = sp[1]
			if u1 - u0 < 0.2:
				continue
			var m := a + dir * (u0 + u1) * 0.5
			d.box(Vector3(m.x, base + ph * 0.5 - 0.3, m.y) + n * 0.05, _along(n, u1 - u0, ph + 0.6, 0.12), CON, seedf, dark)
	if house:
		_porch(b, d, col_out, seedf, door_c, di[1], door_w)
		return
	# --- pilares de canto (quebram a aresta da caixa)
	if floors >= 2:
		for cx: float in [r.position.x, r.end.x]:
			for cz: float in [r.position.y, r.end.y]:
				var inx := 1.0 if cx < r.get_center().x else -1.0
				var inz := 1.0 if cz < r.get_center().y else -1.0
				var pc := Vector3(cx + inx * 0.23, (base - 0.4 + top) * 0.5, cz + inz * 0.23)
				d.box(pc, Vector3(0.7, top - base + 0.4, 0.7), plain, seedf, light)
				col_out.add_box_collider(Vector3(pc.x, base + 1.3, pc.z), Vector3(0.7, 2.6, 0.7))
	# --- cornija no topo (telhado plano)
	if str(b["roof"]) != "gable":
		for sd in sides:
			var a: Vector2 = sd[0]
			var e: Vector2 = sd[1]
			var n: Vector3 = sd[2]
			var m := (a + e) * 0.5
			var len := a.distance_to(e)
			d.box(Vector3(m.x, top - 0.18, m.y) + n * 0.16, _along(n, len + 0.64, 0.36, 0.32), plain, seedf, light)
			d.box(Vector3(m.x, top - 0.55, m.y) + n * 0.06, _along(n, len + 0.2, 0.1, 0.12), plain, seedf, light)
	var ch := BuildingGen.cell_h(wm, fh)
	var cw := 3.1 if wm == Assets.WM_RES else (2.4 if wm == Assets.WM_OFFICE else 3.6)
	# --- marquise sobre o térreo (comércio sem toldo de loja)
	var named: bool = str(b["name"]) != "" and wm == Assets.WM_SHOP
	if t in ["commercial", "tower", "apartment", "office", "clinic"] and not named and floors >= 2:
		var sd: Array = sides[facing]
		var a: Vector2 = sd[0]
		var e: Vector2 = sd[1]
		var n: Vector3 = sd[2]
		var m := (a + e) * 0.5
		var len := a.distance_to(e) - 1.4
		var y := base + minf(ch, 3.6) - 0.25
		d.box(Vector3(m.x, y, m.y) + n * 0.85, _along(n, len, 0.16, 1.6), CON, seedf, Color(0.78, 0.77, 0.74))
		d.box(Vector3(m.x, y + 0.1, m.y) + n * 1.62, _along(n, len, 0.42, 0.08), MET, seedf, Color(0.3, 0.32, 0.34))
	if not fine:
		return
	# --- sacadas alinhadas às janelas (residenciais), frente e fundos
	if wm == Assets.WM_RES and t in ["apartment", "tower"] and floors >= 3:
		var every := 2 if rng.randf() < 0.6 else 1
		var solid := rng.randf() < 0.5
		var count := 0
		for si in [facing, (facing + 2) % 4]:
			var sd: Array = sides[si]
			var a: Vector2 = sd[0]
			var e: Vector2 = sd[1]
			var n: Vector3 = sd[2]
			var len := a.distance_to(e)
			var dir := (e - a) / maxf(len, 0.001)
			var rem := fposmod(len, cw)
			var ncell := int(len / cw)
			for k in ncell:
				if k % every != (1 if every == 2 else 0) or k == 0 or k == ncell - 1:
					continue
				var u := rem * 0.5 + (k + 0.5) * cw
				var m := a + dir * u
				for f in range(1, floors):
					if count >= 64:
						break
					count += 1
					var y := base + f * ch
					var c0 := Vector3(m.x, y, m.y)
					# laje, peitoril frontal e laterais
					d.box(c0 + n * 0.55 + Vector3(0, -0.06, 0), _along(n, 2.5, 0.14, 1.1), CON, seedf, Color(0.8, 0.79, 0.76))
					if solid:
						d.box(c0 + n * 1.07 + Vector3(0, 0.45, 0), _along(n, 2.5, 0.9, 0.08), plain, seedf, light)
					else:
						d.box(c0 + n * 1.07 + Vector3(0, 0.92, 0), _along(n, 2.5, 0.05, 0.06), MET, seedf, Color(0.25, 0.26, 0.27))
						d.box(c0 + n * 1.07 + Vector3(0, 0.45, 0), _along(n, 2.46, 0.8, 0.02), MET, seedf, Color(0.35, 0.37, 0.4, 1.0))
					for sx: float in [-1.0, 1.0]:
						d.box(c0 + n * 0.55 + Vector3(dir.x, 0, dir.y) * (1.21 * sx) + Vector3(0, 0.45, 0), _along(n, 0.08, 0.9, 1.1), plain if solid else MET, seedf, light if solid else Color(0.25, 0.26, 0.27))
					_balcony_life(d, rng, c0 + Vector3(0, 0.01, 0), n, Vector3(dir.x, 0, dir.y), seedf)
	# --- peitoris sob as janelas dos residenciais (sombra marcada em cada janela)
	if wm == Assets.WM_RES:
		var sills := 0
		for sd in sides:
			var a: Vector2 = sd[0]
			var e: Vector2 = sd[1]
			var n: Vector3 = sd[2]
			var len := a.distance_to(e)
			var dir := (e - a) / maxf(len, 0.001)
			var rem := fposmod(len, cw)
			for k in int(len / cw):
				var m := a + dir * (rem * 0.5 + (k + 0.5) * cw)
				for f in floors:
					if sills >= 260:
						break
					sills += 1
					var y := base + f * ch + 0.3 * ch - 0.05
					d.box(Vector3(m.x, y, m.y) + n * 0.09, _along(n, 1.62, 0.09, 0.18), CON, seedf, Color(0.82, 0.81, 0.78))
					# verga sobre a janela
					d.box(Vector3(m.x, base + f * ch + 0.86 * ch, m.y) + n * 0.04, _along(n, 1.5, 0.12, 0.08), plain, seedf, light)
	# --- térreo comercial: montantes entre as vitrines e faixa de letreiro
	if wm == Assets.WM_SHOP:
		var band_col := Color.from_hsv(rng.randf(), 0.35, 0.42)
		for sd in sides:
			var a: Vector2 = sd[0]
			var e: Vector2 = sd[1]
			var n: Vector3 = sd[2]
			var len := a.distance_to(e)
			var dir := (e - a) / maxf(len, 0.001)
			var rem := fposmod(len, cw)
			var m0 := (a + e) * 0.5
			d.box(Vector3(m0.x, base + 3.12, m0.y) + n * 0.1, _along(n, len, 0.5, 0.2), plain, seedf, band_col if int(sd[3]) == facing else dark.lightened(0.1))
			for k in range(0, int(len / cw) + 1):
				var m := a + dir * (rem * 0.5 + k * cw)
				if int(sd[3]) == facing and absf(a.distance_to(m) - a.distance_to(Vector2(door_c.x, door_c.z))) < door_w * 0.5 + 0.2:
					continue
				d.box(Vector3(m.x, base + 1.45, m.y) + n * 0.08, _along(n, 0.24, 2.9, 0.16), plain, seedf, dark.lightened(0.15))
	# --- brises verticais nos escritórios (acima do térreo)
	if wm == Assets.WM_OFFICE and floors >= 3 and layer != Assets.L_BRICK:
		for sd in sides:
			var a: Vector2 = sd[0]
			var e: Vector2 = sd[1]
			var n: Vector3 = sd[2]
			var len := a.distance_to(e)
			var dir := (e - a) / maxf(len, 0.001)
			var rem := fposmod(len, cw)
			var ncell := int(len / cw)
			var y0 := base + ch
			var hh := top - 0.6 - y0
			for k in range(1, ncell):
				var m := a + dir * (rem * 0.5 + k * cw)
				d.box(Vector3(m.x, y0 + hh * 0.5, m.y) + n * 0.26, _along(n, 0.2, hh, 0.52), plain, seedf, light)


## Kit de fachada com geometria de verdade (antes era só o desenho do shader):
## caixilho de alumínio com montante em cada janela, grades de ferro no térreo
## das casas e prédios baixos, janelas fechadas com tábuas (abandono), portas de
## aço de enrolar nas lojas (abertas, a meio ou fechadas), calhas e condutores
## de água nos cantos, escada de incêndio nos prédios de tijolo e antenas
## parabólicas. Só no LOD 0; contagem limitada por prédio.
static func _facade_kit(b: Dictionary, d: MeshBuf, col_out: MeshBuf, top: float, seedf: float) -> void:
	var t: String = b["type"]
	var r: Rect2 = b["rect"]
	var base: float = b["base"]
	var floors := int(b["floors"])
	var wm := int(b["wmode"])
	var layer := int(b["layer"])
	var facing := int(b["facing"])
	var rng := Util.rng(int(b["seed"]) * 29 + 3)
	var MET := Assets.uv2_code(Assets.L_METAL)
	var WOOD := Assets.uv2_code(Assets.L_WOOD)
	var CON := Assets.uv2_code(Assets.L_CONCRETE)
	var fh := floor_h(b)
	var ch := cell_h(wm, fh)
	var di := door_info(b)
	var door_c: Vector3 = di[0]
	var door_w: float = di[2]
	var house := t in ["house", "farmhouse", "cabin"]
	var sides := [
		[Vector2(r.end.x, r.position.y), Vector2(r.position.x, r.position.y), Vector3.FORWARD, 0],
		[Vector2(r.end.x, r.end.y), Vector2(r.end.x, r.position.y), Vector3.RIGHT, 1],
		[Vector2(r.position.x, r.end.y), Vector2(r.end.x, r.end.y), Vector3.BACK, 2],
		[Vector2(r.position.x, r.position.y), Vector2(r.position.x, r.end.y), Vector3.LEFT, 3],
	]
	# cor do caixilho do prédio: alumínio natural, branco, preto ou madeira
	var frame_cols := [Color(0.62, 0.63, 0.64), Color(0.82, 0.82, 0.8), Color(0.13, 0.13, 0.14), Color(0.36, 0.25, 0.17)]
	var fcol: Color = frame_cols[rng.randi() % frame_cols.size()]
	var fcode := WOOD if fcol.r < 0.4 and fcol.g < 0.3 else MET
	var bars_col := Color(0.16, 0.16, 0.17) if rng.randf() < 0.6 else Color(0.85, 0.85, 0.83)
	var budget := 150
	if wm == Assets.WM_RES or wm == Assets.WM_OFFICE or wm == Assets.WM_SHOP:
		var cw := 3.1 if wm == Assets.WM_RES else (2.4 if wm == Assets.WM_OFFICE else 3.6)
		var wx := Vector2(0.28, 0.72) if wm == Assets.WM_RES else Vector2(0.1, 0.9)
		var wy := Vector2(0.3, 0.84) if wm == Assets.WM_RES else Vector2(0.24, 0.86)
		var max_f := mini(floors, 7)
		for sd in sides:
			var a: Vector2 = sd[0]
			var e: Vector2 = sd[1]
			var n: Vector3 = sd[2]
			var si: int = sd[3]
			# fachada da frente e dos fundos completas; laterais só nos baixos
			if si != facing and si != (facing + 2) % 4 and floors > 3:
				continue
			var len := a.distance_to(e)
			var dir := (e - a) / maxf(len, 0.001)
			var rem := fposmod(len, cw)
			var back_face := _back_face(n)
			for k in int(len / cw):
				var u := rem * 0.5 + (k + 0.5) * cw
				var m := a + dir * u
				var on_door := si == facing and absf(u - a.distance_to(Vector2(door_c.x, door_c.z))) < door_w * 0.5 + cw * 0.5
				for f in max_f:
					if budget <= 0:
						break
					var shop_floor := wm == Assets.WM_SHOP and f == 0
					if on_door and f == 0:
						continue
					var x0 := (wx.x if not shop_floor else 0.06) * cw
					var x1 := (wx.y if not shop_floor else 0.94) * cw
					var y0 := base + f * ch + (wy.x if not shop_floor else 0.08) * ch
					var y1 := base + f * ch + (wy.y if not shop_floor else 0.78) * ch
					var ww := x1 - x0
					var wh := y1 - y0
					var c0 := Vector3(m.x, (y0 + y1) * 0.5, m.y)
					budget -= 1
					if shop_floor:
						# porta de aço de enrolar: caixa no alto + lâmina abaixada até h
						var state := rng.randf()
						d.box(c0 + Vector3(0, wh * 0.5 + 0.14, 0) + n * 0.14, _along(n, ww + 0.1, 0.28, 0.26), MET, seedf, Color(0.42, 0.43, 0.42), back_face)
						if state < 0.7:
							var drop := wh if state < 0.35 else wh * rng.randf_range(0.25, 0.7)
							var sc := Color.from_hsv([0.0, 0.33, 0.58, 0.08][rng.randi() % 4], rng.randf_range(0.05, 0.3), rng.randf_range(0.35, 0.6))
							d.box(c0 + Vector3(0, wh * 0.5 - drop * 0.5, 0) + n * 0.07, _along(n, ww, drop, 0.04), MET, seedf, sc, back_face)
							# guias laterais
							for sx: float in [-1.0, 1.0]:
								d.box(c0 + Vector3(dir.x, 0, dir.y) * (ww * 0.5 + 0.03) * sx + n * 0.06, _along(n, 0.06, wh, 0.1), MET, seedf, Color(0.35, 0.36, 0.36), back_face)
						continue
					# caixilho: dois batentes, verga, montante central
					for sx: float in [-1.0, 1.0]:
						d.box(c0 + Vector3(dir.x, 0, dir.y) * ((ww * 0.5 + 0.03) * sx) + n * 0.035, _along(n, 0.06, wh + 0.06, 0.07), fcode, seedf, fcol, back_face)
					d.box(c0 + Vector3(0, wh * 0.5 + 0.03, 0) + n * 0.035, _along(n, ww + 0.12, 0.06, 0.07), fcode, seedf, fcol, back_face)
					d.box(c0 + n * 0.02, _along(n, 0.045, wh, 0.04), fcode, seedf, fcol, back_face)
					if wm == Assets.WM_RES:
						d.box(c0 + Vector3(0, wh * 0.18, 0) + n * 0.02, _along(n, ww, 0.04, 0.035), fcode, seedf, fcol, back_face)
					# abandono: tábuas pregadas por cima de algumas janelas
					var boarded := rng.randf() < (0.16 if f <= 1 else 0.05)
					if boarded:
						var nb := rng.randi_range(3, 5)
						for bi in nb:
							var by := c0.y - wh * 0.42 + (wh * 0.84) * float(bi) / float(nb - 1)
							var tilt := rng.randf_range(-0.12, 0.12)
							var bxf := Transform3D(Basis(n, tilt) * _wall_basis(n), Vector3(m.x, by, m.y) + n * 0.09)
							d.box_xf(bxf, Vector3(ww + 0.3, 0.17, 0.025), WOOD, seedf, Color(0.5, 0.4, 0.3).darkened(rng.randf() * 0.3))
					# grades de ferro no térreo (casas e prédios baixos)
					elif f == 0 and (house or floors <= 4) and rng.randf() < 0.75:
						var nbar := int(ww / 0.13)
						for bi in nbar + 1:
							var bu := -ww * 0.5 + ww * float(bi) / float(nbar)
							d.box(c0 + Vector3(dir.x, 0, dir.y) * bu + n * 0.1, _along(n, 0.022, wh + 0.1, 0.022), MET, seedf, bars_col, 63)
						for hy: float in [-0.46, 0.0, 0.46]:
							d.box(c0 + Vector3(0, wh * hy, 0) + n * 0.1, _along(n, ww + 0.04, 0.03, 0.03), MET, seedf, bars_col, 63)
						# chumbadores até a parede
						for sx: float in [-1.0, 1.0]:
							d.box(c0 + Vector3(dir.x, 0, dir.y) * ((ww * 0.5) * sx) + n * 0.055, _along(n, 0.03, wh, 0.11), MET, seedf, bars_col, back_face)
	# calhas e condutores de água nos cantos dos fundos
	if house or t in ["apartment", "commercial", "school", "clinic", "police", "market"]:
		var back := (facing + 2) % 4
		var bsd: Array = sides[back]
		var ba: Vector2 = bsd[0]
		var be: Vector2 = bsd[1]
		var bn: Vector3 = bsd[2]
		var pc := Color(0.75, 0.75, 0.73) if rng.randf() < 0.5 else Color(0.3, 0.3, 0.3)
		for corner: Vector2 in [ba, be]:
			var inward := ((be if corner == ba else ba) - corner).normalized()
			var p := Vector3(corner.x + inward.x * 0.25, 0, corner.y + inward.y * 0.25) + bn * 0.09
			d.tube(Vector3(p.x, base + 0.05, p.z), Vector3(p.x, top - 0.1, p.z), 0.05, 0.05, 6, MET, seedf, pc, false)
			d.tube(Vector3(p.x, base + 0.05, p.z), Vector3(p.x, base + 0.05, p.z) + bn * 0.25, 0.05, 0.05, 6, MET, seedf, pc, true)
		if str(b["roof"]) == "gable":
			var m := (ba + be) * 0.5
			d.box(Vector3(m.x, top - 0.02, m.y) + bn * 0.55, _along(bn, ba.distance_to(be) + 0.9, 0.12, 0.14), MET, seedf, pc)
	# escada de incêndio (prédios de tijolo de 3+ andares)
	if layer == Assets.L_BRICK and floors >= 3 and t in ["apartment", "commercial", "tower"] and rng.randf() < 0.7:
		var si := (facing + 1 + (rng.randi() % 2) * 2) % 4
		var sd: Array = sides[si]
		var a: Vector2 = sd[0]
		var e: Vector2 = sd[1]
		var n: Vector3 = sd[2]
		var len := a.distance_to(e)
		if len > 8.0:
			var dir := (e - a) / len
			var u := len * rng.randf_range(0.3, 0.7)
			var m := a + dir * u
			var dk := Color(0.12, 0.12, 0.12)
			var wl := 3.4
			for f in range(1, mini(floors, 8)):
				var y := base + f * ch - 0.05
				var c0 := Vector3(m.x, y, m.y) + n * 0.6
				# patamar de grade, guarda-corpo, escada até o de baixo
				d.box(c0, _along(n, wl, 0.05, 1.2), MET, seedf, dk)
				d.box(c0 + n * 0.58 + Vector3(0, 0.5, 0), _along(n, wl, 0.04, 0.04), MET, seedf, dk)
				d.box(c0 + n * 0.58 + Vector3(0, 0.25, 0), _along(n, wl, 0.03, 0.03), MET, seedf, dk)
				for sx: float in [-1.0, 1.0]:
					d.box(c0 + Vector3(dir.x, 0, dir.y) * (wl * 0.5 * sx) + Vector3(0, 0.25, 0) + n * 0.3, _along(n, 0.04, 0.5, 1.2), MET, seedf, dk)
				var flip := 1.0 if f % 2 == 0 else -1.0
				var s0 := c0 + Vector3(dir.x, 0, dir.y) * (wl * 0.25 * flip) + n * 0.15
				var s1 := s0 + Vector3(dir.x, 0, dir.y) * (wl * 0.45 * -flip) + Vector3(0, -ch + 0.05, 0)
				if f > 1:
					d.tube(s0, s1, 0.03, 0.03, 4, MET, seedf, dk, false)
					d.tube(s0 + n * 0.55, s1 + n * 0.55, 0.03, 0.03, 4, MET, seedf, dk, false)
					var steps := 9
					for st in steps:
						var q := s0.lerp(s1, (st + 0.5) / steps) + n * 0.27
						d.box(q, _along(n, 0.26, 0.03, 0.55), MET, seedf, dk)
				else:
					# escada de marinheiro recolhida
					d.box(c0 + Vector3(0, -1.0, 0) + n * 0.4, _along(n, 0.5, 1.8, 0.04), MET, seedf, dk)
	# antenas parabólicas (casas e prédios residenciais)
	if (house or t == "apartment") and rng.randf() < 0.55:
		var sd: Array = sides[rng.randi() % 4]
		var a: Vector2 = sd[0]
		var e: Vector2 = sd[1]
		var n: Vector3 = sd[2]
		var p := a.lerp(e, rng.randf_range(0.2, 0.8))
		var y := top - 0.6 if house else base + rng.randi_range(1, maxi(1, floors - 1)) * ch + 1.9
		var c0 := Vector3(p.x, y, p.y) + n * 0.35
		d.tube(c0 - n * 0.3, c0, 0.02, 0.02, 4, MET, seedf, Color(0.5, 0.5, 0.5), false)
		var dish := Transform3D(Basis.looking_at(-(n + Vector3(0, 0.45, 0)).normalized(), Vector3.UP) * Basis(Vector3.RIGHT, PI * 0.5), c0)
		d.cylinder(dish, 0.04, 0.12, 12, MET, seedf, Color(0.85, 0.85, 0.84), true, 0.32)


## O que os moradores deixaram na sacada (piso em `fl`, n para fora, side ao
## longo da parede): vasos, varal com roupa, cadeira de plástico ou a
## condensadora do ar-condicionado. Muitas ficam vazias.
static func _balcony_life(d: MeshBuf, rng: RandomNumberGenerator, fl: Vector3, n: Vector3, side: Vector3, seedf: float) -> void:
	var wb := _wall_basis(n)
	var lk := rng.randf()
	if lk < 0.28:
		for i in rng.randi_range(1, 3):
			d.append(PropLib.buf("plant_pot"), Transform3D(wb.scaled(Vector3.ONE * rng.randf_range(0.7, 1.1)), fl + n * 0.82 + side * rng.randf_range(-0.95, 0.95)))
	elif lk < 0.5:
		# varal: arame de lado a lado e peças de roupa penduradas
		var ly := 1.78
		var MET := Assets.uv2_code(Assets.L_METAL)
		var FAB := Assets.uv2_code(Assets.L_FABRIC)
		var p0 := fl + n * 0.62 + Vector3(0, ly, 0)
		d.tube(p0 - side * 1.17, p0 + side * 1.17, 0.006, 0.006, 3, MET, seedf, Color(0.6, 0.6, 0.6), false)
		var u := -1.05
		while u < 0.85:
			var cw := rng.randf_range(0.28, 0.55)
			var chh := rng.randf_range(0.35, 0.75)
			var col := Color.from_hsv(rng.randf(), rng.randf_range(0.15, 0.7), rng.randf_range(0.3, 0.85))
			d.box_xf(Transform3D(wb * Basis(Vector3.UP, rng.randf_range(-0.12, 0.12)), p0 + side * (u + cw * 0.5) - Vector3(0, chh * 0.5, 0)), Vector3(cw, chh, 0.012), FAB, seedf, col)
			u += cw + rng.randf_range(0.05, 0.3)
	elif lk < 0.62:
		d.append(PropLib.buf("chair"), Transform3D(wb * Basis(Vector3.UP, rng.randf_range(-0.7, 0.7)), fl + n * 0.6 + side * rng.randf_range(-0.8, 0.8)))
	elif lk < 0.74:
		d.append(PropLib.buf("ac_unit"), Transform3D(wb, fl + n * 0.3 + side * (0.75 if rng.randf() < 0.5 else -0.75)))


## Igreja matriz colonial: duas torres com sineira aberta (sino dentro) e
## coruchéu, frontão barroco com óculo e cruz cobrindo a empena do telhado,
## cunhais, cimalha e embasamento na cor da cantaria, portada com arco e
## tímpano de madeira, janelas do coro com sacada, janelões em arco nas laterais
## e adro de pedra. relief: 2 completo, 1 sem os miúdos, 0 só a silhueta
## (torres, frontão, coruchéus) para o LOD distante.
static func _church(b: Dictionary, d: MeshBuf, top: float, seedf: float, relief: int) -> void:
	var r: Rect2 = b["rect"]
	var base: float = b["base"]
	var tint: Color = b["tint"]
	var rng := Util.rng(int(b["seed"]) * 17 + 11)
	var di := door_info(b)
	var dc: Vector3 = di[0]
	var n: Vector3 = di[1]
	var door_w: float = di[2]
	var dh := door_height(b)
	# referencial da fachada: x ao longo (direita de quem olha de fora), y para
	# cima a partir da base, z para fora da parede
	var sd := Vector3.UP.cross(n)
	var front_x := absf(n.x) > 0.5
	var W := r.size.y if front_x else r.size.x
	var L := r.size.x if front_x else r.size.y
	var H := top - base
	var F := Transform3D(Basis(sd, Vector3.UP, n), Vector3(dc.x, base, dc.z))
	var PL := Assets.uv2_code(int(b["layer"]))
	var CON := Assets.uv2_code(Assets.L_CONCRETE)
	var WOOD := Assets.uv2_code(Assets.L_WOOD)
	var MET := Assets.uv2_code(Assets.L_METAL)
	var ROOF := Assets.uv2_code(Assets.L_ROOF)
	var trim: Color = [Color(0.68, 0.56, 0.38), Color(0.42, 0.52, 0.64), Color(0.58, 0.56, 0.52)][rng.randi() % 3]
	var shut: Color = [Color(0.17, 0.32, 0.22), Color(0.16, 0.26, 0.42), Color(0.34, 0.2, 0.1)][rng.randi() % 3]
	var tw := clampf(W * 0.2, 3.2, 4.2)
	var T1 := 6.0
	var Hb := 3.4
	var ue := W * 0.5 - tw
	var fine := relief >= 2
	var lbox := func(c: Vector3, s: Vector3, code: float, col: Color) -> void:
		d.box_xf(Transform3D(F.basis, F * c), s, code, seedf, col)
	# --- torres: fuste acima da cimalha (dentro do retângulo: o térreo delas é a
	# própria parede da nave), sineira aberta, cimalha, coruchéu e cruz
	var v0 := H + T1
	for sgn: float in [-1.0, 1.0]:
		var tu := sgn * (W * 0.5 - tw * 0.5)
		lbox.call(Vector3(tu, H + T1 * 0.5, -tw * 0.5), Vector3(tw, T1, tw), PL, tint)
		var tcw: Vector3 = F * Vector3(tu, 0.0, -tw * 0.5)
		# piso da sineira e cimalha do fuste
		lbox.call(Vector3(tu, v0 + 0.12, -tw * 0.5), Vector3(tw + 0.36, 0.24, tw + 0.36), PL, trim)
		var pw := 0.72
		for cx: float in [-1.0, 1.0]:
			for cz: float in [-1.0, 1.0]:
				lbox.call(Vector3(tu + cx * (tw - pw) * 0.5, v0 + Hb * 0.5, -tw * 0.5 + cz * (tw - pw) * 0.5), Vector3(pw, Hb, pw), PL, tint)
		# arcos da sineira nas quatro faces (verga com o arco recortado)
		var a := tw - 2.0 * pw
		var hl := a * 0.5 + 0.45
		var lint := PackedVector2Array([Vector2(-tw * 0.5, 0.0)])
		for i in 13:
			var ang := PI - PI * float(i) / 12.0
			lint.append(Vector2(cos(ang) * a * 0.5, sin(ang) * a * 0.5))
		lint.append_array(PackedVector2Array([Vector2(tw * 0.5, 0.0), Vector2(tw * 0.5, hl), Vector2(-tw * 0.5, hl)]))
		for fn: Vector3 in [n, -n, sd, -sd]:
			var fo := tcw + fn * (tw * 0.5) + Vector3(0.0, v0 + Hb - hl, 0.0)
			d.extrude(lint, -pw, 0.0, Transform3D(Basis(Vector3.UP.cross(fn), Vector3.UP, fn), fo), PL, seedf, tint)
		# sino de bronze pendurado na viga
		var bell_top := v0 + Hb - hl - 0.1
		lbox.call(Vector3(tu, bell_top, -tw * 0.5), Vector3(tw - 0.2, 0.16, 0.16), WOOD, Color(0.3, 0.22, 0.15))
		d.cylinder(Transform3D(Basis.IDENTITY, tcw + Vector3(0.0, bell_top - 0.85, 0.0)), 0.48, 0.78, 14, MET, seedf, Color(0.5, 0.36, 0.16), true, 0.24)
		# cimalha da sineira, coruchéu de telha, pináculos nos cantos e cruz
		lbox.call(Vector3(tu, v0 + Hb + 0.18, -tw * 0.5), Vector3(tw + 0.5, 0.36, tw + 0.5), PL, trim)
		var roof_h := 3.2
		d.cylinder(Transform3D(Basis(Vector3.UP, PI * 0.25), tcw + Vector3(0.0, v0 + Hb + 0.36, 0.0)), (tw * 0.5 + 0.1) * sqrt(2.0), roof_h, 4, ROOF, seedf, Color(0.95, 0.92, 0.9), false, 0.04)
		var tip := tcw + Vector3(0.0, v0 + Hb + 0.36 + roof_h, 0.0)
		d.cylinder(Transform3D(Basis.IDENTITY, tip - Vector3(0, 0.1, 0)), 0.16, 0.35, 8, MET, seedf, Color(0.55, 0.45, 0.25), true, 0.05)
		d.box(tip + Vector3(0, 0.85, 0), Vector3(0.07, 1.3, 0.07), MET, seedf, Color(0.25, 0.24, 0.22))
		d.box_xf(Transform3D(F.basis, tip + Vector3(0, 1.1, 0)), Vector3(0.6, 0.07, 0.07), MET, seedf, Color(0.25, 0.24, 0.22))
		if relief >= 1:
			for cx: float in [-1.0, 1.0]:
				for cz: float in [-1.0, 1.0]:
					var pc: Vector3 = F * Vector3(tu + cx * (tw * 0.5 + 0.05), v0 + Hb + 0.36, -tw * 0.5 + cz * (tw * 0.5 + 0.05))
					d.box(pc + Vector3(0, 0.15, 0), Vector3(0.36, 0.3, 0.36), PL, seedf, trim)
					d.cylinder(Transform3D(Basis(Vector3.UP, PI * 0.25), pc + Vector3(0, 0.3, 0)), 0.2, 0.9, 4, PL, seedf, trim, false, 0.02)
			# cunhais do fuste (os quatro cantos)
			for cx: float in [-1.0, 1.0]:
				for cz: float in [-1.0, 1.0]:
					lbox.call(Vector3(tu + cx * (tw * 0.5 - 0.17), H + T1 * 0.5, -tw * 0.5 + cz * (tw * 0.5 - 0.17)), Vector3(0.5, T1, 0.5), PL, trim)
			# janelinha em arco na frente de cada torre, no térreo
			_arch_window(d, F * Transform3D(Basis.IDENTITY, Vector3(tu, H * 0.68, 0.0)), 0.8, 0.9, shut, trim, seedf, fine)
			# óculo no fuste
			var oc: Vector3 = F * Vector3(tu, H + T1 * 0.55, 0.0)
			d.tube(oc, oc + n * 0.16, 0.55, 0.55, 14, PL, seedf, trim, true)
			d.tube(oc, oc + n * 0.2, 0.38, 0.38, 14, MET, seedf, Color(0.06, 0.06, 0.07), true)
	# --- frontão barroco entre as torres, cobrindo a empena do telhado
	var gable_front := (r.size.x >= r.size.y) == front_x
	var rise := W * (0.18 if int(b["roof_layer"]) == Assets.L_METAL else 0.32)
	var hb := 1.0
	var ha := 4.6
	if gable_front:
		ha = maxf(ha, rise + 0.7)
	var prof := PackedVector2Array([Vector2(-ue, H), Vector2(ue, H)])
	var band := PackedVector2Array()
	var tops: Array[Vector2] = []
	var N := 28
	for i in N + 1:
		var u := ue - 2.0 * ue * float(i) / float(N)
		var t := 1.0 - absf(u) / ue
		var s := pow(smoothstep(0.0, 1.0, t), 0.8)
		var f := hb + (ha - hb) * s + 0.4 * exp(-pow((t - 0.1) / 0.06, 2.0))
		if t > 0.94:
			f = hb + (ha - hb) * pow(smoothstep(0.0, 1.0, 0.94), 0.8)
		if gable_front:
			f = maxf(f, rise * (1.0 - absf(u) / (W * 0.5 + CHURCH_EAVE)) + 0.35)
		tops.append(Vector2(u, H + f))
		prof.append(Vector2(u, H + f))
	d.extrude(prof, -0.3, 0.3, F, PL, seedf, tint)
	# moldura do contorno (faixa na cor da cantaria, saliente)
	for p in tops:
		band.append(p + Vector2(0.0, 0.3))
	for i in range(tops.size() - 1, -1, -1):
		band.append(tops[i] - Vector2(0.0, 0.02))
	d.extrude(band, -0.35, 0.42, F, PL, seedf, trim)
	var apex: float = tops[int(N * 0.5)].y + 0.3
	# cruz de pedra no alto do frontão
	lbox.call(Vector3(0.0, apex + 0.2, 0.1), Vector3(0.6, 0.4, 0.6), PL, trim)
	lbox.call(Vector3(0.0, apex + 1.2, 0.1), Vector3(0.16, 1.6, 0.16), PL, trim)
	lbox.call(Vector3(0.0, apex + 1.45, 0.1), Vector3(0.9, 0.16, 0.16), PL, trim)
	# óculo do coro no frontão
	var ov := H + minf(ha * 0.45, apex - H - 1.4)
	d.tube(F * Vector3(0.0, ov, 0.25), F * Vector3(0.0, ov, 0.48), 0.95, 0.95, 18, PL, seedf, trim, true)
	d.tube(F * Vector3(0.0, ov, 0.25), F * Vector3(0.0, ov, 0.52), 0.68, 0.68, 18, MET, seedf, Color(0.05, 0.05, 0.06), true)
	# --- cimalha e embasamento em volta da nave
	var cx0 := r.position.x
	var cx1 := r.end.x
	var cz0 := r.position.y
	var cz1 := r.end.y
	var sides := [
		[Vector2(cx1, cz0), Vector2(cx0, cz0), Vector3.FORWARD],
		[Vector2(cx1, cz1), Vector2(cx1, cz0), Vector3.RIGHT],
		[Vector2(cx0, cz1), Vector2(cx1, cz1), Vector3.BACK],
		[Vector2(cx0, cz0), Vector2(cx0, cz1), Vector3.LEFT],
	]
	for sdd in sides:
		var a2: Vector2 = sdd[0]
		var e2: Vector2 = sdd[1]
		var ns: Vector3 = sdd[2]
		var m := (a2 + e2) * 0.5
		var len := a2.distance_to(e2)
		d.box(Vector3(m.x, base + H - 0.17, m.y) + ns * 0.17, _along(ns, len + 0.6, 0.34, 0.34), PL, seedf, trim)
		if relief >= 1:
			d.box(Vector3(m.x, base + H - 0.48, m.y) + ns * 0.08, _along(ns, len + 0.3, 0.12, 0.16), PL, seedf, trim)
			if ns.dot(n) < 0.5:
				d.box(Vector3(m.x, base + 0.2, m.y) + ns * 0.07, _along(ns, len + 0.2, 0.8, 0.14), PL, seedf, trim.darkened(0.25))
	if relief < 1:
		return
	# cunhais da nave (cantos) e pilastras nas bordas das torres
	for c2: Vector2 in [Vector2(cx0, cz0), Vector2(cx1, cz0), Vector2(cx0, cz1), Vector2(cx1, cz1)]:
		var ox := -1.0 if c2.x < r.get_center().x else 1.0
		var oz := -1.0 if c2.y < r.get_center().y else 1.0
		d.box(Vector3(c2.x + ox * 0.14, base + H * 0.5, c2.y + oz * 0.14), Vector3(0.6, H, 0.6), PL, seedf, trim)
	for sgn: float in [-1.0, 1.0]:
		lbox.call(Vector3(sgn * ue, H * 0.5, 0.07), Vector3(0.5, H, 0.14), PL, trim)
	# embasamento da fachada (com o vão da porta)
	var gap := door_w * 0.5 + 0.45
	for sgn: float in [-1.0, 1.0]:
		var wpart := W * 0.5 - gap
		lbox.call(Vector3(sgn * (gap + wpart * 0.5), 0.2, 0.07), Vector3(wpart, 0.8, 0.14), PL, trim.darkened(0.25))
	# --- portada: ombreiras de pedra, arco com fecho, tímpano de madeira e cornija
	var stone := trim.lightened(0.12)
	for sgn: float in [-1.0, 1.0]:
		lbox.call(Vector3(sgn * (door_w * 0.5 + 0.2), dh * 0.5, 0.1), Vector3(0.4, dh, 0.2), CON, stone)
	var tymp := PackedVector2Array()
	for i in 17:
		var ang := PI * float(i) / 16.0
		tymp.append(Vector2(cos(ang) * door_w * 0.5, dh + sin(ang) * door_w * 0.5))
	d.extrude(tymp, -0.05, 0.04, F, WOOD, seedf, shut.darkened(0.35))
	_arch_ring(d, F, Vector2(0.0, dh), door_w * 0.5 + 0.2, 0.4, 0.0, 0.22, CON, stone, seedf, 12)
	lbox.call(Vector3(0.0, dh + door_w * 0.5 + 0.32, 0.13), Vector3(0.36, 0.5, 0.26), CON, stone)
	lbox.call(Vector3(0.0, dh + door_w * 0.5 + 0.72, 0.15), Vector3(door_w + 1.8, 0.24, 0.3), CON, stone)
	# --- janelas do coro com sacada de ferro
	var nwin := 3 if ue > 4.6 else 2
	var sill := H * 0.55
	for k in nwin:
		var wu := (float(k) - (nwin - 1) * 0.5) * (2.3 if nwin == 3 else 2.6)
		_arch_window(d, F * Transform3D(Basis.IDENTITY, Vector3(wu, sill, 0.0)), 1.1, 1.6, shut, trim, seedf, fine)
		if fine:
			lbox.call(Vector3(wu, sill - 0.08, 0.32), Vector3(1.7, 0.12, 0.64), CON, stone)
			var iron := Color(0.1, 0.1, 0.1)
			lbox.call(Vector3(wu, sill + 0.9, 0.6), Vector3(1.66, 0.05, 0.05), MET, iron)
			lbox.call(Vector3(wu, sill + 0.12, 0.6), Vector3(1.66, 0.04, 0.04), MET, iron)
			for bi in 13:
				lbox.call(Vector3(wu - 0.78 + bi * 0.13, sill + 0.5, 0.6), Vector3(0.025, 0.78, 0.025), MET, iron)
	# --- janelões em arco nas laterais da nave
	for sgn: float in [-1.0, 1.0]:
		var ns := sd * sgn
		var G := Transform3D(Basis(Vector3.UP.cross(ns), Vector3.UP, ns), Vector3(dc.x, base, dc.z) + ns * (W * 0.5))
		var count := int((L - tw - 6.0) / 5.0) + 1
		for k in count:
			var s := tw + 3.0 + float(k) * 5.0
			# s = distância da fachada para trás (o eixo x do lado aponta para frente ou para trás)
			var lx := (Vector3.UP.cross(ns)).dot(-n) * s
			_arch_window(d, G * Transform3D(Basis.IDENTITY, Vector3(lx, 3.6, 0.0)), 1.3, 2.8, shut, trim, seedf, fine)
	# --- adro de pedra diante da fachada
	if fine:
		lbox.call(Vector3(0.0, -0.1, 1.6), Vector3(W + 1.0, 0.26, 3.2), CON, Color(0.62, 0.6, 0.56))
		lbox.call(Vector3(0.0, -0.08, 3.25), Vector3(W + 1.2, 0.22, 0.12), CON, Color(0.5, 0.49, 0.46))


## Contorno de vão com arco pleno (anti-horário, base em y = 0): retângulo de
## largura w até hs e semicírculo em cima.
static func _arch_poly(w: float, hs: float, seg: int = 12) -> PackedVector2Array:
	var p := PackedVector2Array([Vector2(-w * 0.5, 0.0), Vector2(w * 0.5, 0.0)])
	for i in seg + 1:
		var a := PI * float(i) / float(seg)
		p.append(Vector2(cos(a) * w * 0.5, hs + sin(a) * w * 0.5))
	return p


## Moldura em arco (meia-volta) feita de aduelas: centro c (x, y) no plano do
## referencial xf, raio médio rm, largura t, profundidade de z0 a z1.
static func _arch_ring(d: MeshBuf, xf: Transform3D, c: Vector2, rm: float, t: float, z0: float, z1: float, code: float, col: Color, seedf: float, seg: int) -> void:
	for i in seg:
		var a0 := PI * float(i) / float(seg)
		var a1 := PI * float(i + 1) / float(seg)
		var am := (a0 + a1) * 0.5
		var lc := Vector3(c.x + cos(am) * rm, c.y + sin(am) * rm, (z0 + z1) * 0.5)
		var seg_len := 2.0 * rm * sin((a1 - a0) * 0.5) + 0.04
		var bx := xf.basis * Basis(Vector3.BACK, am + PI * 0.5)
		d.box_xf(Transform3D(bx, xf * lc), Vector3(seg_len, t, z1 - z0), code, seedf, col)


## Janela colonial em arco: folhas de madeira pintada com almofadas, ombreiras,
## peitoril e arco de cantaria com fecho. xf: origem no centro do peitoril, z
## para fora da parede.
static func _arch_window(d: MeshBuf, xf: Transform3D, w: float, hs: float, shut: Color, trim: Color, seedf: float, fine: bool) -> void:
	var WOOD := Assets.uv2_code(Assets.L_WOOD)
	var PL := Assets.uv2_code(Assets.L_PLASTER)
	var ft := 0.22
	d.extrude(_arch_poly(w, hs), 0.0, 0.05, xf, WOOD, seedf, shut)
	for sgn: float in [-1.0, 1.0]:
		d.box_xf(Transform3D(xf.basis, xf * Vector3(sgn * (w * 0.5 + ft * 0.5), hs * 0.5, 0.07)), Vector3(ft, hs, 0.14), PL, seedf, trim)
	d.box_xf(Transform3D(xf.basis, xf * Vector3(0.0, -0.07, 0.1)), Vector3(w + ft * 2.0 + 0.12, 0.14, 0.2), PL, seedf, trim)
	_arch_ring(d, xf, Vector2(0.0, hs), w * 0.5 + ft * 0.5, ft, 0.0, 0.14, PL, trim, seedf, 8)
	if not fine:
		return
	d.box_xf(Transform3D(xf.basis, xf * Vector3(0.0, hs + w * 0.5 + ft * 0.6, 0.09)), Vector3(0.2, 0.3, 0.18), PL, seedf, trim)
	# junta das duas folhas e almofadas
	var dark := shut.darkened(0.4)
	d.box_xf(Transform3D(xf.basis, xf * Vector3(0.0, (hs + w * 0.4) * 0.5, 0.06)), Vector3(0.04, hs + w * 0.4, 0.03), WOOD, seedf, dark)
	for sgn: float in [-1.0, 1.0]:
		for k in 2:
			var ph := hs * 0.38
			d.box_xf(Transform3D(xf.basis, xf * Vector3(sgn * w * 0.25, hs * (0.27 + 0.48 * k), 0.06)), Vector3(w * 0.32, ph, 0.025), WOOD, seedf, shut.lightened(0.08))


static func _back_face(n: Vector3) -> int:
	if n.z < -0.5:
		return 63 & ~16
	if n.z > 0.5:
		return 63 & ~32
	if n.x > 0.5:
		return 63 & ~2
	return 63 & ~1


## Base com X ao longo da parede, Z para fora (normal n).
static func _wall_basis(n: Vector3) -> Basis:
	var x := Vector3(-n.z, 0, n.x)
	return Basis(x, Vector3.UP, n)


## Tamanho de caixa encostada numa fachada de normal `n`: largura ao longo da
## parede, altura, profundidade para fora.
static func _along(n: Vector3, w: float, h: float, depth: float) -> Vector3:
	return Vector3(w, h, depth) if absf(n.z) > 0.5 else Vector3(depth, h, w)


## Casas: alpendre coberto sobre a porta (laje + 2 pilares) e floreira.
static func _porch(b: Dictionary, d: MeshBuf, col_out: MeshBuf, seedf: float, door_c: Vector3, n: Vector3, door_w: float) -> void:
	var base: float = b["base"]
	var CON := Assets.uv2_code(Assets.L_CONCRETE)
	var WOOD := Assets.uv2_code(Assets.L_WOOD)
	var rng := Util.rng(int(b["seed"]) * 3 + 11)
	var w := door_w + 1.8
	var depth := 1.6
	var y := base + 2.55
	var side := Vector3(-n.z, 0, n.x)
	var roof_col := Color(0.55, 0.3, 0.22) if rng.randf() < 0.6 else Color(0.72, 0.72, 0.7)
	d.box(Vector3(door_c.x, y, door_c.z) + n * (depth * 0.5), _along(n, w, 0.12, depth), CON, seedf, roof_col)
	for sx: float in [-1.0, 1.0]:
		var pp := Vector3(door_c.x, base + 1.25, door_c.z) + n * (depth - 0.12) + side * (w * 0.5 - 0.12) * sx
		d.box(pp, Vector3(0.14, 2.5, 0.14), WOOD, seedf, Color(0.5, 0.38, 0.28))
		col_out.add_box_collider(pp, Vector3(0.16, 2.5, 0.16))
	# piso do alpendre
	d.box(Vector3(door_c.x, base + 0.04, door_c.z) + n * (depth * 0.5), _along(n, w, 0.1, depth), CON, seedf, Color(0.62, 0.6, 0.57))


## Ponto à frente da fachada principal, a `dist` metros da parede.
static func _front_point(b: Dictionary, dist: float) -> Vector3:
	var di := door_info(b)
	var p: Vector3 = di[0]
	var n: Vector3 = di[1]
	return p + n * dist


static func _stadium(b: Dictionary, shell: MeshBuf, detail: MeshBuf, lod: int) -> void:
	var r: Rect2 = b["rect"]
	var base: float = b["base"]
	var c := r.get_center()
	var rx := r.size.x * 0.5
	var rz := r.size.y * 0.5
	var H := 14.0
	var seg := 28 if lod == 0 else 14
	var code := Assets.uv2_code(Assets.L_PANELS, 0)
	var stand := Assets.uv2_code(Assets.L_CONCRETE, 0)
	var tint := Color(0.78, 0.77, 0.75)
	var gate_angles := [PI * 0.5, PI * 1.5]
	for i in seg:
		var a0 := TAU * i / seg
		var a1 := TAU * (i + 1) / seg
		var am := (a0 + a1) * 0.5
		var is_gate := false
		for ga in gate_angles:
			if absf(angle_difference(am, ga)) < PI / seg:
				is_gate = true
		var p0 := Vector2(c.x + cos(a0) * rx, c.y + sin(a0) * rz)
		var p1 := Vector2(c.x + cos(a1) * rx, c.y + sin(a1) * rz)
		var n := Vector3(cos(am) / rx, 0, sin(am) / rz).normalized()
		var i0 := Vector2(c.x + cos(a0) * (rx - 18.0), c.y + sin(a0) * (rz - 18.0))
		var i1 := Vector2(c.x + cos(a1) * (rx - 18.0), c.y + sin(a1) * (rz - 18.0))
		if is_gate:
			shell.wall(p0, p1, base + 4.5, H - 4.5, n, code, 0.3, tint)
		else:
			shell.wall(p0, p1, base - 1.0, H + 1.0, n, code, 0.3, tint)
			if lod == 0:
				var mid := (p0 + p1) * 0.5
				var len := p0.distance_to(p1)
				shell.add_collider(Transform3D(Basis(Vector3.UP, -am + PI * 0.5), Vector3(mid.x, base + H * 0.5, mid.y)), Vector3(len + 0.5, H, 0.6))
		# arquibancada (rampa em degraus visuais)
		var top0 := Vector3(p0.x, base + H - 1.0, p0.y) - n * 0.6
		var top1 := Vector3(p1.x, base + H - 1.0, p1.y) - n * 0.6
		var bot0 := Vector3(i0.x, base + 1.2, i0.y)
		var bot1 := Vector3(i1.x, base + 1.2, i1.y)
		var sn := (top1 - top0).cross(bot0 - top0).normalized()
		if sn.y < 0.0:
			sn = -sn
		shell.quad(bot0, bot1, top1, top0, sn, Vector2(0, 0), Vector2(p0.distance_to(p1), 0), Vector2(p0.distance_to(p1), 20.0), Vector2(0, 20.0), stand, 0.5, Color(0.65, 0.65, 0.66))
		shell.wall(i1, i0, base, 1.2, -n, stand, 0.5, Color(0.6, 0.6, 0.6))
	# gramado
	var fr := Rect2(c.x - rx + 18.0, c.y - rz + 18.0, (rx - 18.0) * 2.0, (rz - 18.0) * 2.0)
	var g := Assets.uv2_code(Assets.L_GRASS, 0)
	shell.quad(Vector3(fr.position.x, base + 0.02, fr.position.y), Vector3(fr.end.x, base + 0.02, fr.position.y), Vector3(fr.end.x, base + 0.02, fr.end.y), Vector3(fr.position.x, base + 0.02, fr.end.y),
		Vector3.UP, Vector2(fr.position.x, fr.position.y), Vector2(fr.end.x, fr.position.y), Vector2(fr.end.x, fr.end.y), Vector2(fr.position.x, fr.end.y), g, 0.1, Color(1.1, 1.15, 1.0))
	if lod == 0:
		for sx: float in [-1.0, 1.0]:
			for sz: float in [-1.0, 1.0]:
				detail.append(PropLib.buf("floodlight"), Transform3D(Basis(Vector3.UP, atan2(sx, sz)), Vector3(c.x + sx * rx * 0.8, base, c.y + sz * rz * 0.8)))
