class_name Tower
extends Node2D

@onready var cam : Camera2D = $tower_cam

const TOWER_SEGMENTS := {
	0:preload("res://scenes/level_generation/tower/segments/tower_segment_1.tscn"),
	1:preload("res://scenes/level_generation/tower/segments/tower_segment_2.tscn"),
}
var segment_spawns : Array

var segments : Array = []

var current_segment : int = -1

@onready var level_label : Label = $level_ui/level_label

var tower_save_data : Dictionary = {}

func _enter_tree():
	Global.tower_manager = self

func _ready():
	segment_spawns = $segment_spawns.get_children()
	
	if FileAccess.file_exists(Global.tower_save_path):
		var d = load_tower()
		if d.size() <= 0:
			generate_segments()
			spawn_player(segments[0])
			save_tower()
	else:
		generate_segments()
		spawn_player(segments[0])
		save_tower()
	
	Global.save_game()
	
	level_label.text = "Floor " + str(current_segment+1)

func generate_segments():
	for i in segment_spawns:
		var rand = get_random_seg(TOWER_SEGMENTS)
		var picked = TOWER_SEGMENTS[rand]
		var seg = picked.instantiate()
		seg.built_from = rand
		add_child(seg)
		seg.global_position = i.global_position
		
		var entrance_spawns = seg.entrance_spawns
		var exit_spawns = seg.exit_spawns
		var rand_ens = entrance_spawns.pick_random()
		var rand_exs = exit_spawns.pick_random()
		
		seg.set_main_doors(rand_exs.global_position, rand_ens.global_position)
		seg.set_room_door()
		
		if i == segment_spawns[2]:
			#SWITCHGRADE SPAWN
			seg.set_npc()
		
		if randf() < 0.04:
			#CHEST
			seg.set_chest()
		
		segments.append(seg)
		seg.seg_id = segments.find(seg)
		seg.change_segments.connect(change_segments)

func spawn_player(segment):
	var player = Global.PLAYER_SCENE.instantiate()
	Global.player_ref = player
	get_tree().root.add_child.call_deferred(player)
	player.position = segment.entrance_pos
	current_segment = segments.find(segment)

var last_change_dir : int 
func change_segments(new_segment_index):
	last_change_dir = new_segment_index
	var old_segment = current_segment
	var new_segment = current_segment+new_segment_index
	var ct = cam.create_tween()
	ct.tween_property(cam, "position", segments[new_segment].global_position, 0.6).set_ease(Tween.EASE_IN_OUT)
	current_segment = new_segment
	var lt = create_tween()
	lt.tween_property(level_label, "modulate:a", 0.0, 0.1)
	
	ct.finished.connect(on_change_finished)
	
	Global.save_game()

func on_change_finished():
	var lt = create_tween()
	lt.tween_property(level_label, "modulate:a", 1.0, 0.1)
	
	level_label.text = "Floor " + str(current_segment+1)
	
	var move_to_pos 
	match last_change_dir:
		1:
			#UP
			move_to_pos = get_entrance_pos()
		-1:
			#DOWN
			move_to_pos = get_exit_pos()
	
	Global.player_ref.global_position = move_to_pos

func get_exit_pos():
	return segments[current_segment].exit_pos
func get_entrance_pos():
	return segments[current_segment].entrance_pos

func get_random_seg(_segments):
	var a = _segments.keys()
	a = a[randi() % a.size()]
	return a

func save_tower():
	tower_save_data = {}
	for segment in range(segments.size()):
		tower_save_data[segment] = segments[segment].save_segment()
	
	var file = FileAccess.open(Global.tower_save_path, FileAccess.WRITE)
	var data = JSON.stringify(tower_save_data, "\t")
	
	file.store_string(data)
	file.close()
	return data

func load_tower():
	var file = FileAccess.open(Global.tower_save_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	if data.size() <= 0:
		file.close()
		return {}
	
	for k in data.keys():
		var scene = data[k]["scene"]
		var new_seg = TOWER_SEGMENTS[int(scene)].instantiate()
		add_child(new_seg)
		new_seg.change_segments.connect(change_segments)
		var pos_x = data[k]["position_x"]
		var pos_y = data[k]["position_y"]
		new_seg.global_position = Vector2(float(pos_x), float(pos_y))
		var enter_pos_x = data[k]["enter_pos_x"]
		var enter_pos_y = data[k]["enter_pos_y"]
		var exit_pos_x = data[k]["exit_pos_x"]
		var exit_pos_y = data[k]["exit_pos_y"]
		##TODO: Load room door data and place doors
		new_seg.set_main_doors(Vector2(exit_pos_x, exit_pos_y), Vector2(enter_pos_x, enter_pos_y))
		segments.append(new_seg)
	
	cam.global_position = segments[current_segment].global_position
	spawn_player(segments[current_segment])
	
	file.close()
	return data

func clear_tower_data():
	print("HERE")
	if FileAccess.file_exists(Global.tower_save_path):
		var file = FileAccess.open(Global.tower_save_path, FileAccess.WRITE)
		var empty_data = {}
		var sd = JSON.stringify(empty_data, "\t")
		file.store_string(sd)
		file.close()
