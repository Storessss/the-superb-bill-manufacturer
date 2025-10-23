extends Control

var http_request = HTTPRequest.new()

func _ready():
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	
	
func save_level():
	var url = "https://stuffbystore.com/api/tsbm/save-level"
	var headers = [
		"Content-Type: application/json",
		"Accept: application/json"
	]
	var body = {
		"name": %LevelName.text,
		"data": JSON.stringify(GlobalVariables.level_data)
	}
	var json_body = JSON.stringify(body)

	http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)

func _on_save_level_button_pressed():
	save_level()

func _on_copy_code_pressed():
	DisplayServer.clipboard_set(%LevelCode.text)
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())

	if parse_result != OK:
		%StateLabel.text = "Failed to parse response."
		return
		
	var response = json.get_data()
	if response_code == 200:
		%StateLabel.text = str(response.get("message", "No message"))
		%SaveLevelButton.visible = false
		%ReturnToLevelBuilder.visible = false
		%LevelCode.text = response.get("code")
	elif response_code == 422:
		var errors = response.get("errors", {})
		var error_text = str(response.get("message", "No message")) + "\n"
		for field in errors.keys():
			error_text += field + ": " + str(errors[field][0]) + "\n"
		%StateLabel.text = error_text
	elif response_code == 429:
		%StateLabel.text = "Too many requests, please wait a bit and then retry."
	else:
		%StateLabel.text = "Unexpected error. Code: " + str(response_code)

func _on_return_to_level_builder_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/level_blueprint.tscn")
func _on_return_to_menu_pressed() -> void:
	GlobalVariables.return_to_menu()
