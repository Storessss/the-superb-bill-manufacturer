extends Node

var level_name: String
var level_data: Dictionary
var level_code: String

var max_categories: int = 9
var category0_max: int = 1
var category1_max: int = 12
var category2_max: int = 1
var category3_max: int = 1
var category4_max: int = 2
var category5_max: int = 2
var category6_max: int = 3
var category7_max: int = 2
var category8_max: int = 1

var tiles: Dictionary  = {
	"bill": Vector2i(0,2),
	"goal": Vector2i(1,2),
	"spike": Vector2i(0,3),
	"cannon": Vector2i(1,3),
	"slime": Vector2i(0,4),
	"beholder": Vector2i(1,4),
	"platform": Vector2i(0,7),
	"falling_platform": Vector2i(1,7),
	"key_lock": Vector2i(0,8),
	"key_block": Vector2i(1,8)
}

var keys: int
signal level_win

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
	if get_tree().current_scene:
		current_scene_name = get_tree().current_scene.name
		if current_scene_name != previous_scene_name:
			previous_scene_name = current_scene_name
			if current_scene_name == "LevelBlueprint":
				music_player.stream = preload("res://music/The Eternal Factory.ogg")
				music_player.play()
			elif current_scene_name == "LevelManufacturer":
				music_player.stream = preload("res://music/My Own Creation.ogg")
				music_player.play()
			else:
				music_player.stop()
				
	for player: AudioStreamPlayer2D in sound_players:
		if not player.playing:
			player.queue_free()
			sound_players.erase(player)
				
				
var sound_players: Array

func new_sound_player(db: int = 0) -> AudioStreamPlayer2D:
	var sound_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	sound_player.bus = "Sounds"
	sound_player.volume_db = db
	sound_player.max_distance = 999999999
	sound_player.attenuation = 0
	add_child(sound_player)
	sound_players.append(sound_player)
	return sound_player
	
func bullet_hit_wall_sound() -> void:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/bullet_wall_hit.wav")
	sound_player.play()

func level_win_sound() -> void:
	var sound_player = new_sound_player(0)
	sound_player.stream = preload("res://sounds/level_win.wav")
	sound_player.play()
	
func key_get_sound() -> void:
	var sound_player = new_sound_player(10)
	sound_player.stream = preload("res://sounds/key_get.wav")
	sound_player.play()
	
func lock_unlock_sound() -> void:
	var sound_player = new_sound_player(15)
	sound_player.stream = preload("res://sounds/lock_unlock.wav")
	sound_player.play()
	
func death_sound() -> void:
	var sound_player = new_sound_player(2)
	sound_player.stream = preload("res://sounds/death_sound.wav")
	sound_player.play()
	
func return_to_menu() -> void:
	GlobalVariables.level_data = {}
	GlobalVariables.level_name = ""
	GlobalVariables.level_code = ""
	get_tree().change_scene_to_file("res://scenes/game/api_scenes/game_menu.tscn")
	
