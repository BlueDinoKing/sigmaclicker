class_name AuraBrewery
extends Button
@export var auraLabel : Label
@export var auraTimer : Timer
@export var breweries : Timer

static var ref: AuraBrewery

signal auraBrewery(quantity: int)

func _ready() -> void:
	AuraBrewery.ref = self

func _process(_delta: float) -> void:
	update_available_aura_breweries()

func update_available_aura_breweries():
	var temp_rizz = GameInstance.data.rizz
	var temp_cost = GameInstance.data.auraBreweryCost
	var count = 0

	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.05))
		count += 1
	set_text(Game.format_number(GameInstance.data.auraBreweryCost))
	auraLabel.text = "Aura Brewery : % (%)\nCreates % aura every % seconds\nAura is rizz per second".format([Game.format_number(GameInstance.data.auraBreweries), Game.format_number(count), Game.format_number(GameInstance.data.auraBreweries), '5'], "%")
	
func _on_pressed():
	if GameInstance.data.rizz >= GameInstance.data.auraBreweryCost:
		GameInstance.data.auraBreweries += 1
		Handler.ref.create_aura(1)
		Handler.ref.use_rizz(GameInstance.data.auraBreweryCost)
		auraBrewery.emit(1)
		GameInstance.data.auraBreweryCost = round(pow(GameInstance.data.auraBreweryCost, 1.05))


func _on_aura_timeout():
	Handler.ref.create_rizz(floor(GameInstance.data.aura))


func _on_breweries_timeout() -> void:
	Handler.ref.create_aura(floor(GameInstance.data.auraBreweries))
