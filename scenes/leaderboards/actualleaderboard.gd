extends Control

@export var api_url: String = "https://sigmaclicker.kinhome.org/top_scores/"
@onready var top_rizz_label = $VBoxContainer/Label
@onready var top_aura_label = $VBoxContainer/Label2
@onready var top_clicks_label = $VBoxContainer/Label3
@onready var top_playtime_label = $VBoxContainer/Label4
@onready var top_rebirths_label = $VBoxContainer/Label5

var thresholds = {
	"rizz" : 100,
	"aura" : 100,
	"ticks" : 100,
	"rebirths" : 1,
	"clicks" : 100
}

func seconds_to_hms(seconds: int) -> String:
	var hours = int(seconds / 3600)
	var minutes = int((seconds % 3600) / 60)
	var seconds1 = int(seconds % 60)

	# Use the correct ternary operator format in Godot 4
	var hours_str = "0" + str(hours) if hours < 100 else str(hours)
	
	return "%s:%02d:%02d" % [hours_str, minutes, seconds1]




func _ready() -> void:
	# Fetch the top scores when the scene is ready
	fetch_top_scores()
	# Connect the timer's timeout signal
	timer.connect("timeout", Callable(self, "_on_timeout"))
	add_child(http_request)
	# Start the timer
	timer.start()
	
func fetch_top_scores() -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	var error = http_request.request(api_url)
	if error != OK:
		print("Request error: ", error)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var response = body.get_string_from_utf8()
		var json_response = JSON.parse_string(response)
		if json_response.has('messsage'):
			return
		if json_response.has('top_scores'):
			var result_data = json_response.top_scores
			update_leaderboard(result_data)
	else:
		print("HTTP error: ", response_code)

func update_leaderboard(top_scores: Dictionary) -> void:
	print('updated leaderboard')
	# Update the UI labels with the top scores
	top_rizz_label.text = format_leaderboard("Rizz", top_scores.get("rizz", []))
	top_aura_label.text = format_leaderboard("Aura", top_scores.get("aura", []))
	top_clicks_label.text = format_leaderboard("Clicks", top_scores.get("clicks", []))
	top_playtime_label.text = format_leaderboard("Playtime", top_scores.get("ticks", []), true)
	top_rebirths_label.text = format_leaderboard("Brainrot", top_scores.get("rebirths", []))

func format_leaderboard(title: String, scores: Array, time: bool = false) -> String:
	var leaderboard_text = title + "\n"
	for entry in scores:
		var formatted_score
		if not time:
			formatted_score = Game.format_number(entry["score"])
		else:
			formatted_score = seconds_to_hms(entry["score"])
		# Limit username to 12 characters
		var username_display = entry["username"].left(12)
		leaderboard_text += "%s: %s\n" % [username_display, formatted_score]
	return leaderboard_text


@onready var timer = $"../Timer"
@onready var http_request = HTTPRequest.new()
@export var thresholds_url: String = "https://sigmaclicker.kinhome.org/get_threshold/"
@export var update_score_url: String = "https://sigmaclicker.kinhome.org/scores/"

@export var user_id: int = 13  # Replace with the actual user ID
@export var user_scores: Dictionary = {}

func _on_timeout() -> void:
	# Fetch the thresholds data
	user_scores = {
		"rizz": GameInstance.data.rizz,
		"aura": GameInstance.data.aura,
		"clicks": GameInstance.data.clicks,
		"ticks": GameInstance.data.tick,
		"rebirths": GameInstance.data.rebirth
			}
	fetch_top_scores()
	fetch_thresholds()

func fetch_thresholds() -> void:
	http_request.connect("request_completed", Callable(self, "_on_thresholds_received"))
	var error = http_request.request(thresholds_url)
	print('thresholds fetched')
	if error != OK:
		print("Request error: ", error)

func _on_thresholds_received(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var response = body.get_string_from_utf8()
		var json_response = JSON.parse_string(response)
		if json_response.has("thresholds"):
			var thresholds = json_response.thresholds
			update_scores_if_needed(thresholds)
	else:
		print("HTTP error thresholds recieved: ", response_code)

func update_scores_if_needed(thresholds: Dictionary) -> void:
	for score_type in thresholds.keys():
		if user_scores.has(score_type):
			var current_score = user_scores[score_type]
			var threshold = thresholds[score_type]
			if threshold < current_score and GameInstance.data.uptodate:
				# Update the score to match the threshold
				send_score_update_request(score_type, current_score)
			
func send_score_update_request(score_type: String, points: float) -> void:
	var url = update_score_url
	var json_data = {
		"userId": GameInstance.data.id,
		"points": points,
		"score_type": score_type
	}
	
	# Convert the data to JSON
	var json_string = JSON.stringify(json_data)
	
	# Set up the HTTPRequest node
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_score_update_received"))
	
	# Send the POST request with JSON body
	var headers = [
		"Content-Type: application/json"
	]
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_string)
	if error != OK:
		print("Request error: ", error)



func _on_score_update_received(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var response = body.get_string_from_utf8()
		var json_response = JSON.parse_string(response)
		if json_response:
			print("Score updated successfully")
		else:
			print("Error parsing response")
	else:
		print("HTTP error score update recieved: ", response_code)
