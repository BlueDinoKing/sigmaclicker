class_name ResourceLabel
extends ItemList

func seconds_to_hms(seconds: int) -> String:
	var hours = int(seconds / 3600)
	var minutes = int((seconds % 3600) / 60)
	var seconds1 = int(seconds % 60)

	return "%02d:%02d:%02d" % [hours, minutes, seconds1]


func update_text(_quantity: int = -1) -> void:
	itemResourceLabel(0, "Time : %s", seconds_to_hms(GameInstance.data.tick))
	itemResourceLabel(1, "Clicks : %s", Game.format_number(GameInstance.data.clicks))
	itemResourceLabel(2, "Rizz : %s", Game.format_number(GameInstance.data.rizz))
	itemResourceLabel(3, "Aura : %s", Game.format_number(GameInstance.data.aura))
	itemResourceLabel(4, "Multiplier : x%s", Game.format_number(GameInstance.data.multiplier * GameInstance.data.tempMulti))
	if GameInstance.data.rebirth > 0:
		itemResourceLabel(5, "BR Points : %s", Game.format_number(GameInstance.data.rebirthPoints))

func itemResourceLabel(index: int, format: String, value) -> void:
	var text = format % value

	# Check if the index is within bounds of the existing items
	if index < get_item_count():
		if get_item_text(index) != text:
			set_item_text(index, text)
	else:
		add_item(text, null, false)

	# Ensure the item is not selectable
	set_item_selectable(index, false)

func _ready() -> void:
	update_text()
	#Handler.ref.rizz_created.connect(update_text)
	#Handler.ref.rizz_consumed.connect(update_text)
	#Handler.ref.aura_created.connect(update_text)
	#Handler.ref.aura_consumed.connect(update_text)
	#Handler.ref.rebirth_points_consumed.connect(update_text)
	#Handler.ref.rebirth_points_created.connect(update_text)
func _process(_delta: float) -> void:
	update_text()
