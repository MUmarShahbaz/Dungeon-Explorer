extends Node

@export var sprite: AnimatedSprite2D
@export var number_of_moves: int

signal attack_1()
signal attack_2()
signal attack_3()
signal busy()
signal not_busy()

func _ready() -> void:
	connect_to_sprite()

func connect_to_sprite() -> void:
	attack_1.connect(Callable(sprite, "attack_1"))
	attack_2.connect(Callable(sprite, "attack_2"))
	attack_3.connect(Callable(sprite, "attack_3"))
	sprite.animation_finished.connect(Callable(self, "end_attack"))
	sprite.animation_looped.connect(Callable(self, "end_attack"))

# Attack Logic

var is_attacking:bool = false
var current_move = 0
var buffer:bool = false
var buffer_timer:float = 0.0
var buffer_duration:float = 0.25

func _process(delta: float) -> void:
	if buffer_timer > 0:
		buffer_timer -= delta
		if buffer_timer <= 0:
			buffer_timer = 0
			buffer = false

func attack():
	if is_attacking:
		buffer = true
		buffer_timer = buffer_duration
		return
	is_attacking = true
	emit_signal("busy")
	emit_signal(("attack_" + str(current_move + 1)))

func end_attack() -> void:
	if is_attacking:
		is_attacking = false
		if buffer:
			buffer_timer = 0
			buffer = false
			current_move = (current_move + 1) % number_of_moves
			attack()
		else:
			emit_signal("not_busy")
			current_move = 0
