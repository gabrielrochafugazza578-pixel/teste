class_name NPCDB
extends RefCounted
## Sobreviventes nomeados (história) e modelos de membros de facção.
##
## Campos: name, faction, poi (base), offset (m relativos ao POI), role,
## weapon, essential (não morre: fica caído e se recupera), trader,
## companion (pode acompanhar o jogador), appearance (overrides),
## routine: [[hora_inicial, atividade, âncora]] — âncoras: "home", "fire",
## "post", "wander", "sleep". Atividades mapeiam para animações.
## present: condição para existir no mundo (capítulo, flag, decisão).

const NAMED := {
	"davi": {"name": "Davi", "faction": "remanescentes", "poi": "praca", "offset": [4.0, 0.0, -3.0], "role": "scout",
		"weapon": "cano_ferro", "essential": true, "companion": true,
		"bio": "Batedor dos Remanescentes. Ex-entregador de bicicleta; conhece cada beco da cidade.",
		"appearance": {"female": false, "height": 1.74, "top": "hoodie", "top_color": Color(0.3, 0.42, 0.3), "hair_style": "buzz", "backpack": true, "seed": 101},
		"routine": [[6, "guard", "post"], [12, "wander", "wander"], [19, "warm", "fire"], [23, "sleep", "sleep"]],
		"present": {"chapter_min": 1}},
	"marta": {"name": "Marta Albuquerque", "faction": "remanescentes", "poi": "estadio", "offset": [0.0, 0.0, 10.0], "role": "leader",
		"essential": true, "bio": "Enfermeira-chefe do São Lucas. Hoje lidera os Remanescentes no estádio.",
		"appearance": {"female": true, "height": 1.66, "top": "jacket", "top_color": Color(0.55, 0.62, 0.66), "hair_style": "ponytail", "hair_color": Color(0.35, 0.3, 0.28), "seed": 102},
		"routine": [[6, "talk", "home"], [13, "inspect", "home"], [20, "warm", "fire"], [23, "sleep", "sleep"]]},
	"zilda": {"name": "Dona Zilda", "faction": "remanescentes", "poi": "estadio", "offset": [-6.0, 0.0, 14.0], "role": "cook",
		"essential": true, "trader": true, "bio": "Cozinheira do estádio. Transforma quase nada em sopa para cinquenta.",
		"appearance": {"female": true, "height": 1.56, "girth": 1.2, "top": "longsleeve", "top_color": Color(0.6, 0.35, 0.3), "hair_style": "bun", "hair_color": Color(0.7, 0.7, 0.68), "seed": 103},
		"routine": [[5, "cook", "fire"], [21, "sit", "home"], [23, "sleep", "sleep"]]},
	"tonho": {"name": "Tonho", "faction": "remanescentes", "poi": "oficina", "offset": [3.0, 0.0, 5.0], "role": "mechanic",
		"weapon": "chave_inglesa", "essential": true, "trader": true, "bio": "Mecânico da Vila Operária. Não saiu da oficina nem quando a cidade caiu.",
		"appearance": {"female": false, "height": 1.72, "girth": 1.25, "top": "tshirt", "top_color": Color(0.2, 0.3, 0.45), "hair_style": "bald", "beard": 0.8, "grime": 0.6, "seed": 104},
		"routine": [[6, "inspect", "home"], [19, "sit", "home"], [23, "sleep", "sleep"]],
		"present": {"chapter_min": 1}},
	"tavares": {"name": "Comandante Rui Tavares", "faction": "guarda", "poi": "delegacia", "offset": [0.0, 0.0, 6.0], "role": "leader",
		"weapon": "revolver", "essential": true, "bio": "Comandante da Guarda Aurora. Acredita que ordem é sobrevivência.",
		"appearance": {"id": "police", "female": false, "height": 1.84, "hair_style": "buzz", "hair_color": Color(0.5, 0.5, 0.5), "vest": true, "seed": 105},
		"routine": [[6, "guard", "home"], [22, "sleep", "sleep"]]},
	"corvo": {"name": "Bento \"Corvo\" Siqueira", "faction": "corvos", "poi": "acampamento_rio", "offset": [2.0, 0.0, -4.0], "role": "leader",
		"weapon": "facao", "essential": true, "trader": true, "bio": "Chefe dos Corvos do Rio. Cobra pedágio na Ponte Velha.",
		"appearance": {"female": false, "height": 1.8, "top": "jacket", "top_color": Color(0.15, 0.12, 0.12), "hair_style": "long", "beard": 0.5, "hat": "beanie", "hat_color": Color(0.35, 0.1, 0.08), "seed": 106},
		"routine": [[8, "guard", "home"], [18, "warm", "fire"], [1, "sleep", "sleep"]]},
	"sofia": {"name": "Sofia", "faction": "", "poi": "escola", "offset": [2.0, 0.0, 3.0], "role": "child",
		"essential": true, "companion": true, "bio": "Nove anos. Sobreviveu sozinha na escola por três semanas.",
		"appearance": {"female": true, "height": 1.32, "build": 0.8, "girth": 0.8, "top": "hoodie", "top_color": Color(0.75, 0.55, 0.2), "hair_style": "ponytail", "backpack": true, "backpack_color": Color(0.6, 0.2, 0.35), "seed": 107},
		"routine": [[0, "hide", "home"]],
		"present": {"mission": "s_sofia"}},
	"otavio": {"name": "Dr. Otávio Reis", "faction": "", "poi": "igreja_despertos", "offset": [-3.0, 0.0, 4.0], "role": "captive",
		"essential": true, "bio": "Bioquímico da Corvalis. Sabe fabricar o inibidor NX.",
		"appearance": {"id": "researcher", "female": false, "height": 1.7, "top": "shirt", "top_color": Color(0.8, 0.8, 0.78), "glasses": true, "hair_style": "short", "hair_color": Color(0.55, 0.5, 0.45), "grime": 0.5, "seed": 108},
		"routine": [[0, "captive", "home"]],
		"present": {"chapter_min": 6, "not_flag": "otavio_free"}},
	"celia": {"name": "Célia", "faction": "", "poi": "fazenda_santa_clara", "offset": [5.0, 0.0, 2.0], "role": "family",
		"essential": true, "bio": "Mãe de Caio e Lia. Professora aposentada.",
		"appearance": {"female": true, "height": 1.6, "top": "longsleeve", "top_color": Color(0.5, 0.35, 0.45), "hair_style": "short", "hair_color": Color(0.45, 0.4, 0.38), "glasses": true, "grime": 0.45, "seed": 109},
		"routine": [[0, "sit", "home"]],
		"present": {"chapter_min": 5}},
	"lia": {"name": "Lia", "faction": "", "poi": "setor7", "offset": [0.0, 0.0, 0.0], "role": "family",
		"essential": true, "bio": "Irmã mais nova de Caio. Paciente 0417. Imune.",
		"appearance": {"female": true, "height": 1.58, "build": 0.88, "top": "longsleeve", "top_color": Color(0.85, 0.87, 0.9), "bottom": "pants", "bottom_color": Color(0.8, 0.82, 0.85), "hair_style": "long", "hair_color": Color(0.1, 0.07, 0.05), "seed": 110},
		"routine": [[0, "sit", "home"]],
		"present": {"setor7": true}},
	"helena": {"name": "Dra. Helena Vasconcelos", "faction": "", "poi": "setor7", "offset": [0.0, 0.0, 0.0], "role": "scientist",
		"essential": true, "bio": "Pesquisadora-chefe do Projeto NEXUS.",
		"appearance": {"helena": true},
		"routine": [[0, "typing", "home"]],
		"present": {"setor7": true}},
}

