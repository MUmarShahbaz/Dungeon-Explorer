extends Enemy

@onready var attack_1_zone: Area2D = $Attack_1_Zone
@onready var attack_2_zone: Area2D = $Attack_2_Zone

func init_vals():
	combo = ["attack_1", "attack_2"]

func _damage_handler() -> void:
	if sprite.frame == 2 and sprite.animation == "attack_1":
		give_damage(attack_1_zone)
	if sprite.frame == 2 and sprite.animation == "attack_2":
		give_damage(attack_2_zone)

func flip_damage_zones() -> void:
	attack_1_zone.scale.x *= -1
	attack_2_zone.scale.x *= -1
