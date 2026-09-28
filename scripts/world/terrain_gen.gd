class_name TerrainGen
extends RefCounted
## Geração de malha/colisão de terreno e superfícies de água por chunk.
## Função pura sobre dados do WorldLayout => roda em WorkerThreadPool.

const SKIRT := 4.0


## res = número de células por lado (32 => 2 m, 16 => 4 m, 8 => 8 m)
static func build(layout: WorldLayout, c: Vector2i, res: int, want_collision: bool) -> Dictionary:
	var size := WorldLayout.CHUNK
	var cell := size / float(res)
	var x0 := float(c.x) * size
	var z0 := float(c.y) * size
	var n := res + 1
	# alturas com borda de 1 célula para normais contínuas entre chunks
	var hb := PackedFloat32Array()
	hb.resize((n + 2) * (n + 2))
	for iz in n + 2:
		for ix in n + 2:
			var x := x0 + float(ix - 1) * cell
			var z := z0 + float(iz - 1) * cell
			hb[iz * (n + 2) + ix] = layout.height(x, z)
	var heights := PackedFloat32Array()
	heights.resize(n * n)
	var verts := PackedVector3Array()
	var norms := PackedVector3Array()
	var tans := PackedFloat32Array()
	var cols := PackedColorArray()
	var uvs := PackedVector2Array()
	verts.resize(n * n)
	norms.resize(n * n)
	cols.resize(n * n)
	uvs.resize(n * n)
	tans.resize(n * n * 4)
	var urban := WorldLayout.URBAN
	for iz in n:
		for ix in n:
			var h := hb[(iz + 1) * (n + 2) + ix + 1]
			var hl := hb[(iz + 1) * (n + 2) + ix]
			var hr := hb[(iz + 1) * (n + 2) + ix + 2]
			var hd := hb[iz * (n + 2) + ix + 1]
			var hu := hb[(iz + 2) * (n + 2) + ix + 1]
			var x := x0 + float(ix) * cell
			var z := z0 + float(iz) * cell
			var i := iz * n + ix
			heights[i] = h
			verts[i] = Vector3(x, h, z)
			var nrm := Vector3(hl - hr, 2.0 * cell, hd - hu).normalized()
			norms[i] = nrm
			var t := Vector3(1, 0, 0)
			t = (t - nrm * nrm.dot(t)).normalized()
			tans[i * 4] = t.x
			tans[i * 4 + 1] = t.y
			tans[i * 4 + 2] = t.z
			tans[i * 4 + 3] = 1.0
			uvs[i] = Vector2(x, z)
			cols[i] = _splat(layout, x, z, h, urban)
	var idx := PackedInt32Array()
	var holes: Array = layout.terrain_holes()
	var chunk_rect := Rect2(x0, z0, size, size)
	var has_holes := false
	for hr in holes:
		if chunk_rect.intersects(hr):
			has_holes = true
	for iz in res:
		for ix in res:
			if has_holes:
				var cc := Vector2(x0 + (ix + 0.5) * cell, z0 + (iz + 0.5) * cell)
				var skip := false
				for hr in holes:
					if (hr as Rect2).has_point(cc):
						skip = true
				if skip:
					continue
			var a := iz * n + ix
			var b := a + 1
			var d := a + n
			var e := d + 1
			# frente = sentido horário visto de cima (normal +Y)
			idx.append(a); idx.append(b); idx.append(e)
			idx.append(a); idx.append(e); idx.append(d)
	# saias nas bordas (escondem frestas entre LODs)
	var edges := [[0, 1, 0], [n - 1, 1, 0], [0, 0, 1], [n - 1, 0, 1]]
	for eg in edges:
		var fixed: int = eg[0]
		var along_x: bool = eg[1] == 1
		var base_i := verts.size()
		for k in n:
			var src := (fixed * n + k) if along_x else (k * n + fixed)
			var p := verts[src]
			verts.append(p)
			verts.append(p - Vector3(0, SKIRT, 0))
			norms.append(norms[src])
			norms.append(norms[src])
			for q in 2:
				tans.append(1.0)
				tans.append(0.0)
				tans.append(0.0)
				tans.append(1.0)
			cols.append(cols[src])
			cols.append(cols[src])
			uvs.append(uvs[src])
			uvs.append(uvs[src] + Vector2(0, 0.5))
		for k in n - 1:
			var t0 := base_i + k * 2
			var t1 := t0 + 2
			# saias são visíveis de ambos os lados via duas faces
			idx.append(t0); idx.append(t1); idx.append(t0 + 1)
			idx.append(t1); idx.append(t1 + 1); idx.append(t0 + 1)
			idx.append(t0); idx.append(t0 + 1); idx.append(t1)
			idx.append(t1); idx.append(t0 + 1); idx.append(t1 + 1)
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = norms
	arrays[Mesh.ARRAY_TANGENT] = tans
	arrays[Mesh.ARRAY_COLOR] = cols
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = idx
	var out := {"arrays": arrays, "heights": heights, "res": res, "cell": cell, "has_holes": has_holes}
	if want_collision and has_holes:
		# colisão trimesh (sem os buracos dos portais) para os chunks do túnel
		var faces := PackedVector3Array()
		for q in range(0, idx.size(), 3):
			if idx[q] >= n * n:
				break
			faces.append(verts[idx[q]])
			faces.append(verts[idx[q + 2]])
			faces.append(verts[idx[q + 1]])
		out["faces"] = faces
	out["water"] = _water(layout, c, hb, n, cell, x0, z0)
	return out


