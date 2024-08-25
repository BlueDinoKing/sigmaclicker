class_name ResourceLabel
extends ItemList

func seconds_to_hms(seconds: int) -> String:
	var hours = int(seconds / 3600)
	var minutes = int((seconds % 3600) / 60)
	var seconds1 = int(seconds % 60)

	# Use the correct ternary operator format in Godot 4
	var hours_str = "0" + str(hours) if hours < 100 else str(hours)
	
	return "%s:%02d:%02d" % [hours_str, minutes, seconds1]



func update_text(_quantity: int = -1) -> void:
	itemResourceLabel(0, "%s", GameInstance.data.username)
	itemResourceLabel(1, "Time : %s", seconds_to_hms(GameInstance.data.tick))
	itemResourceLabel(2, "Clicks : %s", Game.format_number(GameInstance.data.clicks))
	itemResourceLabel(3, "Rizz : %s", Game.format_number(GameInstance.data.rizz))
	itemResourceLabel(4, "Aura : %s", Game.format_number(GameInstance.data.aura))
	itemResourceLabel(5, "Multiplier : x%s", Game.format_number(GameInstance.data.multiplier * GameInstance.data.tempMulti))
	if GameInstance.data.rebirth > 0:
		itemResourceLabel(6, "BR Points : %s", Game.format_number(GameInstance.data.rebirthPoints))

func itemResourceLabel(index: int, format: String, value) -> void:
	var text = format % value

	# Check if the index is within bounds of the existing items
	if index < get_item_count():
		if get_item_text(index) != text:
			set_item_text(index, text)
	else:
		add_item(text, null, false)

	# Ensure the item is not selectable
	set_item_selectable(index, false)

func _ready() -> void:
	update_text()
	fetch_user_name()
	
func _process(_delta: float) -> void:
	update_text()
	
func fetch_user_name() -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Connect the request_completed signal
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	
	# Send the GET request to fetch the user data by id
	var error = http_request.request("https://sigmaclicker.kinhome.org/users/%s" % GameInstance.data.id)
	if error != OK:
		print("Request error: ", error)

# Callback for handling the request completion
func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	if response_code == 200:
		var response = body.get_string_from_utf8()
		var json_response = JSON.parse_string(response)
		if json_response.has("name"):
			GameInstance.data.username = json_response.name
			print("Username set to: ", GameInstance.data.username)
	else:
		print("HTTP request failed with status code: ", response_code)
