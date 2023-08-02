extends Node2D

@onready var next_button_area: Area2D =  $next_button/Area2D
@onready var next_button: Sprite2D = $next_button
var normal_position: Vector2 = Vector2.ZERO

var hovering_over_button: bool = false
		
func _ready():
	$AnimationPlayer.play("rotate_title")
	$AnimationPlayer.play("rotate_wrench")
	normal_position = next_button.position
	next_button_area.mouse_entered.connect(func():
		hovering_over_button = true
	)
	next_button_area.mouse_exited.connect(func():
		hovering_over_button = false
	)

func _process(_delta):
	if hovering_over_button:
		next_button.position = normal_position + Vector2(0, -20)
	else:
		next_button.position = normal_position

func _input(event):
	if event is InputEventMouseButton && event.is_pressed() && hovering_over_button:
		Transition.dissolve("res://menus/start_screen/start_screen.tscn")
