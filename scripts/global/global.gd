extends Node

const FADE_FX := preload("res://scenes/fx/fade_fx.tscn")

const MAIN_PLAYER_SCENE := preload("res://scenes/main_player.tscn")
const ROOM_CAM_SCENE := preload("res://scenes/room_cam.tscn")
const ITEM_DROP := preload("res://scenes/item_drop.tscn")
#const ITEM_DRAG := preload("res://scenes/ui/item_drag.tscn")

var player_ref : Player

var room_manager : RoomGenerator
var room_viewport : SubViewport

var ui_canvas_ref : CanvasLayer
var player_inventory_ref : Control

var picked_slot_data := {}

var in_tower : bool = true

#SAVE STUFF
var tower_save_path : String = "user://towerdata.dat"
var save_game_path : String = "user://savedata.dat"
var save_data_loaded : Dictionary = {}

func _ready():
	if not FileAccess.file_exists(tower_save_path):
		var f = FileAccess.open(tower_save_path, FileAccess.WRITE)
		var d = {}
		var jd = JSON.stringify(d, "\t")
		f.store_string(jd)
		f.close()
	
	#if get_tree().current_scene.name != "entrance_segment":
		#save_data_loaded = load_game()
	#
	#randomize()
	#
	#ui_canvas_ref = CanvasLayer.new()
	#ui_canvas_ref.name = "UI"
	#get_tree().current_scene.add_child.call_deferred(ui_canvas_ref)

func set_room_manager(manager : RoomGenerator):
	room_manager = manager
	room_manager.gen_finished.connect(_on_room_finished_generating)

func _on_room_finished_generating(_enter_pos : Vector2):
	player_ref = MAIN_PLAYER_SCENE.instantiate()
	get_tree().root.add_child(player_ref)
	player_ref.global_position = _enter_pos
	
	var cam = ROOM_CAM_SCENE.instantiate()
	get_tree().root.add_child(cam)
	cam.target = player_ref

func make_item_drop(_item : Item, _position : Vector2, _amount : int = 1):
	var i = _item.duplicate()
	i.item_amount = _amount
	var drop = ITEM_DROP.instantiate()
	drop.set_drop(_item)
	get_tree().current_scene.add_child.call_deferred(drop)
	drop.position = _position

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		open_inventory(player_inventory_ref)

func open_inventory(ui):
	ui.visible = !ui.visible
	
	var groups_to_call = ["Player"]
	for i in groups_to_call:
		var nodes = get_tree().get_nodes_in_group(i)
		for n in nodes:
			n.set_process(!ui.visible)

func sleep(_time : float = 0.04):
	get_tree().paused = true
	await get_tree().create_timer(_time).timeout
	get_tree().paused = false

func save_game():
	var data = {}
	
	var json_data = JSON.stringify(data, "\t")
	var file = FileAccess.open(save_game_path, FileAccess.WRITE)
	
	file.store_string(json_data)
	file.close()
	return data

func load_game():
	var file = FileAccess.open(save_game_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	if data.size() <= 0:
		file.close()
		return {}
	
	file.close()
	
	return data

func clear_save_data():
	if FileAccess.file_exists(save_game_path):
		var file = FileAccess.open(save_game_path, FileAccess.WRITE)
		var empty_data = {}
		var sd = JSON.stringify(empty_data, "\t")
		file.store_string(sd)
		file.close()
