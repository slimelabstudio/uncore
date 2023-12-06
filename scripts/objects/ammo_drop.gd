class_name AmmoDrop
extends StaticBody2D

enum AMMO_TYPES {
	BULLET,
	SHELL,
	ENERGY,
}

var velocity : Vector2 = Vector2.ZERO

func _ready():
	velocity = Vector2(randf_range(-1.0,1.0), randf_range(-2.0,-1))

func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if !collision:
		velocity.y += (delta*6)
	else:
		velocity = Vector2.ZERO
	velocity.x = lerp(velocity.x, 0.0, delta)

func _on_area_2d_body_entered(body):
	if body is Player:
		print("Picked up: ")
		queue_free()
