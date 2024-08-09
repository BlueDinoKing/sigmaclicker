extends Node
class_name UpgradeButton

@export var upgrade1Name: Label 
@export var upgrade1Price: Label 
@export var upgrade1Button: TextureButton
@export var upgrade1Line1: Line2D
@export var upgrade1Line2: Line2D
@export var upgrade2Name: Label 
@export var upgrade2Price: Label 
@export var upgrade2Button: TextureButton
@export var upgrade2Line: Line2D
@export var upgrade3Name: Label 
@export var upgrade3Price: Label 
@export var upgrade3Button: TextureButton
@export var upgrade4Name: Label
@export var upgrade4Price: Label 
@export var upgrade4Button: TextureButton
@export var upgrade4Line: Line2D

var baseUpgradeCost: Array = []
var upgradeMultiplier: Array = []
var upgradeDependencies: Array = []
var upgradeUnlocks: Array = []

func _enter_tree() -> void:
	# Set base costs for each upgrade
	baseUpgradeCost = [1000, 10000, 100000, 10000]
	upgradeMultiplier = [1000, 100, 10, 100]  # Example multipliers for each upgrade

	# Example dependencies and unlocks
	upgradeDependencies = [
		[],    # Upgrade 1 has no dependencies
		[0],   # Upgrade 2 depends on Upgrade 1
		[1],   # Upgrade 3 depends on Upgrade 2
		[0]    # Upgrade 4 depends on Upgrade 1
	]
	upgradeUnlocks = [
		[1, 3], # Upgrade 1 unlocks Upgrade 2 and 4
		[2],     # Upgrade 2 unlocks 3
		[],     # Upgrade 3 unlocks nothing
		[]      # Upgrade 4 unlocks nothing
	]

	# Initialize GameInstance.data.upgrades if necessary
	if GameInstance.data.upgrades == null or GameInstance.data.upgrades.size() < 4:
		GameInstance.data.upgrades = []
		for i in range(4):
			GameInstance.data.upgrades.append(0)

	# Initialize GameInstance.data.upgradeCost if necessary
	if GameInstance.data.upgradeCost == null or GameInstance.data.upgradeCost.size() != baseUpgradeCost.size():
		GameInstance.data.upgradeCost = baseUpgradeCost.duplicate()
	else:
		# Check and update the upgrade costs
		for i in range(baseUpgradeCost.size()):
			var expected_cost = baseUpgradeCost[i] * pow(upgradeMultiplier[i], GameInstance.data.upgrades[i])
			if GameInstance.data.upgradeCost[i] != expected_cost:
				GameInstance.data.upgradeCost[i] = expected_cost

	update_labels()

	# Connect signals for updates
	Handler.ref.rizz_created.connect(update_labels)
	Handler.ref.rizz_consumed.connect(update_labels)
	Handler.ref.aura_created.connect(update_labels)
	Handler.ref.aura_consumed.connect(update_labels)

func update_labels() -> void:
	update_upgrade_label(0, upgrade1Name, upgrade1Price, upgrade1Button, [upgrade1Line1, upgrade1Line2], "rizz", 3)
	update_upgrade_label(1, upgrade2Name, upgrade2Price, upgrade2Button, [upgrade2Line], "aura", 3)
	update_upgrade_label(2, upgrade3Name, upgrade3Price, upgrade3Button, [], "aura", 3)
	update_upgrade_label(3, upgrade4Name, upgrade4Price, upgrade4Button, [upgrade4Line], "rizz", 3)

func update_upgrade_label(index: int, name_label: Label, price_label: Label, button: TextureButton, lines: Array, currency: String, max_level: int) -> void:
	var level = GameInstance.data.upgrades[index]
	
	# Debug print statement

	# Check if the upgrade can be unlocked by checking dependencies
	var unlocked = true
	if upgradeDependencies[index].size() > 0:
		for dep in upgradeDependencies[index]:
			if GameInstance.data.upgrades[dep] == 0:
				unlocked = false
				break

	# Debug print statement

	if not unlocked:
		button.disabled = true
		button.visible = false
		name_label.set_text('Locked')
		price_label.set_text('')
		# Debug print statement
	else:
		button.disabled = false
		button.visible = true
		name_label.set_text('%s/%s' % [Game.format_number(level), max_level])
		price_label.set_text('%s %s' % [Game.format_number(GameInstance.data.upgradeCost[index]), currency])
		# Debug print statement

	# Set lines visibility based on the level and unlock status
	for line in lines:
		line.visible = level > 0 and unlocked


func _on_upgrade_1_pressed() -> void:
	handle_upgrade(0, "rizz")

func _on_upgrade_2_pressed() -> void:
	handle_upgrade(1, "aura")

func _on_upgrade_3_pressed() -> void:
	handle_upgrade(2, "aura")

func _on_upgrade_4_pressed() -> void:
	handle_upgrade(3, "rizz")

func handle_upgrade(index: int, currency: String) -> void:
	if currency == "rizz" and GameInstance.data.rizz >= GameInstance.data.upgradeCost[index]:
		GameInstance.data.upgrades[index] += 1
		Handler.ref.use_rizz(GameInstance.data.upgradeCost[index])
	elif currency == "aura" and GameInstance.data.aura >= GameInstance.data.upgradeCost[index]:
		GameInstance.data.upgrades[index] += 1
		Handler.ref.use_aura(GameInstance.data.upgradeCost[index])
		if index == 2:
			GameInstance.data.multiplier += .05
	else:
		return

	# Apply the multiplier only after an upgrade is purchased
	GameInstance.data.upgradeCost[index] *= upgradeMultiplier[index]

	# Unlock other upgrades if this upgrade has any unlocks
	for unlock_index in upgradeUnlocks[index]:
		if GameInstance.data.upgrades[unlock_index] == 0:
			GameInstance.data.upgrades[unlock_index] = 0  # Unlock the upgrade

	update_labels()
