class_name BuildingGen
extends RefCounted
## Casca externa dos prédios (fachadas, telhados, detalhes, colisão).
## Tudo em coordenadas de mundo, escrito em MeshBuf => mesclado por chunk.
## Função pura (sem nós) => pode rodar em thread de trabalho.

const FOUND := 1.2


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


static func build(b: Dictionary, shell: MeshBuf, detail: MeshBuf, lod: int, open_door: bool) -> void:
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
		shell.gable_roof(r, top, rise, 0.45 if lod == 0 else 0.3, ridge_x, roof_code, code, seedf, Color(1, 1, 1), tint)
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
	if lod == 0:
		_details(b, detail, top, seedf)
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
	# igreja: torre + cruz
	if t == "church":
		var tx := c.x
		var tz := r.end.y - 3.0 if facing == 2 else r.position.y + 3.0
		d.box(Vector3(tx, base + 9.0, tz), Vector3(5.0, 18.0, 5.0), Assets.uv2_code(int(b["layer"])), seedf, b["tint"])
		d.box(Vector3(tx, base + 18.0 + 1.5, tz), Vector3(0.25, 3.0, 0.25), MET, seedf, Color(0.8, 0.75, 0.5))
		d.box(Vector3(tx, base + 19.6, tz), Vector3(1.4, 0.25, 0.25), MET, seedf, Color(0.8, 0.75, 0.5))
		d.add_box_collider(Vector3(tx, base + 9.0, tz), Vector3(5.0, 18.0, 5.0))
	# posto: cobertura sobre as bombas
	if t == "gas_station":
		var cp := _front_point(b, 7.0)
		var along_x := facing == 0 or facing == 2
		var csz := Vector3(12.0, 0.6, 8.0) if along_x else Vector3(8.0, 0.6, 12.0)
		d.box(cp + Vector3(0, 5.0, 0), csz, MET, seedf, Color(0.9, 0.9, 0.9))
		d.box(cp + Vector3(0, 4.62, 0), csz * Vector3(1.0, 0.25, 1.0) + Vector3(0.1, 0, 0.1), MET, seedf, Color(0.85, 0.15, 0.1))
		for sx: float in [-1.0, 1.0]:
			var off := Vector3(sx * 3.5, 0, 0) if along_x else Vector3(0, 0, sx * 3.5)
			d.box(cp + off + Vector3(0, 2.4, 0), Vector3(0.35, 4.8, 0.35), MET, seedf, Color(0.8, 0.8, 0.8))
			d.append(PropLib.buf("gas_pump"), Transform3D(Basis(Vector3.UP, 0.0 if along_x else PI * 0.5), cp + off * 0.6))
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
