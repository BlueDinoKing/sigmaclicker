class_name ResourceLabel
extends ItemList

func update_text() -> void:
	itemResourceLabel(0, "Clicks : %s", Game.format_number(GameInstance.data.clicks))
	itemResourceLabel(1, "Rizz : %s", Game.format_number(GameInstance.data.rizz))
	itemResourceLabel(2, "Aura : %s", Game.format_number(GameInstance.data.aura))
#temp func
func _process(_delta: float) -> void:
	update_text()
	
func itemResourceLabel(input1: int, input2: String, input3) -> void:
	set_item_text(input1, input2 %input3)
	set_item_selectable(input1, false)
	if not get_item_text(input1) == input2 %input3:
		add_item(input2 %input3, null, false)
