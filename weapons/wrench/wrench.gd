extends Sprite2D

@export var direction: Vector2
@export var damage: float = 10.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	$Area2D.body_entered.connect(check_collision)

func _physics_process(delta):
	global_position += direction  * 5
	rotation_degrees += 20
	
	if position.x < -1000 || position.x > 1000 || position.y < -1000 || position.y > 1000:
		queue_free()
		
func check_collision(body):
	if body.has_method("playermethod"): return
	$wrench_hit_01.play(0)
	direction = Vector2.ZERO
	animation_player.speed_scale = 2
	animation_player.play("blow_up")
	if body.has_method("clockman"):
		pass
	if body.has_method("take_damage"):
		body.take_damage(damage)
	await animation_player.animation_finished
	queue_free()

# function will be generic to all 
# "weapons" that just returns the damage
# so in other objects that take damage 
# can check for weapon function
func weapon() -> float:
	return damage
