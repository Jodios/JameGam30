extends CharacterBody2D

@export var direction: Vector2 = Vector2.ZERO
@export var speed: float = 200
@export var cooldown: float = .5
@export var max_health: float = 100.0
@export var health: float = max_health
var health_third: float = max_health / 3

@onready var cam: Camera2D = $Camera2D
@onready var player: Sprite2D = $old_man_sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var step_sounds: AudioStreamPlayer2D = $stepsounds
@onready var throw_cooldown: Timer = $throw_cooldown
@onready var health_bar: ProgressBar = $health_bar

var is_cooled_down: bool = true

func _ready():
	Global.level = 1
	health_bar.value = health
	set_camera_limits()
	change_animation()
	throw_cooldown.timeout.connect(func():
		is_cooled_down = true
	)
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("action"): throw_wrench()
		
	direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
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
	change_animation()
	velocity = direction * speed
	move_and_slide()
	
func change_animation():
	
	if direction.x < 0:
		player.flip_h = true
	elif direction.x > 0:
		player.flip_h = false
		
	if direction != Vector2.ZERO:
		if !step_sounds.playing: step_sounds.play(0)
		animation_player.play("move")
	else:
		step_sounds.stop()
		animation_player.play("idle")
		
func set_camera_limits():
	var map: TileMap = get_parent().get_child(0)
	var map_limits = map.get_used_rect()
	var cell_size = map.cell_quadrant_size
	cam.limit_left = map_limits.position.x * cell_size
	cam.limit_right = map_limits.end.x * cell_size
	cam.limit_top = map_limits.position.y * cell_size
	cam.limit_bottom = map_limits.end.y * cell_size
	var map_dimensions = (map_limits.end.x-map_limits.position.x) * (map_limits.end.x-map_limits.position.x)
	var zoom_value = 3
	if map_dimensions < 500: zoom_value += .5
	cam.zoom.x = zoom_value
	cam.zoom.y = zoom_value

func throw_wrench():
	if !is_cooled_down: return
	throw_cooldown.start(cooldown)
	is_cooled_down = false
	var wrench = preload("res://weapons/wrench/wrench.tscn").instantiate()
	wrench.direction = position.direction_to(get_global_mouse_position())
	wrench.global_position = global_position + (wrench.direction*10)
	call_deferred("add_child", wrench)

func take_damage(damage: float):
	if health <= 0: return
	health -= damage
	if health <= 0:
		Transition.dissolve("res://menus/death_screen/death_screen.tscn")

func playermethod():
	pass
