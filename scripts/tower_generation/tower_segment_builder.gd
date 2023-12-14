class_name TowerSegment
extends Node2D

var built_from : int

@onready var tilemap : TileMap = $TileMap

@export var door_parent : Node2D

const DOOR_SCENE := preload("res://scenes/level_generation/door.tscn")
const ROOM_DOOR_SCENE := preload("res://scenes/level_generation/room_door.tscn")

@onready var spawn_point_parent : Node2D = $spawns
@onready var spawn_points : Array = $spawns.get_children()

var seg_id : int = -1

var entrance_pos : Vector2
var exit_pos : Vector2

var security_breach : bool = true

# ROOM DOOR { POSITION, CLEAR }
var room_doors : Dictionary = {}
var spawned_objects : Array = []

signal change_segments(next_segment)

func get_free_spawn(points : Array):
	spawn_points = $spawns.get_children()
	var rp = points.pick_random()
	var pos = rp.global_position
	if rp in spawn_points:
		$spawns.remove_child(rp)
	spawn_points = $spawns.get_children()
	return pos

func set_main_doors(_exit_spawn, _entrance_spawn):
	var exit_door = DOOR_SCENE.instantiate()
	door_parent.add_child(exit_door)
	exit_door.global_position = _exit_spawn
	exit_door.is_exit = true
	exit_door.get_child(0).texture = load("res://textures/tower/tower_door_exit.png")
	exit_pos = exit_door.global_position
	exit_door.entered.connect(on_door_entered)
	spawned_objects.append(exit_door)
	
	var entrance_door = DOOR_SCENE.instantiate()
	door_parent.add_child(entrance_door)
	entrance_door.global_position = _entrance_spawn
	entrance_pos = entrance_door.global_position
	entrance_door.entered.connect(on_door_entered)
	spawned_objects.append(entrance_door)

func set_room_door():
	var rand_room_spawn = get_free_spawn(spawn_points)
	
	var room_door = ROOM_DOOR_SCENE.instantiate()
	door_parent.add_child(room_door)
	room_door.global_position = rand_room_spawn
	#room_door.get_child(0).texture = load("res://textures/tower/tower_door_room_active.png")
	room_door.entered.connect(enter_room)
	room_doors[str(seg_id)+"_"+str(room_door.get_index())] = { 
		"pos" : var_to_str(room_door.global_position),
		"clear" : var_to_str(room_door.room_cleared)
		}
	
	for remaining_spawn in spawn_points:
		if door_parent.get_children().size() < 5 and randf() < 0.8:
			var extra_room_door = ROOM_DOOR_SCENE.instantiate()
			door_parent.add_child(extra_room_door)
			extra_room_door.global_position = remaining_spawn.global_position
			#extra_room_door.get_child(0).texture = load("res://textures/tower/tower_door_room_active.png")
			extra_room_door.entered.connect(enter_room)
			room_doors[str(seg_id)+"_"+str(extra_room_door.get_index())] = { 
			"pos" : var_to_str(extra_room_door.global_position),
			"clear" : var_to_str(extra_room_door.room_cleared)
			}
			$spawns.remove_child(remaining_spawn)
			spawn_points = $spawns.get_children()

func place_room_door(_pos):
	var door = ROOM_DOOR_SCENE.instantiate()
	door_parent.add_child(door)
	door.global_position = _pos
	door.entered.connect(enter_room)
	#door.get_child(0).texture = load("res://textures/tower/tower_door_room_active.png")

func get_exit_pos():
	var r = randi_range(0, 3)
	var point = spawn_points[r]
	var ret = point.global_position
	$spawns.remove_child(point)
	spawn_points = $spawns.get_children()
	return ret
func get_enter_pos():
	var r = randi_range(spawn_points.size()-4, spawn_points.size()-1)
	var point = spawn_points[r]
	var ret = point.global_position
	$spawns.remove_child(point)
	spawn_points = $spawns.get_children()
	return ret

func set_npc():
	var npc_spawns = $spawns.get_children()
	
	#spawned_objects.append(NPC GLOBAL POS)

func set_chest():
	var chest_spawns = $spawns.get_children()
	
	#spawned_objects.append(CHEST GLOBAL POS)

func on_door_entered(dir):
	emit_signal("change_segments", dir)

func enter_room():
	get_tree().change_scene_to_packed(Global.ROOM_SCENE)
	Global.player_ref.visible = false

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
	savedata["segment_id"] = seg_id
	
	return savedata
