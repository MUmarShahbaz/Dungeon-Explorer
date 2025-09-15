extends Node

@export var sprite: AnimatedSprite2D
@export var speed: float = 20.0
@export var sprint_speed: float = 50.0
var character: CharacterBody2D

signal flip()

func _ready() -> void:
	get_character()
	connect_to_sprite()

func get_character():
	character = get_parent() as CharacterBody2D
	if character == null:
		push_warning("MovementComponent must be a child of CharacterBody2D!")

func connect_to_sprite():
	flip.connect(Callable(sprite, "flip"))

# Movement Logic

var _velocity: Vector2 = Vector2.ZERO
var direction = 1

func sprint(input_vector: Vector2, delta: float) -> void:
	if character == null:
		return
	if input_vector.x * direction < 0:
		direction *= -1
		emit_signal("flip")
	_velocity = input_vector * sprint_speed * delta * 1000
	character.velocity = _velocity
	character.move_and_slide()


func walk(input_vector: Vector2, delta: float) -> void:
	if character == null:
		return
	if input_vector.x * direction < 0:
		direction *= -1
		emit_signal("flip")
	_velocity = input_vector * speed * delta * 1000
	character.velocity = _velocity
	character.move_and_slide()
