class_name RoomGenerator
extends Node2D

const move_directions : Array[Vector2i] = [
	Vector2i.RIGHT,
	Vector2.RIGHT,
	Vector2.LEFT,
	Vector2.LEFT,
	Vector2.UP,
	Vector2.DOWN,
]

@onready var map : TileMap = $TileMap

var room_generating : bool = false

var current_grid_pos : Vector2i
var next_move : Vector2i

@export var max_floor_tiles : int = 100
var current_floor_tiles : int = 0

var player_spawn_pos : Vector2 = Vector2.ZERO

signal gen_finished(_spawn_pos : Vector2)

func _ready():
	Global.set_room_manager(self)
	
	#build spawn room
	var room_size_x = randi_range(4,6)
	var room_size_y = randi_range(4,6)
	for x in room_size_x:
		for y in room_size_y:
			map.set_cell(2, Vector2i(0 + x, 0 + y), 0, Vector2i.ZERO)
	
	current_grid_pos = Vector2(floor(room_size_x/2), floor(room_size_y/2))
	player_spawn_pos = map.map_to_local(current_grid_pos)
	
	#create start hallway
	var hall_length = randi_range(10, 14)
	var step_dir = move_directions.pick_random()
	var last_tile_pos 
	for l in range(hall_length):
		map.set_cell(2, ((step_dir*l)+current_grid_pos), 0, Vector2i.ZERO)
		current_floor_tiles += 1
		last_tile_pos = ((step_dir*l)+current_grid_pos)
	current_grid_pos = last_tile_pos
	next_move = step_dir
	room_generating = true

func _process(delta):
	while(room_generating):
		current_grid_pos = move_placer(next_move)
		if is_grid_pos_empty(1):
			if current_floor_tiles < max_floor_tiles:
				map.set_cell(2, current_grid_pos, 0, Vector2i.ZERO)
				current_floor_tiles += 1
				
				if randf() < 0.018 and current_floor_tiles > (max_floor_tiles/3):
					#build a room
					var rand_room_size_x = randi_range(4, 12)
					var rand_room_size_y = randi_range(4, 12)
					for x in rand_room_size_x:
						for y in rand_room_size_y:
							map.set_cell(2, current_grid_pos+Vector2i(x,y), 0, Vector2.ZERO)
					current_floor_tiles -= 5
			else:
				build_walls()
				finish_generating()
		else:
			move_placer(next_move)
		
		next_move = move_directions.pick_random()

func move_placer(_dir : Vector2i):
	return current_grid_pos + _dir

func is_grid_pos_empty(_layer : int = 0) -> bool:
	var used = map.get_used_cells(_layer)
	for u in used:
		if map.get_cell_atlas_coords(_layer, u) == Vector2i(-1,-1):
			return false
	return true

const check_directions := [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT]
func build_walls():
	#get all floor tiles 
	var used_floors = map.get_used_cells(2)
	for tile in used_floors:
		for dir in check_directions:
			if not tile+dir in used_floors:
				if not tile+dir in map.get_used_cells(1) and not tile+dir in map.get_used_cells(0):
					match dir:
						Vector2i.UP:
							map.set_cell(1,tile+dir,0,Vector2i(0,2))
						Vector2i.DOWN:
							map.set_cell(0,tile+dir,0,Vector2i(0,3))
						Vector2i.RIGHT:
							map.set_cell(0,tile+dir,0,Vector2i(0,3))
						Vector2i.LEFT:
							map.set_cell(0,tile+dir,0,Vector2i(0,3))
	#Loop through wall layer to set bottom walls
	var used_top_walls = map.get_used_cells(0)
	for tile in used_top_walls:
		if tile+Vector2i.DOWN in used_floors:
			map.set_cell(0,tile,0,Vector2(-1,-1))
			map.set_cell(1, tile, 0, Vector2i(0,2))
			continue
		if tile+Vector2i.UP in used_floors:
			map.set_cell(0,tile+Vector2i.UP,0,Vector2i(0,1))
	
	var all_walls = []
	all_walls = map.get_used_cells(0) + map.get_used_cells(1)
	for w in all_walls:
		for dir in check_directions:
			if not w+dir in all_walls and not w+dir in used_floors:
				map.set_cell(0,w+dir,0,Vector2i(0,3))
				continue
	
	#Loop through bottom walls
	var used_bot_walls = map.get_used_cells(1)
	for tile in used_bot_walls:
		#Set empty space above all tiles
		if not tile+Vector2i.UP in used_bot_walls and not tile+Vector2i.UP in used_top_walls \
		and not tile+Vector2i.UP in used_floors:
			map.set_cell(0,tile+Vector2i.UP,0,Vector2i(0,3))
			continue
		
		if tile+Vector2i.UP in used_floors:
			map.set_cell(0, tile+Vector2i.UP, 0, Vector2i(0,1))
			continue

func finish_generating():
	room_generating = false
	emit_signal("gen_finished", player_spawn_pos)
