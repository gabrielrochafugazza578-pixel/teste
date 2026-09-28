class_name CraftingDB
extends RefCounted
## Receitas de fabricação, culinária, reparo e melhorias.
## station: "" (qualquer lugar), "workbench" (bancada), "fire" (fogueira/fogão)
## tools: marcadores de ferramenta exigidos (não consumidas, sofrem desgaste)

const CATEGORIES := ["Sobrevivência", "Medicamentos", "Culinária", "Armas", "Ferramentas", "Estruturas", "Reparos", "Melhorias", "História"]

const RECIPES := {
	# --- Sobrevivência ---------------------------------------------------------
	"r_pano_limpo": {"name": "Tiras de pano limpo", "cat": "Sobrevivência", "result": ["pano_limpo", 2], "in": [["pano", 2], ["alcool", 1]], "time": 3.0},
	"r_kit_fogueira": {"name": "Fogueira", "cat": "Sobrevivência", "result": ["kit_fogueira", 1], "in": [["lenha", 3], ["pedra", 2]], "time": 4.0},
	"r_lenha": {"name": "Lenha (tábuas)", "cat": "Sobrevivência", "result": ["lenha", 2], "in": [["tabua", 1]], "tools": ["saw"], "time": 3.0},
	"r_capa": {"name": "Capa de chuva improvisada", "cat": "Sobrevivência", "result": ["capa_chuva", 1], "in": [["lona", 1], ["fita_adesiva", 1]], "time": 5.0},
	"r_mascara": {"name": "Máscara com filtro", "cat": "Sobrevivência", "result": ["mascara_filtro", 1], "in": [["pano", 2], ["carvao_ativado", 1], ["plastico", 1], ["fita_adesiva", 1]], "time": 6.0},
	"r_purificar": {"name": "Filtrar água (carvão)", "cat": "Sobrevivência", "result": ["agua_fervida", 1], "in": [["agua_suja", 1], ["carvao_ativado", 1], ["pano", 1]], "time": 4.0},
	# --- Medicamentos ------------------------------------------------------------
	"r_bandagem": {"name": "Bandagem", "cat": "Medicamentos", "result": ["bandagem", 2], "in": [["pano_limpo", 2], ["fita_adesiva", 1]], "time": 3.0},
	"r_antisseptico": {"name": "Antisséptico caseiro", "cat": "Medicamentos", "result": ["antisseptico", 1], "in": [["alcool", 1], ["mel", 1]], "time": 3.0},
	"r_tala": {"name": "Tala", "cat": "Medicamentos", "result": ["tala", 1], "in": [["tabua", 1], ["pano", 2], ["fita_adesiva", 1]], "time": 5.0},
	"r_kit_ps": {"name": "Kit de primeiros socorros", "cat": "Medicamentos", "result": ["kit_primeiros_socorros", 1], "in": [["bandagem", 2], ["antisseptico", 1], ["analgesico", 2], ["tala", 1]], "station": "workbench", "time": 8.0},
	"r_cha": {"name": "Chá de ervas", "cat": "Medicamentos", "result": ["cha_ervas", 1], "in": [["ervas", 3], ["agua_fervida", 1]], "station": "fire", "time": 5.0},
	# --- Culinária -----------------------------------------------------------------
	"r_ferver": {"name": "Ferver água", "cat": "Culinária", "result": ["agua_fervida", 1], "in": [["agua_suja", 1]], "station": "fire", "time": 4.0},
	"r_carne": {"name": "Assar carne", "cat": "Culinária", "result": ["carne_assada", 1], "in": [["carne_crua", 1]], "station": "fire", "time": 6.0},
	"r_peixe": {"name": "Assar peixe", "cat": "Culinária", "result": ["peixe_assado", 1], "in": [["peixe_cru", 1]], "station": "fire", "time": 5.0},
	"r_arroz": {"name": "Cozinhar arroz", "cat": "Culinária", "result": ["arroz_cozido", 2], "in": [["arroz", 1], ["agua_fervida", 1]], "station": "fire", "time": 7.0},
	"r_macarrao": {"name": "Cozinhar macarrão", "cat": "Culinária", "result": ["macarrao_cozido", 1], "in": [["macarrao", 1], ["agua_fervida", 1]], "station": "fire", "time": 4.0},
	"r_sopa": {"name": "Sopa caseira", "cat": "Culinária", "result": ["sopa_caseira", 2], "in": [["agua_fervida", 2], ["ervas", 2], ["lata_milho", 1]], "station": "fire", "time": 9.0},
	# --- Armas ---------------------------------------------------------------------
	"r_taco_pregos": {"name": "Taco com pregos", "cat": "Armas", "result": ["taco_pregos", 1], "in": [["taco_beisebol", 1], ["pregos", 12]], "tools": ["hammer"], "time": 7.0},
	"r_lanca": {"name": "Lança improvisada", "cat": "Armas", "result": ["lanca", 1], "in": [["tabua", 1], ["faca_cozinha", 1], ["fita_adesiva", 1]], "time": 6.0},
	"r_arco": {"name": "Arco improvisado", "cat": "Armas", "result": ["arco", 1], "in": [["tabua", 2], ["corda", 1]], "tools": ["cut"], "station": "workbench", "time": 12.0},
	"r_flechas": {"name": "Flechas (4)", "cat": "Armas", "result": ["flecha", 4], "in": [["tabua", 1], ["pregos", 4], ["pano", 1]], "tools": ["cut"], "time": 6.0},
	"r_coquetel": {"name": "Coquetel incendiário", "cat": "Armas", "result": ["coquetel", 1], "in": [["garrafa_vazia", 1], ["alcool", 1], ["pano", 1]], "time": 4.0},
	"r_cano": {"name": "Cano de ferro (sucata)", "cat": "Armas", "result": ["cano_ferro", 1], "in": [["sucata", 3], ["fita_adesiva", 1]], "station": "workbench", "time": 8.0},
	# --- Ferramentas -------------------------------------------------------------------
	"r_martelo": {"name": "Martelo improvisado", "cat": "Ferramentas", "result": ["martelo", 1], "in": [["pedra", 1], ["tabua", 1], ["corda", 1]], "time": 6.0},
	"r_faca": {"name": "Faca improvisada", "cat": "Ferramentas", "result": ["faca_cozinha", 1], "in": [["sucata", 1], ["pano", 1], ["fita_adesiva", 1]], "station": "workbench", "time": 6.0},
	"r_mangueira": {"name": "Sifão (mangueira)", "cat": "Ferramentas", "result": ["mangueira", 1], "in": [["plastico", 4], ["fita_adesiva", 1]], "time": 5.0},
	# --- Estruturas --------------------------------------------------------------------
	"r_barricada": {"name": "Kit de barricada", "cat": "Estruturas", "result": ["kit_barricada", 1], "in": [["tabua", 3], ["pregos", 12]], "tools": ["hammer"], "time": 6.0},
	"r_coletor": {"name": "Coletor de chuva", "cat": "Estruturas", "result": ["coletor_chuva", 1], "in": [["lona", 1], ["tabua", 2], ["corda", 1]], "time": 8.0},
	"r_caixa": {"name": "Caixa de armazenamento", "cat": "Estruturas", "result": ["caixa_armazenamento", 1], "in": [["tabua", 4], ["pregos", 10]], "tools": ["hammer"], "station": "workbench", "time": 10.0},
	"r_esconderijo": {"name": "Esconderijo camuflado", "cat": "Estruturas", "result": ["esconderijo", 1], "in": [["tabua", 3], ["lona", 1], ["corda", 2]], "tools": ["hammer"], "time": 10.0},
	"r_cama": {"name": "Cama improvisada", "cat": "Estruturas", "result": ["cama_improvisada", 1], "in": [["pano", 4], ["tecido_grosso", 2]], "time": 7.0},
	"r_bancada": {"name": "Bancada de trabalho", "cat": "Estruturas", "result": ["bancada", 1], "in": [["tabua", 6], ["pregos", 20], ["sucata", 2]], "tools": ["hammer", "saw"], "time": 14.0},
	"r_alarme": {"name": "Alarme de latas", "cat": "Estruturas", "result": ["armadilha_latas", 1], "in": [["lata_vazia", 4], ["corda", 1]], "time": 4.0},
	# --- Reparos ---------------------------------------------------------------------
	"r_rep_arma_metal": {"name": "Reparar arma (metal)", "cat": "Reparos", "repair": "weapon", "amount": 0.45, "in": [["sucata", 1], ["fita_adesiva", 1]], "time": 5.0},
	"r_rep_arma_madeira": {"name": "Reparar arma (madeira)", "cat": "Reparos", "repair": "weapon", "amount": 0.35, "in": [["tabua", 1], ["cola", 1]], "time": 5.0},
	"r_rep_roupa": {"name": "Remendar roupa", "cat": "Reparos", "repair": "torso", "amount": 0.5, "in": [["pano", 2], ["tecido_grosso", 1]], "time": 5.0},
	"r_rep_ferramenta": {"name": "Reparar ferramenta", "cat": "Reparos", "repair": "tool", "amount": 0.4, "in": [["fita_adesiva", 1], ["parafusos", 4]], "time": 5.0},
	# --- Melhorias ---------------------------------------------------------------------
	"r_mochila": {"name": "Mochila de trilha (melhoria)", "cat": "Melhorias", "result": ["mochila_trilha", 1], "in": [["mochila_escolar", 1], ["tecido_grosso", 3], ["corda", 1]], "tools": ["cut"], "station": "workbench", "time": 12.0},
	"r_casaco": {"name": "Casaco reforçado", "cat": "Melhorias", "result": ["casaco_inverno", 1], "in": [["jaqueta", 1], ["tecido_grosso", 2], ["pano", 2]], "tools": ["cut"], "time": 10.0},
	"r_colete": {"name": "Colete de sucata", "cat": "Melhorias", "result": ["colete", 1], "in": [["jaqueta", 1], ["sucata", 6], ["fita_adesiva", 2]], "station": "workbench", "time": 14.0},
	# --- História ----------------------------------------------------------------------
	"r_chave_aurora": {"name": "Chave Aurora (unir fragmentos)", "cat": "História", "result": ["chave_setor7", 1], "in": [["fragmento_1", 1], ["fragmento_2", 1], ["fragmento_3", 1]], "station": "workbench", "time": 6.0, "hidden": true},
}


static func get_recipe(id: String) -> Dictionary:
	return RECIPES.get(id, {})
