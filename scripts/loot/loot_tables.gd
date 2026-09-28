class_name LootTables
extends RefCounted
## Loot CONTEXTUAL: o que existe num contêiner depende do tipo de local
## (casa, hospital, oficina, mercado, posto, delegacia…) e do tipo de móvel
## (geladeira, armário de remédios, caixa de ferramentas…).
## Resultado determinístico por uid (o mesmo armário sempre tem o mesmo
## conteúdo inicial) e persistido no GameState após aberto.
##
## Entrada: [id, peso, mín, máx]

const COUNT := {
	"fridge": [0, 3], "kitchen_cabinet": [0, 3], "drawer": [0, 2], "nightstand": [0, 2], "wardrobe": [0, 3],
	"medicine_cabinet": [0, 3], "bookshelf": [0, 1], "shelf": [0, 4], "counter": [0, 2], "locker": [0, 3],
	"filing": [0, 2], "med_cart": [1, 4], "toolbox": [1, 3], "workbench": [0, 3], "desk": [0, 2], "freezer": [0, 3],
	"crate": [1, 4], "rack": [1, 4], "barrel": [0, 1], "box": [0, 2], "lab_cabinet": [0, 3], "server": [0, 1],
	"stove": [0, 1], "trunk": [0, 3], "glovebox": [0, 2], "stash": [1, 5], "_floor": [1, 1], "body": [0, 3],
}

