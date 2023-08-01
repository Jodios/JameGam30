extends Node2D

@onready var start_button_area: Area2D =  $StartButton/Area2D
@onready var start_button: Sprite2D = $StartButton
var normal_position: Vector2 = Vector2.ZERO

var hovering_over_button: bool = false
		
func _ready():
	$AnimationPlayer.play("rotate_title")
	$AnimationPlayer.play("rotate_wrench")
	normal_position = start_button.position
	start_button_area.mouse_entered.connect(func():
		hovering_over_button = true
	)
	start_button_area.mouse_exited.connect(func():
		hovering_over_button = false
	)

func _process(_delta):
	if hovering_over_button:
		start_button.position = normal_position + Vector2(0, -20)
	else:
		start_button.position = normal_position

func _input(event):
	if event is InputEventMouseButton && event.is_pressed() && hovering_over_button:
		Transition.dissolve("res://levels/level_one/level_one.tscn")
