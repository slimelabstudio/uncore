class_name TowerSegment
extends Node2D

@export var map : TileMap

@export var is_entrance : bool = false

# SEE "SCOURGEBRINGER" FOR IDEA OF HOW TOWER WILL BE STRUCTURED

var segment_data : Dictionary = {}

func set_enter():
	if !is_entrance:
		var enter_spot = $enter_spawns.get_children().pick_random()
		var map_spot = map.local_to_map(enter_spot.global_position)
		
		segment_data["enter_pos"] = map_spot
		
		map.set_cell(1, map_spot+Vector2i.LEFT, 0, Vector2(4,0))
		map.set_cell(1, map_spot+Vector2i.RIGHT, 0, Vector2(4,0))
		map.set_cell(1, map_spot, 0, Vector2(4,0))
		
		#Make corner walls
		map.set_cell(1, map_spot+Vector2i.LEFT*2, 0, Vector2i(10,0))
		map.set_cell(1, map_spot+Vector2i.RIGHT*2, 0, Vector2i(8,0))
		
		#make drop walls
		map.set_cell(1, (map_spot+Vector2i.LEFT*2)+Vector2i.DOWN, 0, Vector2i(10, 1))
		map.set_cell(1, (map_spot+Vector2i.RIGHT*2)+Vector2i.DOWN, 0, Vector2i(8, 1))
		
		return enter_spot.global_position
	
	return $player_spawn.global_position

func set_exit():
	if !is_entrance:
		var exit_spot = $exit_spawns.get_children().pick_random()
		var map_spot = map.local_to_map(exit_spot.global_position)
		
		segment_data["exit_pos"] = map_spot
		
		map.set_cell(1, (map_spot+Vector2i.UP), 0, Vector2(-1,-1))
		map.set_cell(1, (map_spot+Vector2i.UP)+Vector2i.RIGHT, 0, Vector2(-1,-1))
		map.set_cell(1, (map_spot+Vector2i.UP)+Vector2i.LEFT, 0, Vector2(-1,-1))
		
		map.set_cell(1, (map_spot+Vector2i.UP)+Vector2i.LEFT*2, 0, Vector2i(10,2))
		map.set_cell(1, (map_spot+Vector2i.UP)+Vector2i.RIGHT*2, 0, Vector2i(8,2))

func save_segment_data() -> Dictionary:
	var data = {}
	data = segment_data
	return data
