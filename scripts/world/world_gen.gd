class_name WorldGen
extends RefCounted
## Gera o relevo (campo de densidade suave), biomas e decoracoes de cada chunk.
## E seguro criar uma instancia por thread.

const N := 16                 # tamanho horizontal do chunk (em unidades)
const P := N + 2              # pontos de grade por eixo horizontal (inclui borda)
const H := 96                 # altura do mundo
const SEA := 24.0             # nivel do mar
const DMAX := 8.0             # limite da densidade armazenada

enum Biome { OCEAN, BEACH, PLAINS, FOREST, DESERT, SNOWY, MAGIC, MOUNTAIN }

const BIOME_NAMES := ["Oceano", "Praia", "Planicie", "Floresta", "Deserto", "Neve", "Bosque Magico", "Montanha"]

var seed_value: int
var n_cont: FastNoiseLite
var n_hills: FastNoiseLite
var n_mask: FastNoiseLite
var n_ridge: FastNoiseLite
var n_detail: FastNoiseLite
var n_temp: FastNoiseLite
var n_moist: FastNoiseLite


func _init(world_seed: int) -> void:
	seed_value = world_seed
	n_cont = _noise(world_seed + 1, 0.0011, 4)
	n_hills = _noise(world_seed + 2, 0.009, 4)
	n_mask = _noise(world_seed + 3, 0.0024, 2)
	n_ridge = _noise(world_seed + 4, 0.0065, 3)
	n_detail = _noise(world_seed + 5, 0.06, 2)
	n_temp = _noise(world_seed + 6, 0.0016, 2)
	n_moist = _noise(world_seed + 7, 0.0019, 2)


static func _noise(s: int, freq: float, octaves: int) -> FastNoiseLite:
	var n := FastNoiseLite.new()
	n.seed = s
	n.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	n.frequency = freq
	n.fractal_type = FastNoiseLite.FRACTAL_FBM
	n.fractal_octaves = octaves
	return n


## Altura do terreno (sem as modificacoes do jogador).
func height_at(x: float, z: float) -> float:
	var c := n_cont.get_noise_2d(x, z) + 0.07
	var land := smoothstep(-0.12, 0.10, c)
	var h := lerpf(SEA - 11.0 + c * 12.0, SEA + 2.5 + c * 16.0, land)
	h += n_hills.get_noise_2d(x, z) * lerpf(2.5, 8.0, land)
	var mmask := smoothstep(0.05, 0.42, n_mask.get_noise_2d(x, z)) * land
	if mmask > 0.0:
		var r := 1.0 - absf(n_ridge.get_noise_2d(x, z))
		h += r * r * 50.0 * mmask
	h += n_detail.get_noise_2d(x, z) * 0.5
	return clampf(h, 3.0, H - 8.0)


func biome_at(x: float, z: float, h: float) -> int:
	if h < SEA - 0.8:
		return Biome.OCEAN
	if h > 60.0:
		return Biome.MOUNTAIN
	var t := n_temp.get_noise_2d(x, z)
	var m := n_moist.get_noise_2d(x, z)
	if h < SEA + 1.6 and t > -0.3:
		return Biome.BEACH
	if t > 0.24 and m < 0.05:
		return Biome.DESERT
	if t < -0.26:
		return Biome.SNOWY
	if m > 0.26 and t > -0.05:
		return Biome.MAGIC
	if m > 0.02:
		return Biome.FOREST
	return Biome.PLAINS


static func top_material(biome: int, h: float) -> int:
	match biome:
		Biome.OCEAN, Biome.BEACH, Biome.DESERT:
			return Mats.SAND
		Biome.SNOWY:
			return Mats.SNOW
		Biome.MOUNTAIN:
			return Mats.SNOW if h > 68.0 else Mats.STONE
		Biome.MAGIC:
			return Mats.MAGIC_GRASS
		Biome.FOREST:
			return Mats.FOREST_GRASS
	return Mats.GRASS


static func sub_material(biome: int) -> int:
	match biome:
		Biome.OCEAN, Biome.BEACH, Biome.DESERT:
			return Mats.SAND
		Biome.MOUNTAIN:
			return Mats.STONE
	return Mats.DIRT


