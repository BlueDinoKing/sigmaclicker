extends ItemList


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Handler.ref.aura_created.connect(unlock_rebirth)
	if GameInstance.data.rebirth > 0:
		unlock_rebirth()
func unlock_rebirth() -> void:
	if GameInstance.data.rebirth > 0:
		if get_item_text(3) == '':
			add_item('Rebirth')
		else:
			return
	if GameInstance.data.aura >= 100000 and get_item_text(3) != "Rebirth":	
		if get_item_text(3) == '':
			add_item('Rebirth')
		else:
			return
