class_name RoomGenerator
extends Node2D

const player_hud_scene := preload("res://scenes/ui/player_hud.tscn")

const move_directions : Array[Vector2i] = [
	Vector2i.RIGHT,
	Vector2.LEFT,
	Vector2.UP,
	Vector2.UP,
	Vector2.DOWN,
	Vector2.DOWN,
]

@onready var map : TileMap = $TileMap

@onready var hud_layer : SubViewport = $HUD/hud_vp_container/hud_vp

var room_generating : bool = false

var current_grid_pos : Vector2i
var next_move : Vector2i

@export var max_floor_tiles : int = 100
var current_floor_tiles : int = 0

var player_spawn_pos : Vector2 = Vector2.ZERO

var camera_ref : Camera2D 

signal gen_finished(_spawn_pos : Vector2)

func _ready():
	Global.set_room_manager(self)
	
	#build spawn room
	var room_size_x = randi_range(4,6)
	var room_size_y = randi_range(4,6)
	for x in room_size_x:
		for y in room_size_y:
			map.set_cell(3, Vector2i(0 + x, 0 + y), Global.current_tower_floor, Vector2i.ZERO)
	
	current_grid_pos = Vector2(floor(room_size_x/2), floor(room_size_y/2))
	player_spawn_pos = map.map_to_local(current_grid_pos)
	
	#create start hallway
	var hall_length = randi_range(10, 14)
	var step_dir = move_directions.pick_random()
	var last_tile_pos 
	for l in range(hall_length):
		map.set_cell(3, ((step_dir*l)+current_grid_pos), Global.current_tower_floor, Vector2i.ZERO)
		current_floor_tiles += 1
		last_tile_pos = ((step_dir*l)+current_grid_pos)
	current_grid_pos = last_tile_pos
	next_move = step_dir
	room_generating = true

var tiles_between_rooms := 0
func _process(delta):
	while(room_generating):
		current_grid_pos = move_placer(next_move)
		if not current_grid_pos in map.get_used_cells(3):
			if current_floor_tiles < max_floor_tiles:
				var rand_tile = randi_range(0,3)
				if randf() < 0.95:	rand_tile = 0
				map.set_cell(3, current_grid_pos, Global.current_tower_floor, Vector2i(rand_tile, 0))
				current_floor_tiles += 1
				tiles_between_rooms += 1
				
				if randf() < 0.018 and current_floor_tiles > (max_floor_tiles/3) and tiles_between_rooms > 80:
					#build a room
					var rand_room_size_x = randi_range(4, 12)
					var rand_room_size_y = randi_range(4, 12)
					for x in rand_room_size_x:
						for y in rand_room_size_y:
							var randd_tile = randi_range(0,3)
							if randf() < 0.95:	randd_tile = 0
							map.set_cell(3, current_grid_pos+Vector2i(x,y), Global.current_tower_floor, Vector2i(randd_tile, 0))
					tiles_between_rooms = 0
					current_floor_tiles -= 10
			else:
				build_walls()
				place_shadows()
				finish_generating()
		else:
			move_placer(next_move)
		
		next_move = move_directions.pick_random()

func move_placer(_dir : Vector2i):
	return current_grid_pos + _dir

const check_directions := [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT]
func build_walls():
	#get all floor tiles 
	var used_floors = map.get_used_cells(3)
	for tile in used_floors:
		for dir in check_directions:
			if not tile+dir in used_floors:
				if not tile+dir in map.get_used_cells(2) and not tile+dir in map.get_used_cells(1):
					match dir:
						Vector2i.UP:
							map.set_cell(2,tile+dir,Global.current_tower_floor,Vector2i(0,2))
						Vector2i.DOWN:
							map.set_cell(1,tile+dir,Global.current_tower_floor,Vector2i(0,3))
						Vector2i.RIGHT:
							map.set_cell(1,tile+dir,Global.current_tower_floor,Vector2i(0,3))
						Vector2i.LEFT:
							map.set_cell(1,tile+dir,Global.current_tower_floor,Vector2i(0,3))
	#Loop through wall layer to set bottom walls
	var used_top_walls = map.get_used_cells(1)
	for tile in used_top_walls:
		if tile+Vector2i.DOWN in used_floors:
			map.set_cell(1,tile,Global.current_tower_floor,Vector2(-1,-1))
			map.set_cell(2, tile, Global.current_tower_floor, Vector2i(0,2))
			continue
		if tile+Vector2i.UP in used_floors:
			map.set_cell(1,tile+Vector2i.UP,Global.current_tower_floor,Vector2i(0,1))
	
	var all_walls = []
	all_walls = map.get_used_cells(1) + map.get_used_cells(2)
	for w in all_walls:
		for dir in check_directions:
			if not w+dir in all_walls and not w+dir in used_floors:
				map.set_cell(1,w+dir,Global.current_tower_floor,Vector2i(0,3))
				continue
	
	#Loop through bottom walls
	var used_bot_walls = map.get_used_cells(2)
	for tile in used_bot_walls:
		#Set empty space above all tiles
		if not tile+Vector2i.UP in used_bot_walls and not tile+Vector2i.UP in used_top_walls \
		and not tile+Vector2i.UP in used_floors:
			map.set_cell(1,tile+Vector2i.UP,Global.current_tower_floor,Vector2i(0,3))
			continue
		
		if tile+Vector2i.UP in used_floors:
			map.set_cell(1, tile+Vector2i.UP, Global.current_tower_floor, Vector2i(0,1))
			continue

func place_shadows():
	var bot_walls = map.get_used_cells(2)
	for tile in bot_walls:
		map.set_cell(0, tile, Global.current_tower_floor, Vector2i(1,1))
		map.set_cell(0, tile+Vector2i.DOWN, Global.current_tower_floor, Vector2i(1,2))

func spawn_player():
	var p = Global.MAIN_PLAYER_SCENE.instantiate()
	add_child(p)
	p.global_position = player_spawn_pos
	
	Global.player_ref = p

func spawn_camera():
	var c = Global.ROOM_CAM_SCENE.instantiate()
	add_child(c)
	c.target = Global.player_ref
	camera_ref = c

func populate():
	var floor_tiles = map.get_used_cells(3)
	var player_pos = map.local_to_map(player_spawn_pos)
	for tile in floor_tiles:
		var dist = int((tile-player_pos).length())
		if dist > 10 and randf() < 0.07:
			var en = Global.get_rand_enemy_by_floor(Global.current_tower_floor)
			var ens = en["scene"]
			var new_en = ens.instantiate()
			add_child(new_en)
			new_en.position = map.map_to_local(tile)

func place_hud_elements():
	var h = player_hud_scene.instantiate()
	hud_layer.add_child(h)

func finish_generating():
	room_generating = false
	place_hud_elements()
	spawn_player()
	spawn_camera()
	populate()
	#emit_signal("gen_finished", player_spawn_pos)
