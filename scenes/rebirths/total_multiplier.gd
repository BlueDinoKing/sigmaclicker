extends Label

var levels = ['not at all cooked bro', 'not cooked', 'cooked', 'bro is brainrotted', 'unc status', 'sigma']
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Handler.ref.rebirth_points_created.connect(update)
	update()

func update() -> void:
	text = "%sx multiplier from rebirths" % (GameInstance.data.rebirth * .1 + 1) 
	$"../status".text = levels[str(GameInstance.data.rebirth+9).length()]
	$"../total brainrot".text = "Total Brainrot : %s" % GameInstance.data.rebirth
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
