extends Button

@export var moggersTimer : Timer
@export var moggersLabel : Label

func _process(_delta : float) -> void:
	update_available_mogger()

func _on_pressed() -> void:
	if GameInstance.data.rizz >= GameInstance.data.moggersCost:
		GameInstance.data.moggers += 1
		Handler.ref.use_rizz(GameInstance.data.moggersCost)
		GameInstance.data.moggersCost = round(pow(GameInstance.data.moggersCost, 1.05))
	if GameInstance.data.moggers == 1:
		moggersTimer.start()

func mog():
	if not floor(GameInstance.data.moggers * GameInstance.data.aura) == 0:
		GameInstance.data.rizz += floor(GameInstance.data.moggers * GameInstance.data.aura)
		return
	GameInstance.data.rizz += 1
	
func _on_timer_timeout() -> void:
	mog()

func update_available_mogger():
	var temp_rizz = GameInstance.data.rizz
	var temp_cost = GameInstance.data.moggersCost
	var count = 0
	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.05))
		count += 1
	moggersLabel.text = "Moggers : % (%)\nCost : %".format([Game.format_number(GameInstance.data.moggers), Game.format_number(count), Game.format_number(GameInstance.data.moggersCost)], "%")
