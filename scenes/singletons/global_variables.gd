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
			
var music_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
var previous_scene_name: String
var current_scene_name: String
func _ready() -> void:
	music_player.max_distance = 999999999
	music_player.attenuation = 0
	add_child(music_player)
func _process(delta: float) -> void:
	current_scene_name = get_tree().current_scene.name
	if current_scene_name != previous_scene_name:
		previous_scene_name = current_scene_name
		if current_scene_name == "LevelBlueprint":
			music_player.stream = preload("res://music/The Eternal Factory.ogg")
		elif current_scene_name == "LevelManufacturer":
			music_player.stream = preload("res://music/My Own Creation.ogg")
		music_player.play()