static func _splat(layout: WorldLayout, x: float, z: float, h: float, urban: Rect2) -> Color:
	var dirt := 0.0
	var rock := 0.0
	var grav := 0.0
	if urban.has_point(Vector2(x, z)):
		dirt = 0.7
	else:
		var rd := layout.river_distance(x, z)
		if rd < WorldLayout.RIVER_HALF + 34.0:
			grav = 1.0 - smoothstep(WorldLayout.RIVER_HALF + 8.0, WorldLayout.RIVER_HALF + 34.0, rd)
		var le := ((Vector2(x, z) - WorldLayout.LAKE_CENTER) / WorldLayout.LAKE_R).length()
		if le < 1.5:
			grav = maxf(grav, 1.0 - smoothstep(1.05, 1.5, le))
		if h > 40.0:
			rock = smoothstep(40.0, 62.0, h) * 0.7
		var n := layout.noise2.get_noise_2d(x * 0.5, z * 0.5)
		dirt = smoothstep(0.35, 0.7, n) * 0.6
		var dist_name := layout.district_at(x, z)
		if dist_name == "floresta":
			dirt = maxf(dirt, 0.45)
	return Color(dirt, rock, grav, 1.0)


static func _water(layout: WorldLayout, c: Vector2i, hb: PackedFloat32Array, n: int, cell: float, x0: float, z0: float) -> Array:
	# grade de 4 m: emite quad onde algum canto está abaixo do nível
	var step := maxi(1, int(4.0 / cell))
	var verts := PackedVector3Array()
	var norms := PackedVector3Array()
	var uvs := PackedVector2Array()
	var idx := PackedInt32Array()
	var chunk_center := Vector2(x0 + 32.0, z0 + 32.0)
	var near_lake := chunk_center.distance_to(WorldLayout.LAKE_CENTER) < 320.0
	var level := WorldLayout.LAKE_LEVEL if near_lake else WorldLayout.RIVER_LEVEL
	var any := false
	var iz := 0
	while iz < n - 1:
		var ix := 0
		while ix < n - 1:
			var i1 := mini(ix + step, n - 1)
			var j1 := mini(iz + step, n - 1)
			var h00 := hb[(iz + 1) * (n + 2) + ix + 1]
			var h10 := hb[(iz + 1) * (n + 2) + i1 + 1]
			var h01 := hb[(j1 + 1) * (n + 2) + ix + 1]
			var h11 := hb[(j1 + 1) * (n + 2) + i1 + 1]
			if minf(minf(h00, h10), minf(h01, h11)) < level - 0.05:
				any = true
				var ax := x0 + ix * cell
				var az := z0 + iz * cell
				var bx := x0 + i1 * cell
				var bz := z0 + j1 * cell
				var base := verts.size()
				verts.append(Vector3(ax, level, az))
				verts.append(Vector3(bx, level, az))
				verts.append(Vector3(bx, level, bz))
				verts.append(Vector3(ax, level, bz))
				for q in 4:
					norms.append(Vector3.UP)
				uvs.append(Vector2(ax, az))
				uvs.append(Vector2(bx, az))
				uvs.append(Vector2(bx, bz))
				uvs.append(Vector2(ax, bz))
				idx.append(base); idx.append(base + 1); idx.append(base + 2)
				idx.append(base); idx.append(base + 2); idx.append(base + 3)
			ix += step
		iz += step
	if not any:
		return []
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = norms
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = idx
	return arrays
