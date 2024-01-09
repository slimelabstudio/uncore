extends Node


func play_sound_at(pos : Vector2, sound : AudioStream, n : String = "audioplayer") -> AudioStreamPlayer2D:
	var p = AudioStreamPlayer2D.new()
	get_tree().root.add_child(p)
	p.global_position = pos
	
	p.stream = sound
	
	p.play()
	
	p.process_mode = Node.PROCESS_MODE_ALWAYS
	
	p.name = n
	
	p.finished.connect(func f(): p.queue_free())
	
	return p
