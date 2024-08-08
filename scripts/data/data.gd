class_name Data
extends Resource


# settings
@export var username : String = "Sigma"

@export var maxDigitsUntilScientific : int = 3
@export var audio : bool = true
@export var scientific : bool = false

# buildings/purchases
@export var goldChains : int = 0
@export var auraBreweries : int = 0
@export var moggers : int = 0

# upgrades
@export var upgrades : Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
@export var upgradeCost : Array = [10000, 10000, 0]
# stats
@export var clicks : int = 0 # rizzes
@export var addedRizz : float = 1 # increased by gold chains
@export var tick : int = 0 #ingame ticks
@export var multiplier : float = 1
@export var tempMulti : float = 1

# resources
@export var aura : float = 0 # rizz/s
@export var rizz : float = 0 # W RIZZ

# costs
@export var goldChainsCost : float = 16
@export var auraBreweryCost : float = 64
@export var moggersCost : float = 256

func reset():
	upgrades = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	upgradeCost = [10000, 10000, 0]
	goldChains = 0
	auraBreweries = 0
	moggers = 0
	clicks = 0
	addedRizz = 1
	multiplier = 1
	tempMulti = 1
	aura = 0
	rizz = 0
	goldChainsCost = 16
	auraBreweryCost = 64
	moggersCost = 256
	tick = 0
