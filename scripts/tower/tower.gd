class_name Tower
extends Node

const MAP_LOC_SCENE := preload("res://scenes/tower/map_location.tscn")

@onready var location_spawns : Array = $location_spawns.get_children()
@onready var entrance_spawn_pos : Vector2 = $entrance.global_position
@onready var exit_spawn_pos : Vector2 = $exit.global_position

@onready var map_nodes := $map_nodes

#how many combat rooms have been placed?
var current_combat_rooms : int = 0
@export var max_combat_rooms : int = 2

#has a loot room spawned?
var loot_room_spawned : bool = false

var pathways : Dictionary = {}

func _enter_tree():
	Global.tower_manager = self

func place_entrance():
	var ent = MAP_LOC_SCENE.instantiate()
	add_child(ent)
	ent.icon.frame = 2
	ent.global_position = entrance_spawn_pos

func place_exit():
	var ext = MAP_LOC_SCENE.instantiate()
	add_child(ext)
	ext.icon.frame = 1
	ext.global_position = exit_spawn_pos

func place_location(type : Global.LOCATION_TYPES, pos : Vector2):
	var loc = MAP_LOC_SCENE.instantiate()
	map_nodes.add_child(loc)
	loc.global_position = pos
	
	match type:
		Global.LOCATION_TYPES.SAFE:
			pass
		Global.LOCATION_TYPES.LOOT:
			pass
		Global.LOCATION_TYPES.COMBAT:
			pass
		Global.LOCATION_TYPES.NPC:
			pass
		Global.LOCATION_TYPES.BOSS:
			pass

func mark_locations(spawn_markers : Array):
	for marker in spawn_markers:
		var spawn_chance = randf() * 100
		#Loot room
		if spawn_chance < 10.0 and !loot_room_spawned:
			place_location(Global.LOCATION_TYPES.LOOT, marker.global_position)
			loot_room_spawned = true
			continue
		#TODO: ADD SPAWN LOGIC FOR NPC ROOMS
		elif spawn_chance < 60.0 and current_combat_rooms < max_combat_rooms:
			place_location(Global.LOCATION_TYPES.COMBAT, marker.global_position)
			current_combat_rooms += 1
			continue

func build_path(pos_a : Vector2, pos_b : Vector2):
	var line = Line2D.new()
	line.width = 2
	add_child(line)
	line.add_point(pos_a, 0)
	line.add_point(pos_b, 1)
	pathways[pathways.keys().size()] = {
		"pos_a" : pos_a,
		"pos_b" : pos_b
	}

func _ready():
	place_entrance()
	place_exit()
	build_path(entrance_spawn_pos, exit_spawn_pos)
	mark_locations(location_spawns)
