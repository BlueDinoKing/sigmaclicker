extends Button

func _on_pressed() -> void:
	DisplayServer.clipboard_set("save file name!")
