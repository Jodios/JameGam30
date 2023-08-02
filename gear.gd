extends StaticBody2D

@export var turn_speed: float = 1
@export var max_health: float = 1000
var health: float = max_health
var health_third: float = max_health / 3

@onready var health_bar: ProgressBar = $health_bar

func _ready():
	health_bar.global_position = self.position - Vector2(70,10)
	health_bar.value = health
	health_bar.max_value = max_health
	health = max_health

func _physics_process(_delta):
	rotation_degrees += turn_speed
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
	
func take_damage(damage: float, damage_direction: Vector2 = Vector2.ZERO):
	if health <= 0: return
	turn_speed -= (damage/max_health)
	health -= damage
	if health <= 0:
		explode()
		for clockman in get_all_clockmen():
			clockman.lament_defeat()
			return
	for clockman in get_all_clockmen():
		clockman.grind_his_gears()
		return

func get_all_clockmen():
	var clockmen = []
	for body in get_parent().get_children():
		if body.has_method("grind_his_gears"):
			clockmen.append(body)
	return clockmen

func explode():
	var explosion = preload("res://effects/explosion/explosion.tscn").instantiate()
	explosion.scale = Vector2(3,3)
	call_deferred("add_child", explosion)
