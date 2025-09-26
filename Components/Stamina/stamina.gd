extends Node
class_name Stamina

@export var STM: int
@export var Regeneration_rate: float
var current_stm: float

func _ready() -> void:
	current_stm = STM

func _process(delta: float) -> void:
	current_stm = min(current_stm + Regeneration_rate*delta, STM)

#===========================================
#                Consumption
#===========================================

@export var Primary_move_cost: float
@export var Secondary_move_cost: float
@export var Special_move_cost: float

func try(action):
	match action:
		"primary":
			if current_stm >= Primary_move_cost:
				current_stm -= Primary_move_cost
				return true
			else: return false
		"secondary":
			if current_stm >= Secondary_move_cost:
				current_stm -= Secondary_move_cost
				return true
			else: return false
		"special":
			if current_stm >= Special_move_cost:
				current_stm -= Special_move_cost
				return true
			else: return false
		"regenerate_hp":
			if current_stm == STM: return true
			else: return false
	push_warning("Stamina: " + action + "is not defined")
