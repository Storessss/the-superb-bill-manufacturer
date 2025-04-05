extends Control

var http_request = HTTPRequest.new()

func _ready():
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))

func register():
	#var url = "http://localhost:8000/api/register"
	var url = "https://yellow-yellow-bird.fun/api/register"
	var headers = ["Content-Type: application/json"]
	var body = {
		"name": %RegisterUsername.text,
		"email": %RegisterEmail.text,
		"password": %RegisterPassword.text,
		"confirm_password": %RegisterConfirm.text,
	}
	var json_body = JSON.stringify(body)

	http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)
	
func login():
	#var url = "http://localhost:8000/api/login"
	var url = "https://yellow-yellow-bird.fun/api/login"
	var headers = ["Content-Type: application/json"]
	var body = {
		"email": %LoginEmail.text,
		"password": %LoginPassword.text,
	}
	var json_body = JSON.stringify(body)

	http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())

	if parse_result != OK:
		%StateLabel.text = "Failed to parse response."
		return
		
	var response = json.get_data()
	
	if response_code == 200:
		%StateLabel.text = str(response.get("message", "No message"))
		if response.has("token") and response.get("token") != null:
			GlobalVariables.token = response.get("token")
			get_tree().change_scene_to_file("res://scenes/game/save_level.tscn")
	elif response_code == 422:
		var errors = response.get("errors", {})
		var error_text = str(response.get("message", "No message")) + "\n"
		for field in errors.keys():
			error_text += field + ": " + str(errors[field][0]) + "\n"
		%StateLabel.text = error_text
	elif response_code == 401:
		%StateLabel.text = str(response.get("message", "No message"))
	else:
		%StateLabel.text = "Unexpected error. Code: " + str(response_code)

func _on_sign_up_button_pressed():
	register()

func _on_sign_in_button_pressed():
	login()
