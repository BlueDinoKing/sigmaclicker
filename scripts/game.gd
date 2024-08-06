class_name Game
extends Node

# singleton reference
static var ref: Game

# data property
var data: Data
@export var save_timer : Timer

static func format_number(input) -> String:
	var _exp = str(input).split(".")[0].length() - 1
	if input == 0:
		return "0"
	if str(input).length() <= GameInstance.data.maxDigitsUntilScientific:
		return str(input)
	else:
		var _dec = input / pow(10, _exp)
		return "{dec}e{exp}".format({"dec": ("%1.2f" % _dec), "exp": str(_exp)})

# singleton check
func _singleton_check() -> void:
	if not ref:
		ref = self
		print("Game singleton initialized")
	else:
		print("Game singleton already exists, freeing this instance")
		queue_free()

# data init & singleton check
func _enter_tree() -> void:
	_singleton_check()
	if ref == self:
		if not data:
			data = Data.new()
		SaveSystem.load_data()
		print("Data initialized")

func _ready() -> void:
	if ref == self:
		if not data:
			data = Data.new()
		# Check and connect the save timer
