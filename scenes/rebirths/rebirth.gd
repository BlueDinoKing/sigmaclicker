extends Button

var base_rebirth_cost : int = 100000
var count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceHandlers.ref.aura_created.connect(update_label)
	update_rebirth_cost()
	update_label()


# Calculate the cost for a specific rebirth level
func calculate_rebirth_cost(level: int) -> int:
	return int(base_rebirth_cost * (1.2 * level + 1))  

# Update the rebirth cost based on the current rebirth level
func update_rebirth_cost():
	# This is for displaying purposes, the actual cost calculation happens in `calculate_possible_rebirths`
	print("Base rebirth cost:", base_rebirth_cost)

# Calculate how many rebirths are possible with the available aura
func calculate_possible_rebirths() -> int:
	return estimate_max_rebirths(GameInstance.data.aura)

# Update the label to show the current rebirth cost or the number of possible rebirths
func update_label():
	count = calculate_possible_rebirths()
	if count > 0:
		text = "Increase Brainrot Level (" + Game.format_number(count) + " possible)"
	else:
		text = "%s Aura to increase Brainrot Level" % Game.format_number(calculate_rebirth_cost(GameInstance.data.rebirth))

# Handle button press to perform rebirth
# Handle button press to perform rebirth
func _on_pressed() -> void:
	var total_cost = 0
	var rebirths_possible = calculate_possible_rebirths()
	var level = GameInstance.data.rebirth  # Start from the current rebirth level

	# Calculate total cost for the number of possible rebirths
	for i in range(rebirths_possible):
		total_cost += calculate_rebirth_cost(level)
		level += 1

	if GameInstance.data.aura >= total_cost:
		rebirth_reset(rebirths_possible)
		update_rebirth_cost()  # Update the rebirth cost for the next rebirth
		update_label()

# Estimate the maximum number of rebirths possible with the given aura
func estimate_max_rebirths(aura: int) -> int:
	var rebirths = 0
	var total_cost = 0
	var level = GameInstance.data.rebirth  # Start from the current rebirth level

	# Loop to calculate how many rebirths are possible
	while true:
		var cost = calculate_rebirth_cost(level)
		if total_cost + cost > aura:
			break
		total_cost += cost
		rebirths += 1
		level += 1

	return rebirths

var baseUpgradeCost = [1000, 10000, 100000, 10000, 100000, 1, 2, 16, 32, 32]

# Reset game state after rebirth
func rebirth_reset(input):
	# Reset upgrades 1-5 to 0 while keeping the rest unchanged
	for i in range(5):
		if i < GameInstance.data.upgrades.size():
			GameInstance.data.upgrades[i] = 0

	# Reset the costs for the first four upgrades
	for i in range(5):
		if i < GameInstance.data.upgrades.size():
			GameInstance.data.upgradeCost[i] = baseUpgradeCost[i]

	GameInstance.data.goldChains = 0
	GameInstance.data.auraBreweries = 0
	GameInstance.data.moggers = 0
	GameInstance.data.addedRizz = 1
	GameInstance.data.tempMulti = 1
	GameInstance.data.aura = 0
	GameInstance.data.rizz = 0
	GameInstance.data.goldChainsCost = 16
	GameInstance.data.auraBreweryCost = 64
	GameInstance.data.moggersCost = 256
	GameInstance.data.rebirth += input
	Handler.ref.create_rebirth_points(input * 2**GameInstance.data.upgrades[6])
	GameInstance.data.multiplier = 0.1 * GameInstance.data.rebirth + 1
