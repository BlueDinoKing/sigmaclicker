extends Node
class_name UpgradeButton
@export var upgrade1Name: Label 
@export var upgrade1Price: Label 
@export var upgrade1Button: TextureButton
@export var upgrade1Panel: Panel
@export var upgrade1Line: Line2D
@export var upgrade2Name: Label 
@export var upgrade2Price: Label 
@export var upgrade2Button: TextureButton
@export var upgrade2Panel: Panel
@export var upgrade2Line: Line2D
var upgradeCost: Array 

func _process(delta: float) -> void:
	update_labels()

func _enter_tree() -> void:
	# Initialize upgradeCost with the same length as GameInstance.data.upgrades
	upgradeCost = GameInstance.data.upgradeCost
	upgradeCost.resize(GameInstance.data.upgrades.size())

	# Set initial costs if the array was empty or partially filled
	for i in range(upgradeCost.size()):
		if not upgradeCost[i]: 
			upgradeCost[i] = 0  # Set default cost for any uninitialized upgrade

	# Update upgrade costs based on current levels
	for i in range(GameInstance.data.upgrades.size()):
		for k in range(GameInstance.data.upgrades[i]):
			upgradeCost[i] = upgradeCost[i] * 1

	update_labels()

	# Connect signals for updates
	Handler.ref.rizz_created.connect(update_labels)
	Handler.ref.rizz_consumed.connect(update_labels)
	Handler.ref.aura_created.connect(update_labels)
	Handler.ref.aura_consumed.connect(update_labels)

func update_labels():
	# Update labels for the first upgrade as an example
	upgrade1Name.set_text('%s/3 upgrade 1' % Game.format_number(GameInstance.data.upgrades[0]))
	upgrade1Price.set_text('%s rizz' % Game.format_number(GameInstance.data.upgradeCost[0]))
	if GameInstance.data.upgrades[0] == 3:
		upgrade1Button.disabled = true
	else:
		upgrade1Button.disabled = false
	if GameInstance.data.upgrades[0] >= 1:
		upgrade1Line.visible = true
		upgrade2Button.visible = true
		upgrade2Name.set_text('%s/3 upgrade 2' % Game.format_number(GameInstance.data.upgrades[1]))
		upgrade2Price.set_text('%s rizz' % Game.format_number(GameInstance.data.upgradeCost[1]))
	else:
		upgrade2Button.visible = false
		upgrade2Line.visible = false
	if GameInstance.data.upgrades[1] == 3:
		upgrade2Button.disabled = true
	else:
		upgrade2Button.disabled = false


func _on_upgrade_1_pressed() -> void:
	if GameInstance.data.rizz >= GameInstance.data.upgradeCost[0]:
		GameInstance.data.upgrades[0] += 1
		Handler.ref.use_rizz(GameInstance.data.upgradeCost[0])
		GameInstance.data.upgradeCost[0] *= 1  # Increase the cost for the next upgrade
		update_labels()


func _on_upgrade_2_pressed() -> void:
	if GameInstance.data.rizz >= GameInstance.data.upgradeCost[1]:
		GameInstance.data.upgrades[1] += 1
		Handler.ref.use_rizz(GameInstance.data.upgradeCost[1])
		GameInstance.data.upgradeCost[1] *= 1  # Increase the cost for the next upgrade
		update_labels()
