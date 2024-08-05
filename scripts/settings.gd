extends Control

@export var view: userInterface.Views
@export var user_interface: userInterface
@export var exponents: HSlider
@export var exponentsLabel: Label
@export var user_interface_path: NodePath
func _on_navigation_request(requestedView: userInterface.Views) -> void:
	if requestedView == view:
		visible = true
		return
	visible = false

func _ready():
	var user_interface = get_node(user_interface_path)
	if user_interface:
		print("User interface node found: ", user_interface)
		user_interface.navigation_requested.connect(_on_navigation_request)
	else:
		print("Error: User interface node not found at path: ", user_interface_path)

func _on_h_slider_drag_ended(value_changed: bool) -> void:
	GameInstance.data.maxDigitsUntilScientific = exponents.value
	exponentsLabel.text = "% digits until scientific notation (1.0e6)".format([exponents.value + 1], "%")
