extends Game_Character
class_name Player

enum states {idle, walking, running, primary, secondary, special, healing}
var current_state

# STATS
@export var SPD:float = 100
@export var STM: int = 100
@export var num_healing_potions:int = 3

func _ready() -> void:
	add_to_group("players")

func state_update(new_state: states):
	if !alive or hurting or primary_attacking or new_state == current_state:
		return
	match new_state:
		states.idle:
			sprite.play("idle")
		states.walking:
			sprite.play("walk")
		states.running:
			sprite.play("run")
		states.secondary:
			secondary()
		states.special:
			special()
		states.healing:
			heal()
	current_state = new_state

# Attacks & Abilities
var combo = []
var next_attack = 0
var primary_attacking = false

var attack_buffer_duration = 1
var attack_buffer_timer = 0.0
var attack_buffer = false

func _process(delta: float) -> void:
	if attack_buffer_timer > 0:
		attack_buffer_timer -= delta
		if attack_buffer_timer <= 0:
			attack_buffer = false

func _animation_finished() -> void:
	primary_attacking = false
	if attack_buffer:
		next_attack = (next_attack + 1) % combo.size()
		attack_buffer_timer = 0
		attack_buffer = false
		primary()
	else:
		next_attack = 0

func primary():
	if primary_attacking:
		attack_buffer = true
		attack_buffer_timer = attack_buffer_duration
		return
	current_state = states.primary
	primary_attacking = true
	sprite.play(combo[next_attack])

func secondary():
	print("Secondary Move used")
	return

func special():
	print("Special Move used")
	return

func heal():
	if num_healing_potions > 0:
		num_healing_potions -= 1
		current_HP += HP*0.75
