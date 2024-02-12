extends State

var follow := false

var start_pos : Vector2

var chasing := false

func enter(msg := {}):
	if msg.has("agro"):
		chasing = true
	
	start_pos = owner.global_position
	
	if owner.obstacle_detection.is_colliding():
		state_machine.transition_to("Idle")
	
	owner.anim_player.play("run")

func phys_update(_delta : float):
	if start_pos.distance_to(owner.global_position) > 40 and randf() < 0.03:
		state_machine.transition_to("Idle")
	
	if (owner.obstacle_detection.is_colliding() and owner.velocity != Vector2.ZERO) or randf()*100 < 2:
		owner.obstacle_detection.rotation += (owner.turn_dir*6) * _delta
	
	if not chasing:
		if owner.can_see_player():
			chasing = true
		owner.velocity = Vector2.from_angle(owner.obstacle_detection.rotation) * owner.move_speed
	else:
		if owner.can_see_player() == false:
			chasing = false
		
		var dir_to_player = (Global.player_ref.global_position - owner.global_position).normalized()
		owner.obstacle_detection.rotation = dir_to_player.angle()
		
		if owner.global_position.distance_to(Global.player_ref.global_position) < 42:
			state_machine.transition_to("Charge")
		
		owner.velocity = Vector2.from_angle(owner.obstacle_detection.rotation) * owner.chase_speed
	owner.move_and_slide()
	
	if owner.velocity.x < 0:
		owner.graphic.flip_h = true
	if owner.velocity.x > 0:
		owner.graphic.flip_h = false
