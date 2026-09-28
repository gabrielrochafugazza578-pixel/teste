class_name StoryDB
extends RefCounted
## Conteúdo narrativo: capítulos, gravações da Dra. Helena Vasconcelos,
## bilhetes/documentos e posicionamento no mundo (POI + marcador do interior).

const CHAPTERS := {
	1: {"title": "O RETORNO", "sub": "Caio volta a Santa Aurora procurando a família."},
	2: {"title": "SILÊNCIO", "sub": "O Hospital São Lucas guarda mais do que corpos."},
	3: {"title": "NEXUS", "sub": "O nome escondido atrás da Corvalis Biotecnologia."},
	4: {"title": "OS SOBREVIVENTES", "sub": "Ninguém atravessa o rio sozinho."},
	5: {"title": "A VERDADE", "sub": "O Centro de Triagem e o marcador Aurora."},
	6: {"title": "EVOLUÇÃO", "sub": "Os infectados estão mudando."},
	7: {"title": "O INÍCIO DO FIM", "sub": "O Setor 7."},
}

## Gravações: id -> {title, date, text (linhas de legenda), poi, marker}
const LOGS := {
	"helena_01": {"title": "Registro 01 — Ensaios clínicos", "date": "3 de março", "poi": "hospital", "marker": "desk",
		"lines": ["Registro um. Doutora Helena Vasconcelos, Corvalis Biotecnologia.",
			"Hoje iniciamos a fase clínica do Projeto NEXUS aqui no São Lucas.",
			"A proposta é simples de explicar e absurda de realizar: acelerar a regeneração celular.",
			"Queimaduras que fecham em dias. Medula que se reconstrói. Se funcionar, muda tudo."]},
	"helena_02": {"title": "Registro 02 — Células que não param", "date": "19 de março", "poi": "clinica", "marker": "desk",
		"lines": ["As culturas tratadas com o NEXUS-1 continuam se dividindo depois do limite de Hayflick.",
			"Elas não envelhecem como deveriam. Não morrem como deveriam.",
			"O conselho chama isso de sucesso. Eu chamo de sinal de alerta.",
			"Pedi a suspensão temporária dos ensaios. Pedi por escrito."]},
	"helena_03": {"title": "Registro 03 — A decisão", "date": "2 de abril", "poi": "apartamento_helena", "marker": "desk",
		"lines": ["O diretor Leme negou a suspensão. Pior: aprovou uma segunda formulação.",
			"NEXUS-2. Mais agressivo, com afinidade por tecido neural.",
			"Ele quer regenerar neurônios. Quer vender a cura do Alzheimer para o mundo inteiro.",
			"Guardei cópias do protocolo aqui em casa. Se alguém perguntar, eu nunca disse isso."]},
	"helena_04": {"title": "Registro 04 — Primatas", "date": "28 de abril", "poi": "corvalis_hq", "marker": "desk",
		"lines": ["Os três primatas do lote C apresentaram perda de memória recente e agitação noturna.",
			"Depois, algo pior. Eles pararam de reconhecer uns aos outros.",
			"O NEXUS-2 não repara o cérebro. Ele o reescreve.",
			"O relatório oficial diz 'reação adversa transitória'. Eu não assinei."]},
	"helena_05": {"title": "Registro 05 — Voluntário 01", "date": "14 de maio", "poi": "lab_nexus", "marker": "helena_office_desk",
		"lines": ["Rafael Duarte, trinta e quatro anos, voluntário. Assinou tudo sem ler direito.",
			"Primeiras vinte e quatro horas: febre de trinta e nove, desorientação leve.",
			"Quarenta e oito horas: não lembra o nome da filha. Chora quando percebe.",
			"Setenta e duas horas: ele parou de chorar. Parou de perceber."]},
	"helena_06": {"title": "Registro 06 — O incidente", "date": "17 de maio", "poi": "lab_nexus", "marker": "observer",
		"lines": ["Houve uma falha na contenção do laboratório principal. Um frasco. Um corte. Um segundo de descuido.",
			"Três técnicos expostos. Leme ordenou silêncio absoluto e liberou todos para casa.",
			"Ele disse que o NEXUS não é transmissível entre humanos.",
			"Eu vi o Rafael através do vidro hoje. Ele encostou a mão no vidro. E sorriu."]},
	"helena_07": {"title": "Registro 07 — Incubação", "date": "25 de maio", "poi": "terminal", "marker": "center",
		"lines": ["Estou no terminal. Ônibus saindo para todas as cidades da região.",
			"O NEXUS-2 tem incubação de até dez dias sem sintomas. Dez dias.",
			"Cada pessoa que tosse nessa fila pode ser o próximo Rafael.",
			"Liguei para a Vigilância Sanitária. Me colocaram em espera."]},
	"helena_08": {"title": "Registro 08 — Quarentena", "date": "2 de junho", "poi": "delegacia", "marker": "desk",
		"lines": ["A prefeitura decretou quarentena. Tarde demais.",
			"Entreguei ao delegado tudo o que eu sabia. Ele leu metade e pediu que eu não espalhasse pânico.",
			"Os hospitais estão lotados. O São Lucas fechou as portas ontem à noite.",
			"Eu ouço sirenes o tempo todo. Às vezes acho que ouço mesmo quando param."]},
	"helena_09": {"title": "Registro 09 — Marcador Aurora", "date": "20 de junho", "poi": "fazenda_santa_clara", "marker": "center",
		"lines": ["Descobri por que algumas pessoas não adoecem. Uma variante genética rara. Chamei de marcador Aurora.",
			"Algo em torno de três por cento da população. Eles carregam o vírus, mas o corpo o contém.",
			"O sangue deles é a chave para uma cura.",
			"E o Leme sabe disso. Este 'Centro de Triagem' não está salvando ninguém. Está colecionando imunes."]},
	"helena_10": {"title": "Registro 10 — A chave", "date": "29 de junho", "poi": "bunker", "marker": "center",
		"lines": ["Levei os dados da pesquisa do marcador para o Setor 7 e tranquei tudo com uma chave criptográfica.",
			"Dividi a chave em três fragmentos: AURORA, SETOR, SETE.",
			"Um na torre de rádio da serra, um no túnel, um aqui neste bunker.",
			"Se eu não voltar, quem juntar as três partes decide o que fazer com isso."]},
	"helena_11": {"title": "Registro 11 — Transmissão", "date": "3 de julho", "poi": "torre_radio", "marker": "desk",
		"lines": ["Tentei transmitir tudo pela torre. O transmissor queimou no segundo minuto.",
			"Alguém lá fora ouviu? Tem alguém lá fora?",
			"Estou deixando o primeiro fragmento aqui. AURORA.",
			"A cidade está quieta demais. Os infectados andam em grupos agora. Como se aprendessem."]},
	"helena_12": {"title": "Registro 12 — O túnel", "date": "8 de julho", "poi": "tunel_manutencao", "marker": "center",
		"lines": ["Consegui sair da cidade pelo túnel da serra. Voltei na mesma noite.",
			"Não posso ir embora enquanto os dados estiverem nas mãos erradas.",
			"Segundo fragmento: SETOR. Deixei nesta sala de manutenção.",
			"Se você está ouvindo isto, você também voltou. Por quê?"]},
	"helena_13": {"title": "Registro 13 — Os Despertos", "date": "15 de julho", "poi": "igreja_despertos", "marker": "center",
		"lines": ["O Tadeu trabalhava comigo. Técnico de laboratório. Um dos três expostos no incidente.",
			"Ele não adoeceu. Ele é imune e acha que foi escolhido.",
			"Agora prega que o NEXUS é o Despertar. Que os Hospedeiros são anjos.",
			"Ele me ofereceu abrigo em troca dos meus dados. Recusei."]},
	"helena_14": {"title": "Registro 14 — NEXUS-3", "date": "22 de julho", "poi": "setor7", "marker": "entrance",
		"lines": ["O Leme nunca quis a cura. Quer uma versão controlável.",
			"NEXUS-3: soldados que não sentem dor, que não esquecem ordens, que não param.",
			"Os imunes da Triagem são a matéria-prima. Cada um deles.",
			"Uma garota chegou ontem. Dezesseis anos. Perguntou pelo irmão. Disse que ele ia voltar."]},
	"helena_15": {"title": "Registro 15 — Inibidor", "date": "30 de julho", "poi": "setor7", "marker": "lab",
		"lines": ["Fui exposta. Apliquei o inibidor NX-7 em mim. Compra semanas, não meses.",
			"A menina se chama Lia. Ela tem o marcador Aurora mais forte que eu já vi.",
			"Escondi a Lia no isolamento do Setor 7, longe dos homens do Leme.",
			"Caio. Se esse é o seu nome. Ela fala de você o tempo todo."]},
	"helena_16": {"title": "Registro 16 — O início do fim", "date": "sem data", "poi": "setor7", "marker": "core",
		"lines": ["Este é o último registro.",
			"A cura é possível. O sangue da Lia e os meus dados, juntos, podem salvar quem restou.",
			"Mas nas mãos erradas, os mesmos dados criam o NEXUS-3.",
			"O fim do mundo que conhecíamos já aconteceu. O que vem depois ainda não foi decidido."]},
}

