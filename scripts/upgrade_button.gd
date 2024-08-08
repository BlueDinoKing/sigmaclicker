extends Node
class_name UpgradeButton

# Define exported variables for each upgrade
@export var upgrade1Name: Label 
@export var upgrade1Price: Label 
@export var upgrade1Button: TextureButton
@export var upgrade1Line: Line2D
@export var upgrade2Name: Label 
@export var upgrade2Price: Label 
@export var upgrade2Button: TextureButton
@export var upgrade2Line: Line2D
@export var upgrade3Name: Label 
@export var upgrade3Price: Label 
@export var upgrade3Button: TextureButton

# Store upgrade costs and multipliers
var upgradeCost: Array = []
var upgradeMultiplier: Array = []

func _enter_tree() -> void:
	# Initialize upgradeCost and upgradeMultiplier with the same length as GameInstance.data.upgrades
	upgradeCost = GameInstance.data.upgradeCost
	upgradeMultiplier = [1000, 10, 0.05]  # Example multipliers for each upgrade
	upgradeCost.resize(GameInstance.data.upgrades.size())

	# Set initial costs if the array was empty or partially filled
	for i in range(upgradeCost.size()):
		if not upgradeCost[i]:
			upgradeCost[i] = 0  # Set default cost for any uninitialized upgrade

	# Update upgrade costs based on current levels
	for i in range(GameInstance.data.upgrades.size()):
		for k in range(GameInstance.data.upgrades[i]):
			upgradeCost[i] = upgradeCost[i] * upgradeMultiplier[i]

	update_labels()

	# Connect signals for updates
	Handler.ref.rizz_created.connect(update_labels)
	Handler.ref.rizz_consumed.connect(update_labels)
	Handler.ref.aura_created.connect(update_labels)
	Handler.ref.aura_consumed.connect(update_labels)

func update_labels() -> void:
	update_upgrade_label(0, upgrade1Name, upgrade1Price, upgrade1Button, upgrade1Line, "rizz", 3)
	update_upgrade_label(1, upgrade2Name, upgrade2Price, upgrade2Button, upgrade2Line, "aura", 3)
	update_upgrade_label(2, upgrade3Name, upgrade3Price, upgrade3Button, null, "rizz", 3)

func update_upgrade_label(index: int, name_label: Label, price_label: Label, button: TextureButton, line: Line2D, currency: String, max_level: int) -> void:
	var level = GameInstance.data.upgrades[index]
	name_label.set_text('%s/%s' % [Game.format_number(level), max_level])
	price_label.set_text('%s %s' % [Game.format_number(upgradeCost[index]), currency])

	if level >= max_level:
		button.disabled = true
	else:
		button.disabled = false
		if line:
			line.visible = false
	if level > 0:
		if line:
			line.visible = true
	if index > 0 and GameInstance.data.upgrades[index - 1] == 0:
		button.visible = false
	else:
		button.visible = true

func _on_upgrade_1_pressed() -> void:
	handle_upgrade(0, "rizz")

func _on_upgrade_2_pressed() -> void:
	handle_upgrade(1, "aura")

func _on_upgrade_3_pressed() -> void:
	handle_upgrade(2, "rizz")

func handle_upgrade(index: int, currency: String) -> void:
	if currency == "rizz" and GameInstance.data.rizz >= upgradeCost[index]:
		GameInstance.data.upgrades[index] += 1
		Handler.ref.use_rizz(upgradeCost[index])
	elif currency == "aura" and GameInstance.data.aura >= upgradeCost[index]:
		GameInstance.data.upgrades[index] += 1
		Handler.ref.use_aura(upgradeCost[index])
	else:
		return

	upgradeCost[index] *= upgradeMultiplier[index]  # Increase the cost for the next upgrade
	update_labels()
