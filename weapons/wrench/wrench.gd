extends Sprite2D

@export var direction: Vector2

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	$Area2D.body_entered.connect(check_collision)

func _process(_delta):
	position += direction  * 2
	rotation_degrees += 20
	
	if position.x < -1000 || position.x > 1000 || position.y < -1000 || position.y > 1000:
		queue_free()
		
func check_collision(body):
	if body.has_method("clockman"):
		$wrench_hit_01.play(0)
		direction = Vector2.ZERO
		animation_player.speed_scale = 2
		animation_player.play("blow_up")
		await animation_player.animation_finished
		queue_free()
