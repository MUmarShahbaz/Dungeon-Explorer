extends Mob_Controller

@export var VIS: int = 200
@export var RNG: int = 50
@export var projectile_offset: Vector2
@export var spread: int = 60
@export var vision_ray: RayCast2D
@export var projectile_sfx: AudioStreamPlayer

@onready var all_mobs := get_tree().get_nodes_in_group("mob")
@onready var home: Vector2 = me.global_position

enum state {patrol, pursue, attack}
var current_state = state.patrol

var pause_timer:= 0.0
var pause_cooldown:= 0.0
var dir:= Vector2.ZERO
var radius:= 50.0

#==========================================
#   Main Loop
#==========================================

func _physics_process(delta: float) -> void:
	if health.current_hp <= 0:
		return
	var player = detect_player()
	match current_state:
		state.patrol:
			if player:
				current_state = state.pursue
				return
			patrol(delta)
		state.pursue:
			if not player:
				current_state = state.patrol
				home = me.global_position
				return
			if (player.global_position - me.global_position).length() < RNG:
				current_state = state.attack
				return
			pursue(player, delta)
		state.attack:
			if not player or (player.global_position - me.global_position).length() > RNG:
				current_state = state.pursue
				return
			attack(player)

#==========================================
#Behvior Functions
#==========================================

func patrol(delta):
	var disp = me.global_position - home
	if disp.length() > radius*1.1:
		emit_signal("walk", -disp.normalized(), delta)
		dir = Vector2.ZERO
		return
	if pause_timer > 0:
		emit_signal("idle")
		pause_timer -= delta
		pause_cooldown = 0.5 + delta
		return
	
	pause_cooldown -= delta

	if dir == Vector2.ZERO:
		var current_angle: float = atan2(disp.y, disp.x)
		var rads_range:float = asin(radius*0.7 / disp.length())
		var rads_change: float = randf_range(-rads_range, rads_range)
		var new_angle: float = current_angle + rads_change
		dir = Vector2.LEFT.rotated(new_angle)
	emit_signal("walk", dir, delta)
	
	if disp.length() > radius and pause_cooldown < 0:
		emit_signal("idle")
		pause_timer = randf_range(2.0, 5.0)

func pursue(player: CharacterBody2D, delta: float):
	face_player(player)
	var direction := (player.global_position - me.global_position).normalized()
	var avoidance := Vector2.ZERO
	for mob in get_tree().get_nodes_in_group("mob"):
		if mob == me:
			continue
		var to_mob :Vector2 = me.global_position - mob.global_position
		var dist := to_mob.length()
		if dist < spread:
			avoidance += to_mob.normalized() / dist
		direction += avoidance
		direction = direction.normalized()
	emit_signal("sprint", direction, delta)


func attack(player: CharacterBody2D):
	face_player(player)
	if primary:
		emit_signal("primary_attack")
	elif projectile:
		emit_signal("secondary_attack")

#==========================================
# Misc Functions
#==========================================

func detect_player() -> CharacterBody2D:
	var all_players := get_tree().get_nodes_in_group("player")
	var closest_player: CharacterBody2D = null
	var closest_dist: float = INF
	
	for this_player in all_players as Array[CharacterBody2D]:
		var disp: Vector2 = this_player.global_position - me.global_position
		var dist: float = disp.length()
		
		if disp.x * velocity.direction < 0 and dist > RNG:
			continue
		
		var target_pos: Vector2 = me.to_local(this_player.global_position)
		if dist > VIS:
			target_pos = target_pos.normalized() * VIS
		vision_ray.target_position = target_pos
		vision_ray.force_raycast_update()
		
		if vision_ray.is_colliding():
			var collider = vision_ray.get_collider()
			if collider == this_player and dist < closest_dist:
				closest_player = this_player
				closest_dist = dist
	
	return closest_player

func face_player(player: CharacterBody2D):
	if (player.global_position - me.global_position).x * velocity.direction < 0:
		velocity.flip_character()

@export var projectile_frame:int
func launch_projectile():
	var player = detect_player()
	if sprite.animation == "secondary" and sprite.frame == projectile_frame and player:
		projectile_sfx.play()
		var new_projectile: Projectile = projectile.instantiate()
		new_projectile.global_position = me.global_position + Vector2(velocity.direction*projectile_offset.x, projectile_offset.y)
		new_projectile.target = (player.global_position - new_projectile.global_position).normalized()
		me.add_sibling(new_projectile)
