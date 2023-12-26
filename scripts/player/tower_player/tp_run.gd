extends State


func enter(_msg := {}):
	owner.anim_player.play("run")

func phys_update(_delta : float):
	if not owner.is_on_floor():
		state_machine.transition_to("InAir")
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("InAir", {"do_jump"=true})
	
	var inp = owner.get_input()
	owner.velocity.x = inp * owner.SPEED
	
	if inp < 0.0:
		owner.graphic.flip_h = true
	if inp > 0.0:
		owner.graphic.flip_h = false
	
	if is_equal_approx(inp, 0.0):
		state_machine.transition_to("Idle")
