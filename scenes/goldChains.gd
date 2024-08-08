extends Button
class_name GoldChains
@export var goldChainsLabel : Label
static var ref : GoldChains
signal goldChains(amount: int)
func _process(_delta: float) -> void:
	update_available_gold_chains()

func _ready() -> void:
	var initial_cost = 16
	var num = GameInstance.data.goldChains
	var cost = initial_cost
	for i in range(num):
		cost = round(pow(cost, 1.05))
		GameInstance.data.goldChainsCost = cost
	GoldChains.ref = self

func update_available_gold_chains():
	var temp_rizz = GameInstance.data.rizz
	var temp_cost = GameInstance.data.goldChainsCost
	var count = 0
	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.05))
		count += 1
	set_text(Game.format_number(GameInstance.data.goldChainsCost))
	goldChainsLabel.text = "Gold Chains : % (%)\nEach click grants % extra rizz".format([Game.format_number(GameInstance.data.goldChains), Game.format_number(count), Game.format_number(GameInstance.data.goldChains* GameInstance.data.multiplier * GameInstance.data.tempMulti)], "%")



func _on_pressed():
	if GameInstance.data.rizz >= GameInstance.data.goldChainsCost:
		goldChains.emit(1)
		GameInstance.data.goldChains += 1
		GameInstance.data.addedRizz += 1
		Handler.ref.use_rizz(GameInstance.data.goldChainsCost)
		GameInstance.data.goldChainsCost = round(pow(GameInstance.data.goldChainsCost, 1.05))
