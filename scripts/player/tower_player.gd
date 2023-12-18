class_name TowerPlayer
extends CharacterBody2D


const SPEED = 140.0
const JUMP_VELOCITY = -340.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1080.0

var jump_held : bool = false

func _physics_process(delta):
	if not is_on_floor():
		if jump_held:
			velocity.y += (gravity-120.0) * (delta*0.8)
		else:
			velocity.y += gravity * delta
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, -JUMP_VELOCITY)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_held = true
	if Input.is_action_just_released("jump"):
		jump_held = false

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
