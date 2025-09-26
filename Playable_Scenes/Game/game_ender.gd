extends Node

@onready var player_health: Health = get_tree().get_first_node_in_group("player").find_child("Health")
@onready var display_text: Label = $"../CanvasLayer/DISP"

var next_game: PackedScene

func _ready() -> void:
	player_health.die.connect(Callable(self, "respawn"))
	next_game = preload("res://Playable_Scenes/Game/game.tscn")
	
func respawn():
	display_text.text = "YOU LOSE"
	var timer := Timer.new()
	timer.wait_time = 1.5
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	get_tree().change_scene_to_packed(next_game)

func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("mob").is_empty():
		display_text.text = "YOU WIN"
		var timer := Timer.new()
		timer.wait_time = 3.0
		timer.one_shot = true
		add_child(timer)
		timer.start()
		await timer.timeout
		get_tree().change_scene_to_file("res://Playable_Scenes/Main Menu/main_menu.tscn")
