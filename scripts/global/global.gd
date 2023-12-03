extends Node

const ITEM_DROP := preload("res://scenes/item_drop.tscn")
#const ITEM_DRAG := preload("res://scenes/ui/item_drag.tscn")

var ui_canvas_ref : CanvasLayer
var player_inventory_ref : Control

var picked_slot_data := {}

var in_tower : bool = true

func _ready():
	ui_canvas_ref = CanvasLayer.new()
	ui_canvas_ref.name = "UI"
	get_tree().current_scene.add_child.call_deferred(ui_canvas_ref)

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
