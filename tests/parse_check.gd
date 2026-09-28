extends SceneTree
## Compila todos os scripts do projeto e reporta falhas (uso: godot --headless -s tests/parse_check.gd)

var _done := false


func _process(_delta: float) -> bool:
	if _done:
		return true
	_done = true
	_run()
	return false


func _run() -> void:
	var failed := 0
	var files := _collect("res://scripts")
	files.append_array(_collect("res://tests"))
	for f in files:
		var s = load(f)
		if s == null:
			printerr("FALHA: ", f)
			failed += 1
	var shaders := _collect("res://shaders", ".gdshader")
	for f in shaders:
		var sh = load(f)
		if sh == null:
			printerr("FALHA SHADER: ", f)
			failed += 1
	print("Scripts verificados: %d, shaders: %d, falhas: %d" % [files.size(), shaders.size(), failed])
	quit(1 if failed > 0 else 0)


func _collect(dir: String, ext: String = ".gd") -> Array:
	var out: Array = []
	var d := DirAccess.open(dir)
	if d == null:
		return out
	d.list_dir_begin()
	var n := d.get_next()
	while n != "":
		if d.current_is_dir():
			if not n.begins_with("."):
				out.append_array(_collect(dir + "/" + n, ext))
		elif n.ends_with(ext):
			out.append(dir + "/" + n)
		n = d.get_next()
	return out
