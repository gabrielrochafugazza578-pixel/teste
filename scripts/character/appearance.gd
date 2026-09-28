class_name Appearance
extends RefCounted
## Presets de aparência. Um dicionário de aparência descreve proporções,
## roupas e marcas de infecção; o HumanoidMeshBuilder transforma isso em
## malha com esqueleto. Mesmos presets no gameplay e na cinemática.

const SKIN_TONES := [Color(0.93, 0.78, 0.68), Color(0.86, 0.68, 0.56), Color(0.76, 0.57, 0.44),
	Color(0.62, 0.45, 0.33), Color(0.48, 0.33, 0.24), Color(0.36, 0.24, 0.17)]
const HAIR_COLORS := [Color(0.08, 0.06, 0.05), Color(0.16, 0.1, 0.06), Color(0.3, 0.18, 0.09),
	Color(0.5, 0.36, 0.2), Color(0.62, 0.55, 0.45), Color(0.72, 0.7, 0.68)]
const CLOTH_COLORS := [Color(0.18, 0.2, 0.24), Color(0.5, 0.12, 0.1), Color(0.22, 0.3, 0.2),
	Color(0.75, 0.72, 0.65), Color(0.12, 0.12, 0.13), Color(0.32, 0.36, 0.5), Color(0.55, 0.45, 0.3),
	Color(0.62, 0.62, 0.64), Color(0.4, 0.25, 0.35), Color(0.7, 0.55, 0.2), Color(0.25, 0.4, 0.45)]
const DENIM := [Color(0.16, 0.22, 0.36), Color(0.26, 0.33, 0.46), Color(0.12, 0.13, 0.16), Color(0.36, 0.3, 0.22)]

static func base() -> Dictionary:
	return {
		"id": "generic", "height": 1.75, "build": 1.0, "girth": 1.0, "female": false,
		"skin": SKIN_TONES[2], "hair_style": "short", "hair_color": HAIR_COLORS[1], "beard": 0.0,
		"top": "tshirt", "top_color": CLOTH_COLORS[0], "top2_color": CLOTH_COLORS[3],
		"bottom": "jeans", "bottom_color": DENIM[0], "shoes": "sneakers", "shoes_color": Color(0.2, 0.2, 0.22),
		"backpack": false, "backpack_color": Color(0.2, 0.22, 0.2), "bedroll": false,
		"glasses": false, "hat": "", "hat_color": Color(0.1, 0.1, 0.12), "mask": false,
		"vest": false, "vest_color": Color(0.1, 0.11, 0.1), "gloves": false,
		"infected": 0.0, "tear": 0.0, "hunch": 0.0, "growths": 0.0, "blind": false,
		"asym": 0.0, "grime": 0.2, "seed": 0,
	}


static func caio() -> Dictionary:
	var a := base()
	a["id"] = "caio"
	a["height"] = 1.8
	a["build"] = 1.03
	a["skin"] = Color(0.66, 0.48, 0.36)
	a["hair_style"] = "messy"
	a["hair_color"] = Color(0.09, 0.07, 0.05)
	a["beard"] = 0.55
	a["top"] = "jacket"
	a["top_color"] = Color(0.24, 0.26, 0.19)
	a["top2_color"] = Color(0.42, 0.43, 0.44)
	a["bottom"] = "jeans"
	a["bottom_color"] = Color(0.14, 0.18, 0.28)
	a["shoes"] = "boots"
	a["shoes_color"] = Color(0.28, 0.18, 0.1)
	a["backpack"] = true
	a["backpack_color"] = Color(0.22, 0.2, 0.17)
	a["bedroll"] = true
	a["grime"] = 0.35
	a["seed"] = 7
	return a


static func helena() -> Dictionary:
	var a := base()
	a["id"] = "helena"
	a["height"] = 1.68
	a["female"] = true
	a["build"] = 0.92
	a["girth"] = 0.9
	a["skin"] = Color(0.88, 0.72, 0.62)
	a["hair_style"] = "bun"
	a["hair_color"] = Color(0.32, 0.15, 0.08)
	a["glasses"] = true
	a["top"] = "labcoat"
	a["top_color"] = Color(0.9, 0.9, 0.88)
	a["top2_color"] = Color(0.34, 0.44, 0.6)
	a["bottom"] = "pants"
	a["bottom_color"] = Color(0.2, 0.2, 0.23)
	a["shoes"] = "sneakers"
	a["shoes_color"] = Color(0.12, 0.12, 0.13)
	a["grime"] = 0.05
	a["seed"] = 11
	return a


