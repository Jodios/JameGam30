extends Node2D

func _ready():
	$AnimationPlayer.speed_scale = 8
	$AnimationPlayer.play("explosion")
	$AudioStreamPlayer2D.play(0)
	await $AnimationPlayer.animation_finished
	await $AudioStreamPlayer2D.finished
	queue_free()
