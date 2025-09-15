extends Control

var player: Player
@onready var Character_Portrait: TextureRect = $"Stats/Character Portrait"
@onready var HP_Bar: ProgressBar = $"Stats/Bars/HP"
@onready var STM_Bar: ProgressBar = $"Stats/Bars/STM"

func set_player(player_ref, portrait):
	player = player_ref
	Character_Portrait.texture = portrait
	HP_Bar.max_value = player.HP
	STM_Bar.max_value = player.STM
	update()

func update():
	HP_Bar.value = player.current_HP
	STM_Bar.value = player.current_STM
