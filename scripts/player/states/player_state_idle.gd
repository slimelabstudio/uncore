extends PlayerState

func enter(_msg := {}):
	player.anim_player.play("idle")

func update(delta : float):
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") \
	or Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		state_machine.transition_to("Run")
