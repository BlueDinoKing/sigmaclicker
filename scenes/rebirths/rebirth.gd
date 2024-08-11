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
	var total_aura = GameInstance.data.aura
	var level = 0
	var cost = calculate_rebirth_cost(level)
	var rebirths = 0

	while total_aura >= cost:
		total_aura -= cost
		rebirths += 1
		level += 1
		cost = calculate_rebirth_cost(level)  # Update cost for the next rebirth

	return rebirths

# Update the label to show the current rebirth cost or the number of possible rebirths
func update_label():
	count = calculate_possible_rebirths()
	if count > 0:
		text = "Increase Brainrot Level (" + Game.format_number(count) + " possible)"
	else:
		text = "%s Aura to increase Brainrot Level" % Game.format_number(calculate_rebirth_cost(GameInstance.data.rebirth))

# Handle button press to perform rebirth
func _on_pressed() -> void:
	if GameInstance.data.aura >= calculate_rebirth_cost(0):  # Ensure there's enough aura for at least one rebirth
		var rebirths_possible = calculate_possible_rebirths()
		var total_cost = 0
		var level = 0

		for i in range(rebirths_possible):
			total_cost += calculate_rebirth_cost(level)
			level += 1

		if GameInstance.data.aura >= total_cost:
			update_rebirth_cost()  # Update the rebirth cost for the next rebirth
			rebirth_reset(rebirths_possible)
			update_label()

# Reset game state after rebirth
func rebirth_reset(input):
	GameInstance.data.upgrades = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	GameInstance.data.upgradeCost = [10000, 10000, 0, 10000]
	GameInstance.data.goldChains = 0
	GameInstance.data.auraBreweries = 0
	GameInstance.data.moggers = 0
	GameInstance.data.addedRizz = 1
	GameInstance.data.multiplier = 1
	GameInstance.data.tempMulti = 1
	GameInstance.data.aura = 0
	GameInstance.data.rizz = 0
	GameInstance.data.goldChainsCost = 16
	GameInstance.data.auraBreweryCost = 64
	GameInstance.data.moggersCost = 256
	GameInstance.data.tick = 0
	GameInstance.data.rebirth += input
	GameInstance.data.rebirthPoints += input
