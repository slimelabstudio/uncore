class_name TowerSegment
extends Node2D

var built_from : int

@onready var tilemap : TileMap = $TileMap

const DOOR_SCENE := preload("res://scenes/level_generation/door.tscn")

var seg_id : int = -1

var entrance_pos : Vector2
var exit_pos : Vector2

var security_breach : bool = true

# ROOM DOOR { ID, POSITION }
var room_doors : Dictionary = {}
var spawned_objects : Array = []

var exit_spawns
var entrance_spawns

signal change_segments(next_segment)

func _enter_tree():
	entrance_spawns = $spawns/entrance_spawns.get_children()
	exit_spawns = $spawns/exit_spawns.get_children()

func set_main_doors(_exit_spawn, _entrance_spawn):
	var exit_door = DOOR_SCENE.instantiate()
	add_child(exit_door)
	exit_door.global_position = _exit_spawn
	exit_door.is_exit = true
	exit_door.get_child(0).texture = load("res://textures/tower/tower_door_exit.png")
	exit_pos = exit_door.global_position
	exit_door.entered.connect(on_door_entered)
	spawned_objects.append(exit_door)
	
	var entrance_door = DOOR_SCENE.instantiate()
	add_child(entrance_door)
	entrance_door.global_position = _entrance_spawn
	entrance_pos = entrance_door.global_position
	entrance_door.entered.connect(on_door_entered)
	spawned_objects.append(entrance_door)

func set_room_door():
	var room_spawns = $spawns/room_spawns.get_children()
	for s in room_spawns:
		if randf() < 0.7:
			var room_door = DOOR_SCENE.instantiate()
			add_child(room_door)
			room_door.global_position = s.global_position
			room_door.get_child(0).texture = load("res://textures/tower/tower_door_room_active.png")
			room_doors[str(s.get_index())+"_x"] = s.global_position.x
			room_doors[str(s.get_index())+"_y"] = s.global_position.y

func set_npc():
	var npc_spawns = $spawns/npc_spawns.get_children()
	
	#spawned_objects.append(NPC GLOBAL POS)

func set_chest():
	var chest_spawns = $spawns/chest_spawns.get_children()
	
	#spawned_objects.append(CHEST GLOBAL POS)

func on_door_entered(dir):
	emit_signal("change_segments", dir)

func check_security_status() -> bool:
	for k in room_doors.keys():
		if room_doors[k] == false:
			return false
		else:
			return true
	return true

func save_segment():
	var savedata : Dictionary = {}
	
	savedata["scene"] = built_from
	savedata["enter_pos_x"] = entrance_pos.x
	savedata["enter_pos_y"] = entrance_pos.y
	savedata["exit_pos_x"] = exit_pos.x
	savedata["exit_pos_y"] = exit_pos.y
	savedata["position_x"] = global_position.x
	savedata["position_y"] = global_position.y
	savedata["room_spawns"] = room_doors
	
	return savedata
