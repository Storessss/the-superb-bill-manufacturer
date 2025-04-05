extends Control

var http_request = HTTPRequest.new()

func _ready():
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	
	
func get_random_level():
	#var url = "http://localhost:8000/api/get-random-level"
	var url = "https://yellow-yellow-bird.fun/api/get-random-level"
	var headers = ["Content-Type: application/json"]

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
		GlobalVariables.level_data = JSON.parse_string(response.get("level_data"))
		get_tree().change_scene_to_file("res://scenes/game/level_manufacturer.tscn")
	elif response_code == 404:
		%StateLabel.text = str(response.get("message", "No message"))
	else:
		%StateLabel.text = "Unexpected error. Code: " + str(response_code)

func _on_random_level_button_pressed():
	get_random_level()
