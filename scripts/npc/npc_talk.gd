class_name NPCTalk
extends Interactable
## Área de conversa de um sobrevivente.

var npc: SurvivorNPC


func get_prompt(_player: Node) -> String:
	if npc.trader and not npc.named:
		return "Falar / Negociar — " + npc.display_name
	return "Falar com " + npc.display_name


func can_interact(_player: Node) -> bool:
	return enabled and npc != null and npc.can_talk()


func interact(player: Node) -> void:
	super.interact(player)
	EventBus.dialogue_requested.emit(npc)
