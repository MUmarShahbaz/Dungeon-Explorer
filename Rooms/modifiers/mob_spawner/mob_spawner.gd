extends Area2D

@onready var collider: CollisionShape2D = $CollisionShape2D
@export var mobs: Array[PackedScene]
@export var count: int = 5

func _ready() -> void:
	if not collider: return
	var rectangle: RectangleShape2D = collider.shape
	for i in range(count):
		var new_mob = mobs[randi() % mobs.size()].instantiate()

		var offset = Vector2(
			randf_range(-rectangle.extents.x, rectangle.extents.x),
			randf_range(-rectangle.extents.y, rectangle.extents.y)
		)
		new_mob.global_position = collider.global_position + offset

		call_deferred("add_sibling", new_mob)
