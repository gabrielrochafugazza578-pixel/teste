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
	for lz in P:
		for lx in P:
			var wx := float(cx * N + lx)
			var wz := float(cz * N + lz)
			var h := height_at(wx, wz)
			var b := biome_at(wx, wz, h)
			var top := top_material(b, h)
			var sub := sub_material(b)
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
