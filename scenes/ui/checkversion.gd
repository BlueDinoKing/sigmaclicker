extends Node
class_name CheckVersion

# URL of the remote version.txt file
const REMOTE_VERSION_URL = "https://raw.githubusercontent.com/BlueDinoKing/sigmaclicker/notwrizz/version.txt"

# Store the fetched remote version
var remote_version = ""

# Store the local version for comparison
var local_version = "82"

static var ref: CheckVersion

# Signal to indicate completion of version fetching
signal version_fetched
	
# Reference to the PopupDialog node
@onready var update_popup = $UpdatePopup

# Reference to the UpdateButton node
@onready var update_button = $UpdatePopup/UpdateButton

# Reference to the CloseButton node
@onready var close_button = $UpdatePopup/CloseButton

# Example link and message template
const UPDATE_LINK = "https://github.com/BlueDinoKing/sigmaclicker"
const MESSAGE_TEXT = "New Updates: Click to update\nCurrent version: %s\nLatest version: %s"

func _ready():
	hide_update_popup()
	ref = self
	# Ensure update_popup and UpdateButton are properly referenced
	if not update_popup or not update_button:
		print("UpdatePopup or UpdateButton node not found.")
		return

	# Connect the UpdateButton's signal for clicks
	update_button.pressed.connect(_on_update_button_pressed)

	# Connect the CloseButton's signal for clicks
	close_button.pressed.connect(_on_close_button_pressed)

	# Start the version comparison process
	compare_versions()

func compare_versions() -> void:
	# Connect the signal for version comparison
	version_fetched.connect(_on_version_fetched)
	fetch_remote_version()

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
		remote_version = body.get_string_from_utf8().strip_edges()
		print("Request successful, fetched version: ", remote_version)
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
			hide_update_popup()  # Hide the popup if versions are the same
		else:
			print("The versions are different. local: %s remote: %s" % [local_version, remote_version])
			show_update_popup()  # Show the popup if versions are different
	else:
		print("Failed to fetch the remote version.")
		hide_update_popup()  # Hide the popup if fetching failed

func show_update_popup() -> void:
	# Construct the message with the current and remote versions
	var message = MESSAGE_TEXT % [local_version, remote_version]
	update_button.text = message
	# Show the popup
	update_popup.visible = true
	update_popup.popup_centered()

func hide_update_popup() -> void:
	# Hide the popup if it's currently visible
	update_popup.hide()
	update_popup.visible = false

func _on_update_button_pressed() -> void:
	OS.shell_open(UPDATE_LINK)  # Open the URL in the default web browser

func _on_close_button_pressed() -> void:
	hide_update_popup()  # Hide the popup when the close button is pressed


func _on_update_popup_close_requested() -> void:
	hide_update_popup()
