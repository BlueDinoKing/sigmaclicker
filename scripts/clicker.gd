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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## when rizz up baddies is pressed  rizz up baddies
func _on_button_pressed() -> void:
	rizzupbaddies()

## rizz up bro
func rizzupbaddies() -> void:
	rizz += addedRizz
	update_rizz()

## updates the rizz label
func update_rizz() -> void:
	label.text = "Rizz : %s" %rizz
	if rizz >= goldChainsCost:
		goldChainsButton



func _on_gold_chains_pressed():
	if rizz >= goldChainsCost:
		goldChains = 1 + goldChains
		rizz = rizz - goldChainsCost
		goldChainsCost = round(pow(goldChainsCost, 1.05))
		goldChainsLabel.text = "Gold Chains : % \nCost : %".format([goldChains, goldChainsCost], "%")
		addedRizz = addedRizz + 1
		update_rizz()
