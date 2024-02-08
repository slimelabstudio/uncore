extends Node

@onready var bws_timer := $bws_delay_timer

@export var auto_play : bool = false

@export var min_bws_delay : float = 1.0
@export var max_bws_delay : float = 10.0

@export var area1_amb_loop : AudioStream 
@export var area1_bws_sfx : AudioStream
@export var area2_amb_loop : AudioStream
@export var area2_bws_sfx : AudioStream

var time_left : float = 0.0

func _ready():
	if auto_play:
		AudioManager.play_ambience(area1_amb_loop)
		
		var rand_delay_time = randf_range(min_bws_delay, max_bws_delay)
		bws_timer.start(rand_delay_time)

func _on_bws_delay_timer_timeout():
	AudioManager.play_bws_sound(Global.player_ref.global_position, area1_bws_sfx)
	
	var rand_delay_time = randf_range(min_bws_delay, max_bws_delay)
	bws_timer.start(rand_delay_time)
