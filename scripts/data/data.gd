class_name Data
extends Resource

# settings
@export var maxDigitsUntilScientific : int = 3
@export var audio : bool = true

# buildings/purchases
@export var goldChains : int = 0
@export var auraBreweries : int = 0
@export var moggers : int = 0

# upgrades

# stats
@export var clicks : int = 0 # rizzes
@export var addedRizz : float = 1 # increased by gold chains

# resources
@export var aura : float = 0 # rizz/s
@export var rizz : float = 0 # W RIZZ

# costs
@export var goldChainsCost : int = 16
@export var auraBreweryCost : int = 64
@export var moggersCost : int = 256

func reset():
	maxDigitsUntilScientific = 3
	audio = true
	goldChains = 0
	auraBreweries = 0
	moggers = 0
	clicks = 0
	addedRizz = 1
	aura = 0
	rizz = 0
	goldChainsCost = 16
	auraBreweryCost = 64
	moggersCost = 256
