extends Button
@export var auraLabel : Label
@export var auraTimer : Timer

var darkCost = 32



func update_available_aura_breweries():
	var temp_rizz = GameInstance.data.rizz
	var temp_cost = darkCost
	var count = 0

	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.1))
		count += 1
	auraLabel.text = "Aura Brewery : % (%)\nCost : %".format([Game.format_number(GameInstance.data.auraBreweries), Game.format_number(count), Game.format_number(darkCost)], "%")

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
