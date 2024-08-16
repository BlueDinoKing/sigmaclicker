extends Node
class_name UpgradeButton

var baseUpgradeCost: Array = []
var upgradeMultiplier: Array = []
var upgradeDependencies: Array = []
var upgradeUnlocks: Array = []
var rebirthLevel: int = 0

# Define the paths to upgrade nodes directly, including rebirth level upgrades
@onready var upgrade_nodes: Array = [
	$"VBoxContainer/pre rebirth/Upgrade1",
	$"VBoxContainer/pre rebirth/Upgrade2",
	$"VBoxContainer/pre rebirth/Upgrade3",
	$"VBoxContainer/pre rebirth/Upgrade4",
	$"VBoxContainer/pre rebirth/Upgrade5",
	$"VBoxContainer/rebirth1/Upgrade6",
	$"VBoxContainer/rebirth1/Upgrade7",
	$"VBoxContainer/rebirth1/Upgrade8",
	$"VBoxContainer/rebirth1/Upgrade9",
	$"VBoxContainer/rebirth1/Upgrade10"
]

var maxLevel: Array = [
	3,
	3,
	3,
	3,
	1,
	10,
	3,
	5,
	3,
	3
]

# Define currency types for each upgrade
var currencyTypes: Array = [
	"rizz",  # Upgrade 1
	"aura",  # Upgrade 2
	"aura",  # Upgrade 3
	"rizz",  # Upgrade 4
	"rizz",  # Upgrade 5
	"brainrot points",  # Upgrade 6
	"brainrot points",  # Upgrade 7
	"brainrot points",  # Upgrade 8
	"brainrot points",  # Upgrade 9
	"brainrot points"   # Upgrade 10
]

func _enter_tree() -> void:
	# Set base costs for each upgrade
	baseUpgradeCost = [1000, 10000, 100000, 10000, 100000, 1, 2, 16, 32, 32]
	upgradeMultiplier = [1000, 100, 10, 100, 1000, 4, 3, 2, 4, 4]  # Example multipliers for each upgrade

	# Example dependencies and unlocks
	upgradeDependencies = [
		[],    # Upgrade 1 has no dependencies
		[0],   # Upgrade 2 depends on Upgrade 1
		[1],   # Upgrade 3 depends on Upgrade 2
		[0],   # Upgrade 4 depends on Upgrade 1
		[3],   # Upgrade 5 depends on Upgrade 4
		[],    # Upgrade 6 depends on nothing (for rebirth level 1 upgrades)
		[5],   # Upgrade 7 depends on Upgrade 6
		[6],   # Upgrade 8 depends on Upgrade 7
		[7],   # Upgrade 9 depends on Upgrade 8
		[8]    # Upgrade 10 depends on Upgrade 9
	]
	upgradeUnlocks = [
		[1, 3],  # Upgrade 1 unlocks Upgrade 2 and 4
		[2],     # Upgrade 2 unlocks Upgrade 3
		[],      # Upgrade 3 unlocks nothing
		[4],     # Upgrade 4 unlocks Upgrade 5
		[],     # 5
		[6],     # Upgrade 6 unlocks Upgrade 7
		[7],     # Upgrade 7 unlocks Upgrade 8
		[8],     # Upgrade 8 unlocks Upgrade 9
		[9],     # Upgrade 9 unlocks Upgrade 10
		[]       # Upgrade 10 unlocks nothing
	]

	# Initialize GameInstance data if necessary
	if GameInstance.data.upgrades == null:
		GameInstance.data.upgrades = []

	# Ensure upgrades array is the same size as baseUpgradeCost
	while GameInstance.data.upgrades.size() < baseUpgradeCost.size():
		GameInstance.data.upgrades.append(0)

	# Initialize GameInstance.data.upgradeCost if necessary
	if GameInstance.data.upgradeCost == null:
		GameInstance.data.upgradeCost = baseUpgradeCost.duplicate()
	else:
		# Check and update the upgrade costs
		for i in range(baseUpgradeCost.size()):
			var expected_cost = baseUpgradeCost[i] * pow(upgradeMultiplier[i], GameInstance.data.upgrades[i])
			if GameInstance.data.upgradeCost.size() <= i:
				GameInstance.data.upgradeCost.append(expected_cost)
			elif GameInstance.data.upgradeCost[i] != expected_cost:
				GameInstance.data.upgradeCost[i] = expected_cost

	update_labels()

	# Connect signals for updates
	Handler.ref.rizz_created.connect(update_labels)
	Handler.ref.rizz_consumed.connect(update_labels)
	Handler.ref.aura_created.connect(update_labels)
	Handler.ref.aura_consumed.connect(update_labels)
	Handler.ref.rebirth_points_consumed.connect(update_labels)
	Handler.ref.rebirth_points_created.connect(update_labels)

