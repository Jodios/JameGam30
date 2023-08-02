extends Node2D

var done = false

func _ready():
	Global.times_up = false

func _process(_delta):
	if $gear.health <= 0 && !done:
		done = true
		$hourglass.add_time(2)
		await get_tree().create_timer(2).timeout
		await Transition.dissolve("res://menus/win_screen/win_screen.tscn")
