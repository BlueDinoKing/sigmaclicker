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
		GameInstance.data.moggersCost = round(pow(GameInstance.data.moggersCost, 1.05 - 0.005 * GameInstance.data.upgrades[9]))

func _ready() -> void:
	Handler.ref.rizz_created.connect(update_available_mogger)
	Handler.ref.rizz_consumed.connect(update_available_mogger)
	var initial_cost = 256
	var num = GameInstance.data.moggers
	var cost = initial_cost
	for i in range(num):
		cost = round(pow(cost, 1.05 - 0.005 * GameInstance.data.upgrades[9]))
		GameInstance.data.moggersCost = cost
	Moggers.ref = self
	update_available_mogger()

func mog() -> void:
	if floor(GameInstance.data.moggers * GameInstance.data.aura) > 0:
		Handler.ref.create_rizz(floor(floor(0.1 * (1+GameInstance.data.upgrades[1]) * GameInstance.data.moggers * GameInstance.data.aura * pow(2, GameInstance.data.upgrades[7] * log(GameInstance.data.aura + 1) / (5*log(10))))))
	
func _on_timer_timeout() -> void:
	mog()

func update_available_mogger() -> void:
	var temp_rizz = GameInstance.data.rizz
	var temp_cost = GameInstance.data.moggersCost
	var count = 0
	while temp_rizz >= temp_cost:
		temp_rizz -= temp_cost
		temp_cost = round(pow(temp_cost, 1.05 - 0.005 * GameInstance.data.upgrades[9]))
		count += 1
	set_text(Game.format_number(GameInstance.data.moggersCost))
	moggersLabel.text = "Moggers: %s (%s)\n%s rizz/s" % [
		Game.format_number(GameInstance.data.moggers),
		Game.format_number(count),
		Game.format_number(floor(0.1 * (1+GameInstance.data.upgrades[1]) * GameInstance.data.moggers * GameInstance.data.aura * pow(2, GameInstance.data.upgrades[7] * log(GameInstance.data.aura + 1) /(5*log(10)))*GameInstance.data.tempMulti * GameInstance.data.multiplier))
	]
