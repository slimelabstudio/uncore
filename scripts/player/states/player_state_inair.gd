extends PlayerState

var jump_held : bool = false

func enter(msg := {}):
	if msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY
	
	if Input.is_action_pressed("jump"):
		jump_held = true

func phys_update(delta : float):
	if Input.is_action_just_released("jump"):
		jump_held = false
	
	var input_dir = player.get_input()
	player.velocity.x += player.SPEED * (input_dir/6)
	player.velocity.x = clampf(player.velocity.x, -player.SPEED*2, player.SPEED*2)
	
	if jump_held:
		player.velocity.y += player.gravity * (delta*0.72)
	else:
		player.velocity.y += player.gravity * delta
	
	if player.velocity.y > 0:
		player.anim_player.play("fall")
		if jump_held:
			jump_held = false
	if player.velocity.y < 0:
		player.anim_player.play("jump")
	
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
