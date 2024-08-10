extends TextureButton

func _ready() -> void:
	if texture_normal:
		# Get the image from the texture normal
		var image = texture_normal.get_image()
		# Create the BitMap
		var bitmap = BitMap.new()
		# Fill it from the image alpha
		bitmap.create_from_image_alpha(image)
		# Assign it to the mask
		texture_click_mask = bitmap

func random_sign() -> int:
	return 1 if randi() % 2 == 0 else -1

func _on_pressed() -> void:
	var rizzLabel: Label = Label.new()
	rizzLabel.global_position = Vector2(264, 126)
	if GameInstance.data.upgrades[0] == 0:
		rizzLabel.text = Game.format_number((floor(GameInstance.data.multiplier*GameInstance.data.tempMulti*(1 + GameInstance.data.goldChains))))
	else:
		rizzLabel.text = Game.format_number((floor(GameInstance.data.multiplier*GameInstance.data.tempMulti*(1 + GameInstance.data.goldChains+(GameInstance.data.aura*(GameInstance.data.goldChains*.025*GameInstance.data.upgrades[0]))))))
	call_deferred("add_child", rizzLabel)
	rizzLabel.pivot_offset = Vector2(rizzLabel.size / 2)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(rizzLabel, "position:y", rizzLabel.position.y + randi_range(100, 200) * random_sign(), 1).set_ease(Tween.EASE_OUT)
	tween.tween_property(rizzLabel, "position:x", rizzLabel.position.x + randi_range(100, 200) * random_sign(), 1).set_ease(Tween.EASE_OUT)
	tween.tween_property(rizzLabel, "scale", Vector2.ZERO, 0.25).set_ease(Tween.EASE_IN).set_delay(0.5)
	await tween.finished
	rizzLabel.queue_free()
