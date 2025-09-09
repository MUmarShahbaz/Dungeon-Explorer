extends CharacterBody2D
class_name Enemy

@onready var vision_ray: RayCast2D = $Vision_Ray
@onready var obstacle_right: RayCast2D = $Obstacle_Right
@onready var obstacle_left: RayCast2D = $Obstacle_Left
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collider: CollisionShape2D = $Collider
@onready var weapon: Area2D = $Weapon

enum states {patrol, pursue, attack, dead}
enum can_see {player, obstacle, nothing}
enum enemy_type {melee, ranged, boss}

var obstacle_check_distance:int = 25
var direction:int = 1
var current_state:states = states.patrol

# STATS
var HP: int = 100
var DMG:int = 10
var SPD:float = 1.0
var RNG:float = 50
var VIS:float = 100
var TYP:enemy_type = enemy_type.melee

# Main Loop
func _physics_process(delta: float) -> void:
	var closest_player = find_player()
	match  current_state:
		states.patrol:
			patrol(delta)
			if closest_player != null:
				current_state = states.pursue
				return
		states.pursue:
			if closest_player == null:
				current_state = states.patrol
				return
			if (closest_player.global_position - global_position).length() <= RNG:
				current_state = states.attack
				return
			pursue(delta, closest_player)
		states.attack:
			if closest_player == null or (closest_player.global_position - global_position).length() >= RNG:
				current_state =  states.pursue
				return
			attack_sequence(delta, closest_player)

# Behaviors
func _ready() -> void:
	add_to_group("enemies")

func find_player() -> CharacterBody2D:
	var players = get_tree().get_nodes_in_group("players")
	if players.is_empty():
		return
	var closest_player = null
	var closest_player_dist = INF
	for player in players:
		var player_dir = player.global_position - global_position
		if player_dir.x*direction < 0 and current_state == states.patrol: # Player is behind patrolling mob
			continue
		vision_ray.target_position = player_dir.normalized() * min(player_dir.length(), VIS)
		vision_ray.force_raycast_update()
		if vision_ray.is_colliding() and vision_ray.get_collider() == player:
			if closest_player_dist > player_dir.length():
				closest_player = player
				closest_player_dist = player_dir.length()
	return closest_player

func face_player(player: CharacterBody2D) -> void:
	if player == null:
		return
	var player_dir = player.global_position - global_position
	if direction*player_dir.x < 0:
		sprite.flip_h = !sprite.flip_h
		direction *= -1

func take_damage(amount: int) -> void:
	HP -= amount
	if HP <= 0 and current_state != states.dead:
		die()

func die() -> void:
	current_state = states.dead
	collider.disabled = true
	weapon.monitoring = false
	sprite.play("death")
	queue_free()

@warning_ignore("unused_parameter")
func  patrol(delta) -> void:
	return # Should be overwritten by individual enemy types

@warning_ignore("unused_parameter")
func  pursue(delta, player: CharacterBody2D) -> void:
	return # Should be overwritten by individual enemy types

@warning_ignore("unused_parameter")
func  attack_sequence(delta, player: CharacterBody2D) -> void:
	return # Should be overwritten by individual enemy types
