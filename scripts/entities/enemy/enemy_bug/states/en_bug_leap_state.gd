extends State

var leap_direction : Vector2
var start_position : Vector2

func enter(_msg := {}):
	owner.attack_area.monitoring = true
	
	start_position = owner.global_position
	
	if _msg.has("dir"):
		leap_direction = _msg["dir"]
	else:
		state_machine.transition_to("Idle")
	owner.anim_player.play("leap")
	
	AudioManager.play_sound_at(owner.global_position, owner.leap_sound, "en_bug_leap_sfx", "ENEMY")

func exit():
	owner.attack_area.monitoring = false

func phys_update(_delta : float):
	if owner.obstacle_detection.is_colliding():
		state_machine.transition_to("Idle")
	
	if owner.global_position.distance_to(start_position) >= owner.leap_distance:
		state_machine.transition_to("Idle", {finished_leap=true})
	
	owner.velocity = leap_direction * owner.leap_speed
	
	owner.move_and_slide()
	
	if owner.velocity == Vector2.ZERO:
		state_machine.transition_to("Idle")

func _on_attack_area_body_entered(body):
	if body is Player and !body.dead:
		body.health_component.take_damage(owner.damage)
