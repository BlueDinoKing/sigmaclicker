class_name Handler
extends Node
# handles rizz n stuff

static var ref: Handler

func _singleton_check() -> void:
	if not ref:
		ref = self
		print("rizz handler singleton initialized")
	else:
		print("rizz handler singleton already exists, freeing this instance")
		queue_free()

func _enter_tree() -> void:
	_singleton_check()

signal rizz_created(quantity: float)
signal rizz_consumed(quantity: float)

signal aura_created(quantity: float)
signal aura_consumed(quantity: float)

func rizz() -> float:
	return GameInstance.data.rizz 



func create_rizz(quantity : float) -> void:
	GameInstance.data.rizz += quantity*GameInstance.data.multiplier*GameInstance.data.tempMulti
	rizz_created.emit()

func use_rizz(quantity: float) -> Error:
	if quantity <= GameInstance.data.rizz:
		GameInstance.data.rizz -= quantity
		rizz_consumed.emit()
		return Error.OK
	else:
		return Error.FAILED

func aura() -> float:
	return GameInstance.data.rizz 

func create_aura(quantity : float) -> void:
	GameInstance.data.aura += quantity*GameInstance.data.multiplier*GameInstance.data.tempMulti
	aura_created.emit()


func use_aura(quantity: float) -> Error:
	if quantity <= GameInstance.data.aura:
		GameInstance.data.aura -= quantity
		aura_consumed.emit(quantity)
		return Error.OK
	else:
		return Error.FAILED
