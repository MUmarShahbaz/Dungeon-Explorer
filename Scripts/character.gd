extends CharacterBody2D
class_name Game_Character

@onready var sprite: AnimatedSprite2D
@onready var collider: CollisionShape2D

var direction:int = 1
var alive:bool = true
var hurting:bool = false

# STATS
@export var HP: int = 100
@export var ATK:int = 10
@export var DEF:int = 10

var current_HP:int
var default_state

func _physics_process(_delta: float) -> void:
	if !alive:
		return
	z_index = int(round(position.y))

func connect_animations() -> void:
	sprite.connect("frame_changed", Callable(self, "_frame_changed"))
	sprite.connect("animation_finished", Callable(self, "_animation_finished"))

func flip() -> void:
	sprite.flip_h = !sprite.flip_h
	direction *= -1

func give_damage(damage_zone: Area2D) -> void:
	damage_zone.monitoring = true
	await get_tree().physics_frame
	await get_tree().physics_frame
	var overlaps = damage_zone.get_overlapping_bodies()
	damage_zone.monitoring = false
	for body in overlaps:
		body.take_damage(ATK)

func take_damage(amount: int) -> void:
	hurting = true
	current_HP -= (amount - amount*(DEF/100))
	if current_HP <= 0 and alive:
		die()
	else:
		sprite.play("hurt")

func die() -> void:
	alive = false
	collider.disabled = true
	sprite.play("die")
	await sprite.animation_finished
	queue_free()

func _animation_finished():
	if hurting == true:
		hurting = false
		state_update(default_state)

func state_update(_new):
	return
