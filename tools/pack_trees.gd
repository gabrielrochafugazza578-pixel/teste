extends SceneTree
## Converte a saída de tools/make_trees.py (assets/models/trees/src) nas malhas do
## jogo: assets/models/trees/<id>_<lod>.res. Tronco e galhos são simplificados
## com o meshoptimizer do Godot (ImporterMesh.generate_lods) até a meta de
## triângulos de cada nível; as folhas (cartões) vão como estão.
## Superfícies: 0 tronco, 1 galhos, 2 folhas (materiais postos pelo Vegetation).
## Uso: godot --headless --path . -s tools/pack_trees.gd

const SRC := "res://assets/models/trees/src"
const DST := "res://assets/models/trees"


func _init() -> void:
	var d := DirAccess.open(SRC)
	for f in d.get_files():
		if f.ends_with(".json"):
			_pack(f.get_basename())
	quit(0)


func _read(fa: FileAccess, s: Dictionary) -> Array:
	var nv := int(s["nv"])
	var ni := int(s["ni"])
	var pos := fa.get_buffer(nv * 12).to_float32_array()
	var nrm := fa.get_buffer(nv * 12).to_float32_array()
	var uv := fa.get_buffer(nv * 8).to_float32_array()
	var col := fa.get_buffer(nv * 16).to_float32_array()
	var idx := fa.get_buffer(ni * 4).to_int32_array()
	var P := PackedVector3Array()
	var N := PackedVector3Array()
	var UV := PackedVector2Array()
	var C := PackedColorArray()
	P.resize(nv)
	N.resize(nv)
	UV.resize(nv)
	C.resize(nv)
	for i in nv:
		P[i] = Vector3(pos[i * 3], pos[i * 3 + 1], pos[i * 3 + 2])
		N[i] = Vector3(nrm[i * 3], nrm[i * 3 + 1], nrm[i * 3 + 2])
		UV[i] = Vector2(uv[i * 2], uv[i * 2 + 1])
		C[i] = Color(col[i * 4], col[i * 4 + 1], col[i * 4 + 2], col[i * 4 + 3])
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = P
	arrays[Mesh.ARRAY_NORMAL] = N
	arrays[Mesh.ARRAY_TEX_UV] = UV
	arrays[Mesh.ARRAY_COLOR] = C
	arrays[Mesh.ARRAY_INDEX] = idx
	return arrays


## Simplifica até ~target triângulos (escolhe o LOD do meshoptimizer mais
## próximo da meta) e compacta os vértices.
func _simplify(arrays: Array, target: int) -> Array:
	var tris := (arrays[Mesh.ARRAY_INDEX] as PackedInt32Array).size() / 3
	if target <= 0 or tris <= target:
		return arrays
	var im := ImporterMesh.new()
	im.add_surface(Mesh.PRIMITIVE_TRIANGLES, arrays)
	im.generate_lods(25.0, 60.0, [])
	var best: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
	for l in im.get_surface_lod_count(0):
		var li := im.get_surface_lod_indices(0, l)
		best = li
		if li.size() / 3 <= target:
			break
	# compacta: só os vértices usados
	var P: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	var N: PackedVector3Array = arrays[Mesh.ARRAY_NORMAL]
	var UV: PackedVector2Array = arrays[Mesh.ARRAY_TEX_UV]
	var C: PackedColorArray = arrays[Mesh.ARRAY_COLOR]
	var remap := {}
	var P2 := PackedVector3Array()
	var N2 := PackedVector3Array()
	var UV2 := PackedVector2Array()
	var C2 := PackedColorArray()
	var I2 := PackedInt32Array()
	I2.resize(best.size())
	for k in best.size():
		var v := best[k]
		if not remap.has(v):
			remap[v] = P2.size()
			P2.append(P[v])
			N2.append(N[v])
			UV2.append(UV[v])
			C2.append(C[v])
		I2[k] = remap[v]
	var out := []
	out.resize(Mesh.ARRAY_MAX)
	out[Mesh.ARRAY_VERTEX] = P2
	out[Mesh.ARRAY_NORMAL] = N2
	out[Mesh.ARRAY_TEX_UV] = UV2
	out[Mesh.ARRAY_COLOR] = C2
	out[Mesh.ARRAY_INDEX] = I2
	return out


func _pack(name: String) -> void:
	var t0 := Time.get_ticks_msec()
	var meta: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(SRC + "/" + name + ".json"))
	var fa := FileAccess.open(SRC + "/" + name + ".bin", FileAccess.READ)
	var mesh := ArrayMesh.new()
	var total := 0
	for s: Dictionary in meta["surfaces"]:
		var arrays := _read(fa, s)
		arrays = _simplify(arrays, int(s["target"]))
		if str(s["name"]) != "leaves":
			# tangentes para o mapa normal da casca
			var tmp := ArrayMesh.new()
			tmp.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
			var st := SurfaceTool.new()
			st.create_from(tmp, 0)
			st.generate_tangents()
			arrays = st.commit_to_arrays()
		total += (arrays[Mesh.ARRAY_INDEX] as PackedInt32Array).size() / 3
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		mesh.surface_set_name(mesh.get_surface_count() - 1, str(s["name"]))
	mesh.set_meta("tex", meta.get("tex", {}))
	var out := DST + "/" + name + ".res"
	ResourceSaver.save(mesh, out, ResourceSaver.FLAG_COMPRESS)
	print("%s: %d triângulos, %d ms" % [out, total, Time.get_ticks_msec() - t0])
