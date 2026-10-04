class_name ChunkBuilder
extends RefCounted
## Monta os DADOS de um chunk (64 x 64 m) num nível de detalhe:
##   lod 0 (perto): terreno 2 m, ruas, quarteirões, prédios com detalhes e
##                  portas, mobiliário urbano, árvores, grama, colisões
##   lod 1 (médio): terreno 4 m, ruas, prédios sem detalhes, árvores, colisões
##   lod 2 (longe): terreno 8 m, cascas de prédios, árvores simplificadas
## Função pura sobre o WorldLayout => executada em WorkerThreadPool.
## A camada "de fase" (carros, entulho, barricadas, mato) é separada para
## poder ser trocada sem reconstruir o chunk (PRE -> SILÊNCIO -> PÓS).

const ROAD_STEP := 8.0


static func build(layout: WorldLayout, c: Vector2i, lod: int, opts: Dictionary) -> Dictionary:
	var d := {"coord": c, "lod": lod}
	var res := 32 if lod == 0 else (16 if lod == 1 else 8)
	d["terrain"] = TerrainGen.build(layout, c, res, lod <= 1)
	var ground := MeshBuf.new()
	_roads(layout, c, ground, lod)
	_blocks(layout, c, ground, lod)
	_tunnel(layout, c, ground, lod)
	d["ground"] = ground
	var shells := MeshBuf.new()
	var details := MeshBuf.new()
	var enterables: Array = []
	for bi in layout.buildings_owned_by(c):
		var b: Dictionary = layout.buildings[bi]
		var open := lod == 0 and bool(b["enterable"])
		# relevo das fachadas: completo no LOD 0, só o grosso (cornija, pilares, marquise) no LOD 1
		var relief := (2 if lod == 0 else (1 if lod == 1 else 0)) if bool(opts.get("relief", true)) else 0
		BuildingGen.build(b, shells, details, 0 if lod <= 1 else 1, open, relief)
		if open:
			enterables.append(bi)
	d["shells"] = shells
	d["details"] = details
	d["enterables"] = enterables
	var props := {}
	var trees := {}
	var lamps: Array = []
	var labels: Array = []
	var prop_colliders: Array = []
	if lod == 0:
		_street_props(layout, c, props, trees, lamps, labels, prop_colliders, opts)
	_nature(layout, c, trees, lod, opts)
	d["props"] = props
	d["trees"] = trees
	d["lamps"] = lamps
	d["labels"] = labels
	d["prop_colliders"] = prop_colliders
	if lod == 0 and bool(opts.get("grass", true)):
		d["grass"] = _grass(layout, c, opts)
	return d


# ---------------------------------------------------------------------------
# Ruas, pontes, cruzamentos
# ---------------------------------------------------------------------------
static func _clip(a: Vector2, b: Vector2, r: Rect2) -> Vector2:
	# Liang-Barsky no eixo central; retorna (t0, t1) ou (1, 0) se fora
	var t0 := 0.0
	var t1 := 1.0
	var d := b - a
	var p := [-d.x, d.x, -d.y, d.y]
	var q := [a.x - r.position.x, r.end.x - a.x, a.y - r.position.y, r.end.y - a.y]
	for i in 4:
		var pi: float = p[i]
		var qi: float = q[i]
		if absf(pi) < 0.000001:
			if qi < 0.0:
				return Vector2(1, 0)
		else:
			var t := qi / pi
			if pi < 0.0:
				t0 = maxf(t0, t)
			else:
				t1 = minf(t1, t)
	return Vector2(t0, t1)


static func _roads(layout: WorldLayout, c: Vector2i, out: MeshBuf, lod: int) -> void:
	var rect := Rect2(c.x * WorldLayout.CHUNK, c.y * WorldLayout.CHUNK, WorldLayout.CHUNK, WorldLayout.CHUNK)
	for si in layout.chunk_roads.get(c, []):
		var seg: Dictionary = layout.roads[si]
		var a: Vector2 = seg["a"]
		var b: Vector2 = seg["b"]
		var tt := _clip(a, b, rect)
		if tt.x >= tt.y:
			continue
		var hw: float = seg["hw"]
		var kind: String = seg["kind"]
		var ya: float = seg["ya"]
		var yb: float = seg["yb"]
		var len := a.distance_to(b)
		var dir := (b - a) / maxf(len, 0.001)
		var side := Vector2(-dir.y, dir.x)
		var marks := int(seg["marks"])
		var wm := 0
		match marks:
			1: wm = 4
			2: wm = 5
			3: wm = 6
		var layer := Assets.L_DIRT if kind == "dirt" else Assets.L_ASPHALT
		var code := Assets.uv2_code(layer, wm if lod <= 1 else 0)
		var steps := maxi(1, int(ceil((tt.y - tt.x) * len / ROAD_STEP)))
		for k in steps:
			var s0 := lerpf(tt.x, tt.y, float(k) / steps)
			var s1 := lerpf(tt.x, tt.y, float(k + 1) / steps)
			var p0 := a + (b - a) * s0
			var p1 := a + (b - a) * s1
			var y0 := lerpf(ya, yb, s0)
			var y1 := lerpf(ya, yb, s1)
			var v0 := s0 * len
			var v1 := s1 * len
			var q0 := Vector3(p0.x - side.x * hw, y0, p0.y - side.y * hw)
			var q1 := Vector3(p1.x - side.x * hw, y1, p1.y - side.y * hw)
			var q2 := Vector3(p1.x + side.x * hw, y1, p1.y + side.y * hw)
			var q3 := Vector3(p0.x + side.x * hw, y0, p0.y + side.y * hw)
			var n := (q1 - q0).cross(q3 - q0).normalized()
			if n.y < 0.0:
				n = -n
			out.quad(q0, q1, q2, q3, n, Vector2(-hw, v0), Vector2(-hw, v1), Vector2(hw, v1), Vector2(hw, v0), code, 0.0, Color(1, 1, 1))
			if kind == "bridge" or kind == "tunnel":
				_bridge_or_tunnel_piece(out, kind, p0, p1, y0, y1, hw, side, lod)
			elif kind == "highway" and lod <= 1:
				# acostamento de cascalho
				var sc := Assets.uv2_code(Assets.L_GRAVEL)
				for sgn: float in [-1.0, 1.0]:
					var o0 := Vector3(p0.x + side.x * hw * sgn, y0 - 0.02, p0.y + side.y * hw * sgn)
					var o1 := Vector3(p1.x + side.x * hw * sgn, y1 - 0.02, p1.y + side.y * hw * sgn)
					var o2 := o1 + Vector3(side.x, 0, side.y) * (1.6 * sgn) + Vector3(0, -0.06, 0)
					var o3 := o0 + Vector3(side.x, 0, side.y) * (1.6 * sgn) + Vector3(0, -0.06, 0)
					out.quad(o0, o1, o2, o3, Vector3.UP, Vector2(0, v0), Vector2(0, v1), Vector2(1.6, v1), Vector2(1.6, v0), sc, 0.0, Color(0.9, 0.9, 0.9))
	# cruzamentos
	for pi in layout.chunk_patches.get(c, []):
		var pr: Rect2 = layout.patches[pi]
		var pc := pr.get_center()
		if not rect.has_point(pc):
			continue
		var y := 0.021
		var code := Assets.uv2_code(Assets.L_ASPHALT)
		out.quad(Vector3(pr.position.x, y, pr.position.y), Vector3(pr.end.x, y, pr.position.y), Vector3(pr.end.x, y, pr.end.y), Vector3(pr.position.x, y, pr.end.y),
			Vector3.UP, Vector2(pr.position.x, pr.position.y), Vector2(pr.end.x, pr.position.y), Vector2(pr.end.x, pr.end.y), Vector2(pr.position.x, pr.end.y), code, 0.0, Color(1, 1, 1))
		# faixas de pedestre no centro da cidade
		if lod == 0 and layout.district_at(pc.x, pc.y) in ["centro", "centro_sul", "bairro_alto"]:
			var zc := Assets.uv2_code(Assets.L_CONCRETE)
			var wc := Color(1.5, 1.5, 1.45)
			for sgn: float in [-1.0, 1.0]:
				for i in 7:
					var x := pr.position.x + 0.6 + i * (pr.size.x - 1.2) / 6.0
					var zz := pc.y + sgn * (pr.size.y * 0.5 + 1.2)
					out.box(Vector3(x, 0.03, zz), Vector3(0.45, 0.01, 2.2), zc, 0.0, wc, 4)
					var zz2 := pr.position.y + 0.6 + i * (pr.size.y - 1.2) / 6.0
					var xx := pc.x + sgn * (pr.size.x * 0.5 + 1.2)
					out.box(Vector3(xx, 0.03, zz2), Vector3(2.2, 0.01, 0.45), zc, 0.0, wc, 4)


