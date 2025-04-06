extends Node

var level_data: Dictionary
var token: String

var category0_max: int = 1
var category1_max: int = 12
var category2_max: int = 0
var category3_max: int = 1
var category4_max: int = 0
var category5_max: int = 0

var tiles: Dictionary  = {
	"ground": Vector2i(0,1),
	"bill": Vector2i(0,2),
	"spike": Vector2i(0,3),
	"cannon": Vector2i(1,3),
	"slime": Vector2i(0,4),
	"spawner": Vector2i(0,5)
}

func read_level_data(tilemap: TileMapLayer):
	if level_data:
		var level_tiles = level_data["tiles"]
		for level_tile in level_tiles:
			tilemap.set_cell(Vector2i(level_tile["pos_x"], level_tile["pos_y"]), 0, \
			Vector2i(level_tile["atlas_x"], level_tile["atlas_y"]), level_tile["rot"])
			
func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("players").is_empty():
		if get_tree().current_scene.name == "LevelManufacturer":
			get_tree().reload_current_scene()