## Gera os dados de um chunk: densidade + material por ponto de grade.
## Layout: indice = (lz * P + lx) * H + y  (colunas verticais contiguas).
func generate_chunk(cx: int, cz: int) -> Dictionary:
	var dens := PackedFloat32Array()
	dens.resize(P * P * H)
	dens.fill(-DMAX)
	var mats := PackedByteArray()
	mats.resize(P * P * H)
	var hmin := 1.0e9
	var hmax := -1.0e9
	# alturas primeiro (para saber a inclinacao de cada coluna)
	var heights := PackedFloat32Array()
	heights.resize(P * P)
	for lz in P:
		for lx in P:
			heights[lz * P + lx] = height_at(float(cx * N + lx), float(cz * N + lz))
	for lz in P:
		for lx in P:
			var wx := float(cx * N + lx)
			var wz := float(cz * N + lz)
			var h := heights[lz * P + lx]
			var b := biome_at(wx, wz, h)
			var top := top_material(b, h)
			var sub := sub_material(b)
			# penhascos naturais sao de pedra
			var hx := heights[lz * P + mini(lx + 1, P - 1)] - heights[lz * P + maxi(lx - 1, 0)]
			var hz := heights[mini(lz + 1, P - 1) * P + lx] - heights[maxi(lz - 1, 0) * P + lx]
			if Vector2(hx, hz).length() > 3.4 and b != Biome.DESERT and b != Biome.BEACH and b != Biome.OCEAN:
				top = Mats.STONE
				sub = Mats.STONE
			hmin = minf(hmin, h)
			hmax = maxf(hmax, h)
			var base := (lz * P + lx) * H
			var ytop := mini(H, int(h) + 5)
			for y in ytop:
				var d := h - y
				var depth := d
				if d > DMAX:
					d = DMAX
				elif d < -DMAX:
					d = -DMAX
				dens[base + y] = d
				if depth < 1.4:
					mats[base + y] = top
				elif depth < 4.5:
					mats[base + y] = sub
				else:
					mats[base + y] = Mats.STONE
			dens[base] = DMAX  # rocha do fundo
			mats[base] = Mats.STONE
	return {
		"dens": dens,
		"mats": mats,
		"ymin": clampi(int(floor(hmin)) - 2, 0, H - 3),
		"ymax": clampi(int(ceil(hmax)) + 2, 1, H - 3),
	}


# ------------------------------------------------------------ decoracoes --

const DECO_STRIDE := 10  # tipo, x, y, z (locais ao chunk), rotacao, escala, r, g, b, vento

const FLOWER_COLORS: Array[Color] = [
	Color(1.0, 0.35, 0.45), Color(1.0, 0.85, 0.25), Color(0.65, 0.45, 1.0),
	Color(1.0, 1.0, 1.0), Color(1.0, 0.55, 0.2), Color(0.4, 0.7, 1.0),
]


func _slope(x: float, z: float, h: float) -> float:
	var hx := height_at(x + 1.0, z)
	var hz := height_at(x, z + 1.0)
	return Vector2(hx - h, hz - h).length()


static func _push(out: PackedFloat32Array, t: int, lx: float, y: float, lz: float, rot: float, sc: float, tint: Color) -> void:
	out.append(t); out.append(lx); out.append(y); out.append(lz)
	out.append(rot); out.append(sc)
	var lin := tint.srgb_to_linear()
	out.append(lin.r); out.append(lin.g); out.append(lin.b)
	out.append(Deco.SWAY[t])


static func _leaf_tint(rng: RandomNumberGenerator) -> Color:
	var v := rng.randf_range(0.85, 1.12)
	return Color(v * rng.randf_range(0.92, 1.08), v, v * rng.randf_range(0.9, 1.05))


