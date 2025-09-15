extends Area2D

@export var character: PackedScene
@export var playing: bool

func _ready():
	spawn_player()

func spawn_player():
	var rect_shape := $CollisionShape2D.shape as RectangleShape2D
	if rect_shape == null:
		push_error("PlayerSpawner requires a RectangleShape2D")
		return
	var half = rect_shape.extents
	var parent = get_parent()
	if !character:
		return
	var player = character.instantiate()
	var local_pos = Vector2(half.x, half.y)
	player.global_position = global_position + local_pos
	parent.add_child.call_deferred(player)
	if playing:
		await player.ready
		player.load_as_current_player()
