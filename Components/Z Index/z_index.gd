extends Node
class_name Z_Indexer

@export var offset: int = 0
@onready var character: Node2D = get_parent()

func _process(_delta: float) -> void:
	if character:
		character.z_index = int(character.position.y + offset)
