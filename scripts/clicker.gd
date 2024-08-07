class_name Clicker
extends Control

# Exports
@export var label: Label 
@export var button: Button
@export var view: userInterface.Views
@export var user_interface: userInterface
@export var user_interface_path : NodePath

func _on_navigation_request(requestedView: userInterface.Views) -> void:
	if requestedView == view:
		visible = true
		return
	visible = false

func _ready():
	var user_interface = get_node(user_interface_path)
	if user_interface:
		user_interface.navigation_requested.connect(_on_navigation_request)

func rizzupbaddies(input) -> void:
	GameInstance.data.rizz += floor(GameInstance.data.addedRizz * input)


func _on_button_pressed() -> void:
	rizzupbaddies(1)
	
	GameInstance.data.clicks += 1
	print(GameInstance.data.clicks)
	if GameInstance.data.clicks%10 == 1:
		if GameInstance.data.audio == true:
			$"rizz up baddies/AudioStreamPlayer2D".pitch_scale = randf_range(.5, 2)
			$"rizz up baddies/AudioStreamPlayer2D".play()
	#if GameInstance.data.clicks == 10:
	#	unlockUpgrade(1)



#func unlockUpgrade(input) -> void:
#	if input == 1:
#		var message = str("Aura Breweries 5% faster per Gold Chain : % Rizz".format(format_number(5000), "%"))
#		upgradesMenu.add_item(message, 1)
#
#func upgrade(index) -> void:
#	if index == 1 and GameInstance.data.rizz >= 5000:
#		GameInstance.data.rizz -= 5000
#		var upgrade1 = true
#
#func _on_option_button_item_selected(index):
#	upgrade(index)
