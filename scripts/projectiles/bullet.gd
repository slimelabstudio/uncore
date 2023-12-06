extends Projectile

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

var velocity : Vector2 = Vector2.ZERO

func _ready():
	sprite.rotation = direction.angle()

func kill():
	queue_free()

func _physics_process(delta):
	velocity = (direction * proj_speed)
	var collision : KinematicCollision2D = move_and_collide(velocity)
	if collision:
		velocity = Vector2.ZERO
		kill()