func update_labels() -> void:
	$VBoxContainer/rebirth1.visible = GameInstance.data.rebirth >= 1

	for i in range(upgrade_nodes.size()):
		update_upgrade_label(i, upgrade_nodes[i])

func update_upgrade_label(index: int, upgrade_node: Node) -> void:
	if upgrade_node == null:
		return  # Prevent null pointer issues

	var name_label = upgrade_node.get_node("Name") as Label
	var price_label = upgrade_node.get_node("Price") as Label
	var button = upgrade_node as TextureButton
	var lines = []
	for line in ["Line1", "Line2"]:
		if upgrade_node.has_node(line):
			lines.append(upgrade_node.get_node(line) as Line2D)

	var level = GameInstance.data.upgrades[index]
	var currency_type = currencyTypes[index]

	# Ensure the index is within bounds
	if index >= GameInstance.data.upgradeCost.size():
		return  # Exit the function to avoid out-of-bounds access

	# Calculate if the upgrade can be unlocked by checking its dependencies
	var unlocked = true
	if upgradeDependencies[index].size() > 0:
		for dep in upgradeDependencies[index]:
			if GameInstance.data.upgrades[dep] == 0:
				unlocked = false
				break

	# Set the text and visibility based on whether the upgrade is unlocked
	if not unlocked:
		button.disabled = true
		button.visible = false
		name_label.set_text('Locked')
		price_label.set_text('')
	else:
		button.disabled = level >= maxLevel[index]
		button.visible = true
		name_label.set_text('%s/%s' % [Game.format_number(level), maxLevel[index]])
		price_label.set_text('%s %s' % [Game.format_number(GameInstance.data.upgradeCost[index]), currency_type])

		# Disable button and clear price label if upgrade is maxed out
		if level >= maxLevel[index]:
			price_label.set_text('')

	# Set lines visibility based on the unlock status of the upgrades they are pointing to
	for line in lines:
		var target_index = -1
		if line.name == "Line1" and index + 1 < upgrade_nodes.size():
			target_index = index + 1
		elif line.name == "Line2" and index + 2 < upgrade_nodes.size():
			target_index = index + 2

		if target_index != -1 and target_index < upgrade_nodes.size():
			var target_unlocked = true
			if upgradeDependencies[target_index].size() > 0:
				for dep in upgradeDependencies[target_index]:
					if GameInstance.data.upgrades[dep] == 0:
						target_unlocked = false
						break
			line.visible = target_unlocked
		else:
			line.visible = false


func handle_upgrade(index: int) -> void:
	var currency_type = currencyTypes[index]

	if currency_type == "rizz" and GameInstance.data.rizz >= GameInstance.data.upgradeCost[index]:
		GameInstance.data.upgrades[index] += 1
		Handler.ref.use_rizz(GameInstance.data.upgradeCost[index])
	elif currency_type == "aura" and GameInstance.data.aura >= GameInstance.data.upgradeCost[index]:
		GameInstance.data.upgrades[index] += 1
		Handler.ref.use_aura(GameInstance.data.upgradeCost[index])
		if index == 2:
			GameInstance.data.multiplier *= 1.05
	elif currency_type == "brainrot points" and GameInstance.data.rebirthPoints >= GameInstance.data.upgradeCost[index]:
		GameInstance.data.upgrades[index] += 1
		Handler.ref.use_rebirth_points(GameInstance.data.upgradeCost[index])
	else:
		return

	GameInstance.data.upgradeCost[index] *= upgradeMultiplier[index]

	# Unlock other upgrades if this upgrade has any unlocks
	for unlock_index in upgradeUnlocks[index]:
		if GameInstance.data.upgrades[unlock_index] == 0:
			GameInstance.data.upgrades[unlock_index] = 0

	update_labels()

func _on_upgrade_1_pressed() -> void:
	handle_upgrade(0)

func _on_upgrade_2_pressed() -> void:
	handle_upgrade(1)

func _on_upgrade_3_pressed() -> void:
	handle_upgrade(2)

func _on_upgrade_4_pressed() -> void:
	handle_upgrade(3)

func _on_upgrade_5_pressed() -> void:
	handle_upgrade(4)

func _on_upgrade_6_pressed() -> void:
	handle_upgrade(5)

func _on_upgrade_7_pressed() -> void:
	handle_upgrade(6)

func _on_upgrade_8_pressed() -> void:
	handle_upgrade(7)

func _on_upgrade_9_pressed() -> void:
	handle_upgrade(8)

func _on_upgrade_10_pressed() -> void:
	handle_upgrade(9)
