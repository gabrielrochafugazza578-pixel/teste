class_name DebugOverlay
extends Control
## Painel de desempenho (F3): FPS, tempo de quadro, draw calls, VRAM,
## chunks, agentes por tier, orçamento de IA e streaming, posição.

var game: Node
var _label: Label
var _t: float = 0.0


func _ready() -> void:
	theme = UITheme.get_theme()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UITheme.box(Color(0, 0, 0, 0.7), Color(0, 0, 0, 0), 0, 3, 10))
	p.position = Vector2(20, 300)
	_label = UIKit.label("", 13, Color(0.7, 1.0, 0.7))
	p.add_child(_label)
	add_child(p)
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(delta: float) -> void:
	_t -= delta
	if _t > 0.0:
		return
	_t = 0.25
	var fps := Engine.get_frames_per_second()
	var t := "FPS %d  (%.1f ms)\n" % [fps, 1000.0 / maxf(fps, 1.0)]
	t += "Draw calls %d · Objetos %d · Primitivas %dk\n" % [Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),
		Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME), int(Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME) / 1000.0)]
	t += "VRAM %.0f MB · Texturas %.0f MB · RAM %.0f MB\n" % [Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1048576.0,
		Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED) / 1048576.0, Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0]
	t += "Física: %d objetos ativos · Processo %.1f ms · Física %.1f ms\n" % [Performance.get_monitor(Performance.PHYSICS_3D_ACTIVE_OBJECTS),
		Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0, Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000.0]
	var tc := SimScheduler.stat_tier_counts
	t += "IA: %d agentes [cheio %d · simples %d · mínimo %d] · %d chamadas · %d µs\n" % [SimScheduler.agents.size(), tc[0], tc[1], tc[2], SimScheduler.stat_think_calls, SimScheduler.stat_think_usec]
	if game and game.world:
		t += "Chunks %d · jobs %d · aplicação %d µs\n" % [game.world.chunks.size(), game.world.jobs.size(), game.world.stat_apply_usec]
	if game and game.director:
		t += "Infectados ativos %d · pool %d · ameaça %.2f\n" % [game.director.active.size(), game.director.pool.size(), game.director.threat]
	if game and game.survivors:
		t += "Sobreviventes instanciados %d\n" % game.survivors.spawned.size()
	if game and game.player:
		var p: Vector3 = game.player.global_position
		t += "Pos (%.0f, %.1f, %.0f) · %s · %s\n" % [p.x, p.y, p.z, WorldLayout.district_name(game.world.district_at(p)), AudioManager.env_mode]
	t += "Preset %s · escala 3D %d%% · %s" % [Settings.PRESET_NAMES[int(Settings.graphics["preset"])] if int(Settings.graphics["preset"]) >= 0 else "PERSONALIZADO",
		int(float(Settings.graphics["render_scale"]) * 100.0), RenderingServer.get_video_adapter_name()]
	_label.text = t
