extends Node2D

@onready var tilemap = $Tilemap

var tiles: Dictionary  = {
	"ground": Vector2i(0,1),
	"bill": Vector2i(1,1),
	"spike": Vector2i(2,1)
}

func _ready() -> void:
	GlobalVariables.read_level_data(tilemap)
	
	var used_cells = tilemap.get_used_cells()
	
	for cell in used_cells:
		var atlas_coords = tilemap.get_cell_atlas_coords(cell)
		var tile
		var tile_rotation = tilemap.get_cell_alternative_tile(cell)
		if atlas_coords == tiles["bill"]:
			tile = preload("res://scenes/players/bill.tscn").instantiate()
		elif atlas_coords == tiles["spike"]:
			tile = preload("res://scenes/tiles/spike.tscn").instantiate()
			
		if tile != null:
			tile.global_position = tilemap.map_to_local(cell)
			if tile_rotation == 0:
				tile.rotation = deg_to_rad(0)
			elif tile_rotation == 20480:
				tile.rotation = deg_to_rad(90)
			elif tile_rotation == 12288:
				tile.rotation = deg_to_rad(180)
			elif tile_rotation == 24576:
				tile.rotation = deg_to_rad(270)
			add_child(tile)
			tilemap.erase_cell(cell)
		
func _process(_delta: float):
	if Input.is_action_just_pressed("place"):
		get_tree().change_scene_to_file("res://scenes/game/level_blueprint.tscn")
