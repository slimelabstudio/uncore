class_name RoomGenerator
extends Node2D

const move_directions : Array[Vector2] = [
	Vector2.RIGHT,
	Vector2.RIGHT,
	Vector2.LEFT,
	Vector2.LEFT,
	Vector2.DOWN
]

@export var edge_min_x : int 
@export var edge_max_x : int
@export var edge_min_y : int
@export var edge_max_y : int
@export var step_x : int
@export var step_y : int

@onready var room_modules : Dictionary = {
	#FILLER
	0 : [
		preload("res://scenes/level_generation/rooms/room_module_fill_1.tscn"),
	],
	#LEFT/RIGHT
	1 : [
		preload("res://scenes/level_generation/rooms/room_module_lr_1.tscn"),
	],
	#LEFT/RIGHT/DOWN
	2 : [
		preload("res://scenes/level_generation/rooms/room_module_lrd_1.tscn"),
	],
	#LEFT/RIGHT/UP
	3 : [
		preload("res://scenes/level_generation/rooms/room_module_lru_1.tscn"),
	],
	#LEFT/RIGHT/UP/DOWN
	4 : [
		preload("res://scenes/level_generation/rooms/room_module_lrud_1.tscn"),
	],
}

var generating_room : bool = false

#TRACK GENERATOR POSITION
var current_grid_pos : Vector2 = Vector2.ZERO

@export var grid_size_x : int = 4
@export var grid_size_y : int = 4

# { POSITION, TYPE }
# 0 = filler, 1 = left/right, 2 = left/right/down, 3 = left/right/up, 4 = left/right/up/down
var room_grid : Dictionary = {}

var player_spawn_grid_space : Vector2

signal finished_generating(room_grid_data : Dictionary)

#ROOM GENERATES FROM TOP -> BOTTOM 
#WHERE EXIT IS PLACED FIRST

var move_dir : Vector2 = Vector2.ZERO
var last_dir : Vector2 = Vector2.ZERO
var last_room_type : int = -1

func _ready():
	Global.set_room_manager(self)
	
	room_grid = generate_grid()
	
	#Set starting room
	var rand_top_slot = room_grid.keys()[randi_range(0, grid_size_x-1)]
	#Set current grid pos
	current_grid_pos = rand_top_slot
	#Set room type for grid position
	room_grid[current_grid_pos] = 1 if randf() < 0.6 else 2 #exit room
	
	generating_room = true

var next_dir : Vector2
func _process(delta):
	while(generating_room):
		next_dir = move_directions.pick_random()
		
		match next_dir:
			Vector2.DOWN:
				if current_grid_pos.y == edge_max_y:
					room_grid[current_grid_pos] = 4
					finish_generating()
					break
				
				room_grid[current_grid_pos] = 2
				current_grid_pos += next_dir * step_y
				room_grid[current_grid_pos] = 3
			Vector2.LEFT:
				if current_grid_pos.x == edge_min_x:
					if current_grid_pos.y == edge_max_y:
						room_grid[current_grid_pos] = 4
						finish_generating()
						break
					room_grid[current_grid_pos] = 2
					current_grid_pos += Vector2.DOWN * step_y
					room_grid[current_grid_pos] = 3
					break
				
				current_grid_pos += next_dir * step_x
				room_grid[current_grid_pos] = 1
			Vector2.RIGHT:
				if current_grid_pos.x == edge_max_x:
					if current_grid_pos.y == edge_max_y:
						room_grid[current_grid_pos] = 4
						finish_generating()
						break
					room_grid[current_grid_pos] = 2
					current_grid_pos += Vector2.DOWN * step_y
					room_grid[current_grid_pos] = 3
					break
				
				current_grid_pos += next_dir * step_x
				room_grid[current_grid_pos] = 1

func generate_grid() -> Dictionary:
	var data = {}
	for y in grid_size_x:
		for x in grid_size_y:
			data[Vector2(x*step_x,y*step_y)] = -1
	return data

func set_fill_slots(data : Dictionary):
	for key in data.keys():
		if data[key] == -1:
			room_grid[key] = 0

func fill_grid(data : Dictionary):
	player_spawn_grid_space = room_grid.keys()[room_grid.keys().size()-1]
	
	set_fill_slots(room_grid)
	
	for key in data.keys():
		var pos = Vector2(key)
		var type = data[key] as int
		spawn_module(type, pos)

func spawn_module(type : int, pos : Vector2):
	if type != -1:
		var scene = room_modules[type].pick_random().instantiate()
		add_child(scene)
		scene.global_position = pos
		
		if pos == player_spawn_grid_space:
			scene.set_entrance()
		
		return scene

func finish_generating():
	fill_grid(room_grid)
	generating_room = false
	emit_signal("finished_generating", room_grid)
