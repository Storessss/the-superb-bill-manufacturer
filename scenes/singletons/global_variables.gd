extends Node

var level: String = ''

var category0_max: int = 1
var category1_max: int = 2

func read_level_data(tilemap: TileMapLayer):
	if level != "":
		var level_data = JSON.parse_string(level)
		var level_tiles = level_data["tiles"]
		
		for level_tile in level_tiles:
			tilemap.set_cell(Vector2i(level_tile["pos_x"], level_tile["pos_y"]), 0, \
			Vector2i(level_tile["atlas_x"], level_tile["atlas_y"]))
