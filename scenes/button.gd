extends Button

func _enter_tree() -> void:
	text = "Audio: %s" %str(GameInstance.data.audio)

func _on_pressed() -> void:
	if GameInstance.data.audio == true:
		GameInstance.data.audio = false
		text = "Audio: %s" %str(GameInstance.data.audio)
		return
	if not GameInstance.data.audio == true:
		GameInstance.data.audio = true
		text = "Audio: %s" %str(GameInstance.data.audio)
		return
