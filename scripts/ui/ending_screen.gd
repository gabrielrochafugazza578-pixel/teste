class_name EndingScreen
extends Control
## Epílogo conforme a decisão final + decisões anteriores, depois créditos.

var ending: String = "transmitir"

const TEXTS := {
	"transmitir": ["A TRANSMISSÃO",
		"Às 4h12 da manhã, a Torre de Rádio da Serra voltou a funcionar pela última vez.\n\nDurante onze minutos, a voz da Dra. Helena Vasconcelos e os dados do marcador Aurora atravessaram o céu de Santa Aurora.\n\nTrês semanas depois, um helicóptero sem insígnia pousou no estádio. Depois, outro. Depois, dezenas.\n\nO mundo soube. O nome de Augusto Leme virou sinônimo de crime.\nE a cura, pela primeira vez, deixou de ser um segredo."],
	"remanescentes": ["O LABORATÓRIO NO ESTÁDIO",
		"Nas arquibancadas do Estádio Municipal, entre varais e hortas, nasceu o laboratório mais improvável do mundo.\n\nHelena, Otávio e Marta trabalharam por meses com o sangue de Lia e os dados do Setor 7.\n\nA primeira dose foi aplicada numa manhã de chuva, num menino de sete anos. Ele acordou chamando pela mãe.\n\nSanta Aurora não voltou a ser o que era. Mas voltou a ser de alguém."],
	"destruir": ["O SILÊNCIO",
		"Os servidores do Setor 7 queimaram por dois dias.\n\nNão haveria NEXUS-3. Não haveria soldados que não sentem dor. Também não haveria cura rápida.\n\nHelena passou o resto do tempo que o inibidor lhe deu ensinando tudo o que sabia a quem quisesse ouvir.\n\nCaio e Lia voltaram para a Rua das Acácias. Plantaram no quintal, onde antes havia uma árvore.\n\nO fim do mundo já tinha acontecido. O que veio depois, eles decidiram juntos."],
}


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var bg := ColorRect.new()
	bg.color = Color(0, 0, 0, 0)
	UIKit.full_rect(bg)
	add_child(bg)
	var tw := create_tween()
	tw.tween_property(bg, "color:a", 1.0, 3.0)
	var d: Array = TEXTS.get(ending, TEXTS["transmitir"])
	var v := UIKit.vbox(18)
	v.custom_minimum_size = Vector2(900, 0)
	v.modulate.a = 0.0
	v.add_child(UIKit.label(str(d[0]), 40, UITheme.ACCENT, HORIZONTAL_ALIGNMENT_CENTER))
	var body := UIKit.label(str(d[1]) + _extras(), 19, UITheme.TEXT, HORIZONTAL_ALIGNMENT_CENTER)
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.custom_minimum_size = Vector2(900, 0)
	v.add_child(body)
	var b := UIKit.button("Continuar", _credits, 240)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	v.add_child(b)
	add_child(UIKit.center(v))
	tw.tween_property(v, "modulate:a", 1.0, 2.0)
	tw.tween_callback(func() -> void: b.grab_focus())
	AudioManager.music.play_cue("mus_opening_calm", 0.8)


func _extras() -> String:
	var t := "\n\n"
	match GameState.decision("destino_celia"):
		"estadio": t += "Célia deu aulas no estádio até os últimos dias de sua vida.\n"
		"guarda": t += "Célia viveu protegida na delegacia, costurando uniformes para a Guarda.\n"
		"tonho": t += "Célia e Tonho abriram uma pequena oficina-escola na Vila Operária.\n"
	if GameState.has_flag("sofia_safe"):
		t += "Sofia cresceu entre as crianças do estádio e aprendeu todos os nós de corda.\n"
	if GameState.has_flag("otavio_free"):
		t += "O Dr. Otávio nunca mais pisou numa capela.\n"
	match GameState.decision("travessia"):
		"corvos": t += "Os Corvos do Rio cobraram cada favor, até o último.\n"
		"guarda": t += "A Guarda Aurora lembrou de Caio como alguém que ajudou quando ninguém ajudava.\n"
	return t


func _credits() -> void:
	var c := CreditsScreen.new()
	add_child(c)
	c.closed.connect(func() -> void:
		get_tree().paused = false
		GameState.in_game = false
		AudioManager.stop_all_loops()
		get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn"))
