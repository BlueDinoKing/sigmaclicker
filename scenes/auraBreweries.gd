extends Button
@export var auraLabel : Label
@export var auraTimer : Timer

var darkCost = 32

func format_number(input) -> String:
	var _exp = str(input).split(".")[0].length() - 1
	if input == 0:
		return "0"
	if str(input).length() <= GameInstance.data.maxDigitsUntilScientific:
		return str(input)
	else:
		var _dec = input / pow(10, _exp)
		return "{dec}e{exp}".format({"dec": ("%1.2f" % _dec), "exp": str(_exp)})

func update_available_aura_breweries():
	var temp_rizz = GameInstance.data.rizz
	var temp_cost = darkCost
	var count = 0

	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.1))
		count += 1
	auraLabel.text = "Aura Brewery : % (%)\nCost : %".format([format_number(GameInstance.data.auraBreweries), format_number(count), format_number(darkCost)], "%")

func _on_pressed():
	if GameInstance.data.rizz >= darkCost:
		GameInstance.data.auraBreweries += 1
		GameInstance.data.aura += 1
		GameInstance.data.rizz -= darkCost
		darkCost = round(pow(darkCost, 1.1))
		#if upgrade1 == true:
		#	auraTimer.wait_time = auraTimer.wait_time * 0.95
		#	print(auraTimer.wait_time)
	if GameInstance.data.auraBreweries == 1:
		auraTimer.start()

func _on_aura_timeout():
	GameInstance.data.rizz += GameInstance.data.aura

func _process(delta: float) -> void:
	update_available_aura_breweries()
