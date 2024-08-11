extends Node2D
var goldChainsSprite = load("res://images/gold chain.png")
var auraBrewerySprite = load("res://images/aura brewery.png")
var moggerSprite = load("res://images/mogger.png")
var image
var screenSize
var goldChains = 0
var auraBreweries = 0
var moggers = 0

func _ready() -> void:
	if not $"../ScrollContainer".is_node_ready():
		await $"../ScrollContainer".ready
	GoldChains.ref.goldChains.connect(create_goldChain)
	Moggers.ref.moggers.connect(create_mogger)
	AuraBrewery.ref.auraBrewery.connect(create_auraBrewery)

	screenSize = get_viewport().get_visible_rect().size
	for i in range(GameInstance.data.goldChains):
		create_goldChain(1)
	for i in range(GameInstance.data.auraBreweries):
		create_auraBrewery()
	for i in range(GameInstance.data.moggers):
		create_mogger()
	$Timer.start(1.0)



func create_goldChain(_input: int = 1):
	screenSize = get_viewport().get_visible_rect().size
	image = Sprite2D.new()
	image.texture = goldChainsSprite
	image.scale = Vector2(.25, .25)
	image.position = Vector2(randi_range(20, screenSize.x-20), randi_range(20, screenSize.y-20))
	add_child(image)

func create_auraBrewery(_input: int = 1):
	screenSize = get_viewport().get_visible_rect().size
	image = Sprite2D.new()
	image.texture = auraBrewerySprite
	image.scale = Vector2(.05, .05)
	image.position = Vector2(randi_range(20, screenSize.x-20), randi_range(20, screenSize.y-20))
	add_child(image)

func create_mogger(_input: int = 1):
	screenSize = get_viewport().get_visible_rect().size
	image = Sprite2D.new()
	image.texture = moggerSprite
	image.scale = Vector2(.25, .25)
	image.position = Vector2(randi_range(20, screenSize.x-20), randi_range(20, screenSize.y-20))
	add_child(image)

func kill_all_children():
	for child in get_children():
		if not child.is_class("Timer"):
			remove_child(child)
			child.queue_free()


func _on_timer_timeout() -> void:
	if screenSize != get_viewport().get_visible_rect().size:
		screenSize = get_viewport().get_visible_rect().size
		kill_all_children()
		for i in range(GameInstance.data.goldChains):
			create_goldChain(1)
		for i in range(GameInstance.data.auraBreweries):
			create_auraBrewery()
		for i in range(GameInstance.data.moggers):
			create_mogger()
