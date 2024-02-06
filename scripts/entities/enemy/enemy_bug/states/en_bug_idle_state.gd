extends State

func enter(msg := {}):
	owner.velocity = Vector2.ZERO
	
	owner.anim_player.play("idle")

func update(_delta : float):
	if owner.can_see_player():
		if !owner.player_spotted:
			state_machine.transition_to("Run", {agro=true})
	
	if !owner.obstacle_detection.is_colliding():
		if randf()*100 < 3.0:
			state_machine.transition_to("Run")
	
	owner.obstacle_detection.rotation += (owner.turn_dir*6) * _delta
