class_name CreditsScreen
extends Control
## Créditos (rolagem). Também usado ao final do jogo.

signal closed

const LINES := [
	["title", "O INÍCIO DO FIM"],
	["", ""],
	["head", "Projeto original"],
	["", "História, mundo, personagens e sistemas originais."],
	["", "Qualquer semelhança com pessoas reais é coincidência."],
	["", ""],
	["head", "Tecnologia"],
	["", "Godot Engine 4.7 — Forward+ (Vulkan) e Compatibility (OpenGL 3.3)"],
	["", "Animações, áudio e a maior parte das malhas gerados pelo próprio jogo."],
	["", ""],
	["head", "Assets de terceiros"],
	["", "Texturas, móveis, plantas e árvores escaneados: Poly Haven (CC0) — polyhaven.com"],
	["", "Corpos, peles, roupas e cabelos: MakeHuman e comunidade (CC0) — makehumancommunity.org"],
	["", "Roupas CC BY 4.0: Elvaerwyn (camisas social e de botão),"],
	["", "Mindfront (cardigã longo/jaleco, suéteres de tricô), janexx (suéter)"],
	["", "Textura de moita de grama: SimpleGrassTextured, IcterusGames (MIT)"],
	["", ""],
	["head", "Personagens"],
	["", "Caio — sobrevivente que voltou"],
	["", "Dra. Helena Vasconcelos — Projeto NEXUS"],
	["", "Lia e Célia — a família"],
	["", "Marta, Davi, Dona Zilda, Tonho, Sofia, Dr. Otávio"],
	["", "Comandante Tavares, Bento \"Corvo\" Siqueira, Irmão Tadeu"],
	["", "Diretor Augusto Leme"],
	["", ""],
	["head", "Obrigado por jogar."],
	["", ""],
	["", "Godot Engine é software livre (licença MIT) — godotengine.org"],
]

var _scroll: ScrollContainer
var _v: VBoxContainer
var _t: float = 0.0
var auto_scroll: bool = true


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	var bg := UIKit.dim_bg(0.92)
	add_child(bg)
	_scroll = ScrollContainer.new()
	UIKit.full_rect(_scroll)
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(_scroll)
	_v = UIKit.vbox(10)
	_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll.add_child(_v)
	_v.add_child(UIKit.spacer(520))
	for l in LINES:
		var kind: String = l[0]
		var size := 20
		var col := UITheme.TEXT
		match kind:
			"title":
				size = 48
				col = UITheme.ACCENT
			"head":
				size = 26
				col = UITheme.ACCENT
		_v.add_child(UIKit.label(str(l[1]), size, col, HORIZONTAL_ALIGNMENT_CENTER))
	_v.add_child(UIKit.spacer(600))
	var b := UIKit.button("Voltar", close, 180)
	b.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	b.position = Vector2(-220, -70)
	add_child(b)


func _process(delta: float) -> void:
	if auto_scroll:
		_t += delta * 38.0
		_scroll.scroll_vertical = int(_t)
		if _t > _v.size.y:
			close()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	closed.emit()
	queue_free()
