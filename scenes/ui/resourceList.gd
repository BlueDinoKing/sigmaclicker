class_name ResourceLabel
extends ItemList

func update_text(_quantity: int = -1) -> void:
	itemResourceLabel(0, "Clicks : %s", Game.format_number(GameInstance.data.clicks))
	itemResourceLabel(1, "Rizz : %s", Game.format_number(GameInstance.data.rizz))
	itemResourceLabel(2, "Aura : %s", Game.format_number(GameInstance.data.aura))
	itemResourceLabel(3, "Multiplier : x%s", Game.format_number(GameInstance.data.multiplier * GameInstance.data.tempMulti))
	if GameInstance.data.rebirth > 0:
		itemResourceLabel(4, "Brainrot : %s", Game.format_number(GameInstance.data.rebirth))

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
	Handler.ref.rizz_created.connect(update_text)
	Handler.ref.rizz_consumed.connect(update_text)
	Handler.ref.aura_created.connect(update_text)
	Handler.ref.aura_consumed.connect(update_text)
