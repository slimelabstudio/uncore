class_name Tower
extends Node2D

const TOWER_SEGMENTS := [
	preload("res://scenes/level_generation/tower/segments/tower_segment.tscn"),
]

var current_segment = null

func _ready():
	generate_segment()
	
	#var player = Global.PLAYER_SCENE.instantiate()
	#Global.player_ref = player
	#get_tree().root.add_child.call_deferred(player)
	#player.position = current_segment.spawn_pos

func generate_segment():
	var seg = TOWER_SEGMENTS.pick_random().instantiate()
	add_child(seg)
