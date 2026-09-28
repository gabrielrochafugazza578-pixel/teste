class_name MeshBuf
extends RefCounted
## Acumulador de geometria para o material "world_surface".
##
## Permite mesclar todas as paredes, telhados, calçadas e móveis de um chunk
## em UMA malha (poucas draw calls). Todas as UVs são em metros.
## Pode ser preenchido em thread de trabalho (só arrays; sem nós/recursos).

var verts := PackedVector3Array()
var norms := PackedVector3Array()
var tans := PackedFloat32Array()
var cols := PackedColorArray()
var uvs := PackedVector2Array()
var uv2s := PackedVector2Array()
var idx := PackedInt32Array()

## Caixas de colisão acumuladas: [Transform3D, Vector3 tamanho]
var colliders: Array = []


func is_empty() -> bool:
	return verts.is_empty()


func vertex_count() -> int:
	return verts.size()


func _vert(p: Vector3, n: Vector3, t: Vector3, tw: float, uv: Vector2, code: float, seed_value: float, c: Color) -> int:
	verts.append(p)
	norms.append(n)
	tans.append(t.x)
	tans.append(t.y)
	tans.append(t.z)
	tans.append(tw)
	cols.append(c)
	uvs.append(uv)
	uv2s.append(Vector2(code, seed_value))
	return verts.size() - 1


## Quad (p0..p3 em ordem ao redor da face) com normal de face `n`.
## UV em metros; tangente derivada das UVs.
func quad(p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, n: Vector3, uv0: Vector2, uv1: Vector2, uv2: Vector2, uv3: Vector2,
		code: float, seed_value: float = 0.0, c: Color = Color.WHITE) -> void:
	var e1 := p1 - p0
	var e2 := p3 - p0
	var d1 := uv1 - uv0
	var d2 := uv3 - uv0
	var det := d1.x * d2.y - d2.x * d1.y
	var t := Vector3.RIGHT
	var bdir := Vector3.UP
	if absf(det) > 0.000001:
		var r := 1.0 / det
		t = (e1 * d2.y - e2 * d1.y) * r
		bdir = (e2 * d1.x - e1 * d2.x) * r
	t = (t - n * n.dot(t))
	if t.length_squared() < 0.0000001:
		t = n.cross(Vector3.UP if absf(n.y) < 0.9 else Vector3.RIGHT)
	t = t.normalized()
	var tw := -signf(n.cross(t).dot(bdir))
	if tw == 0.0:
		tw = 1.0
	var i0 := _vert(p0, n, t, tw, uv0, code, seed_value, c)
	var i1 := _vert(p1, n, t, tw, uv1, code, seed_value, c)
	var i2 := _vert(p2, n, t, tw, uv2, code, seed_value, c)
	var i3 := _vert(p3, n, t, tw, uv3, code, seed_value, c)
	var fn := (p1 - p0).cross(p2 - p0)
	if fn.dot(n) > 0.0:
		idx.append(i0); idx.append(i2); idx.append(i1)
		idx.append(i0); idx.append(i3); idx.append(i2)
	else:
		idx.append(i0); idx.append(i1); idx.append(i2)
		idx.append(i0); idx.append(i2); idx.append(i3)


func tri(p0: Vector3, p1: Vector3, p2: Vector3, n: Vector3, uv0: Vector2, uv1: Vector2, uv2: Vector2, code: float, seed_value: float = 0.0, c: Color = Color.WHITE) -> void:
	var t := (p1 - p0)
	t = (t - n * n.dot(t)).normalized()
	var tw := 1.0
	var i0 := _vert(p0, n, t, tw, uv0, code, seed_value, c)
	var i1 := _vert(p1, n, t, tw, uv1, code, seed_value, c)
	var i2 := _vert(p2, n, t, tw, uv2, code, seed_value, c)
	if (p1 - p0).cross(p2 - p0).dot(n) > 0.0:
		idx.append(i0); idx.append(i2); idx.append(i1)
	else:
		idx.append(i0); idx.append(i1); idx.append(i2)


