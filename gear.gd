extends StaticBody2D

@export var turn_speed: float = 1
@export var health: float = 100.0

func _ready():
	#hit_box_area.body_entered.connect(take_damage)
	pass

func _physics_process(_delta):
	rotation_degrees += turn_speed
	
func take_damage(damage: float):
	health -= damage
	for body in get_parent().get_children():
		if body.has_method("grind_his_gears"):
			body.grind_his_gears()
			return
