extends Node2D

@onready var obstacle_detection := $ShapeCast2D


func steer():
	if obstacle_detection.is_colliding():
		