## Parede vertical retangular de `a` até `b` (base), altura h, a partir de y0.
## Normal aponta para fora (lado direito de a->b visto de cima, se outward_right).
## UV: u = distância horizontal, v = altura desde `v_base` (janelas por shader).
func wall(a: Vector2, b: Vector2, y0: float, h: float, outward: Vector3, code: float, seed_value: float, c: Color = Color.WHITE, u_off: float = 0.0, v_base: float = 0.0) -> void:
	var len := a.distance_to(b)
	var p0 := Vector3(a.x, y0, a.y)
	var p1 := Vector3(b.x, y0, b.y)
	var p2 := Vector3(b.x, y0 + h, b.y)
	var p3 := Vector3(a.x, y0 + h, a.y)
	var vb := y0 - v_base
	quad(p0, p1, p2, p3, outward, Vector2(u_off, vb), Vector2(u_off + len, vb), Vector2(u_off + len, vb + h), Vector2(u_off, vb + h), code, seed_value, c)


## Parede com aberturas retangulares [[u0, u1, v0, v1], ...] (em metros locais).
func wall_with_holes(a: Vector2, b: Vector2, y0: float, h: float, outward: Vector3, holes: Array, code: float, seed_value: float, c: Color = Color.WHITE, v_base: float = 0.0) -> void:
	if holes.is_empty():
		wall(a, b, y0, h, outward, code, seed_value, c, 0.0, v_base)
		return
	var len := a.distance_to(b)
	var dir := (b - a) / maxf(len, 0.0001)
	# ordena por u
	var hs := holes.duplicate()
	hs.sort_custom(func(x, y): return float(x[0]) < float(y[0]))
	var u := 0.0
	for hole in hs:
		var u0: float = clampf(hole[0], 0.0, len)
		var u1: float = clampf(hole[1], 0.0, len)
		var v0: float = hole[2]
		var v1: float = minf(hole[3], h)
		if u0 > u:
			wall(a + dir * u, a + dir * u0, y0, h, outward, code, seed_value, c, u, v_base)
		# acima e abaixo da abertura
		if v1 < h:
			wall(a + dir * u0, a + dir * u1, y0 + v1, h - v1, outward, code, seed_value, c, u0, v_base)
		if v0 > 0.0:
			wall(a + dir * u0, a + dir * u1, y0, v0, outward, code, seed_value, c, u0, v_base)
		u = maxf(u, u1)
	if u < len:
		wall(a + dir * u, b, y0, h, outward, code, seed_value, c, u, v_base)


## Caixa alinhada aos eixos. faces: bitmask (1 +X, 2 -X, 4 +Y, 8 -Y, 16 +Z, 32 -Z)
func box(center: Vector3, size: Vector3, code: float, seed_value: float = 0.0, c: Color = Color.WHITE, faces: int = 63, side_code: float = -1.0) -> void:
	var h := size * 0.5
	var mn := center - h
	var mx := center + h
	var sc := code if side_code < 0.0 else side_code
	if faces & 4:
		quad(Vector3(mn.x, mx.y, mn.z), Vector3(mx.x, mx.y, mn.z), Vector3(mx.x, mx.y, mx.z), Vector3(mn.x, mx.y, mx.z), Vector3.UP,
			Vector2(mn.x, mn.z), Vector2(mx.x, mn.z), Vector2(mx.x, mx.z), Vector2(mn.x, mx.z), code, seed_value, c)
	if faces & 8:
		quad(Vector3(mn.x, mn.y, mx.z), Vector3(mx.x, mn.y, mx.z), Vector3(mx.x, mn.y, mn.z), Vector3(mn.x, mn.y, mn.z), Vector3.DOWN,
			Vector2(mn.x, mx.z), Vector2(mx.x, mx.z), Vector2(mx.x, mn.z), Vector2(mn.x, mn.z), code, seed_value, c)
	if faces & 16:
		quad(Vector3(mn.x, mn.y, mx.z), Vector3(mx.x, mn.y, mx.z), Vector3(mx.x, mx.y, mx.z), Vector3(mn.x, mx.y, mx.z), Vector3.BACK,
			Vector2(mn.x, 0.0), Vector2(mx.x, 0.0), Vector2(mx.x, size.y), Vector2(mn.x, size.y), sc, seed_value, c)
	if faces & 32:
		quad(Vector3(mx.x, mn.y, mn.z), Vector3(mn.x, mn.y, mn.z), Vector3(mn.x, mx.y, mn.z), Vector3(mx.x, mx.y, mn.z), Vector3.FORWARD,
			Vector2(-mx.x, 0.0), Vector2(-mn.x, 0.0), Vector2(-mn.x, size.y), Vector2(-mx.x, size.y), sc, seed_value, c)
	if faces & 1:
		quad(Vector3(mx.x, mn.y, mx.z), Vector3(mx.x, mn.y, mn.z), Vector3(mx.x, mx.y, mn.z), Vector3(mx.x, mx.y, mx.z), Vector3.RIGHT,
			Vector2(-mx.z, 0.0), Vector2(-mn.z, 0.0), Vector2(-mn.z, size.y), Vector2(-mx.z, size.y), sc, seed_value, c)
	if faces & 2:
		quad(Vector3(mn.x, mn.y, mn.z), Vector3(mn.x, mn.y, mx.z), Vector3(mn.x, mx.y, mx.z), Vector3(mn.x, mx.y, mn.z), Vector3.LEFT,
			Vector2(mn.z, 0.0), Vector2(mx.z, 0.0), Vector2(mx.z, size.y), Vector2(mn.z, size.y), sc, seed_value, c)


