extends PlayerState

@export var max_dash_time : float = 1.0
var dash_time_elapsed : float = 0.0

func enter(msg := {}):
	player.equipment_active = true
	player.equipment_energy_charges -= 1
	
	player.dash_direction = player.get_input()
	
	player.dash_obstacle_check.target_position = player.dash_direction * 2

func exit():
	print("Exiting DASH state")
	player.equipment_active = false

func phys_update(_delta : float):
	player.velocity = (player.dash_direction * player.dash_speed)
	player.velocity.limit_length(player.dash_speed)
	
	if player.dash_obstacle_check.is_colliding():
		dash_time_elapsed = max_dash_time
	
	dash_time_elapsed = move_toward(dash_time_elapsed, max_dash_time, _delta)
	if dash_time_elapsed >= max_dash_time:
		if player.get_input() != Vector2.ZERO:
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")
		dash_time_elapsed = 0.0