static func researcher(seed_value: int) -> Dictionary:
	var r := Util.rng(seed_value * 31 + 5)
	var a := civilian(seed_value)
	a["id"] = "researcher"
	a["top"] = "labcoat"
	a["top_color"] = Color(0.88, 0.89, 0.88)
	a["top2_color"] = CLOTH_COLORS[r.randi() % CLOTH_COLORS.size()]
	a["bottom"] = "pants"
	a["bottom_color"] = [Color(0.2, 0.2, 0.22), Color(0.3, 0.28, 0.25), Color(0.15, 0.17, 0.25)][r.randi() % 3]
	a["glasses"] = r.randf() < 0.4
	a["mask"] = r.randf() < 0.3
	a["backpack"] = false
	a["grime"] = 0.02
	return a


static func patient() -> Dictionary:
	var a := base()
	a["id"] = "patient_zero"
	a["height"] = 1.76
	a["skin"] = Color(0.8, 0.64, 0.52)
	a["hair_style"] = "buzz"
	a["hair_color"] = Color(0.2, 0.14, 0.09)
	a["top"] = "gown"
	a["top_color"] = Color(0.62, 0.74, 0.76)
	a["bottom"] = "pants"
	a["bottom_color"] = Color(0.62, 0.74, 0.76)
	a["shoes"] = "barefoot"
	a["grime"] = 0.0
	a["seed"] = 99
	return a


static func civilian(seed_value: int) -> Dictionary:
	var r := Util.rng(seed_value * 7919 + 13)
	var a := base()
	a["id"] = "civilian"
	a["seed"] = seed_value
	a["female"] = r.randf() < 0.5
	a["height"] = r.randf_range(1.58, 1.72) if a["female"] else r.randf_range(1.66, 1.88)
	a["build"] = r.randf_range(0.88, 1.12)
	a["girth"] = r.randf_range(0.9, 1.2)
	a["skin"] = SKIN_TONES[r.randi() % SKIN_TONES.size()]
	var styles_f := ["long", "ponytail", "bun", "short"]
	var styles_m := ["short", "buzz", "messy", "bald", "short"]
	a["hair_style"] = styles_f[r.randi() % styles_f.size()] if a["female"] else styles_m[r.randi() % styles_m.size()]
	a["hair_color"] = HAIR_COLORS[r.randi() % HAIR_COLORS.size()]
	a["beard"] = 0.0 if a["female"] else (r.randf() if r.randf() < 0.4 else 0.0)
	a["top"] = ["tshirt", "longsleeve", "jacket", "hoodie", "shirt"][r.randi() % 5]
	a["top_color"] = CLOTH_COLORS[r.randi() % CLOTH_COLORS.size()]
	a["top2_color"] = CLOTH_COLORS[r.randi() % CLOTH_COLORS.size()]
	a["bottom"] = ["jeans", "pants", "jeans", "shorts"][r.randi() % 4]
	a["bottom_color"] = DENIM[r.randi() % DENIM.size()] if a["bottom"] == "jeans" else CLOTH_COLORS[r.randi() % CLOTH_COLORS.size()]
	a["shoes"] = ["sneakers", "boots", "sneakers"][r.randi() % 3]
	a["shoes_color"] = CLOTH_COLORS[r.randi() % CLOTH_COLORS.size()] * 0.6
	a["glasses"] = r.randf() < 0.15
	a["hat"] = "cap" if r.randf() < 0.12 else ""
	a["hat_color"] = CLOTH_COLORS[r.randi() % CLOTH_COLORS.size()]
	a["backpack"] = r.randf() < 0.2
	a["grime"] = r.randf_range(0.0, 0.15)
	return a


static func police(seed_value: int) -> Dictionary:
	var a := civilian(seed_value)
	a["id"] = "police"
	a["top"] = "shirt"
	a["top_color"] = Color(0.12, 0.16, 0.26)
	a["bottom"] = "pants"
	a["bottom_color"] = Color(0.1, 0.12, 0.18)
	a["shoes"] = "boots"
	a["shoes_color"] = Color(0.05, 0.05, 0.05)
	a["vest"] = true
	a["vest_color"] = Color(0.08, 0.09, 0.1)
	a["hat"] = "cap"
	a["hat_color"] = Color(0.08, 0.1, 0.18)
	a["backpack"] = false
	return a


static func paramedic(seed_value: int) -> Dictionary:
	var a := civilian(seed_value)
	a["id"] = "paramedic"
	a["top"] = "jacket"
	a["top_color"] = Color(0.75, 0.3, 0.12)
	a["top2_color"] = Color(0.9, 0.9, 0.9)
	a["bottom"] = "pants"
	a["bottom_color"] = Color(0.1, 0.12, 0.2)
	a["mask"] = true
	a["gloves"] = true
	return a


