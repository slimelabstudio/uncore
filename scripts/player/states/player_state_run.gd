extends PlayerState

func enter(msg := {}):
	player.anim_player.play("run")

func phys_update(delta : float):
	var input_dir = player.get_input()
	player.velocity = (input_dir * player.SPEED)
	
	if input_dir == Vector2.ZERO:
		state_machine.transition_to("Idle")
