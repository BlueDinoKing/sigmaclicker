class_name clicker
extends Control

## exports label so you can use it for stuff
@export var label : Label 
@export var button : Button
@export var goldChainsLabel : Label
@export var goldChainsButton : Button
var rizz : int = 0
var goldChainsCost = 16
var goldChains = 0
var addedRizz = 1
##test commits

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_rizz()


## rizz up bro
func rizzupbaddies() -> void:
	rizz += addedRizz
	update_rizz()

func _on_button_pressed() -> void:
	rizzupbaddies()

	
## updates the rizz label
func update_rizz() -> void:
	label.text = "Rizz : %s" %rizz
	update_available_purchases()

func update_available_purchases():
	update_available_gold_chains()
	
func update_available_gold_chains():
	var temp_rizz = rizz
	var temp_cost = goldChainsCost
	var count = 0

	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.1))
		count += 1
	goldChainsLabel.text = "Gold Chains : % (%)\nCost : %".format([goldChains, count, goldChainsCost], "%")

func _on_gold_chains_pressed():
	if rizz >= goldChainsCost:
		goldChains = 1 + goldChains
		addedRizz = addedRizz + 1
		rizz = rizz - goldChainsCost
		goldChainsCost = round(pow(goldChainsCost, 1.1))
		update_rizz()

