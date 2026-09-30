extends SceneTree
# Procura lugares interessantes no mapa (para fotos). Uso:
#   godot --headless --path . --script tools/find_spots.gd
func _init() -> void:
	var g := WorldGen.new(20260930)
	var counts := {}
	var best_mount := Vector3.ZERO
	var best_score := -1.0
	for zi in range(-60, 61):
		for xi in range(-60, 61):
			var x := xi * 16.0
			var z := zi * 16.0
			var h := g.height_at(x, z)
			var b := g.biome_at(x, z, h)
			counts[b] = counts.get(b, 0) + 1
	for zi in range(-30, 31):
		for xi in range(-30, 31):
			var x := xi * 16.0
			var z := zi * 16.0
			var h := g.height_at(x, z)
			var b := g.biome_at(x, z, h)
			if b != WorldGen.Biome.PLAINS and b != WorldGen.Biome.FOREST:
				continue
			if h < WorldGen.SEA + 2 or h > 36:
				continue
			# pontuacao: montanha alta perto + agua perto
			var mh := 0.0
			var water := 0
			for a in 16:
				var ang := a * TAU / 16.0
				for r in [30.0, 50.0, 70.0]:
					var hh := g.height_at(x + cos(ang) * r, z + sin(ang) * r)
					mh = maxf(mh, hh)
					if hh < WorldGen.SEA:
						water += 1
			var score := mh + minf(water, 10) * 3.0
			if score > best_score:
				best_score = score
				best_mount = Vector3(x, h, z)
	var total := 0
	for k in counts: total += counts[k]
	for k in counts:
		print(WorldGen.BIOME_NAMES[k], ": ", snappedf(100.0 * counts[k] / total, 0.1), "%")
	print("melhor lugar: ", best_mount, " score=", best_score)
	for name in ["DESERT", "SNOWY", "MAGIC", "FOREST", "MOUNTAIN"]:
		var target: int = WorldGen.Biome[name]
		var found := false
		for r in range(1, 80):
			for a in 24:
				var ang := a * TAU / 24.0
				var x := cos(ang) * r * 16.0
				var z := sin(ang) * r * 16.0
				var h := g.height_at(x, z)
				if g.biome_at(x, z, h) == target:
					print(name, " mais proximo: ", Vector3(roundf(x), roundf(h), roundf(z)))
					found = true
					break
			if found:
				break
	quit()