const NOTES := {
	"bilhete_mae": {"title": "Bilhete da mãe", "poi": "casa_familia", "marker": "center", "item": "bilhete_mae",
		"text": "Caio,\n\nSe você voltar e ler isto: fomos para o Hospital São Lucas. A Lia está com febre desde terça e os postos fecharam.\nDizem que lá tem médicos do governo.\nLeve a chave reserva do vaso. Tranque a casa.\n\nTe amo, filho. Volta pra gente.\n— Mãe"},
	"prontuario_lia": {"title": "Prontuário — Paciente 0417", "poi": "hospital", "marker": "center", "item": "prontuario_lia",
		"text": "PACIENTE: Lia M. Andrade, 16 anos.\nTRIAGEM: febre 38,2 °C, sem desorientação. Teste NX: POSITIVO, carga viral contida.\nOBSERVAÇÃO: marcador A detectado.\nCONDUTA: transferência imediata ao Centro de Triagem Corvalis (Fazenda Santa Clara). Acompanhante: Célia Andrade (mãe).\nAutorização: Dir. A. Leme."},
	"aviso_guarda": {"title": "Aviso da Guarda Aurora", "poi": "centro", "marker": "",
		"text": "ATENÇÃO CIDADÃO\n\nToque de recolher das 18h às 6h.\nQualquer pessoa com febre deve se apresentar à Delegacia Central.\nSaqueadores serão tratados como inimigos.\n\n— Cmdte. R. Tavares"},
	"memo_corvalis": {"title": "Memorando interno Corvalis", "poi": "corvalis_hq", "marker": "desk",
		"text": "CONFIDENCIAL — DIRETORIA\n\nAssunto: incidente de 17/05, laboratório P&D.\nNenhuma comunicação externa sem aprovação do Dir. Leme.\nFuncionários expostos: liberação sem registro.\nO termo 'NEXUS' não deve constar em prontuários públicos.\nEquipe de segurança: prioridade total ao Setor 7."},
	"diario_morador": {"title": "Diário de um morador", "poi": "casa_familia", "marker": "", "neighbor": true,
		"text": "Dia 9. A vizinha do 110 não reconhece mais o próprio marido. Ele a trancou no quarto e fica sentado na porta.\nDia 12. Ouvi os dois gritando. Depois, só um.\nDia 13. Estamos indo para o estádio. Dizem que lá tem gente organizada."},
	"desenho_crianca": {"title": "Desenho infantil", "poi": "escola", "marker": "center",
		"text": "Um desenho de giz de cera: uma casa, um sol, e pessoas cinzentas com os braços esticados.\nNo canto, escrito com letra torta: \"a professora falou pra gente não abrir a porta\"."},
	"bilhete_tonho": {"title": "Bilhete na oficina", "poi": "oficina", "marker": "center",
		"text": "TÔ NO SÓTÃO. Não abre a porta de baixo que tem dois deles no pátio.\nSe for gente boa, bate três vezes.\n— Tonho"},
	"cartaz_despertos": {"title": "Panfleto dos Despertos", "poi": "igreja_despertos", "marker": "",
		"text": "O FIM É SÓ O COMEÇO.\nO NEXUS não é doença. É a porta.\nOs que dormem, esquecem. Os que despertam, lembram de tudo.\nVenha à Capela São Judas. Traga os seus."},
	"relatorio_triagem": {"title": "Relatório do Centro de Triagem", "poi": "fazenda_santa_clara", "marker": "",
		"text": "Internos com marcador A: 23.\nTransferidos ao Setor 7 esta semana: 4 (incluindo 0417 — prioridade máxima).\nPerdas: 2.\nFamiliares acompanhantes: manter sedados. Não liberar."},
}

