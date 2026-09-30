class_name ChunkMesher
## Transforma o campo de densidade de um chunk em uma malha SUAVE usando
## "Surface Nets": um vertice por celula que cruza a superficie, e um quad por
## aresta que muda de sinal. Resultado: terreno arredondado, sem cubos.

const N := WorldGen.N
const P := WorldGen.P
const H := WorldGen.H
const SX := WorldGen.H          # passo em x no array
const SZ := WorldGen.P * WorldGen.H  # passo em z no array


## Retorna { verts, norms, cols, idx } prontos para ArrayMesh.
## `cx`/`cz` sao usados para variar levemente as cores (visual pintado a mao).
static func build(dens: PackedFloat32Array, mats: PackedByteArray, ymin: int, ymax: int, cx: int, cz: int) -> Dictionary:
	var verts := PackedVector3Array()
	var norms := PackedVector3Array()
	var cols := PackedColorArray()
	var idx := PackedInt32Array()

	var C := N + 1
	var YC := ymax - ymin + 1
	var vmap := PackedInt32Array()
	vmap.resize(C * C * YC)
	vmap.fill(-1)

	var palette: Array[Color] = Mats.COLORS

	var o1 := SX
	var o2 := 1
	var o3 := SX + 1
	var o4 := SZ
	var o5 := SZ + SX
	var o6 := SZ + 1
	var o7 := SZ + SX + 1

	# --- Passo 1: um vertice por celula na superficie ---
	for z in C:
		for x in C:
			var colbase := (z * P + x) * H
			var vbase := (z * C + x) * YC - ymin
			for y in range(ymin, ymax + 1):
				var i := colbase + y
				var d0 := dens[i]
				var d1 := dens[i + o1]
				var d2 := dens[i + o2]
				var d3 := dens[i + o3]
				var d4 := dens[i + o4]
				var d5 := dens[i + o5]
				var d6 := dens[i + o6]
				var d7 := dens[i + o7]
				var s0 := d0 > 0.0
				var s1 := d1 > 0.0
				var s2 := d2 > 0.0
				var s3 := d3 > 0.0
				var s4 := d4 > 0.0
				var s5 := d5 > 0.0
				var s6 := d6 > 0.0
				var s7 := d7 > 0.0
				if s0 == s1 and s0 == s2 and s0 == s3 and s0 == s4 and s0 == s5 and s0 == s6 and s0 == s7:
					continue
				var px := 0.0
				var py := 0.0
				var pz := 0.0
				var cnt := 0
				var t := 0.0
				# arestas em x
				if s0 != s1:
					t = d0 / (d0 - d1); px += t; cnt += 1
				if s2 != s3:
					t = d2 / (d2 - d3); px += t; py += 1.0; cnt += 1
				if s4 != s5:
					t = d4 / (d4 - d5); px += t; pz += 1.0; cnt += 1
				if s6 != s7:
					t = d6 / (d6 - d7); px += t; py += 1.0; pz += 1.0; cnt += 1
				# arestas em y
				if s0 != s2:
					t = d0 / (d0 - d2); py += t; cnt += 1
				if s1 != s3:
					t = d1 / (d1 - d3); px += 1.0; py += t; cnt += 1
				if s4 != s6:
					t = d4 / (d4 - d6); pz += 1.0; py += t; cnt += 1
				if s5 != s7:
					t = d5 / (d5 - d7); px += 1.0; pz += 1.0; py += t; cnt += 1
				# arestas em z
				if s0 != s4:
					t = d0 / (d0 - d4); pz += t; cnt += 1
				if s1 != s5:
					t = d1 / (d1 - d5); px += 1.0; pz += t; cnt += 1
				if s2 != s6:
					t = d2 / (d2 - d6); py += 1.0; pz += t; cnt += 1
				if s3 != s7:
					t = d3 / (d3 - d7); px += 1.0; py += 1.0; pz += t; cnt += 1
				var inv := 1.0 / cnt
				var v := Vector3(x + px * inv, y + py * inv, z + pz * inv)

				# normal = -gradiente da densidade
				var gx := (d1 - d0) + (d3 - d2) + (d5 - d4) + (d7 - d6)
				var gy := (d2 - d0) + (d3 - d1) + (d6 - d4) + (d7 - d5)
				var gz := (d4 - d0) + (d5 - d1) + (d6 - d2) + (d7 - d3)
				var n := Vector3(-gx, -gy, -gz).normalized()

				# material: o canto solido mais proximo da superficie
				var best := 1.0e9
				var m := 0
				if s0 and d0 < best: best = d0; m = mats[i]
				if s1 and d1 < best: best = d1; m = mats[i + o1]
				if s2 and d2 < best: best = d2; m = mats[i + o2]
				if s3 and d3 < best: best = d3; m = mats[i + o3]
				if s4 and d4 < best: best = d4; m = mats[i + o4]
				if s5 and d5 < best: best = d5; m = mats[i + o5]
				if s6 and d6 < best: best = d6; m = mats[i + o6]
				if s7 and d7 < best: best = d7; m = mats[i + o7]

				var col: Color = palette[m]
				# pequena variacao de tom (aspecto pintado)
				var hsh := ((cx * N + x) * 73856093) ^ (y * 19349663) ^ ((cz * N + z) * 83492791)
				var f := 0.95 + float(hsh & 255) / 255.0 * 0.08
				# alfa diz ao shader como a cor muda nas encostas (grama -> terra -> pedra)
				col = Color(col.r * f, col.g * f, col.b * f, Mats.slope_code(m))

				vmap[vbase + y] = verts.size()
				verts.append(v)
				norms.append(n)
				cols.append(col)

	# --- Passo 2: quads nas arestas que cruzam a superficie ---
	for z in C:
		for x in C:
			var colbase := (z * P + x) * H
			var vb := (z * C + x) * YC - ymin
			var vb_x := vb - YC            # celula x-1
			var vb_z := vb - C * YC        # celula z-1
			var vb_xz := vb - C * YC - YC  # celula x-1, z-1
			for y in range(ymin, ymax + 1):
				var i := colbase + y
				var s0 := dens[i] > 0.0
				# aresta em x: (x,y,z)->(x+1,y,z)
				if x < N and z >= 1 and y > ymin:
					if s0 != (dens[i + SX] > 0.0):
						var a := vmap[vb_z + y - 1]
						var b := vmap[vb_z + y]
						var c := vmap[vb + y]
						var d := vmap[vb + y - 1]
						if s0:
							_quad(idx, verts, d, c, b, a)
						else:
							_quad(idx, verts, a, b, c, d)
				# aresta em y: (x,y,z)->(x,y+1,z)
				if x >= 1 and z >= 1:
					if s0 != (dens[i + 1] > 0.0):
						var a := vmap[vb_xz + y]
						var b := vmap[vb_x + y]
						var c := vmap[vb + y]
						var d := vmap[vb_z + y]
						if s0:
							_quad(idx, verts, d, c, b, a)
						else:
							_quad(idx, verts, a, b, c, d)
				# aresta em z: (x,y,z)->(x,y,z+1)
				if z < N and x >= 1 and y > ymin:
					if s0 != (dens[i + SZ] > 0.0):
						var a := vmap[vb_x + y - 1]
						var b := vmap[vb + y - 1]
						var c := vmap[vb + y]
						var d := vmap[vb_x + y]
						if s0:
							_quad(idx, verts, d, c, b, a)
						else:
							_quad(idx, verts, a, b, c, d)

	return {"verts": verts, "norms": norms, "cols": cols, "idx": idx}


