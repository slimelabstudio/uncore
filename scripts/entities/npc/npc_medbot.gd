extends CharacterBody2D

@onready var obstacle_detection := $ShapeCast2D

@export var move_speed : float = 20.0

var turn_dir : int = 1
var move_dir : Vector2


func rand_move_direction() -> Vector2:
	var r : float = randf_range(0,360)
	return Vector2.from_angle(r)

func change_turn_dir():
	turn_dir *= -1

func _ready():
	
	
	move_dir = rand_move_direction()
	obstacle_detection.rotation = move_dir.angle()

func _physics_process(delta):
	
	if obstacle_detection.is_colliding():
		obstacle_detection.rotation += turn_dir * (8*delta)
	
	if randf() < 0.02:
		obstacle_detection.rotation += turn_dir * (8*delta)
	
	if randf() < 0.002:
		change_turn_dir()
	
	move_dir = Vector2.from_angle(obstacle_detection.rotation)
	velocity = move_dir * move_speed
	move_and_slide()
