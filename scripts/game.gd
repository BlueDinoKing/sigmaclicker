class_name Game
extends Node

# singleton reference
static var ref: Game

# data property
var data: Data
@export var save_timer : Timer



static func format_number(input1) -> String:
	var input = round(input1*10)/10
	var _exp = str(input).split(".")[0].length() - 1
	var units = ["", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod"]

	if input == 0:
		return "0"

	if GameInstance.data.scientific:
		if str(input).length() <= GameInstance.data.maxDigitsUntilScientific:
			return add_commas(str(input))
		else:
			var _dec = input / pow(10, _exp)
			return "{dec}e{exp}".format({"dec": ("%1.2f" % _dec), "exp": str(_exp)})
	else:
		if str(input).length() <= GameInstance.data.maxDigitsUntilScientific:
			return add_commas(str(input))
		else:
			if input < 1000:
				return str(input)
			else:
				_exp = int(log(input) / log(1000))
				var _dec = input / pow(1000, _exp)
				if _exp < len(units):
					return "{dec}{unit}".format({"dec": ("%1.2f" % _dec).trim_suffix("0").trim_suffix("."), "unit": units[_exp]})
				else:
					_exp = str(_exp * 3)
					return "{dec}e{exp}".format({"dec": ("%1.2f" % _dec), "exp": _exp})

# Helper function to add commas to numbers
static func add_commas(number: String) -> String:
	var parts = number.split(".")
	parts[0] = _add_commas_to_integer(parts[0])
	return _join(parts, ".")	

static func _add_commas_to_integer(number: String) -> String:
	var result = []
	for i in range(number.length()):
		if i > 0 and i % 3 == 0:
			result.insert(0, ",")
		result.insert(0, number[number.length() - 1 - i])
	return _join(result, "")

static func _join(array: Array, delimiter: String) -> String:
	var result = ""
	for i in range(array.size()):
		result += array[i]
		if i < array.size() - 1:
			result += delimiter
	return result

# Use this function to format the number and add commas if necessary
static func formatted_number(input) -> String:
	var formatted = format_number(input)
	if not GameInstance.data.scientific and input >= 1000:
		return add_commas(formatted)
	return formatted


# singleton check
func _singleton_check() -> void:
	if not ref:
		ref = self
		print("Game singleton initialized")
	else:
		print("Game singleton already exists, freeing this instance")
		queue_free()

signal dataLoaded

# data init & singleton check
func _enter_tree() -> void:
	_singleton_check()
	if ref == self:
		if not data:
			data = Data.new()
		SaveSystem.load_data()
		print("Data initialized")
		dataLoaded.emit()
		send_post_request()

const url = "http://localhost:8000"

signal requestCompleted

func send_post_request() -> void:
	if GameInstance.data.id:
		return
	print('Sending POST request')
	var http_request = HTTPRequest.new()
	add_child(http_request)
	GameInstance.data.username = "Sigma%s" % randi_range(1000, 9999)
	http_request.request_completed.connect(_on_request_completed)
	var error = http_request.request(
		"https://sigmaclicker.kinhome.org/users/?name=%s" % GameInstance.data.username, 
		[], 
		HTTPClient.METHOD_POST
	)
	if error != OK:
		print("Request error: ", error)
	else:
		print("POST request sent successfully")

# This function is triggered when the HTTP request completes
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var response = body.get_string_from_utf8()  # Get the response body as a string
		var json_parse_result = JSON.parse_string(response)  # Parse the JSON response
		
		var json_response = json_parse_result.id  # This is the actual parsed JSON (a Dictionary)
		print("Server response: ", json_response)
		if not GameInstance.data.id or GameInstance.data.id == 0:
			GameInstance.data.id = json_response
		print(GameInstance.data.id)
	else:
		print("HTTP error: ", response_code)



func _ready() -> void:
	if ref == self:
		if not data:
			data = Data.new()
		# Check and connect the save timer