## Caixa orientada (transform aplicada), UV em metros locais.
func box_xf(xf: Transform3D, size: Vector3, code: float, seed_value: float = 0.0, c: Color = Color.WHITE, faces: int = 63) -> void:
	var h := size * 0.5
	var b := xf.basis
	var o := xf.origin
	var corners := [
		Vector3(-h.x, -h.y, -h.z), Vector3(h.x, -h.y, -h.z), Vector3(h.x, h.y, -h.z), Vector3(-h.x, h.y, -h.z),
		Vector3(-h.x, -h.y, h.z), Vector3(h.x, -h.y, h.z), Vector3(h.x, h.y, h.z), Vector3(-h.x, h.y, h.z)]
	var w: Array = []
	for cc in corners:
		w.append(o + b * (cc as Vector3))
	var nx := (b * Vector3.RIGHT).normalized()
	var ny := (b * Vector3.UP).normalized()
	var nz := (b * Vector3.BACK).normalized()
	if faces & 4:
		quad(w[3], w[2], w[6], w[7], ny, Vector2(0, 0), Vector2(size.x, 0), Vector2(size.x, size.z), Vector2(0, size.z), code, seed_value, c)
	if faces & 8:
		quad(w[4], w[5], w[1], w[0], -ny, Vector2(0, 0), Vector2(size.x, 0), Vector2(size.x, size.z), Vector2(0, size.z), code, seed_value, c)
	if faces & 16:
		quad(w[4], w[5], w[6], w[7], nz, Vector2(0, 0), Vector2(size.x, 0), Vector2(size.x, size.y), Vector2(0, size.y), code, seed_value, c)
	if faces & 32:
		quad(w[1], w[0], w[3], w[2], -nz, Vector2(0, 0), Vector2(size.x, 0), Vector2(size.x, size.y), Vector2(0, size.y), code, seed_value, c)
	if faces & 1:
		quad(w[5], w[1], w[2], w[6], nx, Vector2(0, 0), Vector2(size.z, 0), Vector2(size.z, size.y), Vector2(0, size.y), code, seed_value, c)
	if faces & 2:
		quad(w[0], w[4], w[7], w[3], -nx, Vector2(0, 0), Vector2(size.z, 0), Vector2(size.z, size.y), Vector2(0, size.y), code, seed_value, c)


