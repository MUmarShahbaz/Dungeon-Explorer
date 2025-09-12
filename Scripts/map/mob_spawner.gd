extends Area2D

@export var mob_scenes: Array[PackedScene] = []
@export var mob_count: int = 5

func _ready():
	spawn_mobs()

func spawn_mobs():
	var rect_shape := $CollisionShape2D.shape as RectangleShape2D
	if rect_shape == null:
		push_error("MobSpawner requires a RectangleShape2D")
		return

	var half_size = rect_shape.extents
	var parent = get_parent()

	for i in mob_count:
		if mob_scenes.is_empty():
			return

		# Pick a random mob scene
		var mob_scene: PackedScene = mob_scenes[randi() % mob_scenes.size()]
		var mob = mob_scene.instantiate()

		# Pick a random position inside the rectangle
		var local_x = randf_range(-half_size.x, half_size.x)
		var local_y = randf_range(-half_size.y, half_size.y)
		var local_pos = Vector2(local_x, local_y)

		# Convert to global space and assign position
		mob.global_position = global_position + local_pos

		# Add as a sibling
		parent.add_child.call_deferred(mob)
