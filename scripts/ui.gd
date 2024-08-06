class_name userInterface
extends Control

enum Views {
	MAIN,
	SETTINGS,
}

signal navigation_requested(view: Views)


var menus = [Views.MAIN, Views.SETTINGS]
func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	if index == 2:
		SaveSystem.save_data()
	else:
		navigation_requested.emit(menus[index])
