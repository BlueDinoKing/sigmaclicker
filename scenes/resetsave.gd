extends Button
class_name Reset




func _on_pressed(): 
	SaveSystem.reset_data()
	Handler.ref.use_rizz(0)
