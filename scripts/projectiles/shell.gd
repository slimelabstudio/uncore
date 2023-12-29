extends Projectile

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

@onready var timer : Timer = $Timer
@export var wait_to_slow_time : float
var slow_down : bool = false

var velocity : Vector2 = Vector2.ZERO

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.start(wait_to_slow_time)
	sprite.rotation = direction.angle()

func kill():
	queue_free()

func _physics_process(delta):
	if slow_down:
		proj_speed = lerp(proj_speed, 0.0, 6 * delta)
	
	velocity = (direction*proj_speed)
	
	position += velocity * delta
	
	if proj_speed < 50.0:
		queue_free()

func _on_timer_timeout():
	slow_down = true

func _on_body_entered(body):
	kill()


func _on_area_entered(area):
	kill()
