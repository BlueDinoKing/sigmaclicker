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
	
func _enter_tree() -> void:
	exponents.value = GameInstance.data.maxDigitsUntilScientific
	exponentsLabel.text = "% digits until notation (%)".format([exponents.value + 1, Game.format_number(100000)], "%")	

func _ready():
	if user_interface:
		user_interface.navigation_requested.connect(_on_navigation_request)

func _on_h_slider_drag_ended(_value_changed: bool) -> void:
	GameInstance.data.maxDigitsUntilScientific = int(exponents.value)
	exponentsLabel.text = "% digits until notation (%)".format([exponents.value + 1, Game.format_number(100000)], "%")
	
