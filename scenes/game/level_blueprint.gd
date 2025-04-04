extends Node2D

@onready var tilemap = $Tilemap
@onready var selected_tile_sprite = $SelectedTileSprite
var max: int
var selector: int
var category: int = 1

func _ready() -> void:
	GlobalVariables.read_level_data(tilemap)

func _process(_delta: float) -> void:
	max = GlobalVariables.get("category" + str(category) + "_max")
	
	if Input.is_action_pressed("place"):
		if category != 0:
			var mouse_pos = get_global_mouse_position()
			var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
			tilemap.set_cell(tile_mouse_pos, 0, Vector2i(selector, category))
		else:
			if selector == 0:
				save_level()
				get_tree().change_scene_to_file("res://scenes/game/level_manufacturer.tscn")
			elif selector == 1:
				save_level()
				get_tree().change_scene_to_file("res://scenes/game/authentication.tscn")
	elif Input.is_action_pressed("remove"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
		tilemap.erase_cell(tile_mouse_pos)
		
	if Input.is_action_just_pressed("next_tile"):
		selector += 1
		if selector > max:
			selector = 0
	elif Input.is_action_just_pressed("previous_tile"):
		selector -= 1
		if selector < 0:
			selector = max
			
	if Input.is_action_just_pressed("category0"):
		category = 0
	elif Input.is_action_just_pressed("category1"):
		category = 1
		
	var source: TileSetAtlasSource = tilemap.tile_set.get_source(0)
	var rect = source.get_tile_texture_region(Vector2i(selector, category))
	var image: Image = source.texture.get_image()
	var tile_image = image.get_region(rect)
	selected_tile_sprite.texture = ImageTexture.create_from_image(tile_image)
	selected_tile_sprite.global_position = get_global_mouse_position()
			
func save_level():
	var level_data: Array[Dictionary]
	var used_cells = tilemap.get_used_cells()
	for cell in used_cells:
		var atlas_coords = tilemap.get_cell_atlas_coords(cell)
		var level_tile: Dictionary[String, int] = {
			"pos_x": cell.x,
			"pos_y": cell.y,
			"atlas_x": atlas_coords.x,
			"atlas_y": atlas_coords.y
		}
		level_data.append(level_tile)
	GlobalVariables.level_data = level_data
