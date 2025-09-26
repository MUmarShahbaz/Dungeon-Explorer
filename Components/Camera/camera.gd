extends Camera2D

@export var target: CharacterBody2D
@export var smoothing: float = 0.1
@export var offset_distance: Vector2 = Vector2(300, 160)
var target_offset: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	if target:
		global_position = lerp(global_position, target.global_position + target_offset, smoothing)

func set_target_offset(new_offset: Vector2):
	target_offset.x = new_offset.x * offset_distance.x
	target_offset.y = new_offset.y * offset_distance.y
