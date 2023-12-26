extends State


func enter(_msg := {}):
	owner.anim_player.play("idle")

func update(_delta : float):
	if not owner.is_on_floor():
		state_machine.transition_to("InAir")
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("InAir", {"do_jump"=true})
	
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.transition_to("Run")
