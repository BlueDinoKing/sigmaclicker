class_name clicker
extends Control

## exports label so you can use it for stuff
@export var label : Label 
@export var button : Button
@export var goldChainsLabel : Label
@export var goldChainsButton : Button
@export var darkLabel : Label
@export var darkButton : Button
@export var auraTimer : Timer
var rizz : int = 0
var goldChainsCost = 16
var goldChains = 0
var darkCost = 32
var dark = 0
var addedRizz = 1
var aura = 0
var maxDigits : int = 3
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
	label.text = "Rizz : %s" % format_number(rizz)
	update_available_purchases()

func format_number(input) -> String:
	var _exp = str(input).split(".")[0].length() - 1
	if str(input).length() <= maxDigits:
		return str(input)
	else:
		var _dec = input / pow(10,_exp)
		return "{dec}e{exp}".format({"dec":("%1.2f" % _dec), "exp":str(_exp) })

func update_available_purchases():
	update_available_gold_chains()
	update_available_dark()
	
func update_available_gold_chains():
	var temp_rizz = rizz
	var temp_cost = goldChainsCost
	var count = 0

	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.05))
		count += 1
	goldChainsLabel.text = "Gold Chains : % (%)\nCost : %".format([format_number(goldChains), format_number(count), format_number(goldChainsCost)], "%")

func _on_gold_chains_pressed():
	if rizz >= goldChainsCost:
		goldChains = 1 + goldChains
		addedRizz = addedRizz + 1
		rizz = rizz - goldChainsCost
		goldChainsCost = round(pow(goldChainsCost, 1.05))
		update_rizz()

func update_available_dark():
	var temp_rizz = rizz
	var temp_cost = darkCost
	var count = 0

	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.1))
		count += 1
	darkLabel.text = "Dark and Mysterious Potion : % (%)\nCost : %".format([format_number(dark), format_number(count), format_number(darkCost)], "%")

func _on_dark_and_mysterious_pressed():
	if rizz >= darkCost:
		dark = 1 + dark
		aura = aura + 1
		rizz = rizz - darkCost
		darkCost = round(pow(darkCost, 1.1))
		update_rizz()
	if dark == 1:
		auraTimer.start()


func _on_aura_timeout():
	rizz = rizz + aura
