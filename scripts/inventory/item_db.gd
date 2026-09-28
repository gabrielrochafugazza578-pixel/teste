extends Node
## ItemDB — definições de todos os itens do jogo (dados, sem lógica de cena).
##
## Campos: name, cat, w (kg), stack, desc, value (troca), dur (usos máx.),
## use {efeitos}, action (animação de uso), time (s), weapon {...},
## equip (slot), capacity (kg/slots da mochila), warmth, rain, armor,
## spoils (dias até estragar), cook (resultado ao cozinhar), throw {...}.

const CATS := {
	"comida": "Comida", "bebida": "Bebida", "medicamento": "Medicamento", "ferramenta": "Ferramenta",
	"arma": "Arma", "arremesso": "Arremesso", "material": "Material", "equipamento": "Equipamento",
	"combustivel": "Combustível", "historia": "História", "estrutura": "Estrutura", "municao": "Munição", "diversos": "Diversos",
}

const CAT_COLORS := {
	"comida": Color(0.85, 0.6, 0.25), "bebida": Color(0.3, 0.6, 0.9), "medicamento": Color(0.9, 0.3, 0.3),
	"ferramenta": Color(0.7, 0.7, 0.7), "arma": Color(0.75, 0.35, 0.2), "arremesso": Color(0.6, 0.6, 0.4),
	"material": Color(0.6, 0.5, 0.35), "equipamento": Color(0.4, 0.55, 0.4), "combustivel": Color(0.8, 0.7, 0.2),
	"historia": Color(0.75, 0.6, 0.9), "estrutura": Color(0.5, 0.45, 0.4), "municao": Color(0.8, 0.75, 0.5), "diversos": Color(0.6, 0.6, 0.6),
}

var items: Dictionary = {}


func _ready() -> void:
	_define()


func get_item(id: String) -> Dictionary:
	return items.get(id, {})


func exists(id: String) -> bool:
	return items.has(id)


func item_name(id: String) -> String:
	return str(items.get(id, {}).get("name", id))


func weight(id: String) -> float:
	return float(items.get(id, {}).get("w", 0.1))


func max_stack(id: String) -> int:
	return int(items.get(id, {}).get("stack", 1))


func category(id: String) -> String:
	return str(items.get(id, {}).get("cat", "diversos"))


func is_weapon(id: String) -> bool:
	return items.get(id, {}).has("weapon")


func has_durability(id: String) -> bool:
	return items.get(id, {}).has("dur")


func value(id: String) -> float:
	return float(items.get(id, {}).get("value", 1.0))


func _i(id: String, name: String, cat: String, w: float, stack: int, desc: String, extra: Dictionary = {}) -> void:
	var d := {"name": name, "cat": cat, "w": w, "stack": stack, "desc": desc, "value": 1.0}
	for k in extra.keys():
		d[k] = extra[k]
	items[id] = d