static func _bridge_or_tunnel_piece(out: MeshBuf, kind: String, p0: Vector2, p1: Vector2, y0: float, y1: float, hw: float, side: Vector2, lod: int) -> void:
	var CON := Assets.uv2_code(Assets.L_CONCRETE)
	var PAN := Assets.uv2_code(Assets.L_PANELS)
	var mid := (p0 + p1) * 0.5
	var ym := (y0 + y1) * 0.5
	var len := p0.distance_to(p1)
	var yaw := atan2(p1.x - p0.x, p1.y - p0.y)
	var basis := Basis(Vector3.UP, yaw)
	if kind == "bridge":
		# tabuleiro, guarda-corpos e pilares
		out.box_xf(Transform3D(basis, Vector3(mid.x, ym - 0.45, mid.y)), Vector3(hw * 2.0 + 1.2, 0.8, len + 0.05), CON, 0.2, Color(0.72, 0.71, 0.69), 1 | 2 | 8)
		out.add_collider(Transform3D(basis, Vector3(mid.x, ym - 0.45, mid.y)), Vector3(hw * 2.0 + 1.2, 0.9, len + 0.05))
		for sgn: float in [-1.0, 1.0]:
			var rp := Vector3(mid.x + side.x * (hw + 0.4) * sgn, ym + 0.5, mid.y + side.y * (hw + 0.4) * sgn)
			out.box_xf(Transform3D(basis, rp), Vector3(0.3, 1.0, len), CON, 0.3, Color(0.75, 0.74, 0.72))
			out.add_collider(Transform3D(basis, rp), Vector3(0.3, 1.2, len))
		if lod <= 1 and fposmod(mid.x + mid.y, 18.0) < ROAD_STEP:
			out.box(Vector3(mid.x, ym - 3.6, mid.y), Vector3(1.4, 6.0, 1.4), CON, 0.1, Color(0.6, 0.6, 0.58))
	else:
		# túnel: piso, paredes, teto, calçadas, luminárias
		var H := WorldLayout.TUNNEL_HEIGHT
		var w2 := WorldLayout.TUNNEL_HW
		# o terreno não é rebaixado sob a serra: o piso da pista precisa de colisão própria
		out.add_collider(Transform3D(basis, Vector3(mid.x, ym - 0.3, mid.y)), Vector3(w2 * 2.0 + 1.0, 0.6, len + 0.05))
		for sgn: float in [-1.0, 1.0]:
			var wp := Vector3(mid.x + side.x * w2 * sgn, ym + H * 0.5, mid.y + side.y * w2 * sgn)
			var skip_room := sgn < 0.0 and (p0.y + 1150.0) * (p1.y + 1150.0) <= 0.0
			if skip_room:
				_maintenance_room(out, minf(p0.y, p1.y), maxf(p0.y, p1.y), ym, w2)
			else:
				out.box_xf(Transform3D(basis, wp + Vector3(side.x, 0, side.y) * (0.25 * sgn)), Vector3(0.5, H, len + 0.02), PAN, 0.4, Color(0.62, 0.62, 0.6))
				out.add_collider(Transform3D(basis, wp + Vector3(side.x, 0, side.y) * (0.25 * sgn)), Vector3(0.5, H, len + 0.02))
			var cp := Vector3(mid.x + side.x * (w2 - 0.6) * sgn, ym + 0.12, mid.y + side.y * (w2 - 0.6) * sgn)
			out.box_xf(Transform3D(basis, cp), Vector3(1.2, 0.25, len), CON, 0.2, Color(0.55, 0.55, 0.53))
		out.box_xf(Transform3D(basis, Vector3(mid.x, ym + H + 0.3, mid.y)), Vector3(w2 * 2.0 + 1.0, 0.6, len + 0.02), CON, 0.2, Color(0.4, 0.4, 0.4), 8)
		out.add_collider(Transform3D(basis, Vector3(mid.x, ym + H + 0.3, mid.y)), Vector3(w2 * 2.0 + 1.0, 0.6, len + 0.02))
		out.box_xf(Transform3D(basis, Vector3(mid.x, ym + H - 0.1, mid.y)), Vector3(0.5, 0.12, len * 0.4), Assets.uv2_code(Assets.L_METAL), 0.0, Color(0.9, 0.9, 0.8), 8)


static func _maintenance_room(out: MeshBuf, z0: float, z1: float, ym: float, w2: float) -> void:
	# sala escondida na parede oeste do túnel (segredo: fragmento da chave de Helena)
	var PAN := Assets.uv2_code(Assets.L_PANELS)
	var CON := Assets.uv2_code(Assets.L_CONCRETE)
	var x_in := -w2
	var H := WorldLayout.TUNNEL_HEIGHT
	# parede do túnel com porta (vão de 1 m em z = -1150)
	var dz := -1150.0
	out.wall_with_holes(Vector2(x_in, z1), Vector2(x_in, z0), ym, H, Vector3.RIGHT, [[z1 - dz - 0.5, z1 - dz + 0.5, 0.0, 2.1]], PAN, 0.4, Color(0.62, 0.62, 0.6))
	out.add_box_collider(Vector3(x_in - 0.25, ym + H * 0.5, (z0 + dz - 0.5) * 0.5), Vector3(0.5, H, (dz - 0.5) - z0))
	out.add_box_collider(Vector3(x_in - 0.25, ym + H * 0.5, (z1 + dz + 0.5) * 0.5), Vector3(0.5, H, z1 - (dz + 0.5)))
	out.add_box_collider(Vector3(x_in - 0.25, ym + 2.1 + (H - 2.1) * 0.5, dz), Vector3(0.5, H - 2.1, 1.0))
	# sala 4 x 5 m
	var rx0 := x_in - 4.0
	var rz0 := dz - 2.5
	var rz1 := dz + 2.5
	var rh := 2.6
	out.wall(Vector2(rx0, rz0), Vector2(x_in, rz0), ym, rh, Vector3.BACK, CON, 0.2, Color(0.6, 0.6, 0.58))
	out.wall(Vector2(x_in, rz1), Vector2(rx0, rz1), ym, rh, Vector3.FORWARD, CON, 0.2, Color(0.6, 0.6, 0.58))
	out.wall(Vector2(rx0, rz1), Vector2(rx0, rz0), ym, rh, Vector3.RIGHT, CON, 0.2, Color(0.6, 0.6, 0.58))
	out.quad(Vector3(rx0, ym + 0.01, rz0), Vector3(x_in, ym + 0.01, rz0), Vector3(x_in, ym + 0.01, rz1), Vector3(rx0, ym + 0.01, rz1), Vector3.UP,
		Vector2(rx0, rz0), Vector2(x_in, rz0), Vector2(x_in, rz1), Vector2(rx0, rz1), CON, 0.1, Color(0.5, 0.5, 0.48))
	out.quad(Vector3(rx0, ym + rh, rz1), Vector3(x_in, ym + rh, rz1), Vector3(x_in, ym + rh, rz0), Vector3(rx0, ym + rh, rz0), Vector3.DOWN,
		Vector2(rx0, rz1), Vector2(x_in, rz1), Vector2(x_in, rz0), Vector2(rx0, rz0), CON, 0.1, Color(0.5, 0.5, 0.48))
	out.add_box_collider(Vector3(rx0 - 0.2, ym + rh * 0.5, dz), Vector3(0.4, rh, 5.0))
	out.add_box_collider(Vector3((rx0 + x_in) * 0.5, ym + rh * 0.5, rz0 - 0.2), Vector3(4.0, rh, 0.4))
	out.add_box_collider(Vector3((rx0 + x_in) * 0.5, ym + rh * 0.5, rz1 + 0.2), Vector3(4.0, rh, 0.4))
	out.add_box_collider(Vector3((rx0 + x_in) * 0.5, ym + rh + 0.2, dz), Vector3(4.0, 0.4, 5.0))
	out.append(PropLib.buf("shelf"), Transform3D(Basis(Vector3.UP, -PI * 0.5), Vector3(rx0 + 0.4, ym, dz + 1.2)))
	out.append(PropLib.buf("generator"), Transform3D(Basis.IDENTITY, Vector3(rx0 + 1.5, ym, rz0 + 0.8)))
	out.append(PropLib.buf("desk"), Transform3D(Basis(Vector3.UP, PI), Vector3(rx0 + 2.0, ym, rz1 - 0.6)))


