extends AnimatableBody2D

@export var direction: Vector2 = Vector2.ZERO
@export var speed: float = 2.0
@export var walk_time_max: int = 5
@export var stand_time_max: int = 10

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var clock_enemy: Sprite2D = $GrandfatherClockEnemy
@onready var timer: Timer = $Timer
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
	
func _physics_process(_delta):
	if direction.x < 0:
		clock_enemy.flip_h = true
	if direction.x > 0:
		clock_enemy.flip_h = false
	update_animation(direction)
	position += direction * speed

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
		
