extends Projectile

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	sprite.rotation = direction.angle()

func _physics_process(delta):
	position += (direction * proj_speed)


func _on_area_2d_area_entered(area):
	queue_free()
func _on_area_2d_body_entered(body):
	queue_free()
