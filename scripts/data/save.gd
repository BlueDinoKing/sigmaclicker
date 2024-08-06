class_name SaveSystem

const PATH : String = "user://save.tres"
const SHOULD_LOAD : bool = true

# Save gameinstance.data in user://save.tres
static func save_data() -> void:
	if GameInstance.data:
		ResourceSaver.save(GameInstance.data, PATH)
		print('Data saved')

# Loads data and overrides gameinstance.data
static func load_data() -> void:
	if not SHOULD_LOAD:
		return
	if ResourceLoader.exists(PATH):
		var loaded_data = ResourceLoader.load(PATH)
		if loaded_data and loaded_data is Data:
			GameInstance.data = loaded_data
			print("Data loaded")

static func reset_data():
	if GameInstance.data:
		GameInstance.data.reset()
		save_data()
