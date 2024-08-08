extends Button
@export var delayTimer: Timer
@export var revertTimer: Timer

var countdown = 5
var finishedCountdown = false

func _on_pressed() -> void:
	if finishedCountdown:
		SaveSystem.reset_data()
		text = "RESET SAVE"
		finishedCountdown = false
		revertTimer.stop()  # Stop revert timer since save is reset
		return
	
	disabled = true
	countdown = 5
	update_button_text()
	delayTimer.start(1.0)

func _on_timer_timeout() -> void:
	if countdown > 0:
		countdown -= 1
		update_button_text()
		delayTimer.start(1.0)
	else:
		disabled = false
		text = "CLICK TO RESET SAVE"
		finishedCountdown = true
		delayTimer.stop()
		revertTimer.start(5.0)  # Start the revert timer

func _on_revert_timer_timeout() -> void:
	# Revert to the original state after 5 seconds
	finishedCountdown = false
	text = "RESET SAVE"
	disabled = false
	revertTimer.stop()

func update_button_text() -> void:
	text = "RESET SAVE, ARE YOU SURE (" + str(countdown) + ")"
