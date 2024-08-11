extends TextEdit


var current_clipboard

func _on_button_pressed() -> void:
	#do stuff here
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	current_clipboard = DisplayServer.clipboard_get()
	print(current_clipboard)
	print(GameInstance.data)
