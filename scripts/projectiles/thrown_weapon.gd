extends Area2D

@export var throw_speed : float = 100.0
var current_speed : float

@export var decceleration : float = 1.0

@export var rot_speed : float = 10.0

var throw_dir : Vector2

var rot_dir := 1

@onready var graphic := $Sprite2D

func _ready():
	var r = randf()
	rot_dir = 1 if r < 0.5 else -1
	
	current_speed = throw_speed + randf_range(-10.0, 10.0)

func _physics_process(delta):
	graphic.rotation += delta * (rot_dir * rot_speed)
	
	if current_speed > 1.0:
		current_speed = move_toward(current_speed, 0.0, delta * decceleration)
	else:
		queue_free()
	
	position += delta * (throw_dir * current_speed)


func _on_body_entered(body):
	queue_free()
