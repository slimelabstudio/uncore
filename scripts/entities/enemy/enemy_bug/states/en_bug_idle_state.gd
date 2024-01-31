extends State

func enter(msg := {}):
	owner.velocity = Vector2.ZERO
	
	owner.anim_player.play("idle")

func update(_delta : float):
	if randf()*100 < 2.0:
		state_machine.transition_to("Run")