const T := {
	"house": {
		"fridge": [["refrigerante", 3, 1, 2], ["agua_garrafa", 3, 1, 2], ["fruta", 2, 1, 3], ["carne_crua", 1, 1, 1], ["suco_caixa", 2, 1, 2], ["mel", 1, 1, 1], ["cachaca", 1, 1, 1]],
		"kitchen_cabinet": [["lata_feijao", 5, 1, 2], ["lata_sardinha", 4, 1, 2], ["arroz", 3, 1, 1], ["macarrao", 4, 1, 3], ["biscoito", 4, 1, 2], ["lata_milho", 3, 1, 2], ["faca_cozinha", 2, 1, 1], ["fosforos", 2, 1, 1], ["garrafa_vazia", 2, 1, 2], ["alcool", 1, 1, 1], ["cafe_pronto", 1, 1, 1]],
		"drawer": [["pilha", 3, 1, 4], ["fita_adesiva", 2, 1, 1], ["isqueiro", 1, 1, 1], ["chave_fenda", 2, 1, 1], ["fios", 2, 1, 3], ["cigarros", 1, 1, 2], ["analgesico", 2, 1, 3], ["corda", 1, 1, 1], ["parafusos", 2, 3, 12]],
		"nightstand": [["analgesico", 3, 1, 3], ["pilha", 2, 1, 2], ["lanterna", 1, 1, 1], ["vitaminas", 2, 1, 3], ["chocolate", 1, 1, 1], ["cigarros", 1, 1, 1]],
		"wardrobe": [["pano", 5, 1, 4], ["jaqueta", 2, 1, 1], ["capa_chuva", 1, 1, 1], ["casaco_inverno", 1, 1, 1], ["mochila_escolar", 2, 1, 1], ["tecido_grosso", 3, 1, 2], ["luvas", 1, 1, 1], ["botas", 1, 1, 1], ["taco_beisebol", 1, 1, 1]],
		"medicine_cabinet": [["bandagem", 4, 1, 3], ["analgesico", 4, 1, 4], ["antisseptico", 2, 1, 1], ["antitermico", 3, 1, 3], ["vitaminas", 2, 1, 2], ["antibiotico", 1, 1, 1], ["carvao_ativado", 1, 1, 2]],
		"bookshelf": [["pano", 1, 1, 1], ["pilha", 1, 1, 2], ["cigarros", 1, 1, 1]],
		"shelf": [["garrafa_vazia", 2, 1, 2], ["lata_vazia", 2, 1, 2], ["pregos", 2, 5, 20], ["tabua", 1, 1, 2], ["fita_adesiva", 1, 1, 1], ["martelo", 1, 1, 1], ["pa", 1, 1, 1]],
		"stove": [["macarrao", 2, 1, 1], ["fosforos", 3, 1, 1]],
		"tv_stand": [["pilha", 3, 1, 4], ["fios", 3, 2, 5]],
		"_floor": [["lata_vazia", 3, 1, 1], ["garrafa_vazia", 3, 1, 1], ["pano", 3, 1, 2], ["pilha", 1, 1, 2], ["biscoito", 1, 1, 1], ["pedra", 1, 1, 2]],
	},
	"grocery": {
		"shelf": [["lata_feijao", 5, 1, 3], ["lata_sardinha", 5, 1, 3], ["lata_milho", 4, 1, 3], ["arroz", 4, 1, 2], ["macarrao", 5, 2, 5], ["biscoito", 5, 1, 3], ["barra_cereal", 3, 1, 4], ["chocolate", 3, 1, 3], ["agua_garrafa", 4, 1, 3], ["refrigerante", 4, 1, 3], ["suco_caixa", 3, 1, 3], ["mel", 1, 1, 1], ["fosforos", 2, 1, 2], ["pilha", 2, 1, 4], ["cigarros", 2, 1, 3], ["cachaca", 1, 1, 1]],
		"freezer": [["carne_crua", 3, 1, 2], ["peixe_cru", 2, 1, 2], ["refrigerante", 3, 1, 3], ["agua_garrafa", 3, 1, 3], ["energetico", 2, 1, 2]],
		"counter": [["cigarros", 3, 1, 3], ["isqueiro", 2, 1, 1], ["chocolate", 2, 1, 3], ["pilha", 2, 1, 4], ["cachaca", 1, 1, 1]],
		"_floor": [["biscoito", 2, 1, 1], ["lata_vazia", 3, 1, 1], ["garrafa_vazia", 2, 1, 1]],
	},
	"pharmacy": {
		"shelf": [["bandagem", 5, 1, 4], ["analgesico", 5, 2, 6], ["antitermico", 4, 2, 5], ["antisseptico", 3, 1, 2], ["antibiotico", 2, 1, 2], ["vitaminas", 3, 1, 4], ["carvao_ativado", 2, 1, 3], ["comprimido_purificador", 2, 2, 6], ["kit_primeiros_socorros", 1, 1, 1], ["alcool", 2, 1, 2]],
		"counter": [["antibiotico", 2, 1, 2], ["kit_sutura", 1, 1, 1], ["tala", 1, 1, 1], ["analgesico", 2, 1, 3]],
		"_floor": [["bandagem", 2, 1, 1], ["analgesico", 2, 1, 2]],
	},
	"hardware": {
		"shelf": [["pregos", 5, 10, 30], ["parafusos", 4, 10, 30], ["fita_adesiva", 4, 1, 2], ["cola", 3, 1, 2], ["corda", 3, 1, 2], ["fios", 3, 2, 6], ["tabua", 3, 1, 3], ["lona", 2, 1, 1], ["martelo", 2, 1, 1], ["serrote", 2, 1, 1], ["alicate", 2, 1, 1], ["pe_de_cabra", 1, 1, 1], ["marreta", 1, 1, 1], ["machado", 1, 1, 1], ["mangueira", 1, 1, 1], ["galao_vazio", 1, 1, 1]],
		"toolbox": [["chave_inglesa", 3, 1, 1], ["chave_fenda", 3, 1, 1], ["alicate", 2, 1, 1], ["kit_ferramentas", 1, 1, 1], ["fita_adesiva", 2, 1, 1]],
		"counter": [["pilha", 3, 2, 6], ["lanterna", 2, 1, 1], ["isqueiro", 2, 1, 1]],
		"_floor": [["pregos", 3, 3, 8], ["sucata", 3, 1, 2]],
	},
	"workshop": {
		"toolbox": [["chave_inglesa", 4, 1, 1], ["chave_fenda", 3, 1, 1], ["alicate", 3, 1, 1], ["kit_ferramentas", 2, 1, 1], ["fita_adesiva", 2, 1, 2], ["parafusos", 3, 5, 20]],
		"workbench": [["sucata", 5, 1, 4], ["pecas_motor", 2, 1, 1], ["oleo_motor", 3, 1, 1], ["fios", 3, 2, 6], ["cola", 2, 1, 1], ["pe_de_cabra", 1, 1, 1], ["cano_ferro", 2, 1, 1]],
		"shelf": [["oleo_motor", 3, 1, 2], ["pecas_motor", 2, 1, 2], ["pneu", 1, 1, 1], ["bateria_carro", 1, 1, 1], ["mangueira", 2, 1, 1], ["galao_vazio", 2, 1, 1], ["galao_gasolina", 1, 1, 1]],
		"barrel": [["oleo_motor", 2, 1, 1], ["sucata", 2, 1, 2]],
		"_floor": [["sucata", 4, 1, 2], ["parafusos", 3, 3, 10], ["pano", 2, 1, 2]],
	},
	"gas_station": {
		"shelf": [["refrigerante", 4, 1, 3], ["agua_garrafa", 4, 1, 2], ["biscoito", 4, 1, 2], ["chocolate", 3, 1, 2], ["barra_cereal", 3, 1, 3], ["energetico", 3, 1, 2], ["oleo_motor", 2, 1, 1], ["cigarros", 3, 1, 3], ["isqueiro", 2, 1, 1], ["pilha", 2, 1, 4], ["fita_adesiva", 1, 1, 1]],
		"counter": [["cigarros", 3, 1, 4], ["isqueiro", 2, 1, 2], ["mangueira", 1, 1, 1]],
		"storage": [["galao_vazio", 3, 1, 1], ["galao_gasolina", 2, 1, 1], ["oleo_motor", 3, 1, 2], ["mangueira", 2, 1, 1]],
		"crate": [["galao_vazio", 3, 1, 1], ["oleo_motor", 3, 1, 2]],
		"_floor": [["garrafa_vazia", 3, 1, 1], ["lata_vazia", 3, 1, 1]],
	},
	"hospital": {
		"med_cart": [["bandagem", 5, 1, 4], ["antisseptico", 4, 1, 2], ["analgesico", 4, 1, 4], ["antibiotico", 3, 1, 2], ["kit_sutura", 2, 1, 1], ["tala", 2, 1, 1], ["antitermico", 3, 1, 3]],
		"medicine_cabinet": [["antibiotico", 3, 1, 2], ["analgesico", 3, 1, 4], ["kit_primeiros_socorros", 1, 1, 1], ["antisseptico", 3, 1, 2], ["carvao_ativado", 2, 1, 2]],
		"shelf": [["bandagem", 4, 2, 5], ["antisseptico", 3, 1, 2], ["alcool", 3, 1, 2], ["pano_limpo", 3, 2, 5], ["kit_primeiros_socorros", 1, 1, 1], ["comprimido_purificador", 1, 2, 5]],
		"locker": [["jaqueta", 1, 1, 1], ["luvas", 2, 1, 1], ["mochila_escolar", 1, 1, 1], ["barra_cereal", 2, 1, 2], ["cigarros", 1, 1, 2], ["pano", 3, 1, 3]],
		"fridge": [["agua_garrafa", 3, 1, 2], ["suco_caixa", 3, 1, 2], ["antibiotico", 1, 1, 1]],
		"desk": [["analgesico", 2, 1, 2], ["pilha", 2, 1, 2], ["cartao_corvalis", 0, 1, 1]],
		"filing": [["pano", 1, 1, 1]],
		"counter": [["bandagem", 3, 1, 2], ["analgesico", 3, 1, 2]],
		"cabinet_low": [["bandagem", 3, 1, 2], ["pano_limpo", 3, 1, 3]],
		"drawer": [["bandagem", 3, 1, 2], ["analgesico", 3, 1, 3], ["antisseptico", 2, 1, 1]],
		"_floor": [["bandagem", 3, 1, 1], ["pano_limpo", 3, 1, 2], ["analgesico", 2, 1, 1]],
	},
	"police": {
		"locker": [["cassetete", 3, 1, 1], ["colete", 1, 1, 1], ["lanterna", 3, 1, 1], ["pilha", 3, 2, 6], ["bandagem", 2, 1, 2], ["municao_38", 1, 3, 10], ["botas", 1, 1, 1], ["luvas", 2, 1, 1], ["racao_militar", 1, 1, 1]],
		"desk": [["pilha", 2, 1, 3], ["cigarros", 2, 1, 2], ["analgesico", 1, 1, 2], ["cafe_pronto", 1, 1, 1]],
		"filing": [["pano", 1, 1, 1]],
		"shelf": [["municao_38", 1, 2, 6], ["revolver", 0.2, 1, 1], ["colete", 1, 1, 1], ["kit_primeiros_socorros", 1, 1, 1], ["rojao", 1, 1, 2]],
		"crate": [["racao_militar", 3, 1, 2], ["agua_garrafa", 3, 1, 3], ["colete", 1, 1, 1], ["municao_38", 1, 3, 8]],
		"_floor": [["cassetete", 1, 1, 1], ["pilha", 2, 1, 2]],
	},
	"school": {
		"desk": [["biscoito", 2, 1, 1], ["suco_caixa", 2, 1, 1], ["chocolate", 1, 1, 1], ["pano", 1, 1, 1], ["mochila_escolar", 1, 1, 1]],
		"bookshelf": [["pano", 1, 1, 1], ["cola", 2, 1, 1]],
		"locker": [["mochila_escolar", 2, 1, 1], ["taco_beisebol", 1, 1, 1], ["jaqueta", 1, 1, 1], ["barra_cereal", 2, 1, 2]],
		"_floor": [["garrafa_vazia", 2, 1, 1], ["biscoito", 1, 1, 1]],
	},
	"warehouse": {
		"rack": [["tabua", 4, 1, 4], ["sucata", 3, 1, 4], ["lona", 2, 1, 1], ["corda", 2, 1, 2], ["pregos", 3, 10, 30], ["galao_vazio", 1, 1, 1], ["pneu", 1, 1, 1], ["racao_militar", 1, 1, 2], ["agua_garrafa", 2, 1, 4], ["lata_feijao", 2, 1, 4]],
		"crate": [["lata_feijao", 3, 1, 4], ["agua_garrafa", 3, 1, 4], ["tabua", 2, 1, 2], ["pano", 2, 2, 6], ["fita_adesiva", 1, 1, 2]],
		"barrel": [["oleo_motor", 2, 1, 1], ["galao_gasolina", 1, 1, 1]],
		"_floor": [["sucata", 3, 1, 2], ["tabua", 2, 1, 1], ["pregos", 2, 3, 8]],
	},
	"lab": {
		"lab_cabinet": [["antisseptico", 3, 1, 2], ["alcool", 3, 1, 2], ["antibiotico", 2, 1, 1], ["luvas", 2, 1, 1], ["mascara_filtro", 1, 1, 1], ["inibidor_nx", 0.3, 1, 1]],
		"locker": [["jaqueta", 1, 1, 1], ["mascara_filtro", 1, 1, 1], ["pilha", 2, 1, 3], ["lanterna", 1, 1, 1], ["barra_cereal", 2, 1, 2]],
		"desk": [["pilha", 2, 1, 2], ["cafe_pronto", 1, 1, 1], ["analgesico", 1, 1, 2]],
		"freezer": [["agua_garrafa", 2, 1, 2]],
		"filing": [["pano", 1, 1, 1]],
		"shelf": [["alcool", 3, 1, 2], ["antisseptico", 2, 1, 2], ["pano_limpo", 2, 1, 3], ["comprimido_purificador", 2, 2, 5]],
		"server": [["fios", 3, 2, 6], ["sucata", 2, 1, 2]],
		"_floor": [["pano_limpo", 2, 1, 1], ["pilha", 1, 1, 1]],
	},
	"office": {
		"desk": [["pilha", 2, 1, 3], ["cafe_pronto", 1, 1, 1], ["chocolate", 1, 1, 1], ["analgesico", 1, 1, 2], ["cigarros", 1, 1, 1]],
		"filing": [["pano", 1, 1, 1], ["cola", 1, 1, 1]],
		"locker": [["jaqueta", 1, 1, 1], ["capa_chuva", 1, 1, 1], ["mochila_escolar", 1, 1, 1], ["lanterna", 1, 1, 1]],
		"counter": [["pilha", 2, 1, 2], ["cafe_pronto", 1, 1, 1]],
		"_floor": [["garrafa_vazia", 2, 1, 1]],
	},
	"bar": {
		"counter": [["cachaca", 4, 1, 2], ["cigarros", 3, 1, 3], ["refrigerante", 3, 1, 3], ["isqueiro", 2, 1, 1], ["garrafa_vazia", 3, 1, 3]],
		"shelf": [["cachaca", 3, 1, 2], ["refrigerante", 3, 1, 3], ["garrafa_vazia", 3, 1, 3], ["biscoito", 2, 1, 2]],
		"fridge": [["refrigerante", 4, 1, 3], ["agua_garrafa", 2, 1, 2], ["carne_crua", 1, 1, 1]],
		"_floor": [["garrafa_vazia", 4, 1, 2], ["lata_vazia", 2, 1, 1]],
	},
	"church": {
		"cabinet_low": [["pano", 3, 1, 3], ["fosforos", 2, 1, 2], ["cachaca", 1, 1, 1], ["pao_velho", 2, 1, 2]],
		"_floor": [["pano", 2, 1, 1]],
	},
	"barn": {
		"crate": [["corda", 3, 1, 2], ["lona", 2, 1, 1], ["pa", 2, 1, 1], ["machado", 1, 1, 1], ["facao", 2, 1, 1], ["ervas", 3, 2, 5], ["fruta", 3, 2, 5], ["galao_gasolina", 1, 1, 1]],
		"workbench": [["tabua", 3, 1, 3], ["pregos", 3, 5, 15], ["serrote", 2, 1, 1], ["martelo", 2, 1, 1]],
		"barrel": [["galao_gasolina", 1, 1, 1], ["oleo_motor", 2, 1, 1]],
		"_floor": [["lenha", 4, 1, 3], ["ervas", 2, 1, 3], ["fruta", 2, 1, 2]],
	},
	"bunker": {
		"shelf": [["racao_militar", 4, 1, 3], ["agua_garrafa", 4, 2, 4], ["kit_primeiros_socorros", 2, 1, 1], ["pilha", 3, 2, 8], ["municao_38", 1, 3, 10], ["comprimido_purificador", 2, 3, 8]],
		"crate": [["racao_militar", 3, 1, 2], ["mochila_militar", 1, 1, 1], ["colete", 1, 1, 1], ["mascara_filtro", 1, 1, 1], ["rojao", 2, 1, 3]],
		"_floor": [["pilha", 2, 1, 2]],
	},
	"radio": {
		"desk": [["pilha", 3, 2, 6], ["fios", 3, 2, 5], ["radio_portatil", 1, 1, 1]],
		"shelf": [["fios", 3, 2, 5], ["pilha", 2, 2, 4], ["fita_adesiva", 2, 1, 1]],
		"_floor": [["fios", 2, 1, 2]],
	},
	"car": {
		"trunk": [["galao_vazio", 2, 1, 1], ["pano", 3, 1, 2], ["agua_garrafa", 2, 1, 2], ["chave_inglesa", 2, 1, 1], ["pneu", 1, 1, 1], ["corda", 2, 1, 1], ["mochila_escolar", 1, 1, 1], ["lanterna", 1, 1, 1], ["kit_ferramentas", 0.5, 1, 1], ["mangueira", 1, 1, 1]],
		"glovebox": [["pilha", 2, 1, 2], ["cigarros", 2, 1, 1], ["analgesico", 2, 1, 2], ["isqueiro", 2, 1, 1], ["barra_cereal", 2, 1, 1], ["bandagem", 1, 1, 1]],
	},
	"camp": {
		"crate": [["lata_feijao", 3, 1, 2], ["agua_suja", 3, 1, 2], ["pano", 3, 1, 3], ["corda", 2, 1, 1], ["fosforos", 2, 1, 1], ["lenha", 3, 1, 3], ["faca_cozinha", 1, 1, 1], ["tabua", 2, 1, 2]],
		"body": [["bandagem", 2, 1, 1], ["pilha", 2, 1, 2], ["cigarros", 2, 1, 1], ["barra_cereal", 2, 1, 1], ["faca_cozinha", 1, 1, 1], ["mochila_escolar", 1, 1, 1]],
		"_floor": [["lata_vazia", 3, 1, 1], ["lenha", 2, 1, 2]],
	},
}