## Cilindro vertical (ou orientado por xf).
func cylinder(xf: Transform3D, radius: float, height: float, sides: int, code: float, seed_value: float = 0.0, c: Color = Color.WHITE, caps: bool = true, radius_top: float = -1.0) -> void:
	var rt := radius if radius_top < 0.0 else radius_top
	var b := xf.basis
	var o := xf.origin
	var circ := TAU * radius
	for k in sides:
		var a0 := TAU * float(k) / float(sides)
		var a1 := TAU * float(k + 1) / float(sides)
		var d0 := Vector3(cos(a0), 0.0, sin(a0))
		var d1 := Vector3(cos(a1), 0.0, sin(a1))
		var p0 := o + b * (d0 * radius)
		var p1 := o + b * (d1 * radius)
		var p2 := o + b * (d1 * rt + Vector3(0, height, 0))
		var p3 := o + b * (d0 * rt + Vector3(0, height, 0))
		var n := (b * ((d0 + d1) * 0.5)).normalized()
		var u0 := circ * float(k) / float(sides)
		var u1 := circ * float(k + 1) / float(sides)
		quad(p0, p1, p2, p3, n, Vector2(u0, 0), Vector2(u1, 0), Vector2(u1, height), Vector2(u0, height), code, seed_value, c)
		if caps:
			var up := (b * Vector3.UP).normalized()
			var top := o + b * Vector3(0, height, 0)
			tri(top, p3, p2, up, Vector2(0, 0), Vector2(d0.x * rt, d0.z * rt), Vector2(d1.x * rt, d1.z * rt), code, seed_value, c)


## Telhado de duas águas sobre um retângulo (xz). ridge_x: cumeeira ao longo de X.
func gable_roof(rect: Rect2, y0: float, rise: float, overhang: float, ridge_x: bool, code: float, gable_code: float, seed_value: float, c: Color = Color.WHITE, gable_c: Color = Color.WHITE) -> void:
	var r := rect.grow(overhang)
	var x0 := r.position.x
	var x1 := r.end.x
	var z0 := r.position.y
	var z1 := r.end.y
	if ridge_x:
		var zm := (z0 + z1) * 0.5
		var slope_len := Vector2((z1 - z0) * 0.5, rise).length()
		var n1 := Vector3(0, (z1 - z0) * 0.5, -rise).normalized()
		var n2 := Vector3(0, (z1 - z0) * 0.5, rise).normalized()
		quad(Vector3(x0, y0, z0), Vector3(x1, y0, z0), Vector3(x1, y0 + rise, zm), Vector3(x0, y0 + rise, zm), n1,
			Vector2(x0, 0), Vector2(x1, 0), Vector2(x1, slope_len), Vector2(x0, slope_len), code, seed_value, c)
		quad(Vector3(x1, y0, z1), Vector3(x0, y0, z1), Vector3(x0, y0 + rise, zm), Vector3(x1, y0 + rise, zm), n2,
			Vector2(-x1, 0), Vector2(-x0, 0), Vector2(-x0, slope_len), Vector2(-x1, slope_len), code, seed_value, c)
		# empenas (sobre a parede real, sem beiral)
		var gx0 := rect.position.x
		var gx1 := rect.end.x
		var gz0 := rect.position.y
		var gz1 := rect.end.y
		var gzm := (gz0 + gz1) * 0.5
		var grise := rise * (gz1 - gz0) / (z1 - z0)
		tri(Vector3(gx0, y0, gz0), Vector3(gx0, y0, gz1), Vector3(gx0, y0 + grise, gzm), Vector3.LEFT, Vector2(gz0, 0), Vector2(gz1, 0), Vector2(gzm, grise), gable_code, seed_value, gable_c)
		tri(Vector3(gx1, y0, gz1), Vector3(gx1, y0, gz0), Vector3(gx1, y0 + grise, gzm), Vector3.RIGHT, Vector2(-gz1, 0), Vector2(-gz0, 0), Vector2(-gzm, grise), gable_code, seed_value, gable_c)
		# face inferior do beiral
		quad(Vector3(x0, y0 - 0.02, z1), Vector3(x1, y0 - 0.02, z1), Vector3(x1, y0 - 0.02, z0), Vector3(x0, y0 - 0.02, z0), Vector3.DOWN,
			Vector2(x0, z1), Vector2(x1, z1), Vector2(x1, z0), Vector2(x0, z0), gable_code, seed_value, gable_c * 0.7)
	else:
		var xm := (x0 + x1) * 0.5
		var slope_len := Vector2((x1 - x0) * 0.5, rise).length()
		var n1 := Vector3(-rise, (x1 - x0) * 0.5, 0).normalized()
		var n2 := Vector3(rise, (x1 - x0) * 0.5, 0).normalized()
		quad(Vector3(x0, y0, z1), Vector3(x0, y0, z0), Vector3(xm, y0 + rise, z0), Vector3(xm, y0 + rise, z1), n1,
			Vector2(-z1, 0), Vector2(-z0, 0), Vector2(-z0, slope_len), Vector2(-z1, slope_len), code, seed_value, c)
		quad(Vector3(x1, y0, z0), Vector3(x1, y0, z1), Vector3(xm, y0 + rise, z1), Vector3(xm, y0 + rise, z0), n2,
			Vector2(z0, 0), Vector2(z1, 0), Vector2(z1, slope_len), Vector2(z0, slope_len), code, seed_value, c)
		var gx0 := rect.position.x
		var gx1 := rect.end.x
		var gxm := (gx0 + gx1) * 0.5
		var grise := rise * (gx1 - gx0) / (x1 - x0)
		tri(Vector3(gx1, y0, rect.position.y), Vector3(gx0, y0, rect.position.y), Vector3(gxm, y0 + grise, rect.position.y), Vector3.FORWARD,
			Vector2(-gx1, 0), Vector2(-gx0, 0), Vector2(-gxm, grise), gable_code, seed_value, gable_c)
		tri(Vector3(gx0, y0, rect.end.y), Vector3(gx1, y0, rect.end.y), Vector3(gxm, y0 + grise, rect.end.y), Vector3.BACK,
			Vector2(gx0, 0), Vector2(gx1, 0), Vector2(gxm, grise), gable_code, seed_value, gable_c)
		quad(Vector3(x0, y0 - 0.02, z1), Vector3(x1, y0 - 0.02, z1), Vector3(x1, y0 - 0.02, z0), Vector3(x0, y0 - 0.02, z0), Vector3.DOWN,
			Vector2(x0, z1), Vector2(x1, z1), Vector2(x1, z0), Vector2(x0, z0), gable_code, seed_value, gable_c * 0.7)


