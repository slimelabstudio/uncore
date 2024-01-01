class_name LocationNode
extends Area2D

@onready var icon : Sprite2D = $icon

var location_id : int 
#var location_type : LOC_TYPES

func setup(_id : int):
	location_id = _id
