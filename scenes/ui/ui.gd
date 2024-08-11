class_name userInterface
extends Control

enum Views {
	MAIN,
	SETTINGS,
	UPGRADES,
	REBIRTHS,
}

signal navigation_requested(view: Views)


var menus = [Views.MAIN, Views.SETTINGS, Views.UPGRADES, Views.REBIRTHS]
func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	navigation_requested.emit(menus[index])
