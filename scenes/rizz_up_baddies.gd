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

func _on_button_down() -> void:
	print(size)
	size = Vector2(size.x-20, size.y-20)
	print(size)


func _on_button_up() -> void:
	size = Vector2(10/9 * size.x, 10/9 * size.y)
