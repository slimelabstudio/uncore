extends PlayerState

func enter(msg := {}):
	player.anim_player.play("run")

func phys_update(delta : float):
	var input_dir = player.get_input()
	player.velocity = input_dir * player.SPEED
	
	
	if Input.is_action_just_pressed("active_ability") and player.has_energy():
		if player.current_equipment == 1: #----------DASH - ONLY IF ENERGY IS > 0
			state_machine.transition_to("Dash")
	
	if input_dir == Vector2.ZERO and player.equipment_active == false:
		state_machine.transition_to("Idle")
