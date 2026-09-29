extends Node
## Exporta as camadas de material geradas (albedo e normal/AO) para PNG.
## Uso: xvfb-run godot --path . res://tests/tex_dump.tscn -- --out=/tmp/tex

func _ready() -> void:
	var out := "user://tex"
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--out="):
			out = a.substr(6)
	DirAccess.make_dir_recursive_absolute(out)
	Settings.graphics["texture_quality"] = 1
	await Assets.bake_all()
	for i in Assets.LAYER_COUNT:
		var a := Assets.surface_a.get_layer_data(i)
		a.decompress()
		if a.has_mipmaps():
			a.clear_mipmaps()
		a.save_png("%s/%02d_%s_a.png" % [out, i, Assets.LAYER_NAMES[i]])
		var b := Assets.surface_b.get_layer_data(i)
		if b.has_mipmaps():
			b.clear_mipmaps()
		b.save_png("%s/%02d_%s_b.png" % [out, i, Assets.LAYER_NAMES[i]])
	for i in 4:
		var wa := Assets.weapon_a.get_layer_data(i)
		if wa.has_mipmaps():
			wa.clear_mipmaps()
		wa.save_png("%s/arma_%d_a.png" % [out, i])
		var wb := Assets.weapon_b.get_layer_data(i)
		if wb.has_mipmaps():
			wb.clear_mipmaps()
		wb.save_png("%s/arma_%d_b.png" % [out, i])
	print("TEX OK")
	get_tree().quit(0)
