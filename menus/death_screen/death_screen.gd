extends CanvasLayer

@onready var score_label: Label = $Label2

func _ready():
	score_label.text = score_label.text + " " + str(Global.level)
