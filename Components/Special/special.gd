extends Node
class_name Special_Handler

#===========================================
#                 Signals
#===========================================

signal special()
signal busy()
signal not_busy()

#===========================================
#              Connect Nodes
#===========================================

@export var sprite: AnimatedSprite2D

func _ready() -> void:
	connect_to_sprite()

func connect_to_sprite() -> void:
	special.connect(Callable(sprite, "special"))
	sprite.animation_finished.connect(Callable(self, "end_special"))
	sprite.animation_looped.connect(Callable(self, "end_special"))


#===========================================
#               Main Logic
#===========================================

enum type {Boost, Attack}

@export var special_type: type
@export var boost_duration: float
var boost_timer: float
var did_special = false

func use_special():
	did_special = true
	emit_signal("busy")
	if special_type == type.Boost:
		boost_timer = boost_duration
	emit_signal("special")

func _process(delta: float) -> void:
	if boost_timer > 0:
		boost_timer -= delta

func boosted():
	return boost_timer > 0

func end_special() -> void:
	if did_special:
		did_special = false
		emit_signal("not_busy")
