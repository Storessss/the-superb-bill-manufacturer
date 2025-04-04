extends Control

var http_request = HTTPRequest.new()

func _ready():
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))

func register_and_save():
	var url = "http://localhost:8000/api/register-and-save"
	var headers = ["Content-Type: application/json"]
	var body = {
		"name": %RegisterUsername.text,
		"email": %RegisterEmail.text,
		"password": %RegisterPassword.text,
		"confirm_password": %RegisterConfirm.text,
		"level_data": GlobalVariables.level_data
	}
	var json_body = JSON.stringify(body)

	http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)
	
func login_and_save():
	var url = "http://localhost:8000/api/login-and-save"
	var headers = ["Content-Type: application/json"]
	var body = {
		"email": %LoginEmail.text,
		"password": %LoginPassword.text,
		"level_data": GlobalVariables.level_data
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
		%StateLabel.text = "Successful: " + str(response.get("message", "No message"))
	elif response_code == 422:
		var errors = response.get("errors", {})
		var error_text = "Validation failed:\n"
		for field in errors.keys():
			error_text += field + ": " + str(errors[field][0]) + "\n"
		%StateLabel.text = error_text
	elif response_code == 401:
		%StateLabel.text = "Failed: incorrect login"
	else:
		%StateLabel.text = "Unexpected error. Code: " + str(response_code)

func _on_sign_up_button_pressed():
	register_and_save()