## Lista de decoracoes do chunk (deterministica pela semente).
func decorations(cx: int, cz: int) -> PackedFloat32Array:
	var out := PackedFloat32Array()
	var rng := RandomNumberGenerator.new()
	# passo 1: coisas grandes (arvores) numa grade de 4x4
	for gz in range(0, N, 4):
		for gx in range(0, N, 4):
			var wx := cx * N + gx
			var wz := cz * N + gz
			rng.seed = hash([seed_value, wx, wz, 1])
			var lx := gx + rng.randf_range(0.3, 3.7)
			var lz := gz + rng.randf_range(0.3, 3.7)
			var x := cx * N + lx
			var z := cz * N + lz
			var h := height_at(x, z)
			var b := biome_at(x, z, h)
			var r := rng.randf()
			var t := -1
			match b:
				Biome.FOREST:
					if r < 0.55:
						var k := rng.randf()
						t = Deco.TREE_ROUND if k < 0.55 else (Deco.TREE_AUTUMN if k < 0.8 else Deco.TREE_PINE)
				Biome.PLAINS:
					if r < 0.07:
						t = Deco.TREE_ROUND if rng.randf() < 0.8 else Deco.TREE_AUTUMN
				Biome.SNOWY:
					if r < 0.32:
						t = Deco.TREE_PINE_SNOW
				Biome.BEACH:
					if r < 0.10 and h > SEA + 0.4:
						t = Deco.TREE_PALM
				Biome.DESERT:
					if r < 0.10:
						t = Deco.CACTUS
				Biome.MAGIC:
					if r < 0.22:
						t = Deco.MUSHROOM_GIANT
					elif r < 0.30:
						t = Deco.TREE_ROUND
				Biome.MOUNTAIN:
					if r < 0.10 and h < 60.0:
						t = Deco.TREE_PINE
			if t < 0 or _slope(x, z, h) > 0.75:
				continue
			var sc := rng.randf_range(0.8, 1.25)
			var tint := _leaf_tint(rng)
			if t == Deco.MUSHROOM_GIANT:
				var pal := [Color(1, 1, 1), Color(0.55, 0.6, 1.6), Color(1.4, 0.7, 0.3), Color(0.8, 0.5, 1.5)]
				tint = pal[rng.randi() % pal.size()]
			_push(out, t, lx, h - 0.3, lz, rng.randf() * TAU, sc, tint)

	# passo 2: coisas pequenas numa grade de 2x2
	for gz in range(0, N, 2):
		for gx in range(0, N, 2):
			var wx := cx * N + gx
			var wz := cz * N + gz
			rng.seed = hash([seed_value, wx, wz, 2])
			var lx := gx + rng.randf_range(0.1, 1.9)
			var lz := gz + rng.randf_range(0.1, 1.9)
			var x := cx * N + lx
			var z := cz * N + lz
			var h := height_at(x, z)
			var b := biome_at(x, z, h)
			var r := rng.randf()
			var t := -1
			var tint := Color(1, 1, 1)
			match b:
				Biome.PLAINS:
					if r < 0.13:
						t = Deco.FLOWER
					elif r < 0.16:
						t = Deco.BUSH
					elif r < 0.175:
						t = Deco.ROCK
				Biome.FOREST:
					if r < 0.05:
						t = Deco.BUSH
					elif r < 0.09:
						t = Deco.MUSHROOM_GLOW
					elif r < 0.13:
						t = Deco.FLOWER
				Biome.MAGIC:
					if r < 0.12:
						t = Deco.MUSHROOM_GLOW
					elif r < 0.15:
						t = Deco.CRYSTAL
					elif r < 0.22:
						t = Deco.FLOWER
				Biome.DESERT:
					if r < 0.03:
						t = Deco.DEAD_BUSH
					elif r < 0.04:
						t = Deco.ROCK
				Biome.SNOWY, Biome.MOUNTAIN:
					if r < 0.03:
						t = Deco.ROCK
				Biome.BEACH:
					if r < 0.015:
						t = Deco.ROCK
			if t < 0 or _slope(x, z, h) > 1.1:
				continue
			if t == Deco.FLOWER:
				tint = FLOWER_COLORS[rng.randi() % FLOWER_COLORS.size()]
				if b == Biome.MAGIC:
					tint = [Color(0.8, 0.5, 1.0), Color(0.4, 0.9, 1.0), Color(1.0, 0.5, 0.9)][rng.randi() % 3]
			elif t == Deco.ROCK:
				var g := rng.randf_range(0.85, 1.1)
				tint = Color(g, g, g * 1.03)
			else:
				tint = _leaf_tint(rng)
			_push(out, t, lx, h - 0.12, lz, rng.randf() * TAU, rng.randf_range(0.75, 1.3), tint)

	# passo 3: tufos de grama
	rng.seed = hash([seed_value, cx, cz, 3])
	for i in 36:
		var lx := rng.randf() * N
		var lz := rng.randf() * N
		var x := cx * N + lx
		var z := cz * N + lz
		var h := height_at(x, z)
		var b := biome_at(x, z, h)
		if b != Biome.PLAINS and b != Biome.FOREST and b != Biome.MAGIC:
			continue
		if _slope(x, z, h) > 0.6:
			continue
		var v := rng.randf_range(0.9, 1.1)
		var tint := Color(0.50, 0.82, 0.32) * v
		if b == Biome.FOREST:
			tint = Color(0.34, 0.66, 0.29) * v
		elif b == Biome.MAGIC:
			tint = Color(0.66, 0.50, 0.95) * v
		_push(out, Deco.GRASS, lx, h - 0.08, lz, rng.randf() * TAU, rng.randf_range(0.8, 1.4), tint)
	return out
