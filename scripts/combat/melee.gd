class_name Melee
extends RefCounted
## Detecção de golpes corpo a corpo: esfera varrendo o arco do ataque
## (poucas consultas por golpe, só durante a janela ativa).

const MASK_TARGETS := (1 << 1) | (1 << 2) | (1 << 3)   # jogador, npc, infectado


## Retorna alvos (nós com receive_hit) atingidos pelo arco.
static func sweep(attacker: Node3D, origin: Vector3, forward: Vector3, reach: float, radius: float, arc_deg: float, exclude: Array) -> Array:
	var space := attacker.get_world_3d().direct_space_state
	var hits: Array = []
	var seen := {}
	var shape := SphereShape3D.new()
	shape.radius = radius
	var q := PhysicsShapeQueryParameters3D.new()
	q.shape = shape
	q.collision_mask = MASK_TARGETS
	q.exclude = exclude
	q.collide_with_areas = false
	# duas faixas de distância: acerta tanto o alvo colado quanto o da ponta do alcance
	var probes: Array[Vector3] = []
	for f in [0.4, 0.8]:
		for i in 3:
			var a := deg_to_rad(lerpf(-arc_deg * 0.5, arc_deg * 0.5, float(i) / 2.0))
			probes.append(origin + forward.rotated(Vector3.UP, a) * (reach * f))
	for p in probes:
		q.transform = Transform3D(Basis.IDENTITY, p)
		for r in space.intersect_shape(q, 6):
			var col: Object = r["collider"]
			if col == null or seen.has(col.get_instance_id()):
				continue
			if col is Node and (col as Node).has_method("receive_hit"):
				# linha de visão simples (não acerta através de paredes)
				var tn := col as Node3D
				var ray := PhysicsRayQueryParameters3D.create(origin, tn.global_position + Vector3(0, 1.0, 0), 1)
				var block := space.intersect_ray(ray)
				if not block.is_empty() and block["position"].distance_to(origin) < origin.distance_to(tn.global_position) - 0.6:
					continue
				seen[col.get_instance_id()] = true
				hits.append(col)
	return hits


## Arma atual -> parâmetros (desarmado = socos).
static func weapon_params(stack: Dictionary) -> Dictionary:
	if stack.is_empty():
		return {"dmg": 7.0, "speed": 1.4, "reach": 1.15, "stamina": 6.0, "kind": "blunt", "knock": 0.25, "wear": 0.0, "name": "Punhos"}
	var def := ItemDB.get_item(str(stack["id"]))
	var w: Dictionary = def.get("weapon", {})
	if w.is_empty():
		return {"dmg": 7.0, "speed": 1.4, "reach": 1.15, "stamina": 6.0, "kind": "blunt", "knock": 0.25, "wear": 0.0, "name": "Punhos"}
	var out := w.duplicate()
	out["name"] = def["name"]
	# condição baixa reduz o dano
	out["dmg"] = float(w["dmg"]) * lerpf(0.65, 1.0, clampf(float(stack.get("cond", 1.0)) * 1.5, 0.0, 1.0))
	return out
