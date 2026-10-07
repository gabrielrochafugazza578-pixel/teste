extends SceneTree
## Converte as fotos das camadas (assets/materials/src/NN_a.png e NN_b.png, saída
## de tools/fetch_textures.py) em Image .res já comprimidas para a GPU (BC7 com
## mipmaps). O jogo monta o Texture2DArray direto delas: sem gerar nada na
## abertura e com ~4x menos memória de vídeo que RGBA.
## Uso (editor do Godot, que tem os compressores): godot --headless --path . -s tools/pack_layers.gd


func _init() -> void:
	var src := ProjectSettings.globalize_path("res://assets/materials/src")
	var n := 0
	for layer in 16:
		for ch in ["a", "b"]:
			var path := "%s/%02d_%s.png" % [src, layer, ch]
			if not FileAccess.file_exists(path):
				continue
			var out := "res://assets/materials/%02d_%s.res" % [layer, ch]
			# já empacotado depois da última mudança da foto
			if FileAccess.file_exists(out) and FileAccess.get_modified_time(out) > FileAccess.get_modified_time(path):
				continue
			var img := Image.load_from_file(path)
			if img == null:
				printerr("falha ao ler ", path)
				continue
			img.convert(Image.FORMAT_RGBA8)
			if img.get_width() != 2048:
				img.resize(2048, 2048, Image.INTERPOLATE_LANCZOS)
			img.generate_mipmaps(false)
			var t0 := Time.get_ticks_msec()
			var err := img.compress(Image.COMPRESS_BPTC, Image.COMPRESS_SOURCE_GENERIC)
			if err != OK:
				printerr("compressão falhou (%d) em %s" % [err, path])
				continue
			ResourceSaver.save(img, out, ResourceSaver.FLAG_COMPRESS)
			n += 1
			print("%s  %s  %d ms" % [out, Image.FORMAT_BPTC_RGBA == img.get_format(), Time.get_ticks_msec() - t0])
	# tecidos das roupas (1024 px)
	for q in [1, 2, 3]:
		for ch in ["a", "b"]:
			var path := "%s/char_%d_%s.png" % [src, q, ch]
			if not FileAccess.file_exists(path):
				continue
			var img := Image.load_from_file(path)
			img.convert(Image.FORMAT_RGBA8)
			img.generate_mipmaps(false)
			if img.compress(Image.COMPRESS_BPTC, Image.COMPRESS_SOURCE_GENERIC) != OK:
				printerr("compressão falhou em ", path)
				continue
			ResourceSaver.save(img, "res://assets/materials/char_%d_%s.res" % [q, ch], ResourceSaver.FLAG_COMPRESS)
			n += 1
	print("camadas empacotadas: ", n)
	quit(0)