const ALIASES := {"shop": "grocery", "market": "grocery", "clinic": "hospital", "farmhouse": "house", "cabin": "house",
	"apartment": "house", "terminal": "office", "stadium": "camp", "factory": "warehouse"}

## Quão saqueada está cada zona após semanas de colapso (0..1).
const SCAVENGED := {"centro": 0.55, "centro_sul": 0.5, "bairro_alto": 0.4, "acacias": 0.35, "vila_operaria": 0.4,
	"industrial": 0.3, "parque_norte": 0.25, "rural": 0.15, "floresta": 0.1, "serra": 0.15, "rio": 0.3, "periferia": 0.3}


static func table_for(context: String, kind: String) -> Array:
	var ctx := context
	if not T.has(ctx):
		ctx = ALIASES.get(ctx, "house")
	var t: Dictionary = T[ctx]
	if t.has(kind):
		return t[kind]
	# móveis genéricos caem na tabela da casa
	var h: Dictionary = T["house"]
	return h.get(kind, t.get("_floor", []))


static func roll(context: String, kind: String, uid: String, district: String = "", mult: float = 1.0) -> Array:
	var r := Util.rng(Util.hash_str(uid) + 1337)
	var entries := table_for(context, kind)
	var out: Array = []
	if entries.is_empty():
		return out
	var scav: float = SCAVENGED.get(district, 0.3)
	if GameState.world_phase != GameState.Phase.POST:
		scav = 0.0
	if r.randf() < scav * 0.8:
		return out  # já saqueado por outros sobreviventes
	var cnt: Array = COUNT.get(kind, [0, 2])
	var n := r.randi_range(int(cnt[0]), int(cnt[1]))
	n = int(round(n * mult * (1.0 - scav * 0.4)))
	var weighted: Array = []
	for e in entries:
		weighted.append([e, float(e[1])])
	for i in n:
		var e = Util.weighted_pick(weighted, r)
		if e == null:
			continue
		var id: String = e[0]
		if float(e[1]) <= 0.0:
			continue
		var qty := r.randi_range(int(e[2]), int(e[3]))
		var cond := 1.0
		if ItemDB.has_durability(id):
			cond = r.randf_range(0.25, 0.95)
		var data := {}
		if id == "lanterna":
			data["battery"] = r.randf_range(10.0, 80.0)
		out.append(Inventory.make_stack(id, qty, cond, data))
	return out
