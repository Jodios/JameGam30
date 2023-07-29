extends Sprite2D

@export var direction: Vector2

func _ready():
	$Area2D.body_entered.connect(check_collision)

func _process(_delta):
	position += direction  * 2
	rotation_degrees += 12
	
	if position.x < -1000 || position.x > 1000 || position.y < -1000 || position.y > 1000:
		queue_free()
		
func check_collision(body):
	if body.has_method("clockman"):
		queue_free()
