extends Enemy

@onready var attack_zones: Array[Area2D] = [$Attack_1_Zone, $Attack_2_Zone, $Attack_3_Zone]
var main_combo: Array[String] = ["attack_1", "attack_2", "attack_3"]

# For timing the atttcaks by frame
func _frame_changed() -> void:
	if sprite.frame == 3 and sprite.animation == "attack_1":
		give_damage(attack_zones[0])
	if sprite.frame == 3 and sprite.animation == "attack_2":
		give_damage(attack_zones[1])
	if sprite.frame == 2 and sprite.animation == "attack_3":
		give_damage(attack_zones[2])

# DO NOT TOUCH
func _ready():
	super._ready()
	sprite = $Sprite
	collider = $Collider
	vision_ray = $Vision_Ray
	obstacle_check_left = $Obstacle_Check_Left
	obstacle_check_right = $Obstacle_Check_Right
	connect_animations()
	combo = main_combo
	current_HP = HP
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if rng.randi_range(0, 1) == 0:
		flip()
	state_update(states.patrol)

func flip():
	super.flip()
	for zone in attack_zones:
		zone.scale.x *= -1
