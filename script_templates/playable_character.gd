extends Player

@onready var attack_zones: Array[Area2D] = [$Attack_1_Zone, $Attack_2_Zone, $Attack_3_Zone]
@export var portrait: Resource
var main_combo: Array[String] = ["attack_1", "attack_2", "attack_3"]

# For timing the atttcaks by frame
func _frame_changed():
	if sprite.frame == 4 and sprite.animation == "attack_1":
		give_damage(attack_zones[0])
	if sprite.frame == 2 and sprite.animation == "attack_2":
		give_damage(attack_zones[1])
	if sprite.frame == 2 and sprite.animation == "attack_3":
		give_damage(attack_zones[2])

# DO NOT TOUCH
var controller
var HUD: Control

func _ready() -> void:
	super._ready()
	sprite = $Sprite
	collider = $Collider
	connect_animations()
	combo = main_combo
	current_HP = HP
	current_STM = STM

func _physics_process(delta: float) -> void:
	if !alive:
		return
	super._physics_process(delta)
	if controller:
		controller.update()
	if HUD:
		HUD.update()

func flip():
	super.flip()
	for zone in attack_zones:
		zone.scale.x *= -1
	
func load_as_current_player():
	controller = Input_Controller.new(self)
	add_child(Player_Camera.new())
	HUD = $"../CanvasLayer/HUD"
	HUD.set_player(self, portrait)

func die():
	if HUD:
		$"../CanvasLayer".remove_child(HUD)
	super.die()
