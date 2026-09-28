extends Node
## EventBus — barramento global de sinais.
##
## Os sistemas se comunicam por eventos em vez de consultas constantes
## (regra de CPU do projeto: "eventos em vez de verificações constantes").
## Nenhum estado é guardado aqui: apenas sinais.

# --- Mundo / percepção -------------------------------------------------------
## Ruído emitido no mundo. `radius` em metros (alcance para audição base 1.0).
signal noise_emitted(pos: Vector3, radius: float, source: Node, kind: StringName)
signal location_discovered(location_id: String)
signal region_entered(region_id: String)
signal world_phase_changed(phase: int)
signal chunk_loaded(coord: Vector2i)
signal chunk_unloaded(coord: Vector2i)
signal structure_built(structure_id: String, pos: Vector3)

# --- Jogador -------------------------------------------------------------------
signal player_spawned(player: Node)
signal player_damaged(amount: float, source: Node)
signal player_died(cause: String)
signal player_state_changed(state: StringName)
signal player_slept(hours: float)
signal item_picked(item_id: String, qty: int)
signal item_used(item_id: String)
signal item_crafted(item_id: String, qty: int)
signal item_dropped(item_id: String, qty: int)
signal inventory_changed(owner_id: String)
signal equipment_changed(slot: String, item_id: String)
signal container_opened(container_uid: String, context: String)
signal interaction_prompt(text: String)

# --- Combate / IA --------------------------------------------------------------
signal enemy_killed(kind: String, pos: Vector3, killer: Node)
signal npc_killed(npc_id: String, faction_id: String, killer: Node)
signal npc_helped(npc_id: String)
signal combat_hit(attacker: Node, target: Node, amount: float)
signal threat_level_changed(level: float)
signal horde_alerted(pos: Vector3, size: int)

# --- Narrativa / missões ------------------------------------------------------
signal log_found(log_id: String)
signal note_found(note_id: String)
signal story_flag_set(flag: String, value: Variant)
signal decision_made(decision_id: String, choice: String)
signal mission_started(mission_id: String)
signal mission_updated(mission_id: String)
signal objective_completed(mission_id: String, objective_id: String)
signal mission_completed(mission_id: String)
signal mission_failed(mission_id: String)
signal chapter_started(chapter: int)
signal talked_to(npc_id: String, topic: String)
signal interacted(target_id: String)
signal vehicle_repaired(vehicle_id: String)
signal world_event(event_id: String, text: String)

# --- Facções -----------------------------------------------------------------
signal faction_reputation_changed(faction_id: String, value: float)
signal faction_relation_changed(a: String, b: String, value: float)

# --- Tempo / clima ------------------------------------------------------------
signal hour_changed(hour: int)
signal day_changed(day: int)
signal period_changed(period: int)
signal weather_changed(state: int)
signal lightning_strike(pos: Vector3)

# --- Veículos -------------------------------------------------------------------
signal vehicle_entered(vehicle: Node)
signal vehicle_exited(vehicle: Node)

# --- UI / apresentação ------------------------------------------------------------
signal container_ui_requested(inv: Inventory, title: String, source: Node)
signal crafting_ui_requested(station: String, source: Node)
signal readable_opened(title: String, text: String)
signal sleep_requested(source: Node)
signal elevator_requested(target: String, source: Node)
signal fade_requested(to_black: bool, duration: float)
signal notify(text: String, kind: String)
signal subtitle(text: String, speaker: String, duration: float)
signal dialogue_requested(npc: Node)
signal trade_requested(npc: Node)
signal ui_screen_opened(screen: String)
signal ui_screen_closed(screen: String)
signal settings_changed()
signal hud_visibility(visible: bool)

# --- Cinemáticas -------------------------------------------------------------------
signal cinematic_started(id: String)
signal cinematic_shot(id: String, shot_id: String)
signal cinematic_finished(id: String)
signal gameplay_control_given()

# --- Save --------------------------------------------------------------------------
signal game_saved(slot: String)
signal game_loaded(slot: String)


## Atalho para notificações do HUD.
func toast(text: String, kind: String = "info") -> void:
	notify.emit(text, kind)


## Emite ruído — usado por passos, combate, veículos, distrações etc.
func make_noise(pos: Vector3, radius: float, source: Node = null, kind: StringName = &"generic") -> void:
	noise_emitted.emit(pos, radius, source, kind)
