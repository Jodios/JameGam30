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
@onready var aggro_area: Area2D = $aggro_area

var target: CharacterBody2D = null
var speaking: bool = false

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
	timer.start(randi_range(1, stand_time_max))
	aggro_area.body_entered.connect(set_aggro)

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
	var player: AudioStreamPlayer2D = grind_gears_audio.get_child(
		randi_range(0, grind_bones_audio.get_child_count()-1)
	)
	speak(player)

func set_aggro(body):
	if body.has_method("playermethod"):
		var player: AudioStreamPlayer2D = grind_bones_audio.get_child(
			randi_range(0, grind_bones_audio.get_child_count()-1)
		)
		speak(player)

func speak(player):
	if !speaking: 
		player.play(0)
		speaking = true
		player.finished.connect(func():
			speaking = false
		)

func clockman():
	pass