static func _tunnel(layout: WorldLayout, c: Vector2i, out: MeshBuf, lod: int) -> void:
	# fachadas dos portais (cobrem os buracos do terreno)
	var rect := Rect2(c.x * WorldLayout.CHUNK, c.y * WorldLayout.CHUNK, WorldLayout.CHUNK, WorldLayout.CHUNK)
	for pz: float in [WorldLayout.TUNNEL_Z_SOUTH, WorldLayout.TUNNEL_Z_NORTH]:
		var z: float = pz
		if not rect.has_point(Vector2(0.5, z)):
			continue
		var y := WorldLayout.TUNNEL_Y
		var n := Vector3.BACK if z == WorldLayout.TUNNEL_Z_SOUTH else Vector3.FORWARD
		var code := Assets.uv2_code(Assets.L_PANELS)
		var hw := WorldLayout.TUNNEL_HW
		var hole := [[16.0 - hw, 16.0 + hw, 1.0, 1.0 + WorldLayout.TUNNEL_HEIGHT]]
		var a := Vector2(-16.0, z) if n == Vector3.BACK else Vector2(16.0, z)
		var b := Vector2(16.0, z) if n == Vector3.BACK else Vector2(-16.0, z)
		if n == Vector3.FORWARD:
			hole = [[16.0 - hw, 16.0 + hw, 1.0, 1.0 + WorldLayout.TUNNEL_HEIGHT]]
		out.wall_with_holes(a, b, y - 1.0, 26.0, n, hole, code, 0.6, Color(0.62, 0.62, 0.6))
		out.wall_with_holes(b + Vector2(0, -n.z * 1.2), a + Vector2(0, -n.z * 1.2), y - 1.0, 26.0, -n, hole, code, 0.6, Color(0.55, 0.55, 0.53))
		out.box(Vector3(0, y + 25.0, z - n.z * 0.6), Vector3(33.0, 0.4, 1.6), Assets.uv2_code(Assets.L_CONCRETE), 0.1, Color(0.6, 0.6, 0.58))
		var t := 1.2
		var zc := z - n.z * t * 0.5
		out.add_box_collider(Vector3(-(16.0 + hw) * 0.5, y + 12.0, zc), Vector3(16.0 - hw, 26.0, t))
		out.add_box_collider(Vector3((16.0 + hw) * 0.5, y + 12.0, zc), Vector3(16.0 - hw, 26.0, t))
		out.add_box_collider(Vector3(0, y + WorldLayout.TUNNEL_HEIGHT + (25.0 - WorldLayout.TUNNEL_HEIGHT) * 0.5, zc), Vector3(hw * 2.0, 25.0 - WorldLayout.TUNNEL_HEIGHT, t))
		# piso sob o portal: o buraco do terreno não pode deixar ninguém cair
		out.add_box_collider(Vector3(0, y - 0.3, z), Vector3(32.0, 0.6, 7.0))


# ---------------------------------------------------------------------------
# Quarteirões (calçadas + lotes elevados)
# ---------------------------------------------------------------------------
static func _blocks(layout: WorldLayout, c: Vector2i, out: MeshBuf, lod: int) -> void:
	var rect := Rect2(c.x * WorldLayout.CHUNK, c.y * WorldLayout.CHUNK, WorldLayout.CHUNK, WorldLayout.CHUNK)
	var y := WorldLayout.CURB
	var SW := Assets.uv2_code(Assets.L_CONCRETE)
	for bid in layout.chunk_blocks.get(c, []):
		var blk: Dictionary = layout.blocks[bid]
		var br: Rect2 = blk["rect"]
		if not rect.has_point(br.get_center()):
			continue
		var kind: String = blk["kind"]
		var dist: String = blk["district"]
		var inner := br.grow(-WorldLayout.SIDEWALK)
		# anel da calçada (4 faixas)
		var ring := [Rect2(br.position.x, br.position.y, br.size.x, WorldLayout.SIDEWALK), Rect2(br.position.x, inner.end.y, br.size.x, WorldLayout.SIDEWALK),
			Rect2(br.position.x, inner.position.y, WorldLayout.SIDEWALK, inner.size.y), Rect2(inner.end.x, inner.position.y, WorldLayout.SIDEWALK, inner.size.y)]
		for rr in ring:
			_top(out, rr, y, SW, Color(0.85, 0.84, 0.8))
		# miolo
		var gl := Assets.L_CONCRETE
		var gc := Color(0.8, 0.8, 0.78)
		match kind:
			"houses", "small_houses", "family_block", "park", "plaza", "school", "helena_block", "clinic_block", "church_block", "apartments", "stadium":
				gl = Assets.L_GRASS
				gc = Color(1, 1, 1)
			"industrial", "workshop_block", "gas_block":
				gl = Assets.L_GRAVEL
				gc = Color(0.9, 0.9, 0.9)
			"parking", "market", "terminal", "corvalis", "hospital", "police":
				gl = Assets.L_ASPHALT
				gc = Color(1.05, 1.05, 1.05)
		if dist == "centro" and kind == "downtown":
			gl = Assets.L_TILES
			gc = Color(0.75, 0.72, 0.7)
		_top(out, inner, y, Assets.uv2_code(gl), gc)
		# meio-fio (faces laterais)
		var cc := Assets.uv2_code(Assets.L_CONCRETE)
		out.wall(Vector2(br.end.x, br.position.y), Vector2(br.position.x, br.position.y), -0.3, y + 0.3, Vector3.FORWARD, cc, 0.0, Color(0.7, 0.7, 0.68))
		out.wall(Vector2(br.position.x, br.end.y), Vector2(br.end.x, br.end.y), -0.3, y + 0.3, Vector3.BACK, cc, 0.0, Color(0.7, 0.7, 0.68))
		out.wall(Vector2(br.position.x, br.position.y), Vector2(br.position.x, br.end.y), -0.3, y + 0.3, Vector3.LEFT, cc, 0.0, Color(0.7, 0.7, 0.68))
		out.wall(Vector2(br.end.x, br.end.y), Vector2(br.end.x, br.position.y), -0.3, y + 0.3, Vector3.RIGHT, cc, 0.0, Color(0.7, 0.7, 0.68))
		if lod <= 1:
			out.add_box_collider(Vector3(br.get_center().x, (y - 0.4) * 0.5, br.get_center().y), Vector3(br.size.x, y + 0.4, br.size.y))
		# estacionamento (e pátios de asfalto de mercado, hospital, delegacia, terminal): faixas das vagas
		if lod == 0 and kind in LOT_KINDS:
			var paint := Assets.uv2_code(Assets.L_CONCRETE)
			for bay in lot_bays(layout, blk):
				var bp: Vector3 = bay[0]
				_top(out, Rect2(bp.x - 1.36, bp.z - 2.5, 0.12, 5.0), y + 0.012, paint, Color(0.93, 0.92, 0.86))
				if bool(bay[2]):
					_top(out, Rect2(bp.x + 1.24, bp.z - 2.5, 0.12, 5.0), y + 0.012, paint, Color(0.93, 0.92, 0.86))
		# caminhos de pedestre em parques/praças
		if lod == 0 and kind in ["park", "plaza"]:
			var pc := br.get_center()
			_top(out, Rect2(pc.x - 1.5, inner.position.y, 3.0, inner.size.y), y + 0.01, SW, Color(0.75, 0.72, 0.66))
			_top(out, Rect2(inner.position.x, pc.y - 1.5, inner.size.x, 3.0), y + 0.012, SW, Color(0.75, 0.72, 0.66))


const LOT_KINDS := ["parking", "market", "hospital", "police", "terminal"]


## Vagas de um quarteirão: o estacionamento inteiro, ou nos pátios de asfalto
## dos prédios só onde sobra chão — longe das paredes e da frente das portas
## (entrada, ambulâncias e as cenas da abertura ficam livres).
static func lot_bays(layout: WorldLayout, blk: Dictionary) -> Array:
	var kind: String = blk["kind"]
	if not kind in LOT_KINDS:
		return []
	var br: Rect2 = blk["rect"]
	var bays := parking_bays(br.grow(-WorldLayout.SIDEWALK))
	if kind == "parking":
		return bays
	var doors: Array = []
	for b in layout.buildings:
		if (b["rect"] as Rect2).intersects(br):
			var dp: Vector3 = BuildingGen.door_info(b)[0]
			doors.append(Vector2(dp.x, dp.z))
	var out: Array = []
	for bay in bays:
		var bp: Vector3 = bay[0]
		if layout.building_at(Vector3(bp.x, 0.0, bp.z), 3.2) >= 0:
			continue
		var near_door := false
		for d: Vector2 in doors:
			if d.distance_to(Vector2(bp.x, bp.z)) < 16.0:
				near_door = true
				break
		if not near_door:
			out.append(bay)
	return out


