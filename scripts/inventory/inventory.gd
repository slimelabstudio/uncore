class_name Inventory
extends Resource

@export var inventory_items : Array[Item]
@export var inventory_size : int = 15
@export var ui_base_scene : PackedScene
var ui_ref : Control = null

signal inv_items_changed(_indexes)

func _init():
	for i in range(inventory_size):
		inventory_items.append(null)

func init_ui(_ui_owner, _canvas_layer : CanvasLayer):
	if !ui_ref:
		var ui = ui_base_scene.instantiate()
		ui.draw_ui(self, _ui_owner)
		_canvas_layer.add_child(ui)
		ui_ref = ui

func toggle_ui():
	if ui_ref:
		ui_ref.visible = !ui_ref.visible

func make_items_unique():
	var unique_items : Array[Item] = []
	for item in inventory_items:
		if item is Item:
			unique_items.append(item.duplicate(true))
		else:
			unique_items.append(null)
	inventory_items = unique_items

func add_item(_item : Item, _amount : int = 1):
	#Get same items from inventory (if any exist)
	var found_items = get_all_of_item(_item)
	if found_items.size() > 0:
		for fi in range(found_items.size()):
			if inventory_items[fi].item_amount == inventory_items[fi].item_max_stack:
				continue
			if (inventory_items[fi].item_amount + _amount) > inventory_items[fi].item_max_stack:
				var diff = abs(abs(inventory_items[fi].item_amount + _amount)-abs(inventory_items[fi].item_max_stack))
				inventory_items[fi].item_amount = inventory_items[fi].item_max_stack
				var next_slot = get_empty_inventory_slot()
				if next_slot == -1:
					#MAKE ITEM DROP
					Global.make_item_drop(_item, ui_ref.my_owner.position+Vector2.UP*8)
					
					inventory_items[fi].item_amount = inventory_items[fi].item_max_stack
					emit_signal("inv_items_changed", self)
					return
				inventory_items[next_slot] = _item.duplicate()
				inventory_items[next_slot].item_amount = diff
				emit_signal("inv_items_changed", self)
				return
			else:
				inventory_items[fi].item_amount += _amount
				emit_signal("inv_items_changed", self)
				return
	
	var _slot = get_empty_inventory_slot()
	inventory_items[_slot] = _item
	emit_signal("inv_items_changed", self)

func remove_item(_item_index : int) -> Item:
	var prev_item = inventory_items[_item_index]
	inventory_items[_item_index] = null
	emit_signal("inv_items_changed", self)
	return prev_item

func swap_items(_item_index : int, _target_item_index : int):
	var target_item = inventory_items[_target_item_index]
	var item = inventory_items[_item_index]
	inventory_items[_target_item_index] = item
	inventory_items[_item_index] = target_item
	emit_signal("inv_items_changed", self)

func is_item_in_inventory(_item : Item) -> bool:
	for i in inventory_items:
		if i.item_name == _item.item_name:
			return true
	return false

func get_empty_inventory_slot():
	for i in range(inventory_items.size()):
		if inventory_items[i] == null:
			return i
	return -1

func get_all_of_item(_item : Item) -> Array:
	var arr = []
	for i in inventory_items:
		if i != null and i.item_name == _item.item_name:
			arr.append(i)
	return arr

func can_add_to_inventory() -> bool:
	for i in inventory_items:
		if i == null:
			return true
	return false
