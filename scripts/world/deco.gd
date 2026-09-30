class_name Deco
## Decoracoes do mundo (arvores, plantas, pedras...) feitas por codigo em estilo
## cartoon. As malhas sao criadas uma unica vez e desenhadas com MultiMesh.

enum { TREE_ROUND, TREE_AUTUMN, TREE_PINE, TREE_PINE_SNOW, TREE_PALM, BUSH, FLOWER,
	ROCK, CACTUS, MUSHROOM_GIANT, MUSHROOM_GLOW, GRASS, CRYSTAL, DEAD_BUSH, COUNT }

const NAMES := ["Arvore", "Arvore de Outono", "Pinheiro", "Pinheiro Nevado", "Palmeira",
	"Arbusto", "Flor", "Pedra", "Cacto", "Cogumelo Gigante", "Cogumelo Brilhante", "Grama",
	"Cristal", "Arbusto Seco"]

## Colisao do tronco: [raio, altura] (0 = sem colisao)
const COLLIDERS := {
	TREE_ROUND: Vector2(0.32, 3.0), TREE_AUTUMN: Vector2(0.32, 3.0),
	TREE_PINE: Vector2(0.3, 3.0), TREE_PINE_SNOW: Vector2(0.3, 3.0),
	TREE_PALM: Vector2(0.3, 3.5), ROCK: Vector2(0.75, 0.9), CACTUS: Vector2(0.38, 2.4),
	MUSHROOM_GIANT: Vector2(0.45, 3.2), CRYSTAL: Vector2(0.3, 1.2),
}

## O que cada decoracao da ao ser quebrada: [material, quantidade]
const DROPS := {
	TREE_ROUND: [Mats.WOOD, 4], TREE_AUTUMN: [Mats.WOOD, 4], TREE_PINE: [Mats.WOOD, 4],
	TREE_PINE_SNOW: [Mats.WOOD, 4], TREE_PALM: [Mats.WOOD, 3], ROCK: [Mats.STONE, 3],
	CACTUS: [Mats.LEAVES, 2], MUSHROOM_GIANT: [Mats.CLAY, 3], CRYSTAL: [Mats.CRYSTAL, 2],
	BUSH: [Mats.LEAVES, 1],
}

## Quanto cada tipo balanca com o vento
const SWAY := [0.5, 0.5, 0.35, 0.35, 0.8, 0.8, 1.6, 0.0, 0.0, 0.15, 0.6, 2.2, 0.0, 0.8]

static var _meshes: Array = []
static var _material: ShaderMaterial


static func material() -> ShaderMaterial:
	if _material == null:
		_material = ShaderMaterial.new()
		_material.shader = load("res://shaders/props.gdshader")
	return _material


static func mesh(t: int) -> ArrayMesh:
	if _meshes.is_empty():
		_meshes.resize(COUNT)
		for i in COUNT:
			_meshes[i] = _build(i)
	return _meshes[i_clamp(t)]


static func i_clamp(t: int) -> int:
	return clampi(t, 0, COUNT - 1)


const TRUNK := Color(0.52, 0.34, 0.20)
const TRUNK_DARK := Color(0.42, 0.27, 0.16)
const LEAF := Color(0.36, 0.70, 0.27, 0.0)
const PINE_LEAF := Color(0.18, 0.47, 0.30, 0.0)
const SNOW := Color(0.93, 0.96, 1.0)


