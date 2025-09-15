extends Node

@export var sprite: AnimatedSprite2D

signal secondary()
signal busy()
signal not_busy()

func _ready() -> void:
	connect_to_sprite()

func connect_to_sprite() -> void:
	secondary.connect(Callable(sprite, "secondary"))
	sprite.animation_finished.connect(Callable(self, "end_move"))
	sprite.animation_looped.connect(Callable(self, "end_move"))

# Secondary Logic
var is_attacking:bool = false

func attack():
	if is_attacking:
		return
	is_attacking = true
	emit_signal("busy")
	emit_signal("secondary")
	return

func end_move():
	if is_attacking:
		is_attacking = false
		emit_signal("not_busy")
