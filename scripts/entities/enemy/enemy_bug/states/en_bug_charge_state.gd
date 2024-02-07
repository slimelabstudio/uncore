extends State


func enter(_msg := {}):
	owner.anim_player.play("charge")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "charge":
		state_machine.transition_to("Leap", {"dir":(Global.player_ref.global_position-owner.global_position).normalized()})
