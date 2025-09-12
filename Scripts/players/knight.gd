extends Player

@onready var attack_1_zone: Area2D = $Attack_1_Zone
@onready var attack_2_zone: Area2D = $Attack_2_Zone
@onready var attack_3_zone: Area2D = $Attack_3_Zone

var controller
func _ready() -> void:
	super._ready()
	sprite = $Sprite
	collider = $Collider
	connect_animations()
	combo = ["attack_1", "attack_2", "attack_3"]
	current_HP = HP
	controller = Input_Controller.new(self)

func _physics_process(delta: float) -> void:
	if !alive:
		return
	super._physics_process(delta)
	controller.update()

func _frame_changed():
	if sprite.frame == 4 and sprite.animation == "attack_1":
		give_damage(attack_1_zone)
	if sprite.frame == 2 and sprite.animation == "attack_2":
		give_damage(attack_1_zone)
	if sprite.frame == 2 and sprite.animation == "attack_3":
		give_damage(attack_1_zone)

func flip():
	super.flip()
	attack_1_zone.scale.x *= -1
	attack_2_zone.scale.x *= -1
	attack_3_zone.scale.x *= -1
