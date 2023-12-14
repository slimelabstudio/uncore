extends Node

const ROOM_SCENE := preload("res://scenes/level_generation/rooms/room.tscn")

const PLAYER_SCENE := preload("res://scenes/player.tscn")
const ITEM_DROP := preload("res://scenes/item_drop.tscn")
#const ITEM_DRAG := preload("res://scenes/ui/item_drag.tscn")

var player_ref : Player

var tower_manager : Tower

var ui_canvas_ref : CanvasLayer
var player_inventory_ref : Control

var picked_slot_data := {}

var in_tower : bool = true

#SAVE STUFF
var tower_save_path : String = "user://tower.dat"
var save_game_path : String = "user://savedata.dat"
var save_data_loaded : Dictionary = {}

func _ready():
	randomize()
	
	ui_canvas_ref = CanvasLayer.new()
	ui_canvas_ref.name = "UI"
	get_tree().current_scene.add_child.call_deferred(ui_canvas_ref)
	
	if FileAccess.file_exists("user://savedata.dat"):
		save_data_loaded = load_game()
		if save_data_loaded.size() <= 0:
			tower_manager.current_segment = 0

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

func save_game():
	var data = {}
	
	#Track current tower segment
	data["current_tower_segment"] = tower_manager.current_segment
	
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
	
	tower_manager.current_segment = int(data["current_tower_segment"])
	
	file.close()
	
	return data

func clear_save_data():
	if FileAccess.file_exists(save_game_path):
		var file = FileAccess.open(save_game_path, FileAccess.WRITE)
		var empty_data = {}
		var sd = JSON.stringify(empty_data, "\t")
		file.store_string(sd)
		file.close()
