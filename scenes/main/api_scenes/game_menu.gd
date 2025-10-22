extends Control

var http_request = HTTPRequest.new()

func _ready():
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	$VBoxContainer/MasterVolume.value = GlobalVariables.master_volume_value
	$VBoxContainer/MusicVolume.value = GlobalVariables.music_volume_value
	$VBoxContainer/SoundVolume.value = GlobalVariables.sound_volume_value
	
func get_random_level():
	var url = "https://stuffbystore.com/api/tsbm/get-random-level"
	var headers = [
		"Content-Type: application/json",
		"Accept: application/json"
	]

	http_request.request(url, headers, HTTPClient.METHOD_GET)
	
func get_level_by_code():
	var url: String
	if %LevelCode.text == "":
		url = "https://stuffbystore.com/api/tsbm/get-level-by-code/" + "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	else:
		url = "https://stuffbystore.com/api/tsbm/get-level-by-code/" + %LevelCode.text
	var headers = [
		"Content-Type: application/json",
		"Accept: application/json"
	]

	http_request.request(url, headers, HTTPClient.METHOD_GET)
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())

	if parse_result != OK:
		%StateLabel.text = "Failed to parse response."
		return
		
	var response = json.get_data()
	
	if response_code == 200:
		%StateLabel.text = str(response.get("message", "No message"))
		GlobalVariables.level_name = response.get("name")
		GlobalVariables.level_data = JSON.parse_string(response.get("data"))
		GlobalVariables.level_code = response.get("code")
		get_tree().change_scene_to_file("res://scenes/main/level_manufacturer.tscn")
	elif response_code == 404:
		%StateLabel.text = str(response.get("message", "No message"))
	else:
		%StateLabel.text = "Unexpected error. Code: " + str(response_code)

func _on_random_level_button_pressed():
	get_random_level()

func _on_search_by_code_button_pressed() -> void:
	get_level_by_code()

func _on_create_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/level_blueprint.tscn")
	
func _process(_delta: float) -> void:
	var master_db = linear_to_db($VBoxContainer/MasterVolume.value) -14
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_db)
	var music_db = linear_to_db($VBoxContainer/MusicVolume.value) -14
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_db)
	var sound_db = linear_to_db($VBoxContainer/SoundVolume.value) -14
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), sound_db)
	GlobalVariables.master_volume_value = $VBoxContainer/MasterVolume.value
	GlobalVariables.music_volume_value = $VBoxContainer/MusicVolume.value
	GlobalVariables.sound_volume_value = $VBoxContainer/SoundVolume.value
