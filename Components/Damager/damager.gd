extends Node
class_name Damager

#===========================================
#                  Vars
#===========================================

# Nodes
@export var sprite: AnimatedSprite2D
@export var health: Health
@export var special: Special_Handler
@export var velocity: Velocity

# Primary
@export var primary_damage: int
@export var atk1_frame: int
@export var atk2_frame: int
@export var atk3_frame: int
@export var attack_p_zone: Area2D

# Special
@export var special_damage: int
@export var special_frames: Array[int]
@export var attack_s_zone: Area2D
@export var attack_boost_percentage: float
@export var max_attack: int
@export var defense_boost_percentage: float
@export var max_defense: int

func _ready():
	connect_sprite()
	connect_velocity()

func connect_sprite():
	sprite.frame_changed.connect(Callable(self, "giver"))

func connect_velocity():
	velocity.flip.connect(Callable(self, "flip_zones"))
#===========================================
#                  Give
#===========================================

func giver():
	var atk1:bool = (sprite.animation == "attack_1" and sprite.frame == atk1_frame)
	var atk2:bool = (sprite.animation == "attack_2" and sprite.frame == atk2_frame)
	var atk3:bool = (sprite.animation == "attack_3" and sprite.frame == atk3_frame)
	if atk1 or atk2 or atk3:
		var dmg = primary_damage
		if special and special.boosted():
			dmg = min(primary_damage*attack_boost_percentage, max_attack)
		for body in await check_colliders(attack_p_zone):
			if body is TileMapLayer: continue
			if obstruction_check(body): continue
			var body_velocity: Velocity = body.find_child("Velocity")
			var body_damager: Damager = body.find_child("Damager")
			var body_secondary: Secondary_Handler = body.find_child("Secondary")
			if body_secondary:
				if not (body_velocity.direction != velocity.direction and body_secondary.sheilding):
					body_damager.take(dmg)
			else:
				body_damager.take(dmg)
	if sprite.animation == "special" and sprite.frame in special_frames:
		for body in await check_colliders(attack_s_zone):
			(body.find_child("Damager") as Damager).take(special_damage)

#===========================================
#                  Take
#===========================================

func take(amount: float):
	if special and special.boosted():
		amount = min(amount - amount*health.DEF*defense_boost_percentage, max_defense)
		health.current_hp -= amount
	else:
		health.take_damage(amount)

#===========================================
#              Collider Check
#===========================================

func check_colliders(damage_zone: Area2D):
	var overlaps = damage_zone.get_overlapping_bodies()
	return overlaps

func obstruction_check(target: Node) -> bool:
	var ray: RayCast2D = get_parent().find_child("atk_ray")
	ray.target_position = get_parent().to_local(target.global_position)
	ray.force_raycast_update()
	var collider := ray.get_collider()
	if collider:
		print("yeah")
	if collider and collider is TileMapLayer:
		print("tile_map")
		return true
	return false

func flip_zones():
	if attack_p_zone:
		attack_p_zone.scale.x *= -1
	if attack_s_zone:
		attack_s_zone.scale.x *= -1
