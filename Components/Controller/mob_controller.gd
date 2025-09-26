extends Node
class_name Mob_Controller

#===========================================
# Signals
#===========================================

signal busy()
signal not_busy()

signal idle()
signal walk(_direction: Vector2, _delta: float)
signal sprint(_direction: Vector2, _delta: float)

signal primary_attack()
signal secondary_attack()

#===========================================
# Connect to Nodes
#===========================================

@export var stamina: Stamina
@export var health: Health
@export var velocity: Velocity
@export var primary: Primary_Handler
@export var sprite: AnimatedSprite2D
@export var projectile: PackedScene

@onready var me: CharacterBody2D = get_parent()

func _ready() -> void:
	connect_health()
	connect_velocity()
	connect_primary()
	connect_sprite()

func connect_health():
	health.hurt.connect(Callable(self, "set_busy"))
	pass

func connect_velocity():
	walk.connect(Callable(velocity, "walking"))
	sprint.connect(Callable(velocity, "sprinting"))

func connect_primary():
	if primary:
		primary_attack.connect(Callable(primary, "attack"))
		primary.busy.connect(Callable(self, "set_busy"))
		primary.not_busy.connect(Callable(self, "set_not_busy"))

func connect_sprite():
	idle.connect(Callable(sprite, "idle"))
	secondary_attack.connect(Callable(sprite, "secondary"))
	sprite.frame_changed.connect(Callable(self, "launch_projectile"))
	sprite.animation_finished.connect(Callable(self, "set_not_busy"))

#===========================================
#Busy Signals
#===========================================

var is_busy: bool = false

func set_busy():
	is_busy = true
	emit_signal("busy")

func set_not_busy():
	is_busy = false
	emit_signal("not_busy")

func launch_projectile():
	pass
