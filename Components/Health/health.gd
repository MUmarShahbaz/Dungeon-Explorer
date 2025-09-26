extends Node
class_name Health

#===================================
#             Signals
#===================================

signal hurt()
signal die()

#===================================
#          Connect Nodes
#===================================

@export var stamina: Stamina
@export var sprite: AnimatedSprite2D

func _ready() -> void:
	current_hp = HP
	connect_sprite()

func connect_sprite():
	hurt.connect(Callable(sprite, "hurt"))
	die.connect(Callable(sprite, "die"))

#===================================
#               HP
#===================================

@export var HP: int
@export var Regeneration_rate: float
@export var Heals: int
var current_hp: float

func _process(delta: float) -> void:
	if stamina.try("regenerate_hp"):
		current_hp = min(current_hp + Regeneration_rate*delta, HP)

func heal():
	if Heals > 0:
		Heals -= 1
		current_hp = min(current_hp + 0.75*HP, HP)

#===================================
#          Take Damage
#===================================

@export var DEF: int
@export var Max_def: int

func take_damage(amount):
	amount -= min(amount*DEF, Max_def)
	current_hp -= amount
	if current_hp <= 0:
		emit_signal("die")
		await sprite.animation_finished
		get_parent().queue_free()
		return
	emit_signal("hurt")
