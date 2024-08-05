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
@export var upgradesMenu : OptionButton
@export var moggersButton : Button
@export var moggersLabel : Label
@export var moggersTimer : Timer
@export var exponents : HSlider
@export var exponentsLabel : Label
@export var view : userInterface.Views
@export var user_interface : userInterface
var rizz : int = 0
var goldChainsCost = 16
var goldChains = 0
var darkCost = 32
var dark = 0
var addedRizz = 1
var aura = 0
var maxDigits : int = 3
var clicks = 0
var moggers = 0
var moggersCost = 256
var upgrade1 = false
##test commits
func _on_navigation_request(requestedView : userInterface.Views) -> void:
	if requestedView == view:
		visible = true
		return
	visible = false
# Called when the node enters the scene tree for the first time.
func _ready():
	user_interface.navigation_requested.connect(_on_navigation_request)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_rizz()


## rizz up bro
func rizzupbaddies(input) -> void:
	rizz += addedRizz*input
	update_rizz()


func _on_button_pressed() -> void:
	rizzupbaddies(1)
	clicks += 1
	if clicks == 10:
		unlockUpgrade(1)
	
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
	update_available_mogger()
	
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
	darkLabel.text = "Aura Brewery : % (%)\nCost : %".format([format_number(dark), format_number(count), format_number(darkCost)], "%")

func update_available_mogger():
	var temp_rizz = rizz
	var temp_cost = moggersCost
	var count = 0
	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.1))
		count += 1
	moggersLabel.text = "Moggers : % (%)\nCost : %".format([format_number(moggers), format_number(count), format_number(moggersCost)], "%")

func _on_dark_and_mysterious_pressed():
	if rizz >= darkCost:
		dark = 1 + dark
		aura = aura + dark
		rizz = rizz - darkCost
		darkCost = round(pow(darkCost, 1.1))
		update_rizz()
		if upgrade1 == true:
			auraTimer.wait_time = auraTimer.wait_time * 0.95
			print(auraTimer.wait_time)
	if dark == 1:
		auraTimer.start()


func _on_aura_timeout():
	rizz = rizz + aura

func unlockUpgrade(input) -> void:
	if input == 1:
		var message = str("Aura Breweries 5% faster per Gold Chain : % Rizz".format(format_number(5000), "%"))
		upgradesMenu.add_item(message, 1)
		print('test')
		
func upgrade(index) -> void:
	if index == 1 and rizz >= 5000:
		rizz = rizz - 5000
		var upgrade1 = true
	
func _on_option_button_item_selected(index):
	upgrade(index)

func _on_moggers_pressed() -> void:
	if rizz >= moggersCost:
		moggers = 1 + moggers
		rizz = rizz - moggersCost
		moggersCost = round(pow(moggersCost, 1.2))
		update_rizz()
	if moggers == 1:
		moggersTimer.start()
		
func mog():
	rizzupbaddies(moggers)
	


func _on_timer_timeout() -> void:
	mog()



func _on_h_slider_drag_ended(value_changed: bool) -> void:
	print('test')
	maxDigits = exponents.value
	exponentsLabel.text = "% digits".format([exponents.value+1], "%")
