extends PlayerState

func enter(msg := {}):
	player.anim_player.play("run")
	pass

func phys_update(delta : float):
	if not player.is_on_floor():
		state_machine.transition_to("InAir")
		return
	
	var input_dir = player.get_input()
	player.velocity.x = player.SPEED * input_dir
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
#	if player.velocity.x < 0:
#		player.graphic.flip_h = true
#	if player.velocity.x > 0:
#		player.graphic.flip_h = false
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("InAir", {do_jump=true})
	elif is_equal_approx(input_dir, 0.0):
		state_machine.transition_to("Idle")
