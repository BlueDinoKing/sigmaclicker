extends Timer
var lastRizzParty : int = 0
var nextRizzParty = randi_range(30,90) 
var rizzCountDown = 15
var inRizzParty : bool = false
var buttonPressed : bool = false
var button
var buttonCreated : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _button_pressed():
	buttonPressed = true
	buttonCreated == false
	remove_child(button)
	buttonCreated = false
	
func _on_timeout() -> void:
	GameInstance.data.tick += 1
	lastRizzParty += 1
	if inRizzParty == false:
		if lastRizzParty == nextRizzParty:
			inRizzParty = true
			print("RIZZ PARTY BUTTON APPEARED")
	if inRizzParty == true:
		rizzCountDown -= 1
		if buttonPressed == false and buttonCreated == false:
			button = Button.new()
			button.text = "Click me"
			button.pressed.connect(self._button_pressed)
			button.global_position = Vector2(randf_range(350,560),randf_range(350,560))
			add_child(button)
			buttonCreated = true
		if buttonPressed == true:
			print("Implement rizz party logic here")
			##rizz party logic
		if rizzCountDown == 0:
				lastRizzParty = 1
				nextRizzParty = randi_range(30,90) 
				rizzCountDown = 30
				inRizzParty = false
				buttonPressed = false
				remove_child(button)
