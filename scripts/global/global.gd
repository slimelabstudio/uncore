extends Node

const ITEM_DROP := preload("res://scenes/item_drop.tscn")
const ITEM_DRAG := preload("res://scenes/ui/item_drag.tscn")

var ui_canvas_ref : CanvasLayer 

var drag_item_data := {}
var drag_ref : Control = null

func _ready():
	ui_canvas_ref = CanvasLayer.new()
	get_tree().current_scene.add_child.call_deferred(ui_canvas_ref)

func make_item_drop(_item : Item, _position : Vector2, _amount : int = 1):
	var i = _item.duplicate()
	i.item_amount = _amount
	var drop = ITEM_DROP.instantiate()
	drop.set_drop(_item)
	get_tree().current_scene.add_child.call_deferred(drop)
	drop.position = _position

func set_drag_data(_item : Item, _from_inventory : Inventory):
	var drag = ITEM_DRAG.instantiate()
	drag.setup(_item)
	drag_item_data[_item] = _from_inventory
	ui_canvas_ref.add_child.call_deferred(drag)
	drag_ref = drag
