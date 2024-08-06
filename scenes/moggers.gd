extends Button

@export var moggersTimer : Timer
@export var moggersLabel : Label

func _process(delta: float) -> void:
	update_available_mogger()

func _on_pressed() -> void:
	if GameInstance.data.rizz >= GameInstance.data.moggersCost:
		GameInstance.data.moggers += 1
		GameInstance.data.rizz -= GameInstance.data.moggersCost
		GameInstance.data.moggersCost = round(pow(GameInstance.data.moggersCost, 1.2))
	if GameInstance.data.moggers == 1:
		moggersTimer.start()

func mog():
	GameInstance.data.rizz += floor(GameInstance.data.addedRizz * GameInstance.data.moggers * .5)

func _on_timer_timeout() -> void:
	mog()

func update_available_mogger():
	var temp_rizz = GameInstance.data.rizz
	var temp_cost = GameInstance.data.moggersCost
	var count = 0
	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.2))
		count += 1
	moggersLabel.text = "Moggers : % (%)\nCost : %".format([Game.format_number(GameInstance.data.moggers), Game.format_number(count), Game.format_number(GameInstance.data.moggersCost)], "%")
