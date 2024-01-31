extends State

var follow := false

var start_pos : Vector2

func enter(msg := {}):
	start_pos = owner.global_position
	
	owner.anim_player.play("run")
	
	var dir_x = Global.a_or_b(-1,1)
	var dir_y = Global.a_or_b(-1,1)
	
	owner.velocity = Vector2(dir_x,dir_y)*owner.move_speed
	owner.obstacle_detection.rotation = owner.velocity.angle()
	
	if owner.obstacle_detection.is_colliding():
		state_machine.transition_to("Idle")

func phys_update(_delta : float):
	owner.obstacle_detection.rotation = owner.velocity.angle()
	
	if owner.obstacle_detection.is_colliding():
		state_machine.transition_to("Idle")
	
	if start_pos.distance_to(owner.global_position) > 32 and randf() < 0.05:
		state_machine.transition_to("Idle")

	if owner.velocity.x < 0:
		owner.graphic.flip_h = true
	if owner.velocity.x > 0:
		owner.graphic.flip_h = false
