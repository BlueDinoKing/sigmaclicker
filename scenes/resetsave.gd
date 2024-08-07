extends Button
@export var delayTimer : Timer

var countdown = 5
var finishedCountdown = false
func _on_pressed():
	
	# Disable the button to prevent multiple clicks
	# Start the countdown
	if finishedCountdown:
		SaveSystem.reset_data()
		text = "RESET SAVE"
		finishedCountdown = false
		return
	disabled = true
	countdown = 5
	update_button_text()
	delayTimer.start(1.0)

func _on_timer_timeout() -> void:
	countdown -= 1
	if countdown > 0:
		update_button_text()
		delayTimer.start(1.0)
	else:
		delayTimer.stop()
		disabled = false
		countdown = 5
		finishedCountdown = true
		text = "CLICK TO RESET SAVE"

func update_button_text():
	if countdown > 0: 
		text = "RESET SAVE, ARE YOU SURE (" + str(countdown) + ")"
	if countdown <= 0:
		text = "CLICK TO RESET SAVE"