## Vagas de um estacionamento: [centro, yaw do carro, última da fileira].
## Fileiras de 5 m ao longo de X com corredor de 6,5 m entre pares de fileiras.
static func parking_bays(inner: Rect2) -> Array:
	var out: Array = []
	var pr := inner.grow(-1.2)
	var z := pr.position.y
	var k := 0
	while z + 5.0 <= pr.end.y:
		var n := int((pr.size.x) / 2.6)
		var x0 := pr.position.x + (pr.size.x - n * 2.6) * 0.5 + 1.3
		for i in n:
			out.append([Vector3(x0 + i * 2.6, 0.0, z + 2.5), 0.0 if k % 2 == 0 else PI, i == n - 1])
		z += 5.0 + (6.5 if k % 2 == 0 else 0.0)
		k += 1
	return out


static func _top(out: MeshBuf, r: Rect2, y: float, code: float, col: Color) -> void:
	out.quad(Vector3(r.position.x, y, r.position.y), Vector3(r.end.x, y, r.position.y), Vector3(r.end.x, y, r.end.y), Vector3(r.position.x, y, r.end.y),
		Vector3.UP, Vector2(r.position.x, r.position.y), Vector2(r.end.x, r.position.y), Vector2(r.end.x, r.end.y), Vector2(r.position.x, r.end.y), code, 0.0, col)


# ---------------------------------------------------------------------------
# Mobiliário urbano, cercas, placas, árvores de rua
# ---------------------------------------------------------------------------
static func _add_prop(props: Dictionary, name: String, xf: Transform3D, col: Color = Color(1, 1, 1, 0), colliders: Array = [], collide: bool = false) -> void:
	if not props.has(name):
		props[name] = {"xf": [], "col": []}
	props[name]["xf"].append(xf)
	if col.a == 0.0:
		col.a = fposmod(xf.origin.x * 0.13 + xf.origin.z * 0.29, 1.0)
	props[name]["col"].append(col)
	if collide:
		var cs := PropLib.collision_size(name)
		if cs != Vector3.ZERO:
			colliders.append([Transform3D(xf.basis, xf.origin + xf.basis * Vector3(0, cs.y * 0.5, 0)), cs])


static func _add_tree(trees: Dictionary, kind: String, xf: Transform3D) -> void:
	if not trees.has(kind):
		trees[kind] = []
	trees[kind].append(xf)


static func _street_props(layout: WorldLayout, c: Vector2i, props: Dictionary, trees: Dictionary, lamps: Array, labels: Array, colliders: Array, opts: Dictionary) -> void:
	var rect := Rect2(c.x * WorldLayout.CHUNK, c.y * WorldLayout.CHUNK, WorldLayout.CHUNK, WorldLayout.CHUNK)
	var y := WorldLayout.CURB
	for bid in layout.chunk_blocks.get(c, []):
		var blk: Dictionary = layout.blocks[bid]
		var br: Rect2 = blk["rect"]
		if not rect.has_point(br.get_center()):
			continue
		var kind: String = blk["kind"]
		var dist: String = blk["district"]
		var r := Util.rng(int(bid) * 7717 + layout.seed_value)
		# quatro lados do quarteirão: [início, direção, normal para a rua]
		var sides := [[Vector2(br.position.x, br.position.y), Vector2(1, 0), Vector2(0, -1), br.size.x],
			[Vector2(br.end.x, br.position.y), Vector2(0, 1), Vector2(1, 0), br.size.y],
			[Vector2(br.end.x, br.end.y), Vector2(-1, 0), Vector2(0, 1), br.size.x],
			[Vector2(br.position.x, br.end.y), Vector2(0, -1), Vector2(-1, 0), br.size.y]]
		var urban_core := dist in ["centro", "centro_sul", "bairro_alto"]
		for s in sides:
			var o: Vector2 = s[0]
			var dir: Vector2 = s[1]
			var rn: Vector2 = s[2]
			var slen: float = s[3]
			var yaw_to_road := Util.dir_to_yaw(Vector3(rn.x, 0, rn.y))
			var t := 8.0 + r.randf() * 6.0
			var lamp_step := 30.0 if urban_core else 36.0
			while t < slen - 6.0:
				var p := o + dir * t + rn * -0.7
				var p3 := Vector3(p.x, y, p.y)
				_add_prop(props, "lamp_post", Transform3D(Basis(Vector3.UP, yaw_to_road + PI), p3), Color(1, 1, 1, 0), colliders, false)
				colliders.append([Transform3D(Basis.IDENTITY, p3 + Vector3(0, 1.5, 0)), Vector3(0.25, 3.0, 0.25)])
				lamps.append(p3 + Vector3(0, 7.0, 0) + Vector3(-rn.x, 0, -rn.y) * -1.45)
				t += lamp_step
			# árvores de calçada
			t = 5.0 + r.randf() * 5.0
			while t < slen - 4.0:
				var p := o + dir * t + rn * -1.4
				var roll := r.randf()
				if roll < (0.55 if dist in ["acacias", "bairro_alto", "parque_norte"] else 0.3):
					var tk := "palm" if (absf(p.x) < 20.0 or absf(p.y) < 16.0) and urban_core else "broadleaf"
					var sc := r.randf_range(0.8, 1.15)
					_add_tree(trees, tk, Transform3D(Basis(Vector3.UP, r.randf() * TAU).scaled(Vector3.ONE * sc), Vector3(p.x, y, p.y)))
					colliders.append([Transform3D(Basis.IDENTITY, Vector3(p.x, y + 1.5, p.y)), Vector3(0.4, 3.0, 0.4)])
				elif roll < 0.62:
					_add_prop(props, "trash_bin", Transform3D(Basis(Vector3.UP, r.randf() * TAU), Vector3(p.x, y, p.y)))
				elif roll < 0.66 and urban_core:
					_add_prop(props, "bench", Transform3D(Basis(Vector3.UP, yaw_to_road), Vector3(p.x, y, p.y) + Vector3(-rn.x, 0, -rn.y) * 0.4))
				elif roll < 0.7:
					_add_prop(props, "hydrant", Transform3D(Basis.IDENTITY, Vector3(p.x, y, p.y)))
				elif roll < 0.76 and not urban_core:
					_add_prop(props, "power_pole", Transform3D(Basis(Vector3.UP, yaw_to_road), Vector3(p.x, y, p.y)))
					colliders.append([Transform3D(Basis.IDENTITY, Vector3(p.x, y + 1.5, p.y)), Vector3(0.3, 3.0, 0.3)])
				t += r.randf_range(10.0, 16.0)
			# ponto de ônibus nas avenidas
			var mid := o + dir * (slen * 0.5) + rn * -1.6
			var on_avenue := (absf(mid.x) < 14.0 or absf(mid.y) < 13.0) and urban_core
			if on_avenue:
				_add_prop(props, "bus_stop", Transform3D(Basis(Vector3.UP, yaw_to_road), Vector3(mid.x, y, mid.y)), Color(1, 1, 1, 0), colliders, true)
		# semáforos nas esquinas do centro
		if dist == "centro":
			for corner in [br.position, Vector2(br.end.x, br.position.y), br.end, Vector2(br.position.x, br.end.y)]:
				var cv: Vector2 = corner
				var inward := (br.get_center() - cv).normalized()
				var p := cv + inward * 0.9
				_add_prop(props, "traffic_light", Transform3D(Basis(Vector3.UP, Util.dir_to_yaw(Vector3(-inward.x, 0, -inward.y))), Vector3(p.x, y, p.y)))
		# conteúdo do miolo por tipo
		var inner := br.grow(-WorldLayout.SIDEWALK)
		match kind:
			"houses", "small_houses", "family_block":
				_house_lots(layout, c, br, props, trees, colliders, r)
			"park", "plaza":
				for i in int(inner.get_area() / 110.0 * float(opts.get("veg_density", 1.0))):
					var p := Vector2(r.randf_range(inner.position.x + 2, inner.end.x - 2), r.randf_range(inner.position.y + 2, inner.end.y - 2))
					if absf(p.x - br.get_center().x) < 3.0 or absf(p.y - br.get_center().y) < 3.0:
						continue
					if kind == "plaza" and layout.building_at(Vector3(p.x, 0, p.y), 3.0) >= 0:
						continue
					_add_tree(trees, "broadleaf_big" if r.randf() < 0.4 else "broadleaf", Transform3D(Basis(Vector3.UP, r.randf() * TAU).scaled(Vector3.ONE * r.randf_range(0.8, 1.2)), Vector3(p.x, y, p.y)))
					colliders.append([Transform3D(Basis.IDENTITY, Vector3(p.x, y + 1.5, p.y)), Vector3(0.5, 3.0, 0.5)])
				for i in 8:
					var p := br.get_center() + Vector2(r.randf_range(-30, 30), 2.4 if i % 2 == 0 else -2.4)
					if i >= 4:
						p = br.get_center() + Vector2(2.4 if i % 2 == 0 else -2.4, r.randf_range(-30, 30))
					_add_prop(props, "bench", Transform3D(Basis(Vector3.UP, 0.0 if i < 4 else PI * 0.5), Vector3(p.x, y, p.y)))
			"industrial", "corvalis", "workshop_block":
				for i in r.randi_range(4, 10):
					var p := Vector2(r.randf_range(inner.position.x + 3, inner.end.x - 3), r.randf_range(inner.position.y + 3, inner.end.y - 3))
					if layout.building_at(Vector3(p.x, 0, p.y), 2.5) >= 0:
						continue
					var pick := r.randf()
					var pn := "container" if pick < 0.3 else ("pallet" if pick < 0.5 else ("barrel" if pick < 0.75 else ("dumpster" if pick < 0.9 else "forklift")))
					var col := Color.from_hsv(r.randf(), 0.55, 0.6, 0) if pn == "container" else Color(1, 1, 1, 0)
					_add_prop(props, pn, Transform3D(Basis(Vector3.UP, (r.randi() % 4) * PI * 0.5), Vector3(p.x, y, p.y)), col, colliders, true)
				if kind == "corvalis":
					_perimeter_fence(br.grow(-1.0), y, props, colliders, Vector2(br.position.x + 94.0, br.position.y))
		# letreiros das lojas (Label3D criados no nó do chunk)
	for bi in layout.buildings_owned_by(c):
		var b: Dictionary = layout.buildings[bi]
		var nm: String = b["name"]
		if nm == "" or nm == "112":
			continue
		var di := BuildingGen.door_info(b)
		var dp: Vector3 = di[0]
		var dn: Vector3 = di[1]
		var hy := 4.1 if b["type"] != "house" else 3.1
		if b["type"] in ["hospital", "market", "terminal", "office", "lab", "school", "stadium", "church", "police"]:
			hy = BuildingGen.total_height(b) * (0.55 if b["type"] != "church" else 0.4) + float(b["base"])
			# térreo alto (mercado, terminal): acima do toldo e da faixa da vitrine (~3,5 m)
			if b["type"] in ["market", "terminal"]:
				hy = maxf(hy, float(b["base"]) + 4.6)
			if b["type"] == "stadium":
				hy = 12.0
		else:
			hy += float(b["base"])
		labels.append({"pos": Vector3(dp.x, hy, dp.z) + dn * 0.12,
			"yaw": Util.dir_to_yaw(-dn), "text": nm, "size": 0.9 if b["type"] in ["hospital", "market", "terminal", "office", "stadium"] else 0.45})


