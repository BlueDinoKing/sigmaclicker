extends Timer
var lastRizzParty : int = 0
var nextRizzParty = randi_range(5,10) 
var rizzCountDown = 30
var inRizzParty : bool = false
var buttonPressed : bool = false
var button
var buttonCreated : bool = false
var originalMultiplier = 1

func _button_pressed():
	remove_child(button)
	GameInstance.data.multiplier = originalMultiplier*5

func _on_timeout() -> void:
	GameInstance.data.tick += 1
	lastRizzParty += 1
	if inRizzParty == false:
		if lastRizzParty == nextRizzParty:
			inRizzParty = true
			print("RIZZ PARTY BUTTON (SHOULD HAVE) APPEARED")
	if inRizzParty == true:
		rizzCountDown -= 1
		if buttonCreated == false and buttonPressed == false:
			button = TextureButton.new()
			var texture = load("res://images/money_32.png")
			button.texture_normal = texture
			button.custom_minimum_size = Vector2(16,16)
			button.pressed.connect(self._button_pressed)
			button.global_position = Vector2(randf_range(350, 560), randf_range(350, 560))
			add_child(button)
			print("RIZZ PARTY BUTTON APPEARED")
			originalMultiplier = GameInstance.data.multiplier
			buttonCreated = true
		if rizzCountDown == 0:
				lastRizzParty = 1
				nextRizzParty = randi_range(30,90) 
				rizzCountDown = 30
				inRizzParty = false
				buttonPressed = false
				remove_child(button)
				buttonCreated = false
				print("rizz party button dleeted")
				GameInstance.data.multiplier = originalMultiplier
