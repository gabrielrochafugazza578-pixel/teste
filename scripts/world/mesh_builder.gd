class_name MeshBuilder
extends RefCounted
## Junta varias formas simples (esferas, cilindros, cones...) em uma unica malha
## com cores por vertice. Usado para arvores, plantas e bichos em estilo cartoon.
##
## O alfa da cor tem significado para o shader de objetos (props.gdshader):
##   1.0  = cor normal
##   0.0  = "tingivel": multiplicada pela cor da instancia (variacoes)
##   0.5  = brilha no escuro (emissao mais forte a noite)

var verts := PackedVector3Array()
var norms := PackedVector3Array()
var cols := PackedColorArray()
var idx := PackedInt32Array()


static func _hash3(v: Vector3) -> float:
	var h := sin(v.x * 12.9898 + v.y * 78.233 + v.z * 37.719) * 43758.5453
	return h - floorf(h)


## Adiciona uma forma. `jitter` deforma a superficie (visual mais organico).
func add(prim: PrimitiveMesh, xf: Transform3D, color: Color, jitter := 0.0) -> void:
	var arr := prim.get_mesh_arrays()
	var pv: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
	var pn: PackedVector3Array = arr[Mesh.ARRAY_NORMAL]
	var pi: PackedInt32Array = arr[Mesh.ARRAY_INDEX]
	var base := verts.size()
	var nb := xf.basis.inverse().transposed()
	for i in pv.size():
		var v := pv[i]
		if jitter > 0.0:
			v += pn[i] * ((_hash3(v) - 0.5) * 2.0 * jitter)
		verts.append(xf * v)
		norms.append((nb * pn[i]).normalized())
		cols.append(color)
	for j in pi:
		idx.append(base + j)


func commit(material: Material = null) -> ArrayMesh:
	var mesh := ArrayMesh.new()
	var arr := []
	arr.resize(Mesh.ARRAY_MAX)
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_NORMAL] = norms
	arr[Mesh.ARRAY_COLOR] = cols
	arr[Mesh.ARRAY_INDEX] = idx
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	if material:
		mesh.surface_set_material(0, material)
	return mesh


# ------------------------------------------------------------ atalhos --

static func sphere(r: float, rings := 6, segs := 10) -> SphereMesh:
	var s := SphereMesh.new()
	s.radius = r
	s.height = r * 2.0
	s.rings = rings
	s.radial_segments = segs
	return s


static func hemisphere(r: float, rings := 5, segs := 12) -> SphereMesh:
	var s := sphere(r, rings, segs)
	s.is_hemisphere = true
	s.height = r
	return s


static func cyl(r_top: float, r_bottom: float, h: float, segs := 8) -> CylinderMesh:
	var c := CylinderMesh.new()
	c.top_radius = r_top
	c.bottom_radius = r_bottom
	c.height = h
	c.radial_segments = segs
	c.rings = 1
	return c


static func capsule(r: float, h: float, segs := 10) -> CapsuleMesh:
	var c := CapsuleMesh.new()
	c.radius = r
	c.height = h
	c.radial_segments = segs
	c.rings = 4
	return c


static func box(size: Vector3) -> BoxMesh:
	var b := BoxMesh.new()
	b.size = size
	return b


static func at(pos: Vector3, scale := Vector3.ONE, rot := Vector3.ZERO) -> Transform3D:
	var b := Basis.from_euler(rot) * Basis.from_scale(scale)
	return Transform3D(b, pos)
