extends CanvasLayer

@onready var music_slider: HSlider = $ColorRect/music_slider
@onready var audio_slider: HSlider = $ColorRect/audio_slider
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var settings_button: MenuButton = $MenuButton
@onready var background_music: AudioStreamPlayer = $AudioStreamPlayer
@onready var reverse: bool = false

var audio_bus_index: int = 0
var music_bus_index: int = 0

func _ready():
	audio_bus_index = AudioServer.get_bus_index("Audio")
	music_bus_index = AudioServer.get_bus_index("Music")
	Global.sound_volume = audio_slider.value
	Global.music_volume = music_slider.value
	music_slider.value_changed.connect(on_music_slider_change)
	audio_slider.value_changed.connect(on_audio_slider_change)
	settings_button.pressed.connect(open_or_close_settings_box)
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))
	audio_slider.value = db_to_linear(AudioServer.get_bus_volume_db(audio_bus_index))
	background_music.play(0)
	
func _process(_delta):
	background_music.volume_db = Global.music_volume
	if Input.is_action_just_pressed("settings"):
		open_or_close_settings_box()
	
func open_or_close_settings_box():
	if reverse:
		animation_player.play_backwards("slide_in")
		await animation_player.animation_finished
		reverse = false
		get_tree().paused = false
	else:
		animation_player.play("slide_in")
		await animation_player.animation_finished
		reverse = true
		get_tree().paused = true

func on_music_slider_change(value):
	Global.music_volume = value
	AudioServer.set_bus_volume_db(
		music_bus_index,
		linear_to_db(value)
	)
	
func on_audio_slider_change(value):
	Global.sound_volume = value
	AudioServer.set_bus_volume_db(
		audio_bus_index,
		linear_to_db(value)
	)
