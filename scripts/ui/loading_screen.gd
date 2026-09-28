class_name LoadingScreen
extends Control
## Tela de carregamento com barra de progresso, etapa atual e dicas de
## sobrevivência. Usada no boot e na entrada do jogo.

const TIPS := [
	"Infectados enxergam pior no escuro, mas escutam melhor. Ande agachado.",
	"Correr faz barulho. Barulho atrai. Atrair é morrer.",
	"Água da chuva e do rio precisa ser fervida ou purificada.",
	"Roupa molhada no frio leva à hipotermia. Procure abrigo e fogo.",
	"Bandagens param o sangramento. Antisséptico evita infecção no ferimento.",
	"Armas se desgastam. Repare-as numa bancada antes que quebrem.",
	"Os Colossos não recuam com empurrões. Desvie da investida e ataque pelas costas.",
	"Os Hospedeiros soltam esporos. Uma máscara com filtro salva a sua vida.",
	"Arremesse garrafas para distrair infectados e passar despercebido.",
	"Cada facção lembra do que você fez. Para o bem e para o mal.",
	"Carros abandonados podem ter gasolina no tanque. Leve mangueira e galão.",
	"Barricar portas com tábuas segura uma horda por um tempo.",
	"Dormir numa cama salva o jogo e recupera a energia.",
	"O inibidor NX retarda a infecção. Não a cura.",
]

var bar: ProgressBar
var stage: Label
var tip: Label
var _tip_t: float = 0.0
var _tip_i: int = 0


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var bg := ColorRect.new()
	bg.color = Color(0.02, 0.02, 0.025)
	UIKit.full_rect(bg)
	add_child(bg)
	var v := UIKit.vbox(14)
	v.custom_minimum_size = Vector2(760, 0)
	v.add_child(UIKit.label("O INÍCIO DO FIM", 40, UITheme.ACCENT, HORIZONTAL_ALIGNMENT_CENTER))
	v.add_child(UIKit.spacer(30))
	stage = UIKit.label("Preparando…", 18, UITheme.TEXT_DIM, HORIZONTAL_ALIGNMENT_CENTER)
	v.add_child(stage)
	bar = UIKit.bar(UITheme.ACCENT, 1.0)
	bar.custom_minimum_size = Vector2(760, 6)
	v.add_child(bar)
	v.add_child(UIKit.spacer(30))
	_tip_i = randi() % TIPS.size()
	tip = UIKit.label(TIPS[_tip_i], 17, UITheme.TEXT, HORIZONTAL_ALIGNMENT_CENTER)
	tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tip.custom_minimum_size = Vector2(760, 60)
	v.add_child(tip)
	add_child(UIKit.center(v))


func set_progress(p: float, text: String = "") -> void:
	bar.value = clampf(p, 0.0, 1.0)
	if text != "":
		stage.text = text


func _process(delta: float) -> void:
	_tip_t += delta
	if _tip_t > 7.0:
		_tip_t = 0.0
		_tip_i = (_tip_i + 1) % TIPS.size()
		tip.text = TIPS[_tip_i]
