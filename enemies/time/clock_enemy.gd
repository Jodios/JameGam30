extends CharacterBody2D

@export var direction: Vector2 = Vector2.ZERO
@export var speed: float = 1.6
@export var walk_time_max: int = 5
@export var stand_time_max: int = 10
@export var voice_max: int = 30
@export var aggro_time: int = 1
@export var damage: int = 5
@export var attack_cooldown_seconds: float = .5
@export var max_health: float = 200
@export var health: float = max_health
var health_third: float = max_health / 3

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var clock_enemy: Sprite2D = $GrandfatherClockEnemy
@onready var timer: Timer = $Timer
@onready var aggro_area: Area2D = $aggro_area
@onready var attack_area: Area2D = $attack_area
@onready var aggro_timer: Timer = $aggro_timer
@onready var attack_cooldown: Timer = $attack_cooldown
@onready var health_bar: ProgressBar = $health_bar

@onready var grind_gears_audio: Node = $grind_gears_audio
@onready var grind_bones_audio: Node = $grind_bones_audio
@onready var aggro_audio: Node       = $aggro_audio
@onready var deaggro_audio: Node     = $deagrro_audio
@onready var hurt_audio: Node        = $hurt_audio
@onready var kill_audio: Node        = $kill_audio
@onready var death_audio: Node       = $death_audio
@onready var gear_broke_audio: Node  = $gear_broke

var target: CharacterBody2D = null
var dying: bool = false
var is_aggro: bool = false
var is_attacking: bool = false

var audio_players := []

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
	aggro_timer.timeout.connect(unset_aggro)
	timer.timeout.connect(change_state)
	timer.start(randi_range(1, stand_time_max))
	aggro_area.body_entered.connect(set_aggro)
	aggro_area.body_exited.connect(aggro_check)
	health_bar.max_value = max_health

	attack_area.body_entered.connect(try_to_attack)
	attack_area.body_exited.connect(try_to_stop_attacking)
	attack_cooldown.timeout.connect(func():
		is_attacking = false
		attack()
	)

func _physics_process(_delta):
	if target != null:
		direction = global_position.direction_to(target.global_position)
	if direction.x < 0:
		clock_enemy.flip_h = true
	if direction.x > 0:
		clock_enemy.flip_h = false

	if health >= max_health:
		health_bar.visible = false
	else:
		health_bar.visible = true
	health_bar.value = health
	if health >= max_health-health_third && health <= max_health:
		health_bar.modulate = Color(0x00, 0xFF, 0x00, 1)
	elif health >= max_health-(health_third*2):
		health_bar.modulate = Color(0xA4, 0x83, 0x00, 1)
	else:
		health_bar.modulate = Color(0xFF, 0x00, 0x00, 1)

	position += direction * speed
	update_animation(direction)
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
	if is_aggro: return
	if current_state == state.STANDING:
		current_state = state.WALKING
		self.direction = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0),
		)
		timer.start(randi_range(1, walk_time_max))
	elif current_state == state.WALKING:
		current_state = state.STANDING
		self.direction = Vector2.ZERO
		timer.start(randi_range(1, stand_time_max))

# This function will get called
# from the levels whenever a gear
# gets hit
func grind_his_gears():
	play_random_audio(grind_gears_audio)

func lament_defeat():
	self.shut_up()
	play_random_audio(gear_broke_audio)

func die():
	self.dying = true
	self.speed = 0
	self.shut_up()
	await play_random_audio(death_audio).finished
	queue_free()

func set_aggro(body):
	if body.has_method("playermethod"):
		is_aggro = true
		timer.stop()
		aggro_timer.stop()
		target = body
		play_random_audio($aggro_audio)

func aggro_check(body):
	if body.has_method("playermethod"):
		aggro_timer.start(aggro_time)

func unset_aggro():
	target = null
	is_aggro = false
	direction = Vector2.ZERO
	current_state = state.STANDING
	timer.start(randi_range(1, stand_time_max))
	aggro_timer.stop()
	play_random_audio($deagrro_audio)

func clockman():
	pass

func try_to_attack(body):
	if !body.has_method("playermethod"): return
	attack()

func attack():
	attack_cooldown.start(attack_cooldown_seconds)
	is_attacking = true
	target.take_damage(damage)
	if target.health <= 0:
		play_random_audio(kill_audio)

func try_to_stop_attacking(body):
	if !body.has_method("playermethod"): return
	is_attacking = false
	attack_cooldown.stop()

func take_damage(damage_amount: float, damage_direction: Vector2, body: CharacterBody2D):
	position -= damage_direction * 10
	Global.time_affecting_hits += 1
	if health <= 0 && !dying:
		die()
		return
	health -= damage_amount
	target = body
	is_aggro = true
	if randi_range(0,3) > 2:
		play_random_audio(hurt_audio)

func play_random_audio(node: Node, forced := false):
	var player: AudioStreamPlayer2D = node.get_child(
		randi_range(0, node.get_child_count()-1)
	)
	speak(player, forced)
	return player

func speak(player, forced):
	var speaking = self.audio_players.size() > 0
	if (forced || !speaking):
		player.play(0)
		self.audio_players.push_front(player)
		player.finished.connect(func():
			self.audio_players.pop_back()
		)

func shut_up():
	while audio_players.size() > 0:
		var player = audio_players.pop_front()
		player.stop()
