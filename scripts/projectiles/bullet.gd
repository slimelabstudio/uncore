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
	position += velocity * delta


func _on_body_entered(body):
	kill()


func _on_area_entered(area):
	kill()