static func _build(t: int) -> ArrayMesh:
	var b := MeshBuilder.new()
	match t:
		TREE_ROUND, TREE_AUTUMN:
			var leaf := LEAF if t == TREE_ROUND else Color(0.95, 0.55, 0.20, 0.0)
			var leaf2 := Color(leaf.r * 0.85, leaf.g * 0.88, leaf.b * 0.85, 0.0)
			b.add(MeshBuilder.cyl(0.2, 0.32, 3.0), MeshBuilder.at(Vector3(0, 1.5, 0)), TRUNK)
			b.add(MeshBuilder.cyl(0.07, 0.12, 1.2), MeshBuilder.at(Vector3(0.45, 2.3, 0), Vector3.ONE, Vector3(0, 0, -0.8)), TRUNK)
			b.add(MeshBuilder.sphere(1.55, 9, 16), MeshBuilder.at(Vector3(0, 3.7, 0)), leaf, 0.07)
			b.add(MeshBuilder.sphere(1.15, 8, 14), MeshBuilder.at(Vector3(1.1, 3.2, 0.3)), leaf2, 0.06)
			b.add(MeshBuilder.sphere(1.1, 8, 14), MeshBuilder.at(Vector3(-0.9, 3.3, -0.6)), leaf2, 0.06)
			b.add(MeshBuilder.sphere(1.0, 8, 14), MeshBuilder.at(Vector3(-0.3, 4.6, 0.5)), leaf, 0.06)
		TREE_PINE, TREE_PINE_SNOW:
			b.add(MeshBuilder.cyl(0.18, 0.28, 1.8), MeshBuilder.at(Vector3(0, 0.9, 0)), TRUNK_DARK)
			var levels := [[1.7, 1.9, 1.4], [1.35, 1.7, 2.5], [0.95, 1.5, 3.5], [0.55, 1.2, 4.4]]
			for lv in levels:
				b.add(MeshBuilder.cyl(0.0, lv[0], lv[1], 10), MeshBuilder.at(Vector3(0, lv[2], 0)), PINE_LEAF, 0.05)
				if t == TREE_PINE_SNOW:
					b.add(MeshBuilder.cyl(0.0, lv[0] * 0.62, lv[1] * 0.62, 10), MeshBuilder.at(Vector3(0, lv[2] + lv[1] * 0.2, 0)), SNOW, 0.03)
		TREE_PALM:
			var p := Vector3.ZERO
			var ang := 0.0
			for i in 6:
				ang += 0.07
				var seg := MeshBuilder.cyl(0.17 - i * 0.012, 0.2 - i * 0.012, 0.85, 7)
				var dir := Vector3(sin(ang), cos(ang), 0)
				b.add(seg, MeshBuilder.at(p + dir * 0.42, Vector3.ONE, Vector3(0, 0, -ang)), TRUNK if i % 2 == 0 else TRUNK_DARK)
				p += dir * 0.8
			for k in 7:
				var a := k * TAU / 7.0
				var d := Vector3(cos(a), 0, sin(a))
				var leaf_xf := Transform3D(Basis.looking_at(d + Vector3(0, -0.35, 0), Vector3.UP) * Basis.from_scale(Vector3(0.45, 0.12, 1.7)), p + d * 1.2 + Vector3(0, -0.15, 0))
				b.add(MeshBuilder.sphere(1.0, 4, 8), leaf_xf, Color(0.30, 0.68, 0.24, 0.0), 0.05)
			for k in 3:
				var a := k * TAU / 3.0 + 0.5
				b.add(MeshBuilder.sphere(0.18, 4, 7), MeshBuilder.at(p + Vector3(cos(a) * 0.25, -0.3, sin(a) * 0.25)), Color(0.45, 0.30, 0.16))
		BUSH:
			b.add(MeshBuilder.sphere(0.75, 7, 12), MeshBuilder.at(Vector3(0, 0.45, 0)), LEAF, 0.05)
			b.add(MeshBuilder.sphere(0.55, 6, 10), MeshBuilder.at(Vector3(0.55, 0.35, 0.2)), Color(0.30, 0.62, 0.24, 0.0), 0.04)
			b.add(MeshBuilder.sphere(0.5, 6, 10), MeshBuilder.at(Vector3(-0.45, 0.32, -0.3)), Color(0.30, 0.62, 0.24, 0.0), 0.04)
			for k in 4:
				var a := k * 1.7
				b.add(MeshBuilder.sphere(0.09, 3, 6), MeshBuilder.at(Vector3(cos(a) * 0.62, 0.55 + sin(a * 2.0) * 0.15, sin(a) * 0.62)), Color(0.9, 0.2, 0.25))
		FLOWER:
			b.add(MeshBuilder.cyl(0.025, 0.03, 0.5, 5), MeshBuilder.at(Vector3(0, 0.25, 0)), Color(0.28, 0.6, 0.22))
			b.add(MeshBuilder.sphere(0.12, 3, 6), MeshBuilder.at(Vector3(0.08, 0.2, 0), Vector3(1.0, 0.3, 0.5)), Color(0.32, 0.66, 0.25))
			for k in 5:
				var a := k * TAU / 5.0
				b.add(MeshBuilder.sphere(0.11, 3, 6), MeshBuilder.at(Vector3(cos(a) * 0.12, 0.52, sin(a) * 0.12), Vector3(1.0, 0.35, 0.8), Vector3(0, -a, 0)), Color(1, 1, 1, 0.0))
			b.add(MeshBuilder.sphere(0.07, 3, 6), MeshBuilder.at(Vector3(0, 0.55, 0)), Color(1.0, 0.85, 0.2))
		ROCK:
			b.add(MeshBuilder.sphere(0.8, 4, 7), MeshBuilder.at(Vector3(0, 0.25, 0), Vector3(1.1, 0.7, 0.9)), Color(0.58, 0.58, 0.64, 0.0), 0.18)
			b.add(MeshBuilder.sphere(0.45, 4, 6), MeshBuilder.at(Vector3(0.7, 0.1, 0.3), Vector3(1.0, 0.8, 1.0)), Color(0.52, 0.52, 0.58, 0.0), 0.12)
		CACTUS:
			var cg := Color(0.30, 0.62, 0.30)
			b.add(MeshBuilder.capsule(0.35, 2.6, 10), MeshBuilder.at(Vector3(0, 1.3, 0)), cg, 0.03)
			b.add(MeshBuilder.capsule(0.2, 1.0, 8), MeshBuilder.at(Vector3(0.55, 1.4, 0)), cg)
			b.add(MeshBuilder.capsule(0.18, 0.6, 8), MeshBuilder.at(Vector3(0.33, 1.1, 0), Vector3.ONE, Vector3(0, 0, PI / 2)), cg)
			b.add(MeshBuilder.capsule(0.18, 0.8, 8), MeshBuilder.at(Vector3(-0.5, 1.75, 0)), cg)
			b.add(MeshBuilder.capsule(0.16, 0.5, 8), MeshBuilder.at(Vector3(-0.3, 1.5, 0), Vector3.ONE, Vector3(0, 0, PI / 2)), cg)
			b.add(MeshBuilder.sphere(0.14, 3, 6), MeshBuilder.at(Vector3(0, 2.62, 0)), Color(1.0, 0.45, 0.65))
		MUSHROOM_GIANT:
			b.add(MeshBuilder.cyl(0.3, 0.45, 3.2, 10), MeshBuilder.at(Vector3(0, 1.6, 0)), Color(0.95, 0.92, 0.82))
			b.add(MeshBuilder.cyl(0.62, 0.62, 0.12, 12), MeshBuilder.at(Vector3(0, 2.3, 0)), Color(0.92, 0.88, 0.78))
			b.add(MeshBuilder.hemisphere(2.0, 6, 16), MeshBuilder.at(Vector3(0, 3.0, 0), Vector3(1, 0.75, 1)), Color(0.88, 0.25, 0.40, 0.0), 0.04)
			b.add(MeshBuilder.cyl(1.9, 1.9, 0.1, 16), MeshBuilder.at(Vector3(0, 3.0, 0)), Color(0.95, 0.85, 0.80))
			for k in 9:
				var a := k * 2.4
				var r := 0.4 + (k % 3) * 0.45
				var pos := Vector3(cos(a) * r, 0.0, sin(a) * r)
				pos.y = 3.0 + sqrt(maxf(0.0, 4.0 - r * r)) * 0.75
				b.add(MeshBuilder.sphere(0.2, 3, 6), MeshBuilder.at(pos, Vector3(1, 0.4, 1)), Color(1.0, 1.0, 0.85, 0.5))
		MUSHROOM_GLOW:
			for k in 3:
				var a := k * 2.1
				var s := 1.0 - k * 0.25
				var base := Vector3(cos(a) * 0.25 * k, 0, sin(a) * 0.25 * k)
				b.add(MeshBuilder.cyl(0.04 * s, 0.06 * s, 0.35 * s, 6), MeshBuilder.at(base + Vector3(0, 0.17 * s, 0)), Color(0.9, 0.9, 0.85))
				b.add(MeshBuilder.hemisphere(0.16 * s, 3, 8), MeshBuilder.at(base + Vector3(0, 0.33 * s, 0)), Color(0.35, 0.95, 1.0, 0.5))
		GRASS:
			for k in 4:
				var a := k * 1.6
				var tilt := Vector3(sin(a) * 0.3, 0, cos(a) * 0.3)
				var hgt := 0.6 - k * 0.07
				b.add(MeshBuilder.cyl(0.0, 0.13, hgt, 4), MeshBuilder.at(Vector3(cos(a) * 0.14, hgt * 0.45, sin(a) * 0.14), Vector3(1.0, 1.0, 0.45), tilt), Color(1, 1, 1, 0.0))
		CRYSTAL:
			var cc := Color(0.70, 0.50, 1.0, 0.5)
			b.add(MeshBuilder.cyl(0.0, 0.28, 1.3, 5), MeshBuilder.at(Vector3(0, 0.65, 0)), cc)
			b.add(MeshBuilder.cyl(0.0, 0.18, 0.8, 5), MeshBuilder.at(Vector3(0.3, 0.35, 0.1), Vector3.ONE, Vector3(0, 0, -0.5)), cc)
			b.add(MeshBuilder.cyl(0.0, 0.16, 0.7, 5), MeshBuilder.at(Vector3(-0.25, 0.3, -0.15), Vector3.ONE, Vector3(0.3, 0, 0.5)), cc)
		DEAD_BUSH:
			var dc := Color(0.55, 0.40, 0.25)
			for k in 5:
				var a := k * 1.25
				b.add(MeshBuilder.cyl(0.015, 0.035, 0.7, 4), MeshBuilder.at(Vector3(cos(a) * 0.12, 0.3, sin(a) * 0.12), Vector3.ONE, Vector3(sin(a) * 0.6, 0, cos(a) * 0.6)), dc)
	return b.commit(material())