## Membros genéricos das facções (gerados por semente em cada base).
const CAMPS := {
	"remanescentes": {"poi": "estadio", "count": 9, "radius": 16.0, "fighters": 0.4, "weapons": ["cano_ferro", "taco_beisebol", "lanca", "pa"]},
	"guarda": {"poi": "delegacia", "count": 6, "radius": 10.0, "fighters": 0.9, "weapons": ["cassetete", "revolver", "cassetete"]},
	"guarda_ponte": {"faction": "guarda", "poi": "checkpoint_ponte", "count": 4, "radius": 9.0, "fighters": 1.0, "weapons": ["revolver", "cassetete"]},
	"corvos": {"poi": "acampamento_rio", "count": 7, "radius": 14.0, "fighters": 0.85, "weapons": ["facao", "taco_pregos", "machado", "revolver"]},
	"corvos_ponte": {"faction": "corvos", "poi": "ponte_velha", "count": 3, "radius": 7.0, "fighters": 1.0, "weapons": ["facao", "revolver"]},
	"despertos": {"poi": "igreja_despertos", "count": 6, "radius": 12.0, "fighters": 0.5, "weapons": ["faca_cozinha", "lanca", "cano_ferro"]},
	"corvalis": {"poi": "corvalis", "count": 6, "radius": 30.0, "fighters": 1.0, "weapons": ["revolver", "cassetete"], "chapter_min": 3},
	"corvalis_fazenda": {"faction": "corvalis", "poi": "fazenda_santa_clara", "count": 5, "radius": 20.0, "fighters": 1.0, "weapons": ["revolver", "cassetete"], "chapter_min": 4},
}

