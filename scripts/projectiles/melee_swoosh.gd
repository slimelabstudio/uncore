extends Area2D

var dir : Vector2
@export var initial_speed : float
@export var decceleration : float
var current_speed : float = 0.0

@export var dmg : int = 0


func _ready():
	current_speed = randf_range(initial_speed-20.0,initial_speed+20.0)
	rotation = dir.angle()

func _physics_process(delta):
	if current_speed > 0.1:
		current_speed = move_toward(current_speed, 0.0, decceleration * delta)
	
	if modulate.a > 0.0:
		modulate.a -= 2*delta
	
	position += (dir * current_speed) * delta
