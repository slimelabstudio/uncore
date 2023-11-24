extends Node2D

@export var ground_check : RayCast2D

var velocity : Vector2 = Vector2.ZERO

var item : Item = null : set = _set_item
func _set_item(val):
	item = val

func _ready():
	velocity = Vector2(randf_range(-30, 30), randf_range(-100,-50))

func _physics_process(delta):
	if not ground_check.is_colliding():
		velocity.y = move_toward(velocity.y, 300.0, 300.0 * delta)
	else:
		velocity.y = 0
		if velocity.x != 0:
			velocity.x = move_toward(velocity.x, 0.0, 120.0 * delta)
	velocity.y = clampf(velocity.y, -300, 300)
	
	position += velocity * delta

func _on_pickup_detection_body_entered(body):
	if body is Player:
		if body.inventory.can_add_to_inventory():
			body.inventory.add_item()
