extends Control
@export var user_interface_path: NodePath
@export var user_interface: userInterface
@export var view: userInterface.Views

func _on_navigation_request(requestedView: userInterface.Views) -> void:
	if requestedView == view:
		visible = true
		return
	visible = false

func _ready():
	if user_interface:
		user_interface.navigation_requested.connect(_on_navigation_request)
