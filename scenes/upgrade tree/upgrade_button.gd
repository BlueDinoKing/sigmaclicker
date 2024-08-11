extends Node
class_name UpgradeButton

var baseUpgradeCost: Array = []
var upgradeMultiplier: Array = []
var upgradeDependencies: Array = []
var upgradeUnlocks: Array = []
var rebirthLevel: int = 0

# Define the paths to upgrade nodes directly, including rebirth level upgrades
@onready var upgrade_nodes : Array = [
	$"pre rebirth/Upgrade1",
	$"pre rebirth/Upgrade2",
	$"pre rebirth/Upgrade3",
	$"pre rebirth/Upgrade4",
	$"pre rebirth/Upgrade5",
	$"rebirth level 1/Upgrade1",
	$"rebirth level 1/Upgrade2",
	$"rebirth level 1/Upgrade3",
	$"rebirth level 1/Upgrade4",
	$"rebirth level 1/Upgrade5"
]

# Define currency types for each upgrade
var currencyTypes: Array = [
	"rizz",  # Upgrade 1
	"aura",  # Upgrade 2
	"aura",  # Upgrade 3
	"rizz",  # Upgrade 4
	"rizz",  # Upgrade 5
	"rizz",  # Upgrade 6
	"rizz",  # Upgrade 7
	"rizz",  # Upgrade 8
	"rizz",  # Upgrade 9
	"rizz"   # Upgrade 10
]

func _enter_tree() -> void:
	# Set base costs for each upgrade
	baseUpgradeCost = [1000, 10000, 100000, 10000, 100000, 200000, 400000, 800000, 1600000, 3200000]
	upgradeMultiplier = [1000, 100, 10, 100, 1000, 1000, 500, 250, 125, 100]  # Example multipliers for each upgrade

	# Example dependencies and unlocks
	upgradeDependencies = [
		[],	# Upgrade 1 has no dependencies
		[0],   # Upgrade 2 depends on Upgrade 1
		[1],   # Upgrade 3 depends on Upgrade 2
		[0],   # Upgrade 4 depends on Upgrade 1
		[3],   # Upgrade 5 depends on Upgrade 4
		[4],   # Upgrade 6 depends on Upgrade 5 (for rebirth level 1 upgrades)
		[5],   # Upgrade 7 depends on Upgrade 6
		[6],   # Upgrade 8 depends on Upgrade 7
		[7],   # Upgrade 9 depends on Upgrade 8
		[8]	# Upgrade 10 depends on Upgrade 9
	]
	upgradeUnlocks = [
		[1, 3], # Upgrade 1 unlocks Upgrade 2 and 4
		[2],	# Upgrade 2 unlocks Upgrade 3
		[],	 # Upgrade 3 unlocks nothing
		[4],	# Upgrade 4 unlocks Upgrade 5
		[5],	# Upgrade 5 unlocks Upgrade 6
		[6],	# Upgrade 6 unlocks Upgrade 7
		[7],	# Upgrade 7 unlocks Upgrade 8
		[8],	# Upgrade 8 unlocks Upgrade 9
		[9]	 # Upgrade 9 unlocks Upgrade 10
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

func update_labels() -> void:
	for i in range(upgrade_nodes.size()):
		var upgrade_node = upgrade_nodes[i]
		# For upgrades 6-10, ensure they are only updated if rebirth level is sufficient
		if i >= 5 and GameInstance.data.rebirth < 1:
			continue
		update_upgrade_label(i, upgrade_node)

func update_upgrade_label(index: int, upgrade_node: Node) -> void:
	if upgrade_node == null:
		return # Prevent null pointer issues

	var name_label = upgrade_node.get_node("Name") as Label
	var price_label = upgrade_node.get_node("Price") as Label
	var button = upgrade_node as TextureButton
	var lines = []
	for line in ["Line1", "Line2"]:
		if upgrade_node.has_node(line):
			lines.append(upgrade_node.get_node(line) as Line2D)

	var level = GameInstance.data.upgrades[index]
	var currency_type = currencyTypes[index]

	# Check if the upgrade can be unlocked by checking dependencies
	var unlocked = true
	if upgradeDependencies[index].size() > 0:
		for dep in upgradeDependencies[index]:
			if GameInstance.data.upgrades[dep] == 0:
				unlocked = false
				break

	if not unlocked:
		button.disabled = true
		button.visible = false
		name_label.set_text('Locked')
		price_label.set_text('')
	else:
		button.disabled = false
		button.visible = true
		name_label.set_text('%s/%s' % [Game.format_number(level), 3])
		price_label.set_text('%s %s' % [Game.format_number(GameInstance.data.upgradeCost[index]), currency_type])
		if level >= 3:
			button.disabled = true
			price_label.set_text('')

	# Set lines visibility based on the unlock status of the upgrades they are pointing to
	for line in lines:
		# Determine the index of the upgrade that this line points to
		var target_index = -1
		if line.name == "Line1" and index + 1 < upgrade_nodes.size():
			target_index = index + 1
		elif line.name == "Line2" and index + 2 < upgrade_nodes.size():
			target_index = index + 2

		# Only show the line if the target upgrade is unlocked
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
			GameInstance.data.multiplier += .05
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