static func _perimeter_fence(r: Rect2, y: float, props: Dictionary, colliders: Array, gate: Vector2) -> void:
	var edges := [[r.position, Vector2(r.end.x, r.position.y)], [Vector2(r.end.x, r.position.y), r.end], [r.end, Vector2(r.position.x, r.end.y)], [Vector2(r.position.x, r.end.y), r.position]]
	for e in edges:
		var a: Vector2 = e[0]
		var b: Vector2 = e[1]
		var len := a.distance_to(b)
		var dir := (b - a) / len
		var yaw := Util.dir_to_yaw(Vector3(dir.y, 0, -dir.x))
		var t := 1.0
		while t < len - 1.0:
			var p := a + dir * t
			if p.distance_to(gate) > 6.0:
				_add_prop(props, "fence_metal", Transform3D(Basis(Vector3.UP, yaw), Vector3(p.x, y, p.y)))
			t += 2.0
		var mid := (a + b) * 0.5
		var sz := Vector3(len, 1.8, 0.15) if absf(dir.x) > 0.5 else Vector3(0.15, 1.8, len)
		if gate.distance_to(mid) > len * 0.5 + 1.0:
			colliders.append([Transform3D(Basis.IDENTITY, Vector3(mid.x, y + 0.9, mid.y)), sz])
		else:
			# lado com o portão: duas partes
			var g := (gate - a).dot(dir)
			var l0 := g - 6.0
			var l1 := len - (g + 6.0)
			if l0 > 0.5:
				var c0 := a + dir * (l0 * 0.5)
				colliders.append([Transform3D(Basis.IDENTITY, Vector3(c0.x, y + 0.9, c0.y)), Vector3(l0, 1.8, 0.15) if absf(dir.x) > 0.5 else Vector3(0.15, 1.8, l0)])
			if l1 > 0.5:
				var c1 := b - dir * (l1 * 0.5)
				colliders.append([Transform3D(Basis.IDENTITY, Vector3(c1.x, y + 0.9, c1.y)), Vector3(l1, 1.8, 0.15) if absf(dir.x) > 0.5 else Vector3(0.15, 1.8, l1)])
			_add_prop(props, "gate_bar", Transform3D(Basis(Vector3.UP, yaw + PI * 0.5), Vector3(gate.x - 2.5, y, gate.y)))


static func _house_lots(layout: WorldLayout, c: Vector2i, br: Rect2, props: Dictionary, trees: Dictionary, colliders: Array, r: RandomNumberGenerator) -> void:
	var y := WorldLayout.CURB
	for bi in layout.chunk_buildings.get(c, []):
		var b: Dictionary = layout.buildings[bi]
		if not b.has("lot"):
			continue
		var lot: Rect2 = b["lot"]
		if not br.encloses(lot.grow(-0.5)):
			continue
		var owned: bool = Vector2i(floori(lot.get_center().x / WorldLayout.CHUNK), floori(lot.get_center().y / WorldLayout.CHUNK)) == c
		if not owned:
			continue
		var facing := int(b["facing"])
		var front_z := lot.position.y if facing == 0 else lot.end.y
		var di := BuildingGen.door_info(b)
		var door: Vector3 = di[0]
		# muro frontal com portão
		var gate_x := door.x + r.randf_range(-0.5, 0.5)
		var x := lot.position.x + 1.0
		var use_wall := r.randf() < 0.7
		while x < lot.end.x - 0.9:
			if absf(x - gate_x) > 1.6:
				var pz := front_z + (0.2 if facing == 0 else -0.2)
				_add_prop(props, "wall_low" if use_wall else "fence_wood", Transform3D(Basis.IDENTITY, Vector3(x, y, pz)), Color(1, 1, 1, 0), colliders, true)
			x += 2.0
		# cercas laterais
		var z := lot.position.y + 1.0
		while z < lot.end.y - 0.9:
			_add_prop(props, "fence_wood", Transform3D(Basis(Vector3.UP, PI * 0.5), Vector3(lot.position.x + 0.1, y, z)), Color(1, 1, 1, 0), colliders, true)
			z += 2.0
		# quintal
		var hr: Rect2 = b["rect"]
		var back_z := lot.end.y - 3.0 if facing == 0 else lot.position.y + 3.0
		if absf(back_z - hr.get_center().y) > hr.size.y * 0.5 + 2.0 and r.randf() < 0.65:
			var tp := Vector3(lot.get_center().x + r.randf_range(-2, 2), y, back_z)
			_add_tree(trees, "broadleaf" if r.randf() < 0.7 else "palm", Transform3D(Basis(Vector3.UP, r.randf() * TAU).scaled(Vector3.ONE * r.randf_range(0.7, 1.1)), tp))
			colliders.append([Transform3D(Basis.IDENTITY, tp + Vector3(0, 1.5, 0)), Vector3(0.4, 3.0, 0.4)])
		if r.randf() < 0.6:
			var bp := Vector3(lot.position.x + r.randf_range(1.5, 3.0), y, front_z + (2.0 if facing == 0 else -2.0))
			_add_tree(trees, "bush", Transform3D(Basis(Vector3.UP, r.randf() * TAU).scaled(Vector3.ONE * r.randf_range(0.7, 1.2)), bp))
		if r.randf() < 0.4:
			_add_prop(props, "mailbox", Transform3D(Basis.IDENTITY, Vector3(gate_x + 1.3, y, front_z + (0.5 if facing == 0 else -0.5))))