## Divide o quad pela diagonal mais curta (superficie mais lisa).
static func _quad(idx: PackedInt32Array, verts: PackedVector3Array, q0: int, q1: int, q2: int, q3: int) -> void:
	if verts[q0].distance_squared_to(verts[q2]) <= verts[q1].distance_squared_to(verts[q3]):
		idx.append(q0); idx.append(q1); idx.append(q2)
		idx.append(q0); idx.append(q2); idx.append(q3)
	else:
		idx.append(q0); idx.append(q1); idx.append(q3)
		idx.append(q1); idx.append(q2); idx.append(q3)


static func make_mesh(data: Dictionary, material: Material) -> ArrayMesh:
	var mesh := ArrayMesh.new()
	var verts: PackedVector3Array = data["verts"]
	var idx: PackedInt32Array = data["idx"]
	if verts.is_empty() or idx.is_empty():
		return mesh
	var arr := []
	arr.resize(Mesh.ARRAY_MAX)
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_NORMAL] = data["norms"]
	arr[Mesh.ARRAY_COLOR] = data["cols"]
	arr[Mesh.ARRAY_INDEX] = idx
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	mesh.surface_set_material(0, material)
	return mesh


static func collision_faces(data: Dictionary) -> PackedVector3Array:
	var verts: PackedVector3Array = data["verts"]
	var idx: PackedInt32Array = data["idx"]
	var faces := PackedVector3Array()
	faces.resize(idx.size())
	for k in idx.size():
		faces[k] = verts[idx[k]]
	return faces
