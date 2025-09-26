extends Node2D

@onready var map: TextureButton = find_child("Map")
@onready var play: Button = find_child("Play")

@export var map_url: String

var game = preload("res://Playable_Scenes/Game/game.tscn")

func _ready() -> void:
	map.pressed.connect(Callable(self, "open_map"))
	play.pressed.connect(Callable(self, "play_game"))

func open_map():
	OS.shell_open(map_url)

func play_game():
	get_tree().change_scene_to_packed(game)
