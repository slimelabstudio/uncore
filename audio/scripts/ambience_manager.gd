extends Node

@export var min_bws_delay : float = 1.0
@export var max_bws_delay : float = 10.0

@export var area1_amb_loop : AudioStream 
@export var area1_bws_sfx : AudioStream
@export var area2_amb_loop : AudioStream
@export var area2_bws_sfx : AudioStream

var time_left : float = 0.0


func _process(delta):
	if time_left > 0:
		time_left -= delta
	else:
		var strm 
		match Global.current_tower_floor:
			1:
				strm = area1_bws_sfx
			2:
				strm = area2_bws_sfx
		
		AudioManager.play_bws_sound(Global.player_ref.global_position, strm)