## Itens-chave colocados no mundo (fragmentos da chave etc.)
const KEY_ITEMS := {
	"frag_1": {"poi": "torre_radio", "marker": "desk", "item": "fragmento_1", "chapter": 6},
	"frag_2": {"poi": "tunel_manutencao", "marker": "", "item": "fragmento_2", "chapter": 6},
	"frag_3": {"poi": "bunker", "marker": "center", "item": "fragmento_3", "chapter": 6},
	"cartao_helena": {"poi": "apartamento_helena", "marker": "center", "item": "cartao_corvalis", "chapter": 3},
	"cartao_n4": {"poi": "lab_nexus", "marker": "helena_desk", "item": "cartao_nivel4", "chapter": 3},
	"dossie": {"poi": "corvalis_hq", "marker": "center", "item": "dossie_nexus", "chapter": 3},
	"chave_oficina": {"poi": "oficina", "marker": "center", "item": "chave_oficina", "chapter": 4},
	"foto": {"poi": "casa_familia", "marker": "", "item": "foto_familia", "chapter": 1},
	"remedios": {"poi": "clinica", "marker": "center", "item": "remedios_remanescentes", "chapter": 2},
}


static func log_def(id: String) -> Dictionary:
	return LOGS.get(id, {})


static func note_def(id: String) -> Dictionary:
	return NOTES.get(id, {})


## Objetos de história que pertencem a um POI (para spawn quando o local carrega).
static func objects_for_poi(poi: String) -> Array:
	var out: Array = []
	for id in LOGS.keys():
		var d: Dictionary = LOGS[id]
		if d["poi"] == poi:
			out.append({"id": id, "kind": "audio", "marker": d.get("marker", ""), "item": ""})
	for id in NOTES.keys():
		var d: Dictionary = NOTES[id]
		if d["poi"] == poi and d.get("marker", "") != "" and not d.get("neighbor", false):
			out.append({"id": id, "kind": "note", "marker": d["marker"], "item": d.get("item", "")})
	for id in KEY_ITEMS.keys():
		var d: Dictionary = KEY_ITEMS[id]
		if d["poi"] == poi:
			out.append({"id": id, "kind": "item", "marker": d.get("marker", ""), "item": d["item"], "chapter": d.get("chapter", 1)})
	return out
