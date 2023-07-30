extends AnimatableBody2D

@export var direction: Vector2 = Vector2.ZERO
@export var speed: float = 2.0
@export var walk_time_max: int = 5
@export var stand_time_max: int = 10
@export var voice_max: int = 30

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var clock_enemy: Sprite2D = $GrandfatherClockEnemy
@onready var timer: Timer = $Timer
@onready var grind_bones_audio: Node = $grind_bones_audio
@onready var grind_gears_audio: Node = $grind_gears_audio
@onready var audio_timer: Timer = $audio_timer

enum active_direction {
	FRONT,
	BACK
}

var previous_direction: active_direction = active_direction.FRONT
enum state {
	STANDING,
	WALKING
}
var current_state: state = state.STANDING

func _ready():
	timer.timeout.connect(change_state)
	audio_timer.timeout.connect(test)
	timer.start(randi_range(1, stand_time_max))
	audio_timer.start(randi_range(1,voice_max))

func _process(_delta):
	set_volume()

func _physics_process(_delta):
	if direction.x < 0:
		clock_enemy.flip_h = true
	if direction.x > 0:
		clock_enemy.flip_h = false
	update_animation(direction)
	position += direction * speed
	move_and_collide(direction * speed)

func update_animation(move_direction: Vector2):
	if move_direction == Vector2.ZERO:
		if previous_direction == active_direction.FRONT:
			animation_player.play("front_idle")
		elif previous_direction == active_direction.BACK:
			animation_player.play("back_idle")
	elif move_direction.y < 0:
		animation_player.play("back_walk")
		previous_direction = active_direction.BACK
	elif move_direction.y > 0:
		animation_player.play("front_walk")
		previous_direction = active_direction.FRONT
	elif move_direction.x != 0:
		animation_player.play("front_walk")
		previous_direction = active_direction.FRONT
		
func test():
	var player: AudioStreamPlayer2D = grind_bones_audio.get_child(
		randi_range(0, grind_bones_audio.get_child_count()-1)
	)
	player.play(0)
	audio_timer.start(randi_range(1,voice_max))
	
func change_state():
	if !Global.input_enabled: return
	if current_state == state.STANDING:
		current_state = state.WALKING
		direction = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0),
		)
		timer.start(randi_range(1, walk_time_max))
	elif current_state == state.WALKING:
		current_state = state.STANDING
		direction = Vector2.ZERO
		timer.start(randi_range(1, stand_time_max))
		
# This function will get called 
# from the levels whenever a gear 
# gets hit
func grind_his_gears():
	pass

func set_volume():
	for player in grind_bones_audio.get_children():
		player.volume_db = Global.sound_volume
	for player in grind_gears_audio.get_children():
		player.volume_db = Global.sound_volume
	
func clockman():
	pass
