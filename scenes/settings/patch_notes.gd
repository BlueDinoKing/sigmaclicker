extends RichTextLabel

const REMOTE_VERSION_URL = "https://raw.githubusercontent.com/BlueDinoKing/sigmaclicker/notwrizz/patchnotes.txt"

@onready var http_request = HTTPRequest.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(http_request)
	# Connect the request_completed signal
	http_request.request_completed.connect(_on_request_completed)
	
	# Send the HTTP GET request
	var error = http_request.request(REMOTE_VERSION_URL)
	if error != OK:
		print("Failed to send HTTP request.")

# Signal handler for the HTTPRequest node
func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	if response_code == 200:
		var content = body.get_string_from_utf8()
		text = content
	else:
		print("Request failed with response code: ", response_code)
