extends Game_Character
class_name Enemy

var vision_ray: RayCast2D
var obstacle_check_left: Area2D
var obstacle_check_right: Area2D

enum states {idle, patrol, pursue, attacking}
var current_state
var obstacle_check_distance:int = 25

# STATS
@export var SPD:float = 100
@export var VIS:float = 150
@export var RNG:float = 50

func _ready() -> void:
	add_to_group("enemies")
	default_state = states.attacking

func _physics_process(delta: float) -> void:
	if !alive:
		return
	super._physics_process(delta)
	var closest_player = find_player()
	match  current_state:
		states.patrol:
			if closest_player != null:
				state_update(states.pursue)
			patrol(delta)
		states.pursue:
			if closest_player == null:
				state_update(states.patrol)
				return
			if (closest_player.global_position - global_position).length() <= RNG:
				state_update(states.attacking)
				return
			pursue(delta, closest_player)
		states.attacking:
			if closest_player == null or (closest_player.global_position - global_position).length() >= RNG:
				state_update(states.patrol)
				is_attacking = false
				return
			attack()

func state_update(new_state: states):
	if !alive or hurting:
		return
	match new_state:
		states.idle:
			sprite.play("idle")
		states.patrol:
			sprite.play("walk")
		states.pursue:
			sprite.play("run")
	current_state = new_state

# Misc funcs

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
	if direction == 1:
		return obstacle_check_right.get_overlapping_bodies().size() > 0
	else:
		return obstacle_check_left.get_overlapping_bodies().size() > 0

# Behavior

func patrol(delta):
	velocity = Vector2(SPD * (delta * 100) * direction, 0)
	move_and_slide()
	if check_obstacle():
		flip()
	
func pursue(delta, player):
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

# Attacking
var combo = []
var next_attack = 0
var is_attacking:bool = false

func attack():
	if is_attacking:
		return
	is_attacking = true
	sprite.play(combo[next_attack])

func _animation_finished() -> void:
	super._animation_finished()
	var player = find_player()
	if player and (find_player().global_position - global_position).length() > RNG:
		next_attack = 0
	else:
		next_attack = (next_attack + 1) % combo.size()
	is_attacking = false
