extends Node
## Cena de entrada da galeria: cria o driver persistente na raiz (sobrevive à troca de cena).

func _ready() -> void:
	var d := Node.new()
	d.set_script(load("res://tests/gallery_driver.gd"))
	d.name = "GalleryDriver"
	get_tree().root.add_child.call_deferred(d)
