extends Timer




func _on_timeout() -> void:
	SaveSystem.save_data()
