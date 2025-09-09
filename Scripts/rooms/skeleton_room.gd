extends Node2D

@export var skeleton_scene: PackedScene
@export var skeleton_count: int = 10

@onready var world_border: StaticBody2D = $World_Border
@onready var left_wall: CollisionShape2D = $World_Border/left
@onready var right_wall: CollisionShape2D = $World_Border/right
@onready var up_wall: CollisionShape2D = $World_Border/up
@onready var down_wall: CollisionShape2D = $World_Border/down

func _ready():
	spawn_skeletons()

func spawn_skeletons():
	# Get the bounding box using the collision shapes’ positions
	var left_x = left_wall.position.x
	var right_x = right_wall.position.x
	var top_y = up_wall.position.y
	var bottom_y = down_wall.position.y
	
	# Ensure min/max order
	var min_x = min(left_x, right_x)
	var max_x = max(left_x, right_x)
	var min_y = min(top_y, bottom_y)
	var max_y = max(top_y, bottom_y)
	
	for i in skeleton_count:
		var skeleton = skeleton_scene.instantiate()
		var random_x = randf_range(min_x, max_x)
		var random_y = randf_range(min_y, max_y)
		skeleton.position = Vector2(random_x, random_y)
		add_child(skeleton)
