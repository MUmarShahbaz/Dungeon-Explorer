extends Game_Character
class_name Enemy_1

@onready var vision_ray: RayCast2D = $Vision_Ray
@onready var obstacle_ray: RayCast2D = $Obstacle_Ray

enum states {patrol, pursue, attack, dead}
enum enemy_type {melee, ranged, boss}

@export var obstacle_check_distance:int = 25
var current_state:states = states.patrol

# STATS
@export var SPD:float = 100
@export var RNG:float = 50
@export var VIS:float = 150
@export var TYP:enemy_type = enemy_type.melee

# Main Loop
func _physics_process(delta: float) -> void:
	if !alive:
		return
	super._physics_process(delta)
	var closest_player = find_player()
	match  current_state:
		states.patrol:
			patrol(delta)
			if closest_player != null:
				current_state = states.pursue
				return
		states.pursue:
			face_player(closest_player)
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
				is_attacking = false
				return
			attack_sequence()

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
		if player_dir.x*direction < 0 and current_state == states.patrol and player_dir.length() >= obstacle_check_distance: # Player is behind patrolling mob
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
		flip()

func check_obstacle() -> bool:
	obstacle_ray.target_position = Vector2(direction*obstacle_check_distance,0)
	obstacle_ray.force_raycast_update()
	if obstacle_ray.is_colliding():
		return true
	return false

func patrol(delta) -> void:
	sprite.animation = "walk"
	
	velocity = Vector2(SPD * (delta * 100) * direction, 0)
	move_and_slide()
	
	if check_obstacle():
		flip()

func pursue(delta: float, player: CharacterBody2D) -> void:
	sprite.animation = "run"
	face_player(player)

	var player_dir = (player.global_position - global_position).normalized()

	var separation = Vector2.ZERO
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy.get_instance_id() == self.get_instance_id():
			continue
		var offset = global_position - enemy.global_position
		var distance = offset.length()
		var min_distance = 100
		if distance < min_distance:
			
			separation += offset.normalized() * (min_distance - distance) / min_distance

	var move_dir = (player_dir + separation).normalized()

	velocity = move_dir * (SPD * 1.5) * (delta * 100)
	move_and_slide()


var combo = [] # Overwrite with animation frames
var next_attack = 0
var is_attacking = false

func attack_sequence() -> void:
	if is_attacking:
		return
	is_attacking = true
	sprite.play(combo[next_attack])

func _animation_finished() -> void:
	var player = find_player()
	if player and (find_player().global_position - global_position).length() > RNG:
		next_attack = 0
	else:
		next_attack = (next_attack + 1) % combo.size()
	is_attacking = false
