extends Node
class_name Secondary_Handler

#===========================================
#                 Signals
#===========================================

signal secondary()
signal busy()
signal not_busy()

#===========================================
#              Connect Nodes
#===========================================

@export var sprite: AnimatedSprite2D
@export var velocity: Velocity
@export var camera: Camera2D

func _ready() -> void:
	connect_to_sprite()

func connect_to_sprite() -> void:
	secondary.connect(Callable(sprite, "secondary"))
	sprite.animation_finished.connect(Callable(self, "end_secondary"))
	sprite.animation_looped.connect(Callable(self, "end_secondary"))

#===========================================
#                Move Logic
#===========================================

enum type { Projectile, Protection }

@export var Move_type: type

func use_secondary() -> void:
	if Move_type == type.Projectile:
		launch_projectile()
	if Move_type == type.Protection:
		protect()

func end_secondary() -> void:
	if throwing:
		throw_projectile()
		throwing = false
		emit_signal("not_busy")

#=====================================
#             Projectile
#=====================================

@export var projectile: PackedScene
@export var Projectile_spawn_offset: Vector2
var throwing:bool = false

func launch_projectile():
	if throwing:
		return
	throwing = true
	emit_signal("busy")
	emit_signal("secondary")

func throw_projectile():
	var character = get_parent() as CharacterBody2D
	var new_projectile = projectile.instantiate()
	
	var direction: Vector2 = Vector2.ZERO
	if Input.is_joy_known(0):
		var joy_direction = Vector2.ZERO
		joy_direction.x = Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left")
		joy_direction.y = Input.get_action_strength("camera_down") - Input.get_action_strength("camera_up")
		
		direction.x = joy_direction.x * camera.offset_distance.x
		direction.y = joy_direction.y * camera.offset_distance.y
		if direction == Vector2.ZERO:
			direction = Vector2(velocity.direction, 0)
	else:
		var mouse_world_pos = get_viewport().get_camera_2d().get_global_mouse_position()
		var current_spawn_offset = Vector2(Projectile_spawn_offset.x, Projectile_spawn_offset.y * velocity.direction)
		direction = (mouse_world_pos - character.global_position - current_spawn_offset).normalized()
		
	new_projectile.target = direction.normalized()
	character.add_sibling(new_projectile)
	new_projectile.global_position = character.global_position + Projectile_spawn_offset

#=====================================
#              Protect
#=====================================
var sheilding: bool

func protect():
	sheilding = true
	emit_signal("busy")
	emit_signal("secondary")
	await wait_for_release("secondary")
	sheilding = false
	emit_signal("not_busy")

func wait_for_release(action_name: String) -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_released(action_name):
			return
