class_name DamageInfo
extends RefCounted
## Dados de um golpe/impacto. Todos os alvos implementam receive_hit(info).

var amount: float = 10.0
var kind: String = "blunt"       # blunt | sharp | heavy | bite | scratch | fire | bullet | push
var source: Node = null
var direction: Vector3 = Vector3.FORWARD   # direção do golpe (do atacante para o alvo)
var knockback: float = 0.0
var stagger: float = 0.0         # 0..1 (1 = derruba alvos fracos)
var infection_chance: float = 0.0
var bleed: float = 0.0
var heavy: bool = false
var stealth: bool = false
var headshot: bool = false
var point: Vector3 = Vector3.ZERO
var blockable: bool = true


static func make(amt: float, k: String, src: Node, dir: Vector3) -> DamageInfo:
	var d := DamageInfo.new()
	d.amount = amt
	d.kind = k
	d.source = src
	d.direction = dir.normalized() if dir.length_squared() > 0.0001 else Vector3.FORWARD
	return d