## Sobrevivente de facção (roupas gastas + cor de identificação).
static func survivor(faction_color: Color, seed_value: int, armed_role: bool = false) -> Dictionary:
	var r := Util.rng(seed_value * 131 + 7)
	var a := civilian(seed_value)
	a["id"] = "survivor"
	a["top"] = ["jacket", "hoodie", "longsleeve", "jacket"][r.randi() % 4]
	a["top_color"] = faction_color.lerp(CLOTH_COLORS[r.randi() % CLOTH_COLORS.size()], 0.35)
	a["grime"] = r.randf_range(0.25, 0.5)
	a["tear"] = r.randf_range(0.0, 0.15)
	a["backpack"] = r.randf() < 0.55
	a["backpack_color"] = CLOTH_COLORS[r.randi() % CLOTH_COLORS.size()] * 0.7
	a["gloves"] = r.randf() < 0.4
	if armed_role:
		a["vest"] = r.randf() < 0.6
		a["vest_color"] = faction_color * 0.5
		a["hat"] = ["", "beanie", "cap", "helmet"][r.randi() % 4]
		a["hat_color"] = faction_color * 0.6
	a["shoes"] = "boots"
	return a


## Infectados. `kind` = errante, febril, sentinela, colosso, rastejante, hospedeiro
static func infected(kind: String, seed_value: int) -> Dictionary:
	var r := Util.rng(seed_value * 977 + 3)
	var a := civilian(seed_value)
	a["id"] = "infected_" + kind
	a["infected"] = r.randf_range(0.65, 0.85)
	a["tear"] = r.randf_range(0.25, 0.5)
	a["grime"] = r.randf_range(0.45, 0.8)
	a["hunch"] = r.randf_range(0.4, 0.8)
	a["asym"] = r.randf_range(0.2, 0.7)
	a["hat"] = ""
	a["glasses"] = false
	a["backpack"] = r.randf() < 0.08
	# parte dos infectados eram pacientes, médicos, policiais…
	var origin := r.randf()
	if origin < 0.1:
		a["top"] = "gown"
		a["top_color"] = Color(0.55, 0.66, 0.68)
		a["shoes"] = "barefoot"
	elif origin < 0.16:
		a["top"] = "labcoat"
		a["top_color"] = Color(0.8, 0.8, 0.76)
	elif origin < 0.22:
		a["top"] = "shirt"
		a["top_color"] = Color(0.12, 0.16, 0.26)
		a["vest"] = true
	match kind:
		"febril":
			a["girth"] = 0.82
			a["build"] = 0.92
			a["infected"] = 0.5
			a["hunch"] = 0.25
		"sentinela":
			a["blind"] = true
			a["infected"] = 0.95
			a["hair_style"] = "bald"
			a["hunch"] = 0.9
			a["growths"] = 0.35
		"colosso":
			a["height"] = 2.1
			a["build"] = 1.5
			a["girth"] = 1.7
			a["infected"] = 1.0
			a["tear"] = 0.75
			a["hunch"] = 0.7
			a["growths"] = 0.5
			a["hair_style"] = "bald"
			a["top"] = "tshirt"
			a["top_color"] = Color(0.25, 0.24, 0.22)
		"rastejante":
			a["girth"] = 0.8
			a["infected"] = 0.95
			a["tear"] = 0.7
			a["shoes"] = "barefoot"
		"hospedeiro":
			a["infected"] = 1.0
			a["growths"] = 1.0
			a["tear"] = 0.6
			a["hunch"] = 0.5
			a["hair_style"] = "bald"
	return a


## Chave estável para cache de malha.
static func mesh_key(a: Dictionary, lod: int) -> String:
	var parts := []
	for k: String in ["id", "height", "build", "girth", "female", "hair_style", "beard", "top", "bottom",
			"shoes", "backpack", "bedroll", "glasses", "hat", "mask", "vest", "gloves", "tear", "hunch", "growths", "blind", "asym", "seed"]:
		parts.append(str(a.get(k, "")))
	for k: String in ["skin", "hair_color", "top_color", "top2_color", "bottom_color", "shoes_color", "backpack_color", "hat_color", "vest_color"]:
		var c: Color = a.get(k, Color.BLACK)
		parts.append(c.to_html(false))
	parts.append(str(lod))
	return "|".join(PackedStringArray(parts))
