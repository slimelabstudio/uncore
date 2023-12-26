class_name Tower
extends Node2D

const ENTRANCE_SEGMENT := preload("res://scenes/level_generation/tower/segments/entrance_segment.tscn")
const BOSS_SEGMENT := preload("res://scenes/level_generation/tower/segments/boss_segment.tscn")
const SEGMENTS := [
	preload("res://scenes/level_generation/tower/segments/tower_segment_1.tscn"),
	
]


@onready var cam : Camera2D = $tower_cam

@export var max_segments : int = 6

# { ID, {DATA} }
var tower_data : Dictionary = {}

var current_segment : int = -1
var current_seg_rendered = null

var player_ref : TowerPlayer = null

func _enter_tree():
	Global.tower_manager = self

func _ready():
	if not is_instance_valid(player_ref):
		player_ref = Global.TOWER_PLAYER_SCENE.instantiate()
		add_child.call_deferred(player_ref)
		player_ref.visible = false
	
	if FileAccess.file_exists(Global.tower_save_path):
		tower_data = load_tower_data()
		if tower_data.keys().size() > 0:
			generate_segment(current_segment)
		else:
			tower_data = generate_tower_data()
	
	SignalBus.segment_exited.connect(on_segment_exit)
	
	save_tower_data()
	Global.save_game()

func generate_tower_data() -> Dictionary:
	var data = {}
	
	if FileAccess.file_exists(Global.tower_save_path):
		var saved_data = load_tower_data()
	
	for i in range(max_segments):
		if i == max_segments-1:
			data[i] = {
				"scene" : BOSS_SEGMENT,
				"boss_segment" : true,
				"entrance_segment" : false,
				"segment_data" : {},
			}
			continue
		if i == 0:
			data[i] = {
				"scene" : ENTRANCE_SEGMENT,
				"boss_segment" : false,
				"entrance_segment" : true,
				"segment_data" : {},
			}
			continue
		data[i] = {
			"scene" : SEGMENTS.pick_random(),
			"boss_segment" : false,
			"entrance_segment" : false,
			"segment_data" : {},
		}
	
	return data

func generate_segment(seg_id : int):
	if tower_data.keys().size() <= 0:
		printerr("NO SEGMENTS IN TOWER DATA")
		return
	
	var enter_pos
	
	var picked_seg 
	var seg
	if seg_id == 0: #is entrance segment?
		picked_seg = ENTRANCE_SEGMENT
		seg = picked_seg.instantiate()
		enter_pos = seg.set_enter()
		seg.set_exit()
	else:
		picked_seg = SEGMENTS.pick_random()
		seg = picked_seg.instantiate()
		enter_pos = seg.set_enter()
		seg.set_exit()
		tower_data[str(seg_id)]["segment_data"] = seg.save_segment_data()
	
	seg.global_position = Vector2.ZERO
	add_child.call_deferred(seg)
	
	#TEMP
	current_segment = seg_id
	
	current_seg_rendered = seg
	
	place_player(enter_pos)
	
	save_tower_data()

func place_player(_pos : Vector2):
	player_ref.global_position = _pos + (Vector2.UP * 16)
	player_ref.visible = true

func on_segment_exit():
	#Disable player
	player_ref.visible = false
	player_ref.global_position = Vector2(0,0)
	
	#Wait for transition in
	
	#clear old segment
	
	
	current_segment += 1
	
	#generate new segment



func save_tower_data():
	var file = FileAccess.open(Global.tower_save_path,FileAccess.WRITE)
	var data = {}
	
	data = tower_data
	
	var json_data = JSON.stringify(data, "\t")
	file.store_string(json_data)
	file.close()

func load_tower_data():
	var file = FileAccess.open(Global.tower_save_path,FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	file.close()
	return data
