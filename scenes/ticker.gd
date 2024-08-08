extends Node

var lastRizzParty: int = 0
var nextRizzParty: int = randi_range(5, 10)
var rizzCountDown: int = 30
var inRizzParty: bool = false
var buttonPressed: bool = false
var buttonCreated: bool = false
var originalMultiplier: int = 1
var screenSize
var host_sprite
@export var button: TextureButton
@export var animationImage: Sprite2D

var x_max: float = 1
var r_max: float = 10
const STOP_THRESHOLD: float = 0.1
var TWEEN_DURATION: float = 0.3
const RECOVERY_FACTOR: float = 2 / 3
const pivot_below: bool = false

func start() -> void:
	TWEEN_DURATION = randf()
	var x = x_max
	var r = r_max
	while x > STOP_THRESHOLD:
		var tween = _tilt_left(x, r)
		await tween.finished
		x *= RECOVERY_FACTOR
		r *= RECOVERY_FACTOR
		await _recenter()
		tween = _tilt_right(x, r)
		await tween.finished
		x *= RECOVERY_FACTOR
		r *= RECOVERY_FACTOR
		await _recenter()

func _tilt_left(x: float, r: float) -> Tween:
	var tween = create_tween()
	tween.tween_property(host_sprite, "position:x", round(host_sprite.position.x-x), TWEEN_DURATION)
	r = -r if pivot_below else r
	tween.tween_property(host_sprite, "rotation_degrees", r, TWEEN_DURATION)
	return tween

func _tilt_right(x: float, r: float) -> Tween:
	var tween = create_tween()
	tween.tween_property(host_sprite, "position:x", round(host_sprite.position.x-x), TWEEN_DURATION)
	r = r if pivot_below else -r
	tween.tween_property(host_sprite, "rotation_degrees", r, TWEEN_DURATION)
	return tween

func _recenter() -> Tween:
	var tween = create_tween()
	tween.tween_property(host_sprite, "position:x", round(host_sprite.position.x+x_max), TWEEN_DURATION)
	tween.tween_property(host_sprite, "rotation_degrees", 0, TWEEN_DURATION)
	return tween

func _ready():
	screenSize = get_viewport().get_visible_rect().size
	button.visible = false
	host_sprite = get_parent().get_node("Sprite")
	host_sprite.visible = false


func _button_pressed():
	button.visible = false
	host_sprite.visible = false
	GameInstance.data.tempMulti = originalMultiplier*5

func _on_timer_timeout() -> void:
	screenSize = get_viewport().get_visible_rect().size
	GameInstance.data.tick += 1
	lastRizzParty += 1
	if inRizzParty == false:
		if lastRizzParty == nextRizzParty:
			inRizzParty = true
			print("RIZZ PARTY BUTTON (SHOULD HAVE) APPEARED")
	if inRizzParty == true:
		if rizzCountDown == 29:
			host_sprite.position = Vector2(randi_range(50, screenSize.x-50), randi_range(50, screenSize.y-50))
		rizzCountDown -= 1
		if buttonCreated == true:
			start()
		if buttonCreated == false and buttonPressed == false and rizzCountDown == 28:
			button.visible = true
			host_sprite.visible = true
			button.pressed.connect(self._button_pressed)
			print(host_sprite.global_position)
			print("RIZZ PARTY BUTTON APPEARED")
			originalMultiplier = GameInstance.data.tempMulti
			buttonCreated = true
		if rizzCountDown == 0:
				lastRizzParty = 1
				nextRizzParty = randi_range(30,90) 
				rizzCountDown = 30
				inRizzParty = false
				buttonPressed = false
				button.visible = false
				host_sprite.visible = false
				buttonCreated = false
				print("rizz party button dleeted")
