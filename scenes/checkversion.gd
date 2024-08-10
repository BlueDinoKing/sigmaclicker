extends Node

# URL of the remote version.txt file
const REMOTE_VERSION_URL = "https://raw.githubusercontent.com/BlueDinoKing/sigmaclicker/notwrizz/version.txt"

# Path to the local version.txt file
const LOCAL_VERSION_PATH = "res://version.txt"

# Store the fetched remote version
var remote_version = ""
# Store the local version for comparison
var local_version = ""

# Signal to indicate completion of version fetching
signal version_fetched

# Reference to the PopupDialog node
@onready var update_popup = $UpdatePopup

func _ready():
	# Start the version comparison process
	compare_versions()

func compare_versions() -> void:
	# Read the local version file
	local_version = read_local_version()
	
	# Fetch the remote version file
	fetch_remote_version()
	
	# Use call_deferred to ensure the method is called after the request completes
	connect("version_fetched", Callable(self, "_on_version_fetched"))

func read_local_version() -> String:
	var file = FileAccess.open(LOCAL_VERSION_PATH, FileAccess.READ)
	if file:
		var version = file.get_as_text().strip_edges()
		file.close()
		return version
	else:
		print("Local version.txt not found.")
		return ""  # Return an empty string if the file is not found

func fetch_remote_version() -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Connect the request_completed signal to a handler function
	http_request.request_completed.connect(_on_request_completed)
	
	# Initiate the HTTP request
	var err = http_request.request(REMOTE_VERSION_URL)
	if err != OK:
		print("HTTP request failed: ", err)
		remote_version = ""  # Set to empty if the request fails
		emit_signal("version_fetched")  # Emit the signal to handle completion

func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	if response_code == 200:
		# Parse the response body
		print('Request success')
		remote_version = body.get_string_from_utf8().strip_edges()
	else:
		print("Failed to fetch remote version. HTTP Status Code: ", response_code)
		remote_version = ""  # Set to empty if the status code is not 200

	# Emit the signal after handling the response
	emit_signal("version_fetched")

func _on_version_fetched() -> void:
	# Compare the versions and output the result
	if remote_version != "":
		if local_version == remote_version:
			print("The versions are the same. (%s)" % local_version)
		else:
			print("The versions are different. local: %s remote: %s" % [local_version, remote_version])
			show_update_popup()
	else:
		print("Failed to fetch the remote version.")

func show_update_popup() -> void:
	# Update the label text and show the popup
	var label = update_popup.get_node("Label")
	var button = update_popup.get_node("Button")
	label.text = "Client is out of date:\nUpdate here: https://github.com/BlueDinoKing/sigmaclicker\nCurrent version: %s\nLatest version: %s" % [local_version, remote_version]
	
	button.text = "Update"
	button.connect("pressed", Callable(self, "_on_update_button_pressed"))
	
	update_popup.popup_centered()

func _on_update_button_pressed() -> void:
	# Open the update link in the default browser
	OS.shell_open("https://github.com/BlueDinoKing/sigmaclicker")
