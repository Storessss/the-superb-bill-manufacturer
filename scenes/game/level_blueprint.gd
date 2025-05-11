extends Node2D

@onready var tilemap = $Tilemap
@onready var selected_tile_sprite = $SelectedTileSprite
var max: int
var selector: int
var category: int = 1

var flip_h := TileSetAtlasSource.TRANSFORM_FLIP_H
var flip_v := TileSetAtlasSource.TRANSFORM_FLIP_V
var transpose := TileSetAtlasSource.TRANSFORM_TRANSPOSE

var tile_transforms := {
	Vector2i(0, -1): [0],
	Vector2i(1, 0): [flip_h, transpose],
	Vector2i(0, 1): [flip_v, flip_h],
	Vector2i(-1, 0): [flip_v, transpose]
}

var tile_direction := Vector2i(0, 1)
var applied_transform: int

func rotate_tile():
	tile_direction = Vector2i(tile_direction[1] * -1, tile_direction[0])
	get_applied_transform()
	redraw_tile()
	
func get_applied_transform():
	applied_transform = 0
	for i in tile_transforms[tile_direction]:
		applied_transform += i
		
func redraw_tile():
	var mouse_pos = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	tilemap.set_cell(tile_mouse_pos, 0, Vector2i(selector, category), applied_transform)

func _ready() -> void:
	GlobalVariables.read_level_data(tilemap)
	for i in range(8):
		var source: TileSetAtlasSource = tilemap.tile_set.get_source(0)
		var rect = source.get_tile_texture_region(Vector2i(0, i))
		var image: Image = source.texture.get_image()
		var tile_image = image.get_region(rect)
		var hotbar_button: TextureButton = TextureButton.new()
		hotbar_button.texture_normal = ImageTexture.create_from_image(tile_image)
		hotbar_button.custom_minimum_size = Vector2(40, 40)
		hotbar_button.stretch_mode = TextureButton.STRETCH_SCALE
		hotbar_button.set_meta("category_index", i)
		hotbar_button.connect("pressed", Callable(self, "_on_category_hotbar_button_pressed").bind(hotbar_button))
		$Hud/CategoryHotbar.add_child(hotbar_button)
		
func _on_category_hotbar_button_pressed(category_button: TextureButton) -> void:
	for child in $Hud/TileHotbar.get_children():
		child.queue_free()
	category = category_button.get_meta("category_index")
	for i in range(GlobalVariables.get("category" + str(category) + "_max") + 1):
		var source: TileSetAtlasSource = tilemap.tile_set.get_source(0)
		var rect = source.get_tile_texture_region(Vector2i(i, category))
		var image: Image = source.texture.get_image()
		var tile_image = image.get_region(rect)
		var hotbar_button: TextureButton = TextureButton.new()
		hotbar_button.texture_normal = ImageTexture.create_from_image(tile_image)
		hotbar_button.custom_minimum_size = Vector2(40, 40)
		hotbar_button.stretch_mode = TextureButton.STRETCH_SCALE
		hotbar_button.set_meta("tile_index", i)
		hotbar_button.connect("pressed", Callable(self, "_on_tile_hotbar_button_pressed").bind(hotbar_button))
		$Hud/TileHotbar.add_child(hotbar_button)
		
func _on_tile_hotbar_button_pressed(tile_button: TextureButton) -> void:
	selector = tile_button.get_meta("tile_index")

func _process(delta: float) -> void:
	max = GlobalVariables.get("category" + str(category) + "_max")
	
	if Input.is_action_pressed("place"):
		if get_viewport().get_mouse_position().y < $Hud/ColorRect.global_position.y:
			if category != 0:
				var mouse_pos = get_global_mouse_position()
				var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
				tilemap.set_cell(tile_mouse_pos, 0, Vector2i(selector, category ))
			else:
				if selector == 0:
					save_level()
					get_tree().change_scene_to_file("res://scenes/game/level_manufacturer.tscn")
				elif selector == 1:
					save_level()
					print(GlobalVariables.level_data)
					get_tree().change_scene_to_file("res://scenes/game/api_scenes/save_level.tscn")
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
			
	if Input.is_action_just_pressed("category1"):
		category = 0
		selector = 0
	elif Input.is_action_just_pressed("category2"):
		category = 1
		selector = 0
	elif Input.is_action_just_pressed("category3"):
		category = 2
		selector = 0
	elif Input.is_action_just_pressed("category4"):
		category = 3
		selector = 0
	elif Input.is_action_just_pressed("category5"):
		category = 4
		selector = 0
	elif Input.is_action_just_pressed("category6"):
		category = 5
		selector = 0
		
	var source: TileSetAtlasSource = tilemap.tile_set.get_source(0)
	var rect = source.get_tile_texture_region(Vector2i(selector, category))
	var image: Image = source.texture.get_image()
	var tile_image = image.get_region(rect)
	selected_tile_sprite.texture = ImageTexture.create_from_image(tile_image)
	selected_tile_sprite.global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("rotate"):
		rotate_tile()
		
	var direction = Input.get_vector("left", "right", "up", "down")
	$Camera2D.position += direction * 300 * delta
			
func save_level():
	var level_data: Dictionary
	var used_cells = tilemap.get_used_cells()
	var level_tiles: Array
	for cell in used_cells:
		var atlas_coords = tilemap.get_cell_atlas_coords(cell)
		var tile_rotation = tilemap.get_cell_alternative_tile(cell)
		var level_tile: Dictionary[String, int] = {
			"pos_x": cell.x,
			"pos_y": cell.y,
			"atlas_x": atlas_coords.x,
			"atlas_y": atlas_coords.y,
			"rot": tile_rotation
		}
		level_tiles.append(level_tile)
	level_data["tiles"] = level_tiles
	GlobalVariables.level_data = level_data
