class_name Game
extends Node

# singleton reference
static var ref: Game

# data property
var data: Data
@export var save_timer : Timer



static func format_number(input) -> String:
	var _exp = str(input).split(".")[0].length() - 1
	var units = ["", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod"]

	if input == 0:
		return "0"

	if GameInstance.data.scientific:
		if str(input).length() <= GameInstance.data.maxDigitsUntilScientific:
			return add_commas(str(input))
		else:
			var _dec = input / pow(10, _exp)
			return "{dec}e{exp}".format({"dec": ("%1.2f" % _dec), "exp": str(_exp)})
	else:
		if str(input).length() <= GameInstance.data.maxDigitsUntilScientific:
			return add_commas(str(input))
		else:
			if input < 1000:
				return str(input)
			else:
				_exp = int(log(input) / log(1000))
				var _dec = input / pow(1000, _exp)
				if _exp < len(units):
					return "{dec}{unit}".format({"dec": ("%1.2f" % _dec).trim_suffix("0").trim_suffix("."), "unit": units[_exp]})
				else:
					_exp = str(_exp * 3)
					return "{dec}e{exp}".format({"dec": ("%1.2f" % _dec), "exp": _exp})

# Helper function to add commas to numbers
static func add_commas(number: String) -> String:
	var parts = number.split(".")
	parts[0] = _add_commas_to_integer(parts[0])
	return _join(parts, ".")	

static func _add_commas_to_integer(number: String) -> String:
	var result = []
	for i in range(number.length()):
		if i > 0 and i % 3 == 0:
			result.insert(0, ",")
		result.insert(0, number[number.length() - 1 - i])
	return _join(result, "")

static func _join(array: Array, delimiter: String) -> String:
	var result = ""
	for i in range(array.size()):
		result += array[i]
		if i < array.size() - 1:
			result += delimiter
	return result

# Use this function to format the number and add commas if necessary
static func formatted_number(input) -> String:
	var formatted = format_number(input)
	if not GameInstance.data.scientific and input >= 1000:
		return add_commas(formatted)
	return formatted


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
