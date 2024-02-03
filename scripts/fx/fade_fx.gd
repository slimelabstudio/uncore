extends ColorRect

@export var anim : AnimationPlayer

signal done(state : String)


func fade_in():
	anim.play("fade_in")

func fade_out():
	anim.play("fade_out")

func kill():
	queue_free()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		emit_signal("done", "in")
	elif anim_name == "fade_out":
		emit_signal("done", "out")
		kill()
