extends Button
class_name Moggers
@export var moggersTimer : Timer
@export var moggersLabel : Label
static var ref : Moggers


signal moggers(amount: int)
func _on_pressed() -> void:
	if GameInstance.data.rizz >= GameInstance.data.moggersCost:
		GameInstance.data.moggers += 1
		moggers.emit(1)
		Handler.ref.use_rizz(GameInstance.data.moggersCost)
		GameInstance.data.moggersCost = round(pow(GameInstance.data.moggersCost, 1.05))

func _ready() -> void:
	Handler.ref.rizz_created.connect(update_available_mogger)
	var initial_cost = 256
	var num = GameInstance.data.moggers
	var cost = initial_cost
	for i in range(num):
		cost = round(pow(cost, 1.05))
		GameInstance.data.moggersCost = cost
	Moggers.ref = self

func mog():
	if not floor(GameInstance.data.moggers * GameInstance.data.aura) == 0:
		Handler.ref.create_rizz(floor((GameInstance.data.upgrades[1]+1) * .1 * GameInstance.data.moggers * GameInstance.data.aura))
		return
	
func _on_timer_timeout() -> void:
	mog()

func update_available_mogger():
	var temp_rizz = GameInstance.data.rizz
	var temp_cost = GameInstance.data.moggersCost
	var count = 0
	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.05))
		count += 1
	set_text(Game.format_number(GameInstance.data.moggersCost))
	moggersLabel.text = "Moggers : % (%)\nCreates .% * % * % rizz/s\n% rizz/s".format([Game.format_number(GameInstance.data.moggers), Game.format_number(count), Game.format_number(GameInstance.data.upgrades[1]+1), Game.format_number(GameInstance.data.moggers), Game.format_number(GameInstance.data.aura), Game.format_number(floor((GameInstance.data.upgrades[1]+1) * .1 * GameInstance.data.moggers * GameInstance.data.aura * GameInstance.data.multiplier * GameInstance.data.tempMulti))], "%")
