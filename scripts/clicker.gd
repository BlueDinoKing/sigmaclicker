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
	if user_interface:
		user_interface.navigation_requested.connect(_on_navigation_request)

func rizzupbaddies(input) -> void:
	if GameInstance.data.upgrades[0] == 0:
		Handler.ref.create_rizz((floor(input + input*GameInstance.data.goldChains)))
		return
	Handler.ref.create_rizz(floor(input + input*GameInstance.data.goldChains+(GameInstance.data.aura*(GameInstance.data.goldChains*.025*GameInstance.data.upgrades[0]))))


func _on_button_pressed() -> void:
	rizzupbaddies(1)
	GameInstance.data.clicks += 1
	if GameInstance.data.clicks%10 == 1:
		if GameInstance.data.audio == true:
			$"rizz up baddies/AudioStreamPlayer2D".pitch_scale = randf_range(.5, 2)
			$"rizz up baddies/AudioStreamPlayer2D".play()
