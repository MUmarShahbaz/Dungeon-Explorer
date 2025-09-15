extends Node

@export var sprite: AnimatedSprite2D

signal special()
signal busy()
signal not_busy()

func _ready() -> void:
	connect_to_sprite()

func connect_to_sprite() -> void:
	special.connect(Callable(sprite, "special"))
	sprite.animation_finished.connect(Callable(self, "end_move"))
	sprite.animation_looped.connect(Callable(self, "end_move"))

# Special Logic
var is_attacking:bool = false

func attack():
	if is_attacking:
		return
	is_attacking = true
	emit_signal("busy")
	emit_signal("special")
	return

func end_move():
	if is_attacking:
		is_attacking = false
		emit_signal("not_busy")
