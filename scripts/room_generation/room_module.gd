class_name RoomModule
extends Node2D

const DOOR = preload("res://scenes/level_generation/room_door.tscn")

@onready var entrance_spawns : Array = $entrance_spawns.get_children()

var is_entrance : bool = false

var type : int = -1

func set_entrance():
	is_entrance = true
	print(type)
	var spawn = entrance_spawns.pick_random()
	var door = DOOR.instantiate()
	add_child(door)
	door.global_position = spawn.global_position
	
	return door.global_position
