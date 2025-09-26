extends Control

@onready var PFP: TextureRect = self.find_child("Profile")
@onready var HP_Bar: ProgressBar  = self.find_child("HP")
@onready var STM_Bar: ProgressBar  = self.find_child("STM")
@onready var Heals: Label = self.find_child("Count")
@onready var SP_icon: TextureRect = self.find_child("SP")
@onready var timer: Label = self.find_child("Time")


var player : CharacterBody2D
var HP: Health
var STM: Stamina
var SP: Special_Handler
var current_time_in_seconds: float = 0
var sp_icon_file: Resource = preload("res://Assets/super.png")

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	HP = player.find_child("Health")
	STM = player.find_child("Stamina")
	SP = player.find_child("Special")

	HP_Bar.max_value = HP.HP
	STM_Bar.max_value = STM.STM

	var pfp_path = player.get_meta("pfp_path")
	PFP.texture = load(pfp_path)

func _process(_delta: float) -> void:
	if player:
		HP_Bar.value = HP.current_hp
		STM_Bar.value = STM.current_stm
		Heals.text = str(HP.Heals)
		current_time_in_seconds += _delta
		timer.text = s_to_hms(current_time_in_seconds)
		if SP.boosted():
			SP_icon.texture = sp_icon_file
		else:
			SP_icon.texture = null
	else: self.queue_free()

func s_to_hms(num_seconds: int) -> String:
	var hours: int = num_seconds / 3600
	var minutes: int = (num_seconds % 3600) / 60
	var seconds: int = num_seconds % 60
	return "%02d:%02d:%02d" % [hours, minutes, seconds]
