class_name RoomModule
extends Node2D

const DOOR = preload("res://scenes/level_generation/room_door.tscn")

@onready var entrance_spawns = $entrance_spawns.get_children()

var is_entrance : bool = false


func set_entrance():
	is_entrance = true
	
	var spawn = entrance_spawns.pick_random()
	var door = DOOR.instantiate()
	add_child(door)
	door.global_position = spawn.global_position
