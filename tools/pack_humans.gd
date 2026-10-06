extends SceneTree
## Converte a saída de tools/make_humans.py (assets/characters/src) nos recursos do
## jogo: uma ArrayMesh por personagem (com LODs gerados, juntas e medidas do pé nos
## metadados) em assets/characters/<id>.res e as texturas comprimidas para a GPU
## (BC7 com mipmaps) em assets/characters/tex/<nome>.res.
## Uso: godot --headless --path . -s tools/pack_humans.gd [-- id ...]

const SRC := "res://assets/characters/src"
const DST := "res://assets/characters"


func _init() -> void:
	var only: Array = []
	for a in OS.get_cmdline_user_args():
		only.append(a)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(DST + "/tex"))
	var mats: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(SRC + "/materials.json"))
	var used := {}
	var d := DirAccess.open(SRC)
	for f in d.get_files():
		if not f.ends_with(".json") or f == "materials.json":
			continue
		var id := f.get_basename()
		if not only.is_empty() and not id in only:
			continue
		var meta: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(SRC + "/" + f))
		for s: Dictionary in meta["surfaces"]:
			used[s["mat"]] = true
		_pack_mesh(id, meta)
	# texturas (só as dos materiais usados; reaproveita as já empacotadas e atuais)
	var n := 0
	for key: String in mats.keys():
		var m: Dictionary = mats[key]
		for ch in ["albedo", "normal"]:
			if not m.has(ch):
				continue
			if _pack_tex(str(m[ch])):
				n += 1
	# tabela de materiais usada pelo jogo
	var fo := FileAccess.open(DST + "/materials.json", FileAccess.WRITE)
	fo.store_string(JSON.stringify(mats, " "))
	fo.close()
	print("texturas novas: ", n)
	quit(0)


func _pack_mesh(id: String, meta: Dictionary) -> void:
	var t0 := Time.get_ticks_msec()
	var fa := FileAccess.open(SRC + "/" + id + ".bin", FileAccess.READ)
	var im := ImporterMesh.new()
	for s: Dictionary in meta["surfaces"]:
		var nv := int(s["nv"])
		var ni := int(s["ni"])
		var pos := fa.get_buffer(nv * 12).to_float32_array()
		var nrm := fa.get_buffer(nv * 12).to_float32_array()
		var uv := fa.get_buffer(nv * 8).to_float32_array()
		var bones := fa.get_buffer(nv * 16).to_int32_array()
		var wts := fa.get_buffer(nv * 16).to_float32_array()
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
		arrays[Mesh.ARRAY_BONES] = bones
		arrays[Mesh.ARRAY_WEIGHTS] = wts
		arrays[Mesh.ARRAY_INDEX] = idx
		# tangentes (MikkTSpace, mesma convenção dos mapas normais do Godot)
		var tmp := ArrayMesh.new()
		tmp.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		var st := SurfaceTool.new()
		st.create_from(tmp, 0)
		st.generate_tangents()
		arrays = st.commit_to_arrays()
		im.add_surface(Mesh.PRIMITIVE_TRIANGLES, arrays, [], {}, null, str(s["name"]) + "|" + str(s["mat"]))
	im.generate_lods(25.0, 60.0, [])
	var mesh := im.get_mesh()
	mesh.set_meta("joints", meta["joints"])
	mesh.set_meta("foot", meta["foot"])
	mesh.set_meta("height", meta["height"])
	mesh.custom_aabb = AABB(Vector3(-1.4, -0.3, -1.4), Vector3(2.8, 2.8, 2.8))
	var out := DST + "/" + id + ".res"
	ResourceSaver.save(mesh, out, ResourceSaver.FLAG_COMPRESS)
	print("%s: %d superfícies, %d tri, %d ms" % [out, mesh.get_surface_count(), int(meta.get("tris", 0)), Time.get_ticks_msec() - t0])


func _pack_tex(name: String) -> bool:
	var src := ProjectSettings.globalize_path(SRC + "/tex/" + name + ".png")
	var out := DST + "/tex/" + name + ".res"
	if not FileAccess.file_exists(src):
		return false
	if FileAccess.file_exists(out) and FileAccess.get_modified_time(ProjectSettings.globalize_path(out)) >= FileAccess.get_modified_time(src):
		return false
	var img := Image.load_from_file(src)
	img.convert(Image.FORMAT_RGBA8)
	img.generate_mipmaps(false)
	if img.compress(Image.COMPRESS_BPTC, Image.COMPRESS_SOURCE_GENERIC) != OK:
		printerr("compressão falhou em ", src)
		return false
	ResourceSaver.save(img, out, ResourceSaver.FLAG_COMPRESS)
	print("  ", out)
	return true
