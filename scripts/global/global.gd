extends Node

enum LOCATION_TYPES {
	SAFE,
	LOOT,
	COMBAT,
	NPC,
	BOSS
}

const FADE_FX := preload("res://scenes/fx/fade_fx.tscn")

const MAIN_PLAYER_SCENE := preload("res://scenes/main_player.tscn")
const ROOM_CAM_SCENE := preload("res://scenes/room_cam.tscn")
const ITEM_DROP := preload("res://scenes/item_drop.tscn")
#const ITEM_DRAG := preload("res://scenes/ui/item_drag.tscn")
const INHALER_USE_VFX := preload("res://scenes/fx/inhaler_use_vfx.tscn")

@onready var enemy_dict := {
	"turret_n" : {
		"initial_floor" : 1,
		"scene" : preload("res://scenes/entities/enemy/enemy_turret_normal.tscn")
	},
	"bug_n" : {
		"initial_floor" : 1,
		"scene" : preload("res://scenes/entities/enemy/enemy_bug_normal.tscn")
	}
}
func get_rand_enemy_by_floor(floor : int) -> Dictionary:
	var picks : Array[Dictionary] = []
	for enemy in enemy_dict:
		if floor == enemy_dict[enemy]["initial_floor"] or floor > enemy_dict[enemy]["initial_floor"]:
			picks.append(enemy_dict[enemy])
	
	return picks.pick_random()

func get_rand_enemy_by_chance(floor : int) -> Dictionary:
	var picks : Array[Dictionary] = []
	var chance = randf()*100
	for enemy in enemy_dict:
		if floor == enemy_dict[enemy]["initial_floor"] or floor > enemy_dict[enemy]["initial_floor"]:
			picks.append(enemy_dict[enemy])
	
	return {}

var player_ref : Player
var chosen_equipment_style : int = 0

var room_manager : RoomGenerator
var room_viewport : SubViewport

var ui_canvas_ref : CanvasLayer
var player_inventory_ref : Control
var player_hud_ref : Control

var picked_slot_data := {}

var current_tower_floor : int = 1
var tower_manager : Tower 
var in_tower : bool = true


func _ready():
	randomize()
	#
	#ui_canvas_ref = CanvasLayer.new()
	#ui_canvas_ref.name = "UI"
	#get_tree().current_scene.add_child.call_deferred(ui_canvas_ref)

func set_room_manager(manager : RoomGenerator):
	room_manager = manager

func make_item_drop(_item : Item, _position : Vector2, _amount : int = 1):
	var i = _item.duplicate()
	i.item_amount = _amount
	var drop = ITEM_DROP.instantiate()
	drop.set_drop(_item)
	get_tree().current_scene.add_child.call_deferred(drop)
	drop.position = _position

#func _process(delta):
	#if Input.is_action_just_pressed("inventory"):
		#open_inventory(player_inventory_ref)

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

func a_or_b(a, b):
	return a if randf() < 0.5 else b
