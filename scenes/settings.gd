extends Control
@export var view : userInterface.Views
@export var user_Interface : userInterface

func _on_navigation_request(requestedView : userInterface.Views) -> void:
	if requestedView == view:
		visible = true
		return
	visible = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	user_Interface.navigation_requested.connect(_on_navigation_request)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
