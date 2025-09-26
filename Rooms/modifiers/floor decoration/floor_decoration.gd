extends TileMapLayer

@export var floor_tileMapLayer: TileMapLayer
@export_range(0.0, 1.0) var chance: float = 0.3   # initial chance per cell
@export var min_spacing: int = 2                  # minimum distance between placed tiles

# Hardcoded pattern tiles
var pattern_tiles = [
	{ "source": 1, "coords": Vector2i(0, 21), "alt": 0 },
	{ "source": 1, "coords": Vector2i(0, 22), "alt": 0 },
	{ "source": 1, "coords": Vector2i(1, 21), "alt": 0 },
	{ "source": 1, "coords": Vector2i(1, 22), "alt": 0 }
]

func _ready():
	randomize()
	fill_random_patterns()

func fill_random_patterns():
	clear()
	var used_rect = floor_tileMapLayer.get_used_rect()

	var min_x = used_rect.position.x + 1
	var max_x = used_rect.position.x + used_rect.size.x - 1
	var min_y = used_rect.position.y + 1
	var max_y = used_rect.position.y + used_rect.size.y - 1

	var placed: Array[Vector2i] = []

	for x in range(min_x, max_x):
		for y in range(min_y, max_y):
			var pos = Vector2i(x, y)
			if floor_tileMapLayer.get_cell_atlas_coords(pos) == Vector2i(1, 10): # only on base floor
				if randf() < chance and pattern_tiles.size() > 0:
					var too_close := false
					for other in placed:
						if pos.distance_to(other) < float(min_spacing):
							too_close = true
							break

					if not too_close:
						var tile_info = pattern_tiles[randi() % pattern_tiles.size()]
						set_cell(pos, tile_info.source, tile_info.coords, tile_info.alt)
						placed.append(pos)
