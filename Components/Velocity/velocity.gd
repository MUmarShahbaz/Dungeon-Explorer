extends Node
class_name Velocity

#====================================
#             Signals
#====================================

signal walk()
signal sprint()
signal flip()

#====================================
#           Connect Nodes
#====================================

var character: CharacterBody2D
@export var sprite: AnimatedSprite2D

func _ready() -> void:
	character = get_parent()
	connect_sprite()

func connect_sprite():
	walk.connect(Callable(sprite, "walk"))
	sprint.connect(Callable(sprite, "sprint"))
	flip.connect(Callable(sprite, "flip"))

#====================================
#           Main Logic
#====================================

@export var SPD: int
@export var Sprint_SPD: int
var direction = 1

func sprinting(input_vector: Vector2, delta: float):
	if input_vector.x * direction < 0:
		flip_character()
	character.velocity = input_vector * Sprint_SPD * (delta * 100)
	character.move_and_slide()
	emit_signal("sprint")

func walking(input_vector: Vector2, delta: float):
	if input_vector.x * direction < 0:
		flip_character()
	character.velocity = input_vector * SPD * (delta * 100)
	character.move_and_slide()
	emit_signal("walk")

func flip_character():
	direction *= -1
	emit_signal("flip")
