extends Button

var base_rebirth_cost : int = 100000
var count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceHandlers.ref.rebirth_points_created.connect(update_brainrot_level)
	ResourceHandlers.ref.aura_created.connect(update_label)
	update_rebirth_cost()
	update_label()

func update_brainrot_level() -> void:
	$"total multiplier".text = "%sx" % (Game.format_number(GameInstance.data.multiplier * GameInstance.data.tempMulti))

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
	# Reset upgrades 1-5 to 0 while keeping the rest unchanged
	for i in range(5):
		if i < GameInstance.data.upgrades.size():
			GameInstance.data.upgrades[i] = 0

	# Reset the costs for the first four upgrades
	GameInstance.data.upgradeCost = []
	# Ensure that the rest of the upgrade costs are intact
	while GameInstance.data.upgradeCost.size() < GameInstance.data.upgrades.size():
		GameInstance.data.upgradeCost.append(0)

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
	GameInstance.data.tick = 0
	GameInstance.data.rebirth += input
	Handler.ref.create_rebirth_points(input)
	GameInstance.data.multiplier = 0.1 * GameInstance.data.rebirth + 1
# Estimate the maximum number of rebirths possible with the given aura
func estimate_max_rebirths(aura: int) -> int:
	var a = 0.6
	var b = 0.4
	var c = -aura / base_rebirth_cost
	var discriminant = b * b - 4 * a * c

	if discriminant < 0:
		return 0  # No real solutions, meaning no rebirths are possible

	var sqrt_discriminant = sqrt(discriminant)
	var n1 = (-b + sqrt_discriminant) / (2 * a)
	var n2 = (-b - sqrt_discriminant) / (2 * a)

	# We only consider the positive root because rebirth counts can't be negative
	var max_rebirths = max(n1, n2)

	return int(floor(max_rebirths))
