extends Node
class_name Player_Controller

#===========================================
#                 Signals
#===========================================

signal busy()
signal not_busy()

signal idle()
signal walk(_direction: Vector2, _delta: float)
signal sprint(_direction: Vector2, _delta: float)

signal move_camera(_direction: Vector2)

signal heal()
signal primary_move()
signal secondary_move()
signal special_move()

signal equip()
signal interact()

#===========================================
#             Connect to Nodes
#===========================================

@export var stamina: Stamina
@export var health: Health
@export var velocity: Velocity
@export var camera: Camera2D
@export var primary: Primary_Handler
@export var secondary: Secondary_Handler
@export var special: Special_Handler
@export var sprite: AnimatedSprite2D

func _ready() -> void:
	connect_health()
	connect_velocity()
	connect_camera()
	connect_primary()
	connect_secondary()
	connect_special()
	connect_sprite()

func connect_health():
	heal.connect(Callable(health, "heal"))
	health.hurt.connect(Callable(self, "set_busy"))

func connect_velocity():
	walk.connect(Callable(velocity, "walking"))
	sprint.connect(Callable(velocity, "sprinting"))

func connect_camera():
	move_camera.connect(Callable(camera, "set_target_offset"))

func connect_primary():
	primary_move.connect(Callable(primary, "attack"))
	primary.busy.connect(Callable(self, "set_busy"))
	primary.not_busy.connect(Callable(self, "set_not_busy"))
	
func connect_secondary():
	secondary_move.connect(Callable(secondary, "use_secondary"))
	secondary.busy.connect(Callable(self, "set_busy"))
	secondary.not_busy.connect(Callable(self, "set_not_busy"))

func connect_special():
	special_move.connect(Callable(special, "use_special"))
	special.busy.connect(Callable(self, "set_busy"))
	special.not_busy.connect(Callable(self, "set_not_busy"))

func connect_sprite():
	idle.connect(Callable(sprite, "idle"))
	sprite.animation_finished.connect(Callable(self, "set_not_busy"))

#===========================================
#                Busy Signals
#===========================================
var is_busy: bool = false

func set_busy():
	is_busy = true
	emit_signal("busy")

func set_not_busy():
	is_busy = false
	emit_signal("not_busy")

#===========================================
#                Main Loop
#===========================================

var camera_offset: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if health.current_hp <= 0:
		return

	var camera_direction:= Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	if camera_direction != camera_offset:
		camera_offset = camera_direction
		emit_signal("move_camera", camera_direction)

	if Input.is_action_just_pressed("primary"):
		if primary.buffer:
			emit_signal("primary_move")
		elif stamina.try("primary"):
			emit_signal("primary_move")
		return

	if is_busy:
		return

	if Input.is_action_just_pressed("special") and stamina.try("special"):
		emit_signal("special_move")
		return

	if Input.is_action_just_pressed("heal"):
		emit_signal("heal")
		return

	if Input.is_action_just_pressed("secondary") and stamina.try("secondary"):
		emit_signal("secondary_move")
		return

	if Input.is_action_just_pressed("equip"):
		emit_signal("equip")
		return

	if Input.is_action_just_pressed("interact"):
		emit_signal("interact")
		return
	
	var direction := Input.get_vector("left", "right", "up", "down")

	if direction != Vector2.ZERO:
		if Input.is_action_pressed("sprint"):
			emit_signal("sprint", direction, delta)
		else:
			emit_signal("walk", direction, delta)
	else:
		emit_signal("idle")
