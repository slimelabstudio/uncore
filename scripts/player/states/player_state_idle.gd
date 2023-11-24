extends PlayerState

func enter(_msg := {}):
	player.velocity = Vector2.ZERO
	player.anim_player.play("player_idle")

func update(delta : float):
	if not player.is_on_floor():
		state_machine.transition_to("InAir")
		return
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("InAir", {do_jump = true})
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.transition_to("Run")
