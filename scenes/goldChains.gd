extends Button
var goldChainsCost = 16
@export var goldChainsLabel : Label
func format_number(input) -> String:
	var _exp = str(input).split(".")[0].length() - 1
	if input == 0:
		return "0"
	if str(input).length() <= GameInstance.data.maxDigitsUntilScientific:
		return str(input)
	else:
		var _dec = input / pow(10, _exp)
		return "{dec}e{exp}".format({"dec": ("%1.2f" % _dec), "exp": str(_exp)})

func update_available_gold_chains():
	var temp_rizz = GameInstance.data.rizz
	var temp_cost = goldChainsCost
	var count = 0

	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.05))
		count += 1
	goldChainsLabel.text = "Gold Chains : % (%)\nCost : %".format([format_number(GameInstance.data.goldChains), format_number(count), format_number(goldChainsCost)], "%")



func _on_pressed():
	if GameInstance.data.rizz >= goldChainsCost:
		GameInstance.data.goldChains += 1
		GameInstance.data.addedRizz += 1
		GameInstance.data.rizz -= goldChainsCost
		goldChainsCost = round(pow(goldChainsCost, 1.05))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_available_gold_chains()
