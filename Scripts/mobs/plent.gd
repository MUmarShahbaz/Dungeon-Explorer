extends Enemy

@onready var attack_1_zone: Area2D = $Attack_1_Zone
@onready var attack_2_zone: Area2D = $Attack_2_Zone
@onready var attack_3_zone: Area2D = $Attack_3_Zone

func _ready():
	super._ready()
	sprite = $Sprite
	collider = $Collider
	vision_ray = $Vision_Ray
	obstacle_check_left = $Obstacle_Check_Left
	obstacle_check_right = $Obstacle_Check_Right
	connect_animations()
	combo = ["attack_1", "attack_2", "attack_3"]
	current_HP = HP
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if rng.randi_range(0, 1) == 0:
		flip()
	state_update(states.patrol)

func _frame_changed() -> void:
	if sprite.frame == 2 and sprite.animation == "attack_1":
		give_damage(attack_1_zone)
	if sprite.frame == 1 and sprite.animation == "attack_2":
		give_damage(attack_2_zone)
	if sprite.frame == 4 and sprite.animation == "attack_3":
		give_damage(attack_3_zone)

func flip():
	super.flip()
	attack_1_zone.scale.x *= -1
	attack_2_zone.scale.x *= -1
	attack_3_zone.scale.x *= -1