# ---------------------------------------------------------------------------
# Natureza (fora da cidade): florestas, campos, margens de rio
# ---------------------------------------------------------------------------
static func _nature(layout: WorldLayout, c: Vector2i, trees: Dictionary, lod: int, opts: Dictionary) -> void:
	var x0 := c.x * WorldLayout.CHUNK
	var z0 := c.y * WorldLayout.CHUNK
	var center := Vector2(x0 + 32.0, z0 + 32.0)
	if WorldLayout.URBAN.grow(-40.0).encloses(Rect2(x0, z0, 64, 64)):
		return
	var dist := layout.district_at(center.x, center.y)
	var cell := 22.0
	match dist:
		"floresta": cell = 6.5
		"serra": cell = 8.5
		"rural": cell = 16.0
		"rio": cell = 11.0
		"periferia": cell = 14.0
		_:
			cell = 24.0
	cell /= sqrt(maxf(float(opts.get("veg_density", 1.0)), 0.1))
	if lod == 2:
		cell *= 1.35
	var r := Util.rng(Util.hash2(c.x, c.y, 991))
	var n := int(64.0 / cell)
	var roads: Array = layout.chunk_flatten.get(c, [])
	for iz in n:
		for ix in n:
			var p := Vector2(x0 + (ix + r.randf()) * cell, z0 + (iz + r.randf()) * cell)
			if WorldLayout.URBAN.has_point(p):
				continue
			var nz := layout.noise.get_noise_2d(p.x * 3.0, p.y * 3.0)
			if dist == "rural" and nz < 0.05:
				continue
			if layout.is_water(p.x, p.y):
				continue
			var near_road := false
			for si in roads:
				var seg: Dictionary = layout.roads[si]
				if Util.dist_point_segment_2d(p, seg["a"], seg["b"]) < float(seg["hw"]) + 5.0:
					near_road = true
					break
			if near_road:
				continue
			if layout.building_at(Vector3(p.x, 0, p.y), 6.0) >= 0:
				continue
			if absf(p.x) < 20.0 and p.y < WorldLayout.TUNNEL_Z_SOUTH + 30.0 and p.y > WorldLayout.TUNNEL_Z_NORTH - 30.0:
				continue
			var h := layout.ground_height(p.x, p.y)
			var kind := "broadleaf"
			var pr := r.randf()
			if dist == "serra" or h > 38.0:
				kind = "pine" if pr < 0.7 else "broadleaf"
			elif dist == "floresta":
				kind = "broadleaf_big" if pr < 0.45 else ("broadleaf" if pr < 0.8 else ("dead" if pr < 0.86 else "bush"))
			elif dist == "rio":
				kind = "broadleaf" if pr < 0.5 else "bush"
			else:
				kind = "broadleaf" if pr < 0.55 else ("bush" if pr < 0.85 else ("palm" if pr < 0.93 else "dead"))
			var sc := r.randf_range(0.75, 1.3)
			_add_tree(trees, kind, Transform3D(Basis(Vector3.UP, r.randf() * TAU).scaled(Vector3.ONE * sc), Vector3(p.x, h - 0.1, p.y)))


static func _grass(layout: WorldLayout, c: Vector2i, opts: Dictionary) -> Array:
	var out: Array = []
	var dens := float(opts.get("grass_density", 1.0))
	if dens <= 0.0:
		return out
	var x0 := c.x * WorldLayout.CHUNK
	var z0 := c.y * WorldLayout.CHUNK
	var r := Util.rng(Util.hash2(c.x, c.y, 551))
	var step := 1.4 / sqrt(dens)
	var n := int(64.0 / step)
	var urban := WorldLayout.URBAN
	var decay := float(opts.get("decay", 1.0))
	for iz in n:
		for ix in n:
			var p := Vector2(x0 + (ix + r.randf()) * step, z0 + (iz + r.randf()) * step)
			var y := 0.0
			var in_urban := urban.has_point(p)
			if in_urban:
				var bid := layout.block_at(p.x, p.y)
				if bid < 0:
					# mato nas rachaduras das ruas (pós-colapso)
					if r.randf() > 0.06 * decay:
						continue
					y = 0.02
				else:
					var blk: Dictionary = layout.blocks[bid]
					var kind: String = blk["kind"]
					if not kind in ["houses", "small_houses", "family_block", "park", "plaza", "school", "helena_block", "clinic_block", "church_block", "apartments"]:
						if r.randf() > 0.05 * decay:
							continue
					var inner := (blk["rect"] as Rect2).grow(-WorldLayout.SIDEWALK)
					if not inner.has_point(p) and r.randf() > 0.1 * decay:
						continue
					if layout.building_at(Vector3(p.x, 0, p.y), 0.3) >= 0:
						continue
					y = WorldLayout.CURB
			else:
				if layout.is_water(p.x, p.y):
					continue
				y = layout.ground_height(p.x, p.y)
				if y > 45.0 and r.randf() < 0.6:
					continue
			# touceiras: densidade varia em manchas (campo de verdade não é um tabuleiro)
			var patch := 0.5 + 0.5 * sin(p.x * 0.13 + sin(p.y * 0.11) * 2.0) * cos(p.y * 0.09 + p.x * 0.05)
			if r.randf() > 0.3 + patch * 0.9:
				continue
			var s := r.randf_range(0.7, 1.25)
			var xf := Transform3D(Basis(Vector3.UP, r.randf() * TAU).scaled(Vector3(s, 1.0, s)), Vector3(p.x, y, p.y))
			out.append([xf, Color(r.randf_range(0.5, 1.0) + patch * 0.25, r.randf(), r.randf() * (0.6 if in_urban else 0.35), 0)])
	return out


