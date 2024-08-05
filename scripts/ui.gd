class_name userInterface
extends Control


enum Views {
	MAIN,
	SETTINGS,
}
signal navigation_requested(view: Views)

func _on_main_pressed() -> void:
	navigation_requested.emit(Views.MAIN)

func _on_settings_pressed() -> void:
	navigation_requested.emit(Views.SETTINGS)
