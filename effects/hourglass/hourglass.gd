extends CanvasLayer

@export var time_in_seconds: float = 3
var base_time: float = 3

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.animation_finished.connect(func(_nam):
		Global.times_up = true
	)
	animation_player.speed_scale = base_time/time_in_seconds
	print("Playing at ", base_time/time_in_seconds," speed")
	animation_player.play("time_progress")

func _process(_delta):
	if Global.time_affecting_hits > 0:
		Global.time_affecting_hits -= 1
		add_time(.5)
	
func add_time(time_in_seconds=1):
	if animation_player.is_playing():
		print(animation_player.current_animation_position)
		var seek_time = animation_player.current_animation_position - time_in_seconds
		if seek_time < 0: seek_time = 0
		animation_player.seek(seek_time)
