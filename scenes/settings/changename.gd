extends Button
var newUsername
@export var textedit : TextEdit




signal requestCompleted

func send_put_request(newUsername: String) -> void:
	print('Sending PUT request')
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Ensure to connect to request_completed
	http_request.request_completed.connect(_on_request_completed)
	
	# URL formatting	
	var url = "https://sigmaclicker.kinhome.org/users/%s" % GameInstance.data.id
	var json = {
		"new_name" = newUsername
	}
	# Make the request
	var error = http_request.request(url, ["Content-Type: application/json"], HTTPClient.METHOD_PUT, JSON.stringify(json))
	
	if error != OK:
		print("Request error: ", error)
	else:
		print("PUT request sent successfully")


# This function is triggered when the HTTP request completes
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		print('name changed')
	else:
		print("HTTP error: ", response_code)


func _on_pressed() -> void:
	if textedit.text.length() < 16:
		GameInstance.data.username = newUsername
		send_put_request(newUsername)
	else:
		return


func _on_text_edit_text_changed() -> void:
	newUsername = textedit.text
	if textedit.text.length() < 16:
		disabled = false
	else:
		disabled = true	
