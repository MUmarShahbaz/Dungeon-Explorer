extends Enemy

func _ready() -> void:
	add_to_group("enemies")
	HP = 100
	DMG = 10
	SPD = 50
	RNG = 50
	VIS = 150
	TYP = enemy_type.melee
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if rng.randi_range(0, 1) == 0:
		flip_character()

func attack_sequence(delta, player):
	sprite.animation = "attack"
