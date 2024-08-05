extends Button

func format_number(input) -> String:
	var _exp = str(input).split(".")[0].length() - 1
	if input == 0:
		return "0"
	if str(input).length() <= GameInstance.data.maxDigitsUntilScientific:
		return str(input)
	else:
		var _dec = input / pow(10, _exp)
		return "{dec}e{exp}".format({"dec": ("%1.2f" % _dec), "exp": str(_exp)})

@export var moggersTimer : Timer
@export var moggersLabel : Label
var moggersCost = 256

func _process(delta: float) -> void:
	update_available_mogger()

func _on_pressed() -> void:
	if GameInstance.data.rizz >= moggersCost:
		GameInstance.data.moggers += 1
		GameInstance.data.rizz -= moggersCost
		moggersCost = round(pow(moggersCost, 1.2))
	if GameInstance.data.moggers == 1:
		moggersTimer.start()

func mog():
	GameInstance.data.rizz += floor(GameInstance.data.addedRizz * GameInstance.data.moggers * .5)

func _on_timer_timeout() -> void:
	mog()

func update_available_mogger():
	var temp_rizz = GameInstance.data.rizz
	var temp_cost = moggersCost
	var count = 0
	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.1))
		count += 1
	moggersLabel.text = "Moggers : % (%)\nCost : %".format([format_number(GameInstance.data.moggers), format_number(count), format_number(moggersCost)], "%")
