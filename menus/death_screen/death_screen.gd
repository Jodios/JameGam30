extends CanvasLayer

@onready var score_label: Label = $Label2
@onready var retry_button_area: Area2D =  $RetryButton/Area2D
@onready var retry_button: Sprite2D = $RetryButton
var normal_position: Vector2 = Vector2.ZERO

var hovering_over_button: bool = false
		
func _ready():
	normal_position = retry_button.position
	score_label.text = score_label.text + " " + str(Global.level)
	retry_button_area.mouse_entered.connect(func():
		hovering_over_button = true
	)
	retry_button_area.mouse_exited.connect(func():
		hovering_over_button = false
	)

func _process(_delta):
	if hovering_over_button:
		retry_button.position = normal_position + Vector2(0, -20)
	else:
		retry_button.position = normal_position

func _input(event):
	if event is InputEventMouseButton && event.is_pressed() && hovering_over_button:
		Transition.dissolve("res://levels/level_one/level_one.tscn")
