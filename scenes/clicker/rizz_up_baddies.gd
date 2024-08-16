extends TextureButton

func _ready() -> void:
	if texture_normal:
		var image = texture_normal.get_image()
		var bitmap = BitMap.new()
		bitmap.create_from_image_alpha(image)
		texture_click_mask = bitmap

func random_sign() -> int:
	return 1 if randi() % 2 == 0 else -1

func _on_pressed() -> void:
	var button_center = size / 2
	var offset = Vector2(20, 0)

	# Create a Label for Rizz
	var rizz_label = Label.new()
	rizz_label.text = calculate_rizz_text()
	rizz_label.position = button_center + offset
	rizz_label.pivot_offset = rizz_label.size / 2
	add_child(rizz_label)

	# Create and setup tween for the label
	var tween = get_tree().create_tween()
	setup_tween(tween, rizz_label)

	# Connect the tween's finished signal to remove the label
	tween.connect("finished", Callable(self, "_on_tween_completed").bind(rizz_label))

func calculate_rizz_text() -> String:
	var rizz_value = round(floor((GameInstance.data.goldChains+1)* GameInstance.data.multiplier * GameInstance.data.tempMulti))
	if GameInstance.data.upgrades[0] > 0:
		rizz_value = round(1 + 1 * GameInstance.data.goldChains + (GameInstance.data.aura * (GameInstance.data.goldChains * .025 * GameInstance.data.upgrades[0])))

	return Game.format_number(rizz_value)

func setup_tween(tween: Tween, label: Label) -> void:
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y + randi_range(200, 300) * random_sign(), 1).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "position:x", label.position.x + randi_range(200, 300) * random_sign(), 1).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", Vector2.ZERO, 0.25).set_ease(Tween.EASE_IN).set_delay(0.5)
	tween.tween_property(label, "modulate:a", 0, 0.5).set_delay(0.5)

func _on_tween_completed(label: Label) -> void:
	if is_instance_valid(label):
		label.queue_free()
