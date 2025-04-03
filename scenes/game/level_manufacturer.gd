extends Node2D

@onready var tilemap = $Tilemap

var tiles: Dictionary  = {
	"ground": Vector2i(0,0),
	"bill": Vector2i(1,0),
	"spike": Vector2i(2,0)
}

func _ready() -> void:
	GlobalVariables.read_level_data(tilemap)
	
	var used_cells = tilemap.get_used_cells()
	
	for cell in used_cells:
		var atlas_coords = tilemap.get_cell_atlas_coords(cell)
		if atlas_coords == tiles["bill"]:
			var bill = preload("res://scenes/players/bill.tscn").instantiate()
			bill.global_position = tilemap.map_to_local(cell)
			add_child(bill)
			tilemap.erase_cell(cell)
