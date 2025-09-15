extends Camera2D

var smoothing: float = 0.1
var target: CharacterBody2D

func _ready() -> void:
	if get_parent() is CharacterBody2D:
		target = get_parent()

func _process(_delta: float) -> void:
	if target:
		global_position = lerp(global_position, target.global_position, smoothing)
