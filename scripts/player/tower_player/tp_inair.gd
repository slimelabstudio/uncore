extends State

var jump_held : bool = false

func enter(msg := {}):
	if msg.has("do_jump"):
		owner.velocity.y = owner.JUMP_VELOCITY
	
	if Input.is_action_pressed("jump"):
		jump_held = true

func phys_update(delta : float):
	if Input.is_action_just_released("jump"):
		jump_held = false
	
	var input_dir = owner.get_input()
	owner.velocity.x += owner.SPEED * (input_dir/6)
	owner.velocity.x = clampf(owner.velocity.x, -owner.SPEED, owner.SPEED)
	
	if jump_held:
		owner.velocity.y += owner.gravity * (delta*0.72)
	else:
		owner.velocity.y += owner.gravity * delta
	
	if owner.velocity.y > 0:
		owner.anim_player.play("down")
		if jump_held:
			jump_held = false
	if owner.velocity.y < 0:
		owner.anim_player.play("up")
	
	if owner.is_on_floor():
		if is_equal_approx(owner.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
