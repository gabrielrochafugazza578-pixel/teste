class_name SaveGame
## Salva e carrega o mundo (modificacoes do terreno, arvores cortadas, jogador,
## inventario e hora do dia) em user://mundo_<semente>.json

const VERSION := 1


static func path_for(world_seed: int) -> String:
	return "user://mundo_%d.json" % world_seed


static func exists(world_seed: int) -> bool:
	return FileAccess.file_exists(path_for(world_seed))


static func save(world: World, player: Player, day_night: DayNight) -> bool:
	var edits := {}
	for k in world.edits:
		var e: Dictionary = world.edits[k]
		if e.is_empty():
			continue
		var packed := {}
		for li in e:
			var v: Vector2 = e[li]
			packed[str(li)] = [snappedf(v.x, 0.001), int(v.y)]
		edits["%d,%d" % [k.x, k.y]] = packed
	var removed := {}
	for k in world.removed_decos:
		var r: Dictionary = world.removed_decos[k]
		if not r.is_empty():
			removed["%d,%d" % [k.x, k.y]] = r.keys()
	var inv := {}
	for m in player.inventory.counts:
		inv[str(m)] = player.inventory.counts[m]
	var p := player.global_position
	var data := {
		"version": VERSION,
		"seed": world.world_seed,
		"player": {"pos": [p.x, p.y, p.z], "yaw": player.yaw, "pitch": player.pitch, "hp": player.hp},
		"inventory": inv,
		"selected": player.inventory.selected,
		"creative": player.inventory.creative,
		"time": day_night.time_of_day,
		"day": day_night.day_count,
		"edits": edits,
		"removed": removed,
	}
	var f := FileAccess.open(path_for(world.world_seed), FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(JSON.stringify(data))
	return true


## Carrega os dados. Deve ser chamado antes dos chunks aparecerem.
static func load_into(world: World, player: Player, day_night: DayNight) -> bool:
	var path := path_for(world.world_seed)
	if not FileAccess.file_exists(path):
		return false
	var data = JSON.parse_string(FileAccess.get_file_as_string(path))
	if typeof(data) != TYPE_DICTIONARY or int(data.get("version", 0)) != VERSION:
		return false
	for ks in data.get("edits", {}):
		var parts: PackedStringArray = String(ks).split(",")
		var k := Vector2i(int(parts[0]), int(parts[1]))
		var e := {}
		var src: Dictionary = data["edits"][ks]
		for li in src:
			var v: Array = src[li]
			e[int(li)] = Vector2(float(v[0]), float(v[1]))
		world.edits[k] = e
	for ks in data.get("removed", {}):
		var parts: PackedStringArray = String(ks).split(",")
		var k := Vector2i(int(parts[0]), int(parts[1]))
		var r := {}
		for i in data["removed"][ks]:
			r[int(i)] = true
		world.removed_decos[k] = r
	var pl: Dictionary = data.get("player", {})
	if pl.has("pos"):
		var a: Array = pl["pos"]
		player.global_position = Vector3(a[0], a[1] + 0.3, a[2])
		player.set_look(rad_to_deg(float(pl.get("yaw", 0.0))), rad_to_deg(float(pl.get("pitch", 0.0))))
		player.hp = int(pl.get("hp", player.max_hp))
	var inv: Dictionary = data.get("inventory", {})
	for m in inv:
		player.inventory.counts[int(m)] = int(inv[m])
	player.inventory.selected = int(data.get("selected", 0))
	player.inventory.creative = bool(data.get("creative", false))
	player.inventory.changed.emit()
	day_night.time_of_day = float(data.get("time", 0.3))
	day_night.day_count = int(data.get("day", 1))
	return true
