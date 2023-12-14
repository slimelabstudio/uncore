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
	"rm_lr" : [
		preload("res://scenes/level_generation/rooms/room_module_lr_1.tscn"),
	],
	"rm_lrd" : [
		preload("res://scenes/level_generation/rooms/room_module_lrd_1.tscn"),
	],
	"rm_lru" : [
		preload("res://scenes/level_generation/rooms/room_module_lru_1.tscn"),
	],
	"rm_lrud" : [
		preload("res://scenes/level_generation/rooms/room_module_lrud_1.tscn"),
	],
	"rm_fill" : [
		preload("res://scenes/level_generation/rooms/room_module_fill_1.tscn"),
	]
}

var spawned_modules : Dictionary = {}

var generating_room : bool = false

#TRACK GENERATOR POSITION
var current_grid_pos : Vector2 = Vector2.ZERO

@export var grid_size_x : int = 4
@export var grid_size_y : int = 4
var room_grid : Dictionary = {}

signal finished_generating

#ROOM GENERATES FROM TOP -> BOTTOM 
#WHERE EXIT IS PLACED FIRST

var move_dir : Vector2 = Vector2.ZERO
var last_dir : Vector2 = Vector2.ZERO
var last_room_type : String = ""

func _ready():
	room_grid = generate_grid()
	var rand_top_slot = room_grid.keys()[randi_range(0,4)]
	current_grid_pos = rand_top_slot
	spawned_modules[current_grid_pos] = "rm_lr" if randf() < 0.5 else "rm_lrd"
	room_grid[current_grid_pos] = 1
	last_room_type = spawned_modules[current_grid_pos]
	generating_room = true

func _process(delta):
	while(generating_room):
		move_dir = move_directions.pick_random()
		if move_dir == Vector2.DOWN:
			if current_grid_pos.y == edge_max_y:
				print("FINISHED GENERATING")
				room_grid[current_grid_pos] = 2
				fill_grid(spawned_modules)
				generating_room = false
				return
			
			if last_room_type == "rm_lrd":
				spawned_modules[current_grid_pos] = "rm_lrud"
				last_room_type = "rm_lrud"
				room_grid[current_grid_pos] = 0
			else:
				spawned_modules[current_grid_pos] = "rm_lrd"
				last_room_type = "rm_lrd"
				room_grid[current_grid_pos] = 0
		
		current_grid_pos = move_to_grid_pos(move_dir)
		
		match move_dir:
			Vector2.RIGHT:
				spawned_modules[current_grid_pos] = "rm_lr"
				last_room_type = "rm_lr"
				room_grid[current_grid_pos] = 0
			Vector2.LEFT:
				spawned_modules[current_grid_pos] = "rm_lr"
				last_room_type = "rm_lr"
				room_grid[current_grid_pos] = 0
			Vector2.DOWN:
				spawned_modules[current_grid_pos] = "rm_lru"
				last_room_type = "rm_lru"
				room_grid[current_grid_pos] = 0
		
		last_dir = move_dir

func generate_grid() -> Dictionary:
	var data = {}
	for x in grid_size_x:
		for y in grid_size_y:
			data[Vector2(x*step_x,y*step_y)] = -1
	return data

func move_to_grid_pos(dir : Vector2):
	#Handles screen-edge-dropping
	var curr = current_grid_pos
	#var new_pos = Vector2.ZERO
	
	match dir:
		Vector2.DOWN:
			curr += dir * step_y
		Vector2.RIGHT:
			if last_dir == Vector2.LEFT:
				move_to_grid_pos(Vector2.LEFT)
				return curr
			if curr.x == edge_max_x:
				move_to_grid_pos(Vector2.DOWN)
				return curr
			curr += dir * step_x
		Vector2.LEFT:
			if last_dir == Vector2.RIGHT:
				move_to_grid_pos(Vector2.RIGHT)
				return curr
			if curr.x == edge_min_x:
				move_to_grid_pos(Vector2.DOWN)
				return curr
			curr += dir * step_x
	return curr

func fill_grid(data : Dictionary):
	for key in data.keys():
		var pos = Vector2(key)
		var type = data[key] as String
		spawn_module(type, pos)
	
	#var empty_slots = get_empty_spawns()
	#for i in empty_slots:
		#room_grid[i] = 0
		#spawn_module("rm_fill", i)

func spawn_module(type : String, pos : Vector2):
	var scene = room_modules[type].pick_random().instantiate()
	add_child(scene)
	scene.global_position = pos
	#spawned_modules[pos] = type
	return scene

func get_empty_spawns():
	var mod_positions = []
	for key in spawned_modules.keys():
		var pos = Vector2(key)
		mod_positions.append(pos)
	
	var free_slots = []
	for slot in room_grid:
		if not slot in mod_positions:
			#Can place filler module
			free_slots.append(slot)
	
	return free_slots
