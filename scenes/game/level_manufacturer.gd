extends Node2D

@onready var tilemap = $Tilemap

var no_players_reload: bool = true

func _ready() -> void:
	GlobalVariables.read_level_data(tilemap)
	
	var used_cells = tilemap.get_used_cells()
	
	for cell in used_cells:
		var atlas_coords = tilemap.get_cell_atlas_coords(cell)
		var tile
		var tile_rotation = tilemap.get_cell_alternative_tile(cell)
		if atlas_coords == GlobalVariables.tiles["bill"]:
			tile = preload("res://scenes/players/bill.tscn").instantiate()
		elif atlas_coords == GlobalVariables.tiles["spike"]:
			tile = preload("res://scenes/tiles/spike.tscn").instantiate()
		elif atlas_coords == GlobalVariables.tiles["slime"]:
			tile = preload("res://scenes/enemies/slime.tscn").instantiate()
		elif atlas_coords == GlobalVariables.tiles["cannon"]:
			tile = preload("res://scenes/tiles/cannon.tscn").instantiate()
		elif atlas_coords == GlobalVariables.tiles["platform"]:
			tile = preload("res://scenes/tiles/platform.tscn").instantiate()
		elif atlas_coords == GlobalVariables.tiles["falling_platform"]:
			tile = preload("res://scenes/tiles/falling_platform_spawner.tscn").instantiate()
		elif atlas_coords == GlobalVariables.tiles["goal"]:
			tile = preload("res://scenes/tiles/goal.tscn").instantiate()
		elif atlas_coords == GlobalVariables.tiles["key_lock"]:
			tile = preload("res://scenes/tiles/key_lock.tscn").instantiate()
		elif atlas_coords == GlobalVariables.tiles["key_block"]:
			tile = preload("res://scenes/tiles/key_block.tscn").instantiate()
		elif atlas_coords == GlobalVariables.tiles["beholder"]:
			tile = preload("res://scenes/enemies/beholder.tscn").instantiate()
			
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
	if no_players_reload:
		no_players_reload = false
		if get_tree().get_nodes_in_group("players").is_empty():
			GlobalVariables.keys = 0
			get_tree().change_scene_to_file("res://scenes/game/level_blueprint.tscn")
	if Input.is_action_just_pressed("edit"):
		GlobalVariables.keys = 0
		get_tree().change_scene_to_file("res://scenes/game/level_blueprint.tscn")
	if get_tree():
		if get_tree().get_nodes_in_group("players").is_empty():
			get_tree().reload_current_scene()
			
func _on_return_to_menu_pressed() -> void:
	GlobalVariables.return_to_menu()