# ---------------------------------------------------------------------------
# Camada de fase (carros, entulho, barricadas, mato, acampamentos)
# ---------------------------------------------------------------------------
## Decoração das ruas: bueiros e remendos no asfalto (sempre), cartazes nas
## fachadas e bancas de jornal; depois do surto, lixo espalhado, cones e cavaletes,
## carrinhos de mercado, malas, bicicletas largadas e marcas discretas de
## violência (manchas de sangue, furos de bala, restos cobertos). Usa um gerador
## próprio para não mexer na posição dos carros.
static func _street_clutter(layout: WorldLayout, c: Vector2i, rect: Rect2, phase: int, props: Dictionary, colliders: Array, cars: Array) -> void:
	var r := Util.rng(Util.hash2(c.x, c.y, 9100 + phase))
	var pre := phase == GameState.Phase.PRE
	var post := phase == GameState.Phase.POST
	var none := Color(1, 1, 1, 0)
	# --- asfalto e pista ---------------------------------------------------------------
	for si in layout.chunk_roads.get(c, []):
		var seg: Dictionary = layout.roads[si]
		var kind: String = seg["kind"]
		if kind in ["tunnel", "bridge", "dirt"]:
			continue
		var a: Vector2 = seg["a"]
		var b: Vector2 = seg["b"]
		var tt := _clip(a, b, rect)
		if tt.x >= tt.y:
			continue
		var len := a.distance_to(b)
		var dir := (b - a) / maxf(len, 0.001)
		var side := Vector2(-dir.y, dir.x)
		var hw: float = seg["hw"]
		var ya: float = seg["ya"]
		var yb: float = seg["yb"]
		var yaw_road := atan2(-dir.x, -dir.y)
		var urban := WorldLayout.URBAN.has_point((a + b) * 0.5)
		var t := tt.x * len + r.randf() * 8.0
		while t < tt.y * len:
			var y := lerpf(ya, yb, t / len)
			var roll := r.randf()
			if roll < (0.3 if urban else 0.08) and kind != "highway":
				var p := a + dir * t + side * r.randf_range(-hw * 0.35, hw * 0.35)
				var open := not pre and r.randf() < 0.15
				_add_prop(props, "manhole_open" if open else "manhole", Transform3D(Basis(Vector3.UP, r.randf() * TAU), Vector3(p.x, y + 0.004, p.y)))
			elif roll < 0.55:
				var p := a + dir * t + side * r.randf_range(-hw + 1.0, hw - 1.0)
				_add_prop(props, "road_patch", Transform3D(Basis(Vector3.UP, yaw_road + r.randf_range(-0.4, 0.4)).scaled(Vector3.ONE * r.randf_range(0.7, 1.6)), Vector3(p.x, y, p.y)))
			elif roll < 0.75 and urban:
				# óleo onde os carros ficam parados (junto ao meio-fio) ou no meio da faixa
				var lat := (hw - 1.3) * (1.0 if r.randf() < 0.5 else -1.0) if r.randf() < 0.6 else r.randf_range(-hw * 0.6, hw * 0.6)
				var p := a + dir * t + side * lat
				_add_prop(props, "oil_stain", Transform3D(Basis(Vector3.UP, yaw_road + r.randf_range(-0.3, 0.3)).scaled(Vector3.ONE * r.randf_range(0.8, 1.4)), Vector3(p.x, y, p.y)))
			if not pre:
				var p := a + dir * (t + r.randf() * 6.0) + side * r.randf_range(-hw + 0.6, hw - 0.6)
				var v := r.randf()
				if v < (0.34 if urban else 0.12):
					_add_prop(props, "litter", Transform3D(Basis(Vector3.UP, r.randf() * TAU).scaled(Vector3.ONE * r.randf_range(0.7, 1.3)), Vector3(p.x, y, p.y)))
				elif v < 0.4 and urban:
					# cones espalhados (alguns tombados)
					for k in r.randi_range(2, 5):
						var q := p + dir * r.randf_range(-3.0, 3.0) + side * r.randf_range(-1.2, 1.2)
						var bs := Basis(Vector3.UP, r.randf() * TAU)
						var yy := y
						if r.randf() < 0.35:
							bs = bs * Basis(Vector3.BACK, PI * 0.5)
							yy += 0.16
						_add_prop(props, "traffic_cone", Transform3D(bs, Vector3(q.x, yy, q.y)))
				elif v < 0.43 and urban:
					_add_prop(props, "road_barrier", Transform3D(Basis(Vector3.UP, yaw_road + PI * 0.5 + r.randf_range(-0.5, 0.5)), Vector3(p.x, y, p.y)), none, colliders, true)
				elif v < 0.47:
					_add_prop(props, "tire_single", Transform3D(Basis(Vector3.UP, r.randf() * TAU), Vector3(p.x, y, p.y)))
				elif v < (0.485 if post else 0.5):
					_add_prop(props, "blood_smear", Transform3D(Basis(Vector3.UP, yaw_road + r.randf_range(-0.6, 0.6)).scaled(Vector3.ONE * r.randf_range(0.8, 1.3)), Vector3(p.x, y, p.y)))
			t += r.randf_range(10.0, 18.0)
	if not pre:
		# em volta de carros abandonados/queimados: cacos, sangue ou um corpo coberto
		for car in cars:
			var st: String = car["state"]
			if st == "parked" or r.randf() > 0.22:
				continue
			var cp: Vector3 = car["pos"]
			var yaw: float = car["yaw"]
			var left := Vector3(cos(yaw), 0, -sin(yaw))
			var dp := cp + left * (1.6 if r.randf() < 0.5 else -1.6) + Vector3(-sin(yaw), 0, -cos(yaw)) * r.randf_range(-0.6, 0.4)
			var pick := r.randf()
			var pn := "litter" if pick < 0.45 else ("blood_pool_2" if pick < 0.7 else ("covered_body" if pick < 0.82 and phase == GameState.Phase.SILENCE else ("remains" if pick < 0.9 else "traffic_cone")))
			_add_prop(props, pn, Transform3D(Basis(Vector3.UP, yaw + r.randf_range(-0.5, 0.5)), dp))
	# --- calçadas --------------------------------------------------------------------
	for bid in layout.chunk_blocks.get(c, []):
		var blk: Dictionary = layout.blocks[bid]
		var br: Rect2 = blk["rect"]
		var dist: String = blk["district"]
		var core := dist in ["centro", "centro_sul", "bairro_alto"]
		var sides := [[Vector2(br.position.x, br.position.y), Vector2(1, 0), Vector2(0, -1), br.size.x],
			[Vector2(br.end.x, br.position.y), Vector2(0, 1), Vector2(1, 0), br.size.y],
			[Vector2(br.end.x, br.end.y), Vector2(-1, 0), Vector2(0, 1), br.size.x],
			[Vector2(br.position.x, br.end.y), Vector2(0, -1), Vector2(-1, 0), br.size.y]]
		for sd in sides:
			var o: Vector2 = sd[0]
			var dir: Vector2 = sd[1]
			var rn: Vector2 = sd[2]
			var slen: float = sd[3]
			var yaw_to_road := Util.dir_to_yaw(Vector3(rn.x, 0, rn.y))
			var t := 4.0 + r.randf() * 6.0
			while t < slen - 3.0:
				var inset := r.randf_range(0.9, WorldLayout.SIDEWALK - 0.6)
				var p := o + dir * t - rn * inset
				t += r.randf_range(8.0, 14.0)
				if not rect.has_point(p) or layout.building_at(Vector3(p.x, 0, p.y), 0.4) >= 0:
					continue
				var y := layout.ground_height(p.x, p.y)
				var p3 := Vector3(p.x, y, p.y)
				var v := r.randf()
				if core and v < 0.03:
					_add_prop(props, "newspaper_stand", Transform3D(Basis(Vector3.UP, yaw_to_road), Vector3(p.x, y, p.y) + Vector3(-rn.x, 0, -rn.y) * (WorldLayout.SIDEWALK - inset - 0.5)), none, colliders, true)
					continue
				if pre:
					continue
				var yw := Basis(Vector3.UP, r.randf() * TAU)
				if v < 0.25:
					_add_prop(props, "litter", Transform3D(yw.scaled(Vector3.ONE * r.randf_range(0.6, 1.1)), p3))
				elif v < 0.31:
					_add_prop(props, "trash_bags" if r.randf() < 0.6 else "cardboard", Transform3D(yw, Vector3(p.x, y, p.y) + Vector3(-rn.x, 0, -rn.y) * (WorldLayout.SIDEWALK - inset - 0.45)))
				elif v < 0.35 and core:
					_add_prop(props, "shopping_cart", Transform3D(yw, p3), none, colliders, true)
				elif v < 0.39:
					_add_prop(props, "suitcase", Transform3D(yw, p3))
				elif v < 0.42:
					_add_prop(props, "bicycle", Transform3D(yw, p3))
				elif v < 0.435:
					_add_prop(props, "mattress", Transform3D(yw, p3))
				elif v < 0.46:
					_add_prop(props, "blood_pool" if r.randf() < 0.6 else "blood_pool_2", Transform3D(yw, p3))
				elif v < 0.47:
					_add_prop(props, "covered_body" if phase == GameState.Phase.SILENCE else ("remains" if r.randf() < 0.6 else "bones"), Transform3D(yw, p3))
				elif v < 0.474 and post:
					_add_prop(props, "severed_arm", Transform3D(yw, p3))
	# --- fachadas: cartazes, sangue e furos de bala -------------------------------------
	for bi in layout.buildings_owned_by(c):
		var b: Dictionary = layout.buildings[bi]
		var btype: String = b["type"]
		if btype in ["stadium", "barn"]:
			continue
		var br: Rect2 = b["rect"]
		var base: float = b["base"]
		var di := BuildingGen.door_info(b)
		var door: Vector3 = di[0]
		var n_post := (r.randi_range(0, 3) if btype not in ["house"] else (1 if r.randf() < 0.25 else 0))
		var n_marks := 0 if pre else (r.randi_range(0, 2) if btype in ["police", "hospital", "clinic", "market", "shop"] else (1 if r.randf() < 0.3 else 0))
		for k in n_post + n_marks:
			var sd := r.randi() % 4
			var p := Vector3.ZERO
			var yaw := 0.0
			match sd:
				0:
					p = Vector3(r.randf_range(br.position.x + 1.0, br.end.x - 1.0), 0, br.position.y - 0.03)
					yaw = 0.0
				1:
					p = Vector3(br.end.x + 0.03, 0, r.randf_range(br.position.y + 1.0, br.end.y - 1.0))
					yaw = -PI * 0.5
				2:
					p = Vector3(r.randf_range(br.position.x + 1.0, br.end.x - 1.0), 0, br.end.y + 0.03)
					yaw = PI
				_:
					p = Vector3(br.position.x - 0.03, 0, r.randf_range(br.position.y + 1.0, br.end.y - 1.0))
					yaw = PI * 0.5
			if Vector2(p.x - door.x, p.z - door.z).length() < 2.2:
				continue
			if k < n_post:
				p.y = base + r.randf_range(1.3, 1.9)
				_add_prop(props, "wall_poster", Transform3D(Basis(Vector3.UP, yaw) * Basis(Vector3.BACK, r.randf_range(-0.06, 0.06)), p))
			else:
				p.y = base + r.randf_range(0.8, 1.6)
				var pn := "bullet_holes" if r.randf() < 0.55 else "blood_wall"
				var roll := r.randf() * TAU if pn == "bullet_holes" else r.randf_range(-0.15, 0.15)
				_add_prop(props, pn, Transform3D(Basis(Vector3.UP, yaw) * Basis(Vector3.BACK, roll), p))


