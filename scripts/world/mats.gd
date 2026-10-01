class_name Mats
## Materiais do terreno. As cores sao em sRGB (o shader converte para linear).

const AIR := 0
const GRASS := 1
const DIRT := 2
const STONE := 3
const SAND := 4
const SNOW := 5
const WOOD := 6
const LEAVES := 7
const BRICK := 8
const CRYSTAL := 9
const FOREST_GRASS := 10
const MAGIC_GRASS := 11
const CLAY := 12
const COUNT := 13

const COLORS: Array[Color] = [
	Color(0.0, 0.0, 0.0),        # ar
	Color(0.42, 0.74, 0.27),     # grama
	Color(0.56, 0.37, 0.23),     # terra
	Color(0.50, 0.50, 0.57),     # pedra
	Color(0.93, 0.80, 0.50),     # areia
	Color(0.90, 0.94, 1.00),     # neve
	Color(0.64, 0.42, 0.24),     # madeira
	Color(0.30, 0.62, 0.25),     # folhas
	Color(0.78, 0.32, 0.25),     # tijolo
	Color(0.62, 0.42, 0.96),     # cristal
	Color(0.27, 0.58, 0.25),     # grama da floresta
	Color(0.55, 0.42, 0.85),     # grama magica
	Color(0.86, 0.50, 0.30),     # argila
]

const NAMES: Array[String] = [
	"Ar", "Grama", "Terra", "Pedra", "Areia", "Neve", "Madeira", "Folhas",
	"Tijolo", "Cristal", "Grama da Floresta", "Grama Mágica", "Argila",
]


## Codigo guardado no alfa da cor do vertice:
## 1.0 = grama (vira terra e depois pedra nas encostas), 0.66 = neve (vira pedra),
## 0 = nao muda.
static func slope_code(m: int) -> float:
	if m == GRASS or m == FOREST_GRASS or m == MAGIC_GRASS:
		return 1.0
	if m == SNOW:
		return 0.66
	return 0.0


static func is_grassy(m: int) -> bool:
	return m == GRASS or m == FOREST_GRASS or m == MAGIC_GRASS or m == SNOW