## Anexa outro buffer (com transformação).
func append(other: MeshBuf, xf: Transform3D = Transform3D.IDENTITY) -> void:
	var base := verts.size()
	var b := xf.basis
	var identity := xf == Transform3D.IDENTITY
	for i in other.verts.size():
		if identity:
			verts.append(other.verts[i])
			norms.append(other.norms[i])
		else:
			verts.append(xf * other.verts[i])
			norms.append((b * other.norms[i]).normalized())
		var ti := i * 4
		if identity:
			tans.append(other.tans[ti])
			tans.append(other.tans[ti + 1])
			tans.append(other.tans[ti + 2])
		else:
			var t := (b * Vector3(other.tans[ti], other.tans[ti + 1], other.tans[ti + 2])).normalized()
			tans.append(t.x)
			tans.append(t.y)
			tans.append(t.z)
		tans.append(other.tans[ti + 3])
	cols.append_array(other.cols)
	uvs.append_array(other.uvs)
	uv2s.append_array(other.uv2s)
	for v in other.idx:
		idx.append(base + v)


func add_collider(xf: Transform3D, size: Vector3) -> void:
	colliders.append([xf, size])


func add_box_collider(center: Vector3, size: Vector3) -> void:
	colliders.append([Transform3D(Basis.IDENTITY, center), size])


func to_arrays() -> Array:
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = norms
	arrays[Mesh.ARRAY_TANGENT] = tans
	arrays[Mesh.ARRAY_COLOR] = cols
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_TEX_UV2] = uv2s
	arrays[Mesh.ARRAY_INDEX] = idx
	return arrays


func to_mesh(material: Material = null) -> ArrayMesh:
	var m := ArrayMesh.new()
	if verts.is_empty():
		return m
	m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, to_arrays())
	if material:
		m.surface_set_material(0, material)
	return m
