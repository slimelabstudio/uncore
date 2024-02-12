class_name MusicManager
extends Node

@export var autoplay : bool = false

@export var main_menu_music : AudioStream

@export var area_1_music : AudioStream
@export var area_1_secret_music : AudioStream

@export_category("Components")
@export var mx_player : AudioStreamPlayer

var mx_lp : AudioEffectLowPassFilter

func _ready():
	Global.mx_manager = self
	
	#AudioServer.add_bus_effect(4, load("res://audio/effects/mx_lowpass.tres"))
	#mx_lp = AudioServer.get_bus_effect(4, 0) #getting the lowpass effect
	
	mx_player.stream = area_1_music
	if autoplay:	mx_player.play()

func mx_filter_set(to_freq : int, duration : float):
	var t = create_tween()
	t.tween_property(mx_lp, "cutoff_hz", to_freq, duration)
