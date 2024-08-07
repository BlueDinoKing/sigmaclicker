extends Button
@export var goldChainsLabel : Label

func _process(_delta: float) -> void:
	update_available_gold_chains()

func update_available_gold_chains():
	var temp_rizz = GameInstance.data.rizz
	var temp_cost = GameInstance.data.goldChainsCost
	var count = 0

	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.05))
		count += 1
	goldChainsLabel.text = "Gold Chains : % (%)\nCost : %".format([Game.format_number(GameInstance.data.goldChains), Game.format_number(count), Game.format_number(GameInstance.data.goldChainsCost)], "%")



func _on_pressed():
	if GameInstance.data.rizz >= GameInstance.data.goldChainsCost:
		GameInstance.data.goldChains += 1
		GameInstance.data.addedRizz += 1
		Handler.ref.use_rizz(GameInstance.data.goldChainsCost)
		GameInstance.data.goldChainsCost = round(pow(GameInstance.data.goldChainsCost, 1.05))