func _define() -> void:
	# --- Comida ---------------------------------------------------------------------
	_i("lata_feijao", "Feijão enlatado", "comida", 0.45, 6, "Feijoada pronta. Não é a da vó, mas mata a fome.", {"use": {"hunger": 38, "thirst": -4}, "action": "use_eat", "time": 3.0, "value": 6, "empty": "lata_vazia"})
	_i("lata_sardinha", "Sardinha em lata", "comida", 0.2, 8, "Proteína e óleo. Muito óleo.", {"use": {"hunger": 24, "thirst": -6}, "action": "use_eat", "time": 2.5, "value": 5, "empty": "lata_vazia"})
	_i("lata_milho", "Milho em conserva", "comida", 0.35, 6, "Doce e salgado ao mesmo tempo.", {"use": {"hunger": 20, "thirst": 4}, "action": "use_eat", "time": 2.5, "value": 4, "empty": "lata_vazia"})
	_i("arroz", "Pacote de arroz", "comida", 1.0, 4, "Precisa ser cozido (fogueira ou fogão).", {"use": {"hunger": 8, "sickness": {"food_poisoning": 0.2}}, "action": "use_eat", "time": 2.0, "value": 5, "cook": "arroz_cozido"})
	_i("arroz_cozido", "Arroz cozido", "comida", 0.6, 3, "Quente e reconfortante.", {"use": {"hunger": 45, "stamina_regen": 0.1}, "action": "use_eat", "time": 3.0, "value": 7, "spoils": 2.0})
	_i("macarrao", "Macarrão instantâneo", "comida", 0.1, 10, "Melhor cozido, mas dá para mastigar cru.", {"use": {"hunger": 14, "thirst": -8}, "action": "use_eat", "time": 2.0, "value": 3, "cook": "macarrao_cozido"})
	_i("macarrao_cozido", "Macarrão cozido", "comida", 0.35, 3, "Caldo quente.", {"use": {"hunger": 30, "thirst": 6, "warmth": 8}, "action": "use_eat", "time": 3.0, "value": 5, "spoils": 1.0})
	_i("biscoito", "Pacote de biscoito", "comida", 0.2, 8, "Cream cracker. Seco, mas dura para sempre.", {"use": {"hunger": 14, "thirst": -5}, "action": "use_eat", "time": 1.5, "value": 3})
	_i("barra_cereal", "Barra de cereal", "comida", 0.05, 12, "Energia rápida.", {"use": {"hunger": 10, "stamina": 20}, "action": "use_eat", "time": 1.0, "value": 3})
	_i("chocolate", "Barra de chocolate", "comida", 0.1, 10, "Um luxo do mundo antigo.", {"use": {"hunger": 12, "energy": 6, "morale": 5}, "action": "use_eat", "time": 1.2, "value": 6})
	_i("fruta", "Fruta", "comida", 0.2, 8, "Laranja do pomar. Estraga rápido.", {"use": {"hunger": 10, "thirst": 10}, "action": "use_eat", "time": 1.5, "value": 3, "spoils": 4.0})
	_i("pao_velho", "Pão velho", "comida", 0.25, 6, "Duro como pedra. Pode ter mofo.", {"use": {"hunger": 16, "sickness": {"food_poisoning": 0.15}}, "action": "use_eat", "time": 2.0, "value": 1})
	_i("mel", "Pote de mel", "comida", 0.5, 4, "Não estraga. Também é antisséptico natural.", {"use": {"hunger": 18, "energy": 5}, "action": "use_eat", "time": 2.0, "value": 7})
	_i("racao_militar", "Ração militar", "comida", 0.6, 4, "Refeição completa autoaquecível.", {"use": {"hunger": 60, "thirst": 5, "warmth": 10}, "action": "use_eat", "time": 4.0, "value": 14})
	_i("carne_crua", "Carne crua", "comida", 0.5, 4, "Cozinhe antes de comer.", {"use": {"hunger": 15, "sickness": {"food_poisoning": 0.55}}, "action": "use_eat", "time": 3.0, "value": 3, "spoils": 1.5, "cook": "carne_assada"})
	_i("carne_assada", "Carne assada", "comida", 0.4, 4, "Cheiro de churrasco de domingo.", {"use": {"hunger": 50, "health": 4}, "action": "use_eat", "time": 3.5, "value": 9, "spoils": 3.0})
	_i("peixe_cru", "Peixe cru", "comida", 0.4, 4, "Do Rio Aurora. Melhor assar.", {"use": {"hunger": 12, "sickness": {"food_poisoning": 0.45}}, "action": "use_eat", "time": 3.0, "value": 3, "spoils": 1.0, "cook": "peixe_assado"})
	_i("peixe_assado", "Peixe assado", "comida", 0.3, 4, "Simples e bom.", {"use": {"hunger": 38, "health": 3}, "action": "use_eat", "time": 3.0, "value": 7, "spoils": 2.0})
	_i("sopa_caseira", "Sopa caseira", "comida", 0.8, 2, "Legumes, ervas e água fervida. Esquenta a alma.", {"use": {"hunger": 45, "thirst": 25, "warmth": 20, "health": 6}, "action": "use_drink", "time": 4.0, "value": 12, "spoils": 1.0})
	# --- Bebida ----------------------------------------------------------------------
	_i("agua_garrafa", "Garrafa de água", "bebida", 0.55, 4, "Água mineral lacrada.", {"use": {"thirst": 40}, "action": "use_drink", "time": 2.0, "value": 8, "empty": "garrafa_vazia"})
	_i("agua_suja", "Água suja", "bebida", 0.55, 4, "Do rio ou da chuva. Ferva ou purifique.", {"use": {"thirst": 30, "sickness": {"food_poisoning": 0.45}}, "action": "use_drink", "time": 2.0, "value": 1, "empty": "garrafa_vazia", "cook": "agua_fervida"})
	_i("agua_fervida", "Água fervida", "bebida", 0.55, 4, "Segura para beber.", {"use": {"thirst": 38}, "action": "use_drink", "time": 2.0, "value": 5, "empty": "garrafa_vazia"})
	_i("refrigerante", "Lata de refrigerante", "bebida", 0.35, 6, "Quente e sem gás. Ainda assim, açúcar.", {"use": {"thirst": 22, "energy": 6, "hunger": 4}, "action": "use_drink", "time": 1.5, "value": 5, "empty": "lata_vazia"})
	_i("suco_caixa", "Suco de caixinha", "bebida", 0.25, 8, "Sabor uva.", {"use": {"thirst": 20, "hunger": 5}, "action": "use_drink", "time": 1.2, "value": 4})
	_i("energetico", "Energético", "bebida", 0.3, 6, "Tira o sono. Cobra depois.", {"use": {"thirst": 15, "energy": 25, "stamina": 40}, "action": "use_drink", "time": 1.5, "value": 7, "empty": "lata_vazia"})
	_i("cafe_pronto", "Café coado", "bebida", 0.3, 3, "Preto e forte.", {"use": {"thirst": 12, "energy": 18, "warmth": 8}, "action": "use_drink", "time": 2.0, "value": 6})
	_i("cha_ervas", "Chá de ervas", "bebida", 0.3, 3, "Erva-cidreira e boldo. Acalma o estômago.", {"use": {"thirst": 20, "cure": ["food_poisoning"], "warmth": 10}, "action": "use_drink", "time": 2.5, "value": 8})
	# --- Medicamentos ---------------------------------------------------------------
	_i("bandagem", "Bandagem", "medicamento", 0.05, 10, "Estanca sangramentos.", {"use": {"stop_bleed": true, "health": 8}, "action": "use_bandage", "time": 3.5, "value": 8})
	_i("pano_limpo", "Tira de pano limpo", "medicamento", 0.05, 10, "Bandagem improvisada. Pode infeccionar.", {"use": {"stop_bleed": true, "health": 3, "sickness": {"wound_infection": 0.15}}, "action": "use_bandage", "time": 4.0, "value": 3})
	_i("antisseptico", "Antisséptico", "medicamento", 0.15, 5, "Limpa ferimentos. Evita infecção bacteriana.", {"use": {"cure": ["wound_infection"], "health": 4}, "action": "use_bandage", "time": 2.5, "value": 10})
	_i("analgesico", "Analgésico", "medicamento", 0.02, 20, "Dipirona. Alivia dor e febre leve.", {"use": {"pain": -40, "fever": -15}, "action": "use_eat", "time": 1.0, "value": 6})
	_i("antibiotico", "Antibiótico", "medicamento", 0.03, 12, "Amoxicilina. Trata infecções bacterianas.", {"use": {"cure": ["wound_infection", "cold"]}, "action": "use_eat", "time": 1.0, "value": 20})
	_i("antitermico", "Antitérmico", "medicamento", 0.02, 20, "Paracetamol.", {"use": {"fever": -40}, "action": "use_eat", "time": 1.0, "value": 6})
	_i("vitaminas", "Vitaminas", "medicamento", 0.05, 10, "Reforça a imunidade contra resfriados.", {"use": {"immunity": 0.25, "health": 2}, "action": "use_eat", "time": 1.0, "value": 5})
	_i("carvao_ativado", "Carvão ativado", "medicamento", 0.05, 10, "Para intoxicação alimentar.", {"use": {"cure": ["food_poisoning"]}, "action": "use_eat", "time": 1.0, "value": 9})
	_i("tala", "Tala", "medicamento", 0.3, 3, "Imobiliza fraturas.", {"use": {"fix_fracture": true}, "action": "use_bandage", "time": 6.0, "value": 12})
	_i("kit_sutura", "Kit de sutura", "medicamento", 0.1, 3, "Fecha cortes profundos.", {"use": {"stop_bleed": true, "health": 25, "fix_deep_wound": true}, "action": "use_bandage", "time": 7.0, "value": 22})
	_i("kit_primeiros_socorros", "Kit de primeiros socorros", "medicamento", 0.6, 2, "Completo. Trata quase tudo.", {"use": {"stop_bleed": true, "health": 45, "cure": ["wound_infection"], "fix_fracture": true}, "action": "use_bandage", "time": 8.0, "value": 40})
	_i("comprimido_purificador", "Comprimido purificador", "medicamento", 0.01, 20, "Transforma água suja em potável (use com água suja).", {"value": 6, "purifier": true})
	_i("inibidor_nx", "Inibidor NX-7", "medicamento", 0.05, 5, "Composto experimental da Dra. Helena. Retarda a progressão do NEXUS.", {"use": {"infection": -30, "fever": -20}, "action": "use_inject", "time": 2.0, "value": 80})
	# --- Ferramentas ---------------------------------------------------------------------
	_i("lanterna", "Lanterna", "ferramenta", 0.35, 1, "Ilumina, mas também chama atenção. Usa pilhas.", {"equip": "light", "dur": 100, "value": 18})
	_i("pilha", "Pilhas AA", "ferramenta", 0.05, 12, "Energia para lanterna e rádio.", {"value": 5, "battery": 35.0})
	_i("isqueiro", "Isqueiro", "ferramenta", 0.03, 1, "Acende fogueiras.", {"dur": 60, "value": 10, "fire": true})
	_i("fosforos", "Caixa de fósforos", "ferramenta", 0.02, 5, "Acende fogueiras (uso único por palito).", {"value": 3, "fire": true, "consumable_fire": true})
	_i("chave_fenda", "Chave de fenda", "ferramenta", 0.15, 1, "Desmonta coisas.", {"dur": 80, "value": 6, "tool": ["screw"], "weapon": {"dmg": 9, "speed": 1.35, "reach": 1.35, "stamina": 7, "kind": "sharp", "knock": 0.1, "wear": 0.02}})
	_i("chave_inglesa", "Chave inglesa", "ferramenta", 0.7, 1, "Essencial para consertos mecânicos.", {"dur": 150, "value": 10, "tool": ["wrench"], "weapon": {"dmg": 17, "speed": 1.05, "reach": 1.45, "stamina": 11, "kind": "blunt", "knock": 0.35, "wear": 0.01}})
	_i("alicate", "Alicate", "ferramenta", 0.3, 1, "Corta fios, dobra metal.", {"dur": 100, "value": 7, "tool": ["pliers"]})
	_i("serrote", "Serrote", "ferramenta", 0.5, 1, "Corta madeira para barricadas e estruturas.", {"dur": 90, "value": 9, "tool": ["saw"]})
	_i("kit_ferramentas", "Kit de ferramentas", "ferramenta", 3.0, 1, "Conserta motores e peças de veículos.", {"dur": 40, "value": 30, "tool": ["wrench", "screw", "pliers", "mechanic"]})
	_i("mangueira", "Mangueira", "ferramenta", 0.6, 1, "Para sifonar combustível de tanques.", {"value": 8, "tool": ["siphon"]})
	_i("galao_vazio", "Galão vazio (10 L)", "combustivel", 0.8, 1, "Encha em postos ou tanques de carros.", {"value": 6, "fuel_can": 10.0})
	_i("galao_gasolina", "Galão de gasolina", "combustivel", 8.0, 1, "Combustível para veículos e geradores.", {"value": 30, "fuel": 10.0, "empty": "galao_vazio"})
	_i("radio_portatil", "Rádio portátil", "ferramenta", 0.5, 1, "Capta transmissões dos sobreviventes.", {"value": 25, "dur": 100})
	_i("binoculo", "Binóculo", "ferramenta", 0.6, 1, "Observe de longe sem ser visto.", {"value": 15})
	# --- Armas brancas -----------------------------------------------------------------
	_i("faca_cozinha", "Faca de cozinha", "arma", 0.2, 1, "Rápida, curto alcance. Boa para ataques furtivos.", {"dur": 60, "value": 8, "tool": ["cut"], "weapon": {"dmg": 14, "speed": 1.45, "reach": 1.3, "stamina": 7, "kind": "sharp", "knock": 0.05, "wear": 0.02, "stealth_kill": true}})
	_i("faca_tatica", "Faca tática", "arma", 0.3, 1, "Aço de verdade.", {"dur": 150, "value": 20, "tool": ["cut"], "weapon": {"dmg": 19, "speed": 1.5, "reach": 1.35, "stamina": 7, "kind": "sharp", "knock": 0.08, "wear": 0.008, "stealth_kill": true}})
	_i("cano_ferro", "Cano de ferro", "arma", 1.4, 1, "Pesado e confiável.", {"dur": 200, "value": 6, "weapon": {"dmg": 21, "speed": 0.95, "reach": 1.75, "stamina": 13, "kind": "blunt", "knock": 0.45, "wear": 0.006}})
	_i("taco_beisebol", "Taco de beisebol", "arma", 1.0, 1, "Alcance e impacto.", {"dur": 110, "value": 10, "weapon": {"dmg": 22, "speed": 1.0, "reach": 1.8, "stamina": 12, "kind": "blunt", "knock": 0.5, "wear": 0.012}})
	_i("taco_pregos", "Taco com pregos", "arma", 1.2, 1, "Improvisado. Sangramento extra.", {"dur": 90, "value": 16, "weapon": {"dmg": 29, "speed": 0.98, "reach": 1.8, "stamina": 13, "kind": "blunt", "knock": 0.45, "wear": 0.014, "bleed": 0.4}})
	_i("facao", "Facão", "arma", 0.9, 1, "Abre mato e abre caminho.", {"dur": 130, "value": 18, "tool": ["cut"], "weapon": {"dmg": 30, "speed": 1.1, "reach": 1.65, "stamina": 12, "kind": "sharp", "knock": 0.2, "wear": 0.01, "bleed": 0.5}})
	_i("machado", "Machado", "arma", 2.2, 1, "Devastador, porém lento.", {"dur": 160, "value": 24, "tool": ["chop"], "weapon": {"dmg": 42, "speed": 0.75, "reach": 1.7, "stamina": 20, "kind": "heavy", "knock": 0.7, "wear": 0.008, "bleed": 0.4}})
	_i("marreta", "Marreta", "arma", 4.5, 1, "Derruba qualquer coisa. Inclusive você, de cansaço.", {"dur": 250, "value": 20, "tool": ["smash"], "weapon": {"dmg": 55, "speed": 0.6, "reach": 1.75, "stamina": 28, "kind": "heavy", "knock": 1.0, "wear": 0.004}})
	_i("pe_de_cabra", "Pé de cabra", "arma", 1.5, 1, "Abre portas trancadas e crânios.", {"dur": 220, "value": 18, "tool": ["pry"], "weapon": {"dmg": 24, "speed": 0.95, "reach": 1.6, "stamina": 13, "kind": "blunt", "knock": 0.5, "wear": 0.006}})
	_i("martelo", "Martelo", "arma", 0.6, 1, "Ferramenta de construção e arma de emergência.", {"dur": 140, "value": 9, "tool": ["hammer"], "weapon": {"dmg": 16, "speed": 1.2, "reach": 1.35, "stamina": 9, "kind": "blunt", "knock": 0.3, "wear": 0.01}})
	_i("pa", "Pá", "arma", 1.8, 1, "Cava, bate, bloqueia.", {"dur": 150, "value": 9, "tool": ["dig"], "weapon": {"dmg": 23, "speed": 0.85, "reach": 1.9, "stamina": 15, "kind": "blunt", "knock": 0.6, "wear": 0.008, "block_bonus": 0.2}})
	_i("cassetete", "Cassetete", "arma", 0.7, 1, "Da polícia. Ótimo para defesa.", {"dur": 200, "value": 12, "weapon": {"dmg": 17, "speed": 1.25, "reach": 1.55, "stamina": 9, "kind": "blunt", "knock": 0.35, "wear": 0.005, "block_bonus": 0.25}})
	_i("lanca", "Lança improvisada", "arma", 1.3, 1, "Mantém os infectados à distância.", {"dur": 70, "value": 10, "weapon": {"dmg": 24, "speed": 1.0, "reach": 2.4, "stamina": 12, "kind": "sharp", "knock": 0.25, "wear": 0.018}})
	# --- À distância / arremesso --------------------------------------------------
	_i("revolver", "Revólver .38", "arma", 0.9, 1, "Barulhento. Cada tiro atrai a cidade inteira.", {"dur": 300, "value": 60, "ranged": {"dmg": 55, "ammo": "municao_38", "noise": 95.0, "spread": 0.02, "rate": 0.55, "range": 60.0}})
	_i("municao_38", "Munição .38", "municao", 0.012, 36, "Rara. Valiosa.", {"value": 6})
	_i("arco", "Arco improvisado", "arma", 1.0, 1, "Silencioso. Flechas podem ser recuperadas.", {"dur": 80, "value": 22, "ranged": {"dmg": 38, "ammo": "flecha", "noise": 4.0, "spread": 0.03, "rate": 1.2, "range": 40.0, "recover": 0.6}})
	_i("flecha", "Flecha", "municao", 0.05, 20, "Haste de madeira com ponta de metal.", {"value": 3})
	_i("garrafa_vazia", "Garrafa vazia", "arremesso", 0.3, 5, "Arremesse para distrair (G). Pode encher com água.", {"value": 1, "throw": {"noise": 22.0, "dmg": 4, "break": true}})
	_i("lata_vazia", "Lata vazia", "arremesso", 0.05, 10, "Faz barulho ao cair. Material para armadilhas.", {"value": 0.5, "throw": {"noise": 16.0, "dmg": 1}})
	_i("pedra", "Pedra", "arremesso", 0.4, 6, "Distração clássica.", {"value": 0.2, "throw": {"noise": 14.0, "dmg": 6}})
	_i("rojao", "Rojão", "arremesso", 0.15, 6, "Barulho enorme: atrai hordas para longe de você.", {"value": 12, "throw": {"noise": 120.0, "dmg": 3, "delay": 2.5, "flash": true}})
	_i("coquetel", "Coquetel incendiário", "arremesso", 0.7, 3, "Fogo. Use com cuidado.", {"value": 18, "throw": {"noise": 40.0, "dmg": 45, "fire": true, "break": true}})
	# --- Materiais ------------------------------------------------------------------
	_i("pano", "Pano", "material", 0.1, 20, "Roupas velhas. Vira bandagem, pavio, filtro.", {"value": 1})
	_i("tabua", "Tábua", "material", 1.5, 8, "Barricadas e estruturas.", {"value": 2})
	_i("pregos", "Pregos", "material", 0.01, 60, "Um punhado.", {"value": 0.2})
	_i("sucata", "Sucata de metal", "material", 0.6, 15, "Reparos e armas.", {"value": 1.5})
	_i("fita_adesiva", "Fita adesiva", "material", 0.15, 5, "Conserta tudo. Quase tudo.", {"value": 5, "uses": 5})
	_i("corda", "Corda", "material", 0.4, 5, "Amarrar, escalar, prender.", {"value": 3})
	_i("cola", "Cola forte", "material", 0.1, 5, "Reparos finos.", {"value": 3})
	_i("fios", "Fios elétricos", "material", 0.1, 20, "Recuperados de aparelhos.", {"value": 1})
	_i("parafusos", "Parafusos", "material", 0.01, 60, "Porcas e parafusos variados.", {"value": 0.2})
	_i("pneu", "Pneu", "material", 9.0, 1, "Para veículos.", {"value": 12, "vehicle_part": "tire"})
	_i("pecas_motor", "Peças de motor", "material", 3.0, 3, "Velas, correias, filtros.", {"value": 15, "vehicle_part": "engine"})
	_i("bateria_carro", "Bateria automotiva", "material", 12.0, 1, "Pesada. Dá partida no motor.", {"value": 18, "vehicle_part": "battery"})
	_i("oleo_motor", "Óleo de motor", "material", 1.0, 3, "Mantém o motor vivo.", {"value": 6})
	_i("alcool", "Álcool 70%", "material", 0.5, 4, "Antisséptico, combustível, coquetel.", {"value": 5})
	_i("plastico", "Plástico", "material", 0.1, 20, "Garrafas, sacolas, lonas pequenas.", {"value": 0.5})
	_i("lona", "Lona", "material", 1.0, 3, "Coletores de chuva e abrigos.", {"value": 5})
	_i("lenha", "Lenha", "material", 1.2, 10, "Combustível para fogueira.", {"value": 1})
	_i("ervas", "Ervas medicinais", "material", 0.05, 20, "Encontradas em quintais e fazendas.", {"value": 2})
	_i("tecido_grosso", "Tecido grosso", "material", 0.4, 10, "Jeans, lona, couro. Para roupas e mochilas.", {"value": 2})
	_i("cigarros", "Maço de cigarros", "diversos", 0.03, 10, "Moeda de troca muito aceita.", {"value": 9})
	_i("cachaca", "Garrafa de cachaça", "diversos", 0.9, 3, "Troca, antisséptico ruim, coragem líquida.", {"value": 10, "use": {"thirst": -10, "morale": 10, "fever": -5}, "action": "use_drink", "time": 2.0})
	# --- Equipamentos -----------------------------------------------------------------
	_i("mochila_escolar", "Mochila escolar", "equipamento", 0.6, 1, "+10 kg / +8 espaços.", {"equip": "back", "capacity": 10.0, "slots": 8, "value": 10})
	_i("mochila_trilha", "Mochila de trilha", "equipamento", 1.2, 1, "+20 kg / +14 espaços.", {"equip": "back", "capacity": 20.0, "slots": 14, "value": 25})
	_i("mochila_militar", "Mochila militar", "equipamento", 1.8, 1, "+28 kg / +20 espaços.", {"equip": "back", "capacity": 28.0, "slots": 20, "value": 45})
	_i("jaqueta", "Jaqueta de lona", "equipamento", 1.1, 1, "Aquece e protege um pouco de arranhões.", {"equip": "torso", "warmth": 0.3, "armor": 0.1, "dur": 100, "value": 12})
	_i("capa_chuva", "Capa de chuva", "equipamento", 0.4, 1, "Mantém você seco.", {"equip": "torso", "warmth": 0.1, "rain": 0.8, "dur": 60, "value": 10})
	_i("casaco_inverno", "Casaco de inverno", "equipamento", 1.6, 1, "Para as madrugadas frias da serra.", {"equip": "torso", "warmth": 0.6, "armor": 0.12, "dur": 120, "value": 18})
	_i("colete", "Colete tático", "equipamento", 3.0, 1, "Reduz bastante o dano de mordidas e golpes.", {"equip": "torso", "warmth": 0.15, "armor": 0.35, "dur": 200, "value": 40})
	_i("luvas", "Luvas de couro", "equipamento", 0.2, 1, "Melhor pegada e proteção.", {"equip": "hands", "warmth": 0.1, "armor": 0.05, "grip": 0.1, "dur": 100, "value": 8})
	_i("mascara_filtro", "Máscara com filtro", "equipamento", 0.5, 1, "Protege contra os esporos dos Hospedeiros.", {"equip": "head", "spore_protect": 0.85, "dur": 100, "value": 30})
	_i("botas", "Botas de couro", "equipamento", 1.2, 1, "Passos mais silenciosos em terreno irregular.", {"equip": "feet", "noise": -0.15, "warmth": 0.05, "dur": 150, "value": 15})
	# --- Estruturas (itens colocáveis) ---------------------------------------------
	_i("kit_barricada", "Kit de barricada", "estrutura", 5.0, 3, "Use numa porta para barricá-la.", {"value": 8, "place": "barricade"})
	_i("kit_fogueira", "Fogueira montada", "estrutura", 3.0, 2, "Coloque no chão: cozinhar e aquecer.", {"value": 5, "place": "campfire"})
	_i("coletor_chuva", "Coletor de chuva", "estrutura", 4.0, 1, "Junta água suja quando chove.", {"value": 12, "place": "rain_collector"})
	_i("caixa_armazenamento", "Caixa de armazenamento", "estrutura", 6.0, 1, "Guarde itens no seu esconderijo.", {"value": 10, "place": "storage_box"})
	_i("esconderijo", "Esconderijo camuflado", "estrutura", 4.0, 1, "Armazenamento escondido: saqueadores não encontram.", {"value": 14, "place": "hidden_stash"})
	_i("cama_improvisada", "Cama improvisada", "estrutura", 5.0, 1, "Durma e salve o jogo.", {"value": 8, "place": "bedroll"})
	_i("bancada", "Bancada de trabalho", "estrutura", 12.0, 1, "Receitas avançadas.", {"value": 20, "place": "workbench"})
	_i("armadilha_latas", "Alarme de latas", "estrutura", 1.0, 3, "Faz barulho quando algo passa.", {"value": 4, "place": "can_alarm"})
	# --- História -------------------------------------------------------------------
	_i("bilhete_mae", "Bilhete da mãe", "historia", 0.01, 1, "\"Caio, fomos para o Hospital São Lucas. A Lia está com febre. Te amo. — Mãe\"", {"value": 0, "story": true})
	_i("foto_familia", "Foto da família", "historia", 0.01, 1, "Você, a Lia e a mãe no Lago Azul, dois verões atrás.", {"value": 0, "story": true})
	_i("cartao_corvalis", "Crachá Corvalis (nível 2)", "historia", 0.01, 1, "Abre portas administrativas do Complexo Corvalis.", {"value": 0, "story": true, "key": "corvalis_2"})
	_i("cartao_nivel4", "Cartão de acesso nível 4", "historia", 0.01, 1, "Da Dra. Helena Vasconcelos. Laboratório NEXUS.", {"value": 0, "story": true, "key": "corvalis_4"})
	_i("fragmento_1", "Fragmento de chave A", "historia", 0.05, 1, "Parte de um cartão criptográfico. Gravado: \"AURORA\".", {"value": 0, "story": true})
	_i("fragmento_2", "Fragmento de chave B", "historia", 0.05, 1, "Parte de um cartão criptográfico. Gravado: \"SETOR\".", {"value": 0, "story": true})
	_i("fragmento_3", "Fragmento de chave C", "historia", 0.05, 1, "Parte de um cartão criptográfico. Gravado: \"SETE\".", {"value": 0, "story": true})
	_i("chave_setor7", "Chave Aurora", "historia", 0.05, 1, "Os três fragmentos unidos. Abre o Setor 7.", {"value": 0, "story": true, "key": "setor7"})
	_i("dossie_nexus", "Dossiê NEXUS", "historia", 0.3, 1, "Relatórios internos da Corvalis sobre o NEXUS-2.", {"value": 0, "story": true})
	_i("prontuario_lia", "Prontuário de Lia", "historia", 0.02, 1, "Paciente 0417 — transferida ao Centro de Triagem Corvalis.", {"value": 0, "story": true})
	_i("chave_oficina", "Chave da oficina", "historia", 0.02, 1, "Chaveiro com etiqueta \"TONHO\".", {"value": 0, "story": true, "key": "oficina"})
	_i("remedios_remanescentes", "Caixa de remédios", "historia", 4.0, 1, "Antibióticos para os Remanescentes.", {"value": 60, "story": true})
