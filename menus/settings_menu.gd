extends CanvasLayer

@onready var music_slider: HSlider = $ColorRect/music_slider
@onready var audio_slider: HSlider = $ColorRect/audio_slider
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var settings_button: MenuButton = $MenuButton
@onready var reverse: bool = false

func _ready():
	Global.sound_volume = audio_slider.value
	Global.music_volume = music_slider.value
	music_slider.value_changed.connect(on_music_slider_change)
	audio_slider.value_changed.connect(on_audio_slider_change)
	settings_button.pressed.connect(open_or_close_settings_box)
	
func open_or_close_settings_box():
	if reverse:
		animation_player.play_backwards("slide_in")
		await animation_player.animation_finished
		reverse = false
		Global.input_enabled = true
	else:
		animation_player.play("slide_in")
		await animation_player.animation_finished
		reverse = true
		Global.input_enabled = false

func on_music_slider_change(value):
	Global.music_volume = value
	
func on_audio_slider_change(value):
	Global.sound_volume = value