const FIRST_M := ["Jorge", "Paulo", "Edson", "Rafael", "Wesley", "Luiz", "Márcio", "Renato", "Diego", "Anderson", "Cláudio", "Sérgio", "Everton", "Vítor"]
const FIRST_F := ["Ana", "Cida", "Patrícia", "Juliana", "Rose", "Fernanda", "Tânia", "Bruna", "Kátia", "Luana", "Silvana", "Denise", "Priscila", "Vera"]

## Falas curtas (latidos) por situação e atitude.
const BARKS := {
	"greet_friendly": ["E aí, Caio.", "Bom te ver inteiro.", "Cuidado lá fora.", "Trouxe alguma coisa boa?", "A Marta tava perguntando de você."],
	"greet_neutral": ["Hm.", "Tá procurando alguma coisa?", "Não faz barulho por aqui.", "Fica na sua que eu fico na minha."],
	"warn": ["Para aí! Mais um passo e eu não respondo.", "Mãos onde eu possa ver!", "Aqui não é lugar pra você. Volta.", "Último aviso!"],
	"hostile": ["Pega ele!", "Não deixa fugir!", "Tá no lugar errado, amigo."],
	"infected": ["Infectado!", "Tem um vindo!", "Cuidado, atrás de você!", "Segura a linha!"],
	"flee": ["Corre!", "Não dá, são muitos!", "Sai daqui!"],
	"hurt": ["Ai! Droga...", "Fui atingido!", "Tô sangrando..."],
	"night": ["Noite ruim pra estar na rua.", "Apaga essa luz, pelo amor de Deus."],
	"follow": ["Tô contigo.", "Vai na frente.", "Certo, vamos."],
	"wait": ["Espero aqui.", "Não demora."],
	"thanks": ["Valeu, de verdade.", "Isso vai ajudar muita gente.", "Não vou esquecer."],
	"rain": ["Essa chuva não para.", "Pelo menos a chuva abafa o barulho."],
}

const ACTIVITY_ANIM := {
	"guard": "guard_idle", "warm": "warm_hands", "sit": "sit", "cook": "warm_hands", "inspect": "inspect_low",
	"talk": "gaze", "typing": "typing", "hide": "crouch_hide", "captive": "sit", "sleep": "lie", "carry": "carry_box", "wander": "",
}


static func named(id: String) -> Dictionary:
	return NAMED.get(id, {})


static func appearance_for(id: String) -> Dictionary:
	var d := named(id)
	var ov: Dictionary = d.get("appearance", {})
	if ov.get("helena", false):
		return Appearance.helena()
	var seed_v := int(ov.get("seed", Util.hash_str(id) % 1000))
	var a: Dictionary
	match str(ov.get("id", "")):
		"police": a = Appearance.police(seed_v)
		"researcher": a = Appearance.researcher(seed_v)
		_:
			var f: String = d.get("faction", "")
			a = Appearance.survivor(FactionManager.color(f) if f != "" else Color(0.4, 0.4, 0.4), seed_v, str(d.get("role", "")) in ["scout", "leader"])
	for k in ov.keys():
		if k != "id":
			a[k] = ov[k]
	a["id"] = "npc_" + id
	return a


static func random_name(r: RandomNumberGenerator, female: bool) -> String:
	return FIRST_F[r.randi() % FIRST_F.size()] if female else FIRST_M[r.randi() % FIRST_M.size()]


static func bark(kind: String, r: RandomNumberGenerator = null) -> String:
	var l: Array = BARKS.get(kind, [])
	if l.is_empty():
		return ""
	return str(l[(r.randi() if r else randi()) % l.size()])
