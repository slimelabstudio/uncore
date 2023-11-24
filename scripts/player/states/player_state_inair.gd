extends PlayerState

func enter(msg := {}):
	if msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY

func phys_update(delta : float):
	var input_dir = player.get_input()
	player.velocity.x += player.SPEED * (input_dir/6)
	player.velocity.x = clampf(player.velocity.x, -player.SPEED*2, player.SPEED*2)
	player.velocity.y += player.gravity * delta
	#player.move_and_slide()
	
	if player.get_input() < 0:
		player.graphic.flip_h = true
	if player.get_input() > 0:
		player.graphic.flip_h = false
	
	if player.velocity.y > 0:
		player.anim_player.play("player_fall")
	if player.velocity.y < 0:
		player.anim_player.play("player_jump")
	
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