static func build_phase(layout: WorldLayout, c: Vector2i, phase: int) -> Dictionary:
	var props := {}
	var colliders: Array = []
	var cars: Array = []
	var vines: Array = []
	var rect := Rect2(c.x * WorldLayout.CHUNK, c.y * WorldLayout.CHUNK, WorldLayout.CHUNK, WorldLayout.CHUNK)
	var r := Util.rng(Util.hash2(c.x, c.y, 7000 + phase))
	var post := phase == GameState.Phase.POST
	var silence := phase == GameState.Phase.SILENCE
	# carros estacionados / abandonados ao longo das ruas
	for si in layout.chunk_roads.get(c, []):
		var seg: Dictionary = layout.roads[si]
		var kind: String = seg["kind"]
		if kind in ["tunnel", "bridge", "dirt"]:
			if not (post and kind == "tunnel"):
				continue
		var a: Vector2 = seg["a"]
		var b: Vector2 = seg["b"]
		var tt := _clip(a, b, rect)
		if tt.x >= tt.y:
			continue
		var len := a.distance_to(b)
		var dir := (b - a) / maxf(len, 0.001)
		var side := Vector2(-dir.y, dir.x)
		var hw: float = seg["hw"]
		var t := tt.x * len + r.randf() * 6.0
		var density := 0.45 if phase == GameState.Phase.PRE else (0.5 if silence else 0.4)
		if kind == "highway":
			density *= 0.35
		while t < tt.y * len:
			if r.randf() < density:
				var sgn := -1.0 if r.randf() < 0.5 else 1.0
				var lateral := (hw - 1.3) * sgn
				var yaw := atan2(-dir.x, -dir.y) + (0.0 if sgn > 0.0 else PI)
				var state := "parked"
				if post or silence:
					if r.randf() < 0.35:
						lateral = r.randf_range(-hw + 1.5, hw - 1.5)
						yaw += r.randf_range(-0.7, 0.7)
						state = "abandoned"
					if post and r.randf() < 0.12:
						state = "burned"
				var p2 := a + dir * t + side * lateral
				var ya: float = seg["ya"]
				var yb: float = seg["yb"]
				var y := lerpf(ya, yb, t / len)
				# inclina o carro junto com a pista (a serra chega a ~8% de rampa)
				var nose := Vector2(-sin(yaw), -cos(yaw))
				var pitch := atan((yb - ya) / maxf(len, 0.001) * nose.dot(dir))
				cars.append({"pos": Vector3(p2.x, y, p2.y), "yaw": yaw, "pitch": pitch, "type": ["compact", "sedan", "sedan", "hatch", "pickup", "van", "suv"][r.randi() % 7],
					"color": Color.from_hsv(r.randf(), r.randf_range(0.1, 0.7), r.randf_range(0.25, 0.9)), "state": state,
					"uid": "car_%d_%d_%d" % [c.x, c.y, int(t * 10.0)]})
			t += r.randf_range(7.0, 14.0)
	# carros nas vagas dos estacionamentos
	for bid in layout.chunk_blocks.get(c, []):
		var blk: Dictionary = layout.blocks[bid]
		var br: Rect2 = blk["rect"]
		if not blk["kind"] in LOT_KINDS or not rect.has_point(br.get_center()):
			continue
		for bay in lot_bays(layout, blk):
			if r.randf() > (0.6 if phase == GameState.Phase.PRE else 0.4):
				continue
			var bp: Vector3 = bay[0]
			var st := "parked"
			if post and r.randf() < 0.1:
				st = "burned"
			cars.append({"pos": Vector3(bp.x, WorldLayout.CURB, bp.z), "yaw": float(bay[1]) + r.randf_range(-0.05, 0.05), "pitch": 0.0,
				"type": ["compact", "sedan", "sedan", "hatch", "pickup", "suv"][r.randi() % 6],
				"color": Color.from_hsv(r.randf(), r.randf_range(0.1, 0.7), r.randf_range(0.25, 0.9)), "state": st,
				"uid": "carp_%d_%d_%d" % [c.x, c.y, int(bp.x * 10.0 + bp.z * 7.0)]})
	_street_clutter(layout, c, rect, phase, props, colliders, cars)
	if phase == GameState.Phase.PRE:
		return {"props": props, "colliders": colliders, "cars": cars, "vines": vines}
	# entulho, lixo, papéis
	for i in (18 if post else 12):
		var p := Vector2(rect.position.x + r.randf() * 64.0, rect.position.y + r.randf() * 64.0)
		if layout.is_water(p.x, p.y):
			continue
		if layout.building_at(Vector3(p.x, 0, p.y), 0.5) >= 0:
			continue
		var y := layout.ground_height(p.x, p.y)
		if not WorldLayout.URBAN.has_point(p) and r.randf() < 0.8:
			continue
		var pick := r.randf()
		var pn := "trash_bags" if pick < 0.35 else ("cardboard" if pick < 0.6 else ("debris_pile" if pick < 0.8 else "barrel"))
		_add_prop(props, pn, Transform3D(Basis(Vector3.UP, r.randf() * TAU), Vector3(p.x, y, p.y)), Color(1, 1, 1, 0), colliders, pn == "debris_pile")
	if not post:
		return {"props": props, "colliders": colliders, "cars": cars, "vines": vines}
	# barricadas em cruzamentos do centro e perto de territórios (com fita e aviso de quarentena)
	for pi in layout.chunk_patches.get(c, []):
		var pr: Rect2 = layout.patches[pi]
		var pc := pr.get_center()
		if not rect.has_point(pc):
			continue
		var dist := layout.district_at(pc.x, pc.y)
		var near_hq := pc.distance_to(Vector2(-250, 50)) < 180.0 or pc.distance_to(Vector2(-700, 400)) < 200.0
		if (dist == "centro" and r.randf() < 0.25) or (near_hq and r.randf() < 0.6):
			var axis_x := r.randf() < 0.5
			for k in 4:
				var off := (k - 1.5) * 2.1
				var p := pc + (Vector2(off, pr.size.y * 0.5 + 1.0) if axis_x else Vector2(pr.size.x * 0.5 + 1.0, off))
				var pn: String = ["sandbags", "concrete_barrier", "barricade_wood", "sandbags"][r.randi() % 4]
				_add_prop(props, pn, Transform3D(Basis(Vector3.UP, 0.0 if axis_x else PI * 0.5), Vector3(p.x, 0.02, p.y)), Color(1, 1, 1, 0), colliders, true)
			var sp := pc + (Vector2(6.0, pr.size.y * 0.5 + 3.2) if axis_x else Vector2(pr.size.x * 0.5 + 3.2, 6.0))
			_add_prop(props, "quarantine_sign", Transform3D(Basis(Vector3.UP, 0.0 if axis_x else PI * 0.5), Vector3(sp.x, 0.02, sp.y)), Color(1, 1, 1, 0), colliders, true)
			var tp := pc + (Vector2(-5.5, pr.size.y * 0.5 + 2.4) if axis_x else Vector2(pr.size.x * 0.5 + 2.4, -5.5))
			_add_prop(props, "tape_barrier", Transform3D(Basis(Vector3.UP, (0.0 if axis_x else PI * 0.5) + r.randf_range(-0.2, 0.2)), Vector3(tp.x, 0.02, tp.y)))
	# trepadeiras nas fachadas
	for bi in layout.buildings_owned_by(c):
		var b: Dictionary = layout.buildings[bi]
		if r.randf() < 0.45:
			var br: Rect2 = b["rect"]
			var count := r.randi_range(1, 4)
			for k in count:
				var side := r.randi() % 4
				var p := Vector3.ZERO
				var yaw := 0.0
				match side:
					0:
						p = Vector3(r.randf_range(br.position.x + 1.5, br.end.x - 1.5), float(b["base"]), br.position.y)
						yaw = 0.0
					1:
						p = Vector3(br.end.x, float(b["base"]), r.randf_range(br.position.y + 1.5, br.end.y - 1.5))
						yaw = -PI * 0.5
					2:
						p = Vector3(r.randf_range(br.position.x + 1.5, br.end.x - 1.5), float(b["base"]), br.end.y)
						yaw = PI
					_:
						p = Vector3(br.position.x, float(b["base"]), r.randf_range(br.position.y + 1.5, br.end.y - 1.5))
						yaw = PI * 0.5
				vines.append(Transform3D(Basis(Vector3.UP, yaw).scaled(Vector3.ONE * r.randf_range(0.8, 1.5)), p))
	# acampamentos abandonados
	for id: String in ["acampamento_floresta", "acampamento_estrada"]:
		var pp := layout.poi_pos(id)
		if rect.has_point(Vector2(pp.x, pp.z)):
			var cr := Util.rng(hash(id))
			for k in 4:
				var a := TAU * k / 4.0 + cr.randf() * 0.5
				var tp := Vector3(pp.x + cos(a) * 6.0, 0, pp.z + sin(a) * 6.0)
				tp.y = layout.ground_height(tp.x, tp.z)
				_add_prop(props, "tent", Transform3D(Basis(Vector3.UP, a + PI * 0.5), tp), Color(cr.randf_range(0.5, 1.2), cr.randf_range(0.5, 1.2), cr.randf_range(0.5, 1.2), 0), colliders, true)
			_add_prop(props, "campfire", Transform3D(Basis.IDENTITY, pp))
			_add_prop(props, "tarp_shelter", Transform3D(Basis(Vector3.UP, 0.4), pp + Vector3(3, 0, -4)))
			_add_prop(props, "crate", Transform3D(Basis(Vector3.UP, 0.2), pp + Vector3(-3, 0, 2)), Color(1, 1, 1, 0), colliders, true)
	return {"props": props, "colliders": colliders, "cars": cars, "vines": vines}
