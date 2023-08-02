extends Node

var sound_volume: float = 0
var music_volume: float = 0
var level: int = 1
var times_up: bool = false
var time_affecting_hits = 0

func _process(_delta):
	if times_up:
		Transition.dissolve("res://menus/death_screen/death_screen.tscn")
		times_up = false
