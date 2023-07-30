extends StaticBody2D

@export var turn_speed: float = 1

func _ready():
	pass

func _physics_process(_delta):
	rotation_degrees += turn_speed
