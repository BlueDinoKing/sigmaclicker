class_name Clicker
extends Control

# Exports
@export var label: Label
@export var button: Button
@export var view: userInterface.Views
@export var user_interface: userInterface
@export var user_interface_path : NodePath

var boostTimers : Array = []

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
		Handler.ref.create_rizz(floor(input + input * GameInstance.data.goldChains))
		return
	Handler.ref.create_rizz(floor(input + input * GameInstance.data.goldChains + (GameInstance.data.aura * (GameInstance.data.goldChains * .025 * GameInstance.data.upgrades[0]))))

func _on_button_pressed() -> void:
	rizzupbaddies(1)
	GameInstance.data.clicks += 1
	if GameInstance.data.upgrades[6] > 0:
		var boostTimer = Timer.new()
		boostTimer.wait_time = 1
		boostTimer.one_shot = true
		boostTimer.connect("timeout", Callable(self, "_on_boost_timeout"))
		add_child(boostTimer)
		boostTimers.append(boostTimer)
		boostTimer.start()
		GameInstance.data.tempMulti *= 1.05
	if GameInstance.data.clicks % 10 == 1:
		if GameInstance.data.audio == true:
			$"rizz up baddies/AudioStreamPlayer2D".pitch_scale = randf_range(0.5, 2)
			$"rizz up baddies/AudioStreamPlayer2D".play()

func _on_boost_timeout() -> void:
	GameInstance.data.tempMulti /= 1.05
	var to_remove = []
	for timer in boostTimers:
		if timer.is_stopped():
			to_remove.append(timer)
	for timer in to_remove:
		timer.queue_free()
		boostTimers.erase(timer)

func _on_timer_timeout() -> void:
	GameInstance.data.tick += 1
