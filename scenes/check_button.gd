extends CheckButton




func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameInstance.data.scientific = true
	if not toggled_on:
		GameInstance.data.scientific = false
