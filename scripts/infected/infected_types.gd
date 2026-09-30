class_name InfectedTypes
extends RefCounted
## Tipos originais de infectados pelo NEXUS-2.
##
## Estágios da infecção explicam a variedade: o Febril está no início (corpo
## ainda forte, cérebro em curto), o Errante é o estágio comum, e o NEXUS
## continua "regenerando" o corpo de formas erradas nos estágios tardios
## (Sentinela cega e hipersensível, Colosso hipertrofiado, Rastejante,
## Hospedeiro com colônias que liberam esporos).

const TYPES := {
	"errante": {
		"name": "Errante", "hp": 75.0, "walk": 0.85, "run": 2.9, "vision": 19.0, "fov": 110.0, "hearing": 1.0,
		"damage": 13.0, "reach": 1.45, "attacks": ["inf_swipe", "inf_lunge"], "style": "shamble", "run_style": "shamble",
		"poise": 18.0, "bite": 0.22, "voice": "infected_groan", "twitch": 0.4,
		"desc": "Estágio comum. Lentos, andam em grupos e reagem a qualquer ruído. Perigosos quando cercam.",
	},
	"febril": {
		"name": "Febril", "hp": 48.0, "walk": 1.3, "run": 5.6, "vision": 27.0, "fov": 140.0, "hearing": 0.8,
		"damage": 10.0, "reach": 1.5, "attacks": ["inf_lunge", "inf_swipe"], "style": "feral", "run_style": "feral",
		"poise": 10.0, "bite": 0.15, "voice": "infected_attack", "twitch": 0.9, "light_sensitive": true, "sprint_limit": 7.0,
		"desc": "Início da infecção. Rápidos e erráticos, cansam depois de correr. A luz direta da lanterna os faz recuar.",
	},
	"sentinela": {
		"name": "Sentinela", "hp": 62.0, "walk": 0.8, "run": 3.3, "vision": 2.5, "fov": 360.0, "hearing": 2.6,
		"damage": 15.0, "reach": 1.4, "attacks": ["inf_swipe", "inf_lunge"], "style": "shamble", "run_style": "feral",
		"poise": 16.0, "bite": 0.25, "voice": "infected_groan2", "twitch": 1.0, "screamer": true,
		"desc": "Cegos, com audição absurda. Ao ouvir algo, gritam e chamam todos ao redor. Mova-se agachado.",
	},
	"colosso": {
		"name": "Colosso", "hp": 420.0, "walk": 0.8, "run": 3.9, "vision": 22.0, "fov": 110.0, "hearing": 0.9,
		"damage": 36.0, "reach": 2.2, "attacks": ["brute_slam"], "style": "brute", "run_style": "brute",
		"poise": 160.0, "bite": 0.12, "voice": "brute_roar", "twitch": 0.2, "charger": true, "resist_blunt": 0.55, "resist_sharp": 0.8,
		"desc": "O NEXUS hipertrofiou músculos e ossos. Investe em linha reta — esquive para que ele acerte a parede.",
	},
	"rastejante": {
		"name": "Rastejante", "hp": 38.0, "walk": 0.6, "run": 1.7, "vision": 9.0, "fov": 150.0, "hearing": 1.3,
		"damage": 8.0, "reach": 1.3, "attacks": ["crawler_claw"], "style": "crawl", "run_style": "crawl",
		"poise": 8.0, "bite": 0.3, "voice": "infected_growl", "twitch": 0.6, "ambusher": true,
		"desc": "Pernas destruídas pela infecção. Escondem-se sob carros e na vegetação e atacam os tornozelos.",
	},
	"hospedeiro": {
		"name": "Hospedeiro", "hp": 150.0, "walk": 0.7, "run": 1.9, "vision": 14.0, "fov": 120.0, "hearing": 1.0,
		"damage": 16.0, "reach": 1.5, "attacks": ["inf_swipe", "spores"], "style": "shamble", "run_style": "shamble",
		"poise": 45.0, "bite": 0.3, "voice": "spores", "twitch": 0.3, "spores": true,
		"desc": "Estágio final, surgido após o colapso. Colônias fúngicas liberam esporos que infectam. Use máscara com filtro.",
	},
}


static func get_type(kind: String) -> Dictionary:
	return TYPES.get(kind, TYPES["errante"])
