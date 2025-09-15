extends Node

@export var sprite: AnimatedSprite2D
@export var velocity: Node
@export var primary_attacker: Node
@export var secondary_attacker: Node
@export var special_attacker: Node

signal special()
signal heal()
signal secondary_move()
signal primary_move()
signal interact()
signal equip()
signal sprint(direction : Vector2, delta: float)
signal walk(direction : Vector2, delta: float)
signal idle()

func _ready() -> void:
	connect_to_sprite()
	connect_to_velocity()
	connect_to_primary_attacks()
	connect_to_secondary_attacks()
	connect_to_special_attacks()

func connect_to_sprite():
	idle.connect(Callable(sprite, "idle"))
	walk.connect(Callable(sprite, "walk"))
	sprint.connect(Callable(sprite, "sprint"))

func connect_to_velocity():
	walk.connect(Callable(velocity, "walk"))
	sprint.connect(Callable(velocity, "sprint"))

func connect_to_primary_attacks():
	primary_move.connect(Callable(primary_attacker, "attack"))
	primary_attacker.busy.connect(Callable(self, "set_busy"))
	primary_attacker.not_busy.connect(Callable(self, "set_free"))

func connect_to_secondary_attacks():
	secondary_move.connect(Callable(secondary_attacker, "attack"))
	secondary_attacker.busy.connect(Callable(self, "set_busy"))
	secondary_attacker.not_busy.connect(Callable(self, "set_free"))
	
func connect_to_special_attacks():
	special.connect(Callable(special_attacker, "attack"))
	special_attacker.busy.connect(Callable(self, "set_busy"))
	special_attacker.not_busy.connect(Callable(self, "set_free"))

# Controller Logic

var busy:bool = false

func _process(delta):
	if Input.is_action_just_pressed("special"):
		emit_signal("special")
		return
	if Input.is_action_just_pressed("heal"):
		emit_signal("heal")
		return
	if Input.is_action_just_pressed("secondary"):
		emit_signal("secondary_move")
		return
	if Input.is_action_just_pressed("primary"):
		emit_signal("primary_move")
		return
	if Input.is_action_just_pressed("interact"):
		emit_signal("interact")
		return
	if Input.is_action_just_pressed("equip"):
		emit_signal("equip")
		return
	if busy:
		return
	# Movement
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if direction != Vector2.ZERO:
		if Input.is_action_pressed("sprint"):
			emit_signal("sprint", direction.normalized(), delta)
		else:
			emit_signal("walk", direction.normalized(), delta)
		return
	emit_signal("idle")


func set_busy() -> void:
	busy = true

func set_free() -> void:
	busy = false
