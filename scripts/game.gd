class_name Game
extends Node

# singleton reference
static var ref: Game

# data property
var data: Data

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
		data = Data.new()
		print("Data initialized")

func _ready() -> void:
	if ref == self:
		data = Data.new()
