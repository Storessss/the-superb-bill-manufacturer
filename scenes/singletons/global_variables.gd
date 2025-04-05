extends Node

var level_data: Dictionary
var token: String

var category0_max: int = 1
var category1_max: int = 2

func read_level_data(tilemap: TileMapLayer):
	if level_data:
		var level_tiles = level_data["tiles"]
		for level_tile in level_tiles:
			tilemap.set_cell(Vector2i(level_tile["pos_x"], level_tile["pos_y"]), 0, \
			Vector2i(level_tile["atlas_x"], level_tile["atlas_y"]), level_tile["rot"])
