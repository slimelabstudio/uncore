extends Node

const MAX_VOICES : int = 32
var current_voices : int = 0

var music_player : AudioStreamPlayer

var ambience_player : AudioStreamPlayer

var max_bws_players : int = 4
var bws_players : Array[AudioStreamPlayer2D] = []
const MIN_BWS_DISTANCE : float = 50.0
const MAX_BWS_DISTANCE : float = 300.0

func _enter_tree():
	ambience_player = AudioStreamPlayer.new()
	add_child(ambience_player)

func play_sound_at(_position : Vector2, _sound : AudioStream, _name : String = "audioplayer", _bus : String = "Master") -> AudioStreamPlayer2D:
	var p = AudioStreamPlayer2D.new()
	get_tree().root.add_child(p)
	p.global_position = _position
	
	p.bus = _bus
	
	current_voices += 1
	
	p.stream = _sound
	
	p.play()
	
	p.process_mode = Node.PROCESS_MODE_ALWAYS
	
	p.name = _name
	
	p.finished.connect(func f(): p.queue_free())
	
	return p

func play_ambience(stream):
	ambience_player.stream = stream
	ambience_player.play()

func play_bws_sound(center_point : Vector2, _stream : AudioStream):
	if bws_players.size() >= max_bws_players:
		return
	
	var new_pos : Vector2
	var rand_x = Global.a_or_b(-1,1)
	var rand_y = Global.a_or_b(-1,1)
	var rand_dist = randf_range(MIN_BWS_DISTANCE, MAX_BWS_DISTANCE)
	new_pos = (center_point+Vector2(rand_x,rand_y))*rand_dist
	
	var new_player := AudioStreamPlayer2D.new()
	add_child(new_player)
	bws_players.append(new_player)
	new_player.global_position = new_pos
	new_player.stream = _stream
	new_player.play()
	new_player.finished.connect(func f():
		bws_players.erase(new_player)
		new_player.queue_free()
		)
