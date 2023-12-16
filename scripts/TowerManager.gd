class_name Tower
extends Node2D

const SEGMENTS := [
	preload("res://scenes/level_generation/tower/segments/tower_segment_1.tscn"),
	preload("res://scenes/level_generation/tower/segments/tower_segment_2.tscn"),
	preload("res://scenes/level_generation/tower/segments/tower_segment_3.tscn")
]
#const BOSS_SEGMENT := preload()

@onready var cam : Camera2D = $tower_cam

@export var max_segments : int = 4

# { ID, {DATA} }
var tower_data : Dictionary = {}

var current_segment : int = -1

func _ready():
	tower_data = generate_tower_data()

func generate_tower_data() -> Dictionary:
	var data = {}
	
	for i in range(max_segments):
		#if i == max_segments-1:
			#data[i] = {
				#"scene" : BOSS_SEGMENT.instantiate(),
				#"boss_segment" : true
			#}
			#return
		data[i] = {
			"scene" : SEGMENTS.pick_random(),
			"boss_segment" : false
		}
	
	return data

func change_segment(new_segment : int):
	#SCENE TRANSITION STUFF
	
	var next_segment_scene 

func fade_finished(state):
	print(state)
