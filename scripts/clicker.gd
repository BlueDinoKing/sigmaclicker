class_name Clicker
extends Control

# Exports
@export var label: Label 
@export var button: Button
@export var view: userInterface.Views
@export var user_interface: userInterface
@export var user_interface_path : NodePath
@export var particles : GPUParticles2D

func emit_one_particle():
	# Ensure the particles are initially not emitting
	particles.emitting = false
	# Briefly start emitting
	particles.emitting = true
	# Set a timer to stop emitting after a short delay
	await get_tree().create_timer(0.1).timeout
	particles.emitting = false

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
	emit_one_particle()
	GameInstance.data.rizz += floor(GameInstance.data.addedRizz * input)


func _on_button_pressed() -> void:
	rizzupbaddies(1)
	if GameInstance.data.audio == true:
		$"rizz up baddies/AudioStreamPlayer2D".pitch_scale = randf_range(.5, 2)
		$"rizz up baddies/AudioStreamPlayer2D".play()
	GameInstance.data.clicks += 1
	#if GameInstance.data.clicks == 10:
	#	unlockUpgrade(1)


func format_number(input) -> String:
	var _exp = str(input).split(".")[0].length() - 1
	if input == 0:
		return "0"
	if str(input).length() <= GameInstance.data.maxDigitsUntilScientific:
		return str(input)
	else:
		var _dec = input / pow(10, _exp)
		return "{dec}e{exp}".format({"dec": ("%1.2f" % _dec), "exp": str(_exp)})

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
