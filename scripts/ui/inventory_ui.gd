class_name InventoryUI
extends Control

const ITEM_SLOT := preload("res://scenes/ui/inventory_slot.tscn")

@export var panel_cont : PanelContainer
@export var slot_container : HFlowContainer

var slots : Array[ItemSlotUI] = []

var my_owner = null

var window_grabbed := false

func draw_ui(_inventory : Inventory, _owner):
	my_owner = _owner
	for i in _inventory.inventory_items.size():
		var s = ITEM_SLOT.instantiate()
		s.display_item(_inventory.inventory_items[i])
		s.clicked.connect(_on_slot_clicked)
		s.dropped.connect(_on_slot_dropped)
		s.my_owner = my_owner
		slot_container.add_child(s)
		slots.append(s)
	_inventory.inv_items_changed.connect(_on_items_changed)


func update_display(_inventory : Inventory):
	for item_index in _inventory.inventory_items.size():
		update_slot_display(_inventory, item_index)

func update_slot_display(_inventory : Inventory, _index : int):
	var slot = slots[_index]
	slot.display_item(_inventory.inventory_items[_index])

func _on_items_changed(_inventory : Inventory):
	var items = _inventory.inventory_items
	for i in range(items.size()):
		update_slot_display(_inventory, i)

func get_first_empty_slot(_inventory : Inventory):
	for s in range(slots.size()):
		if _inventory.inventory_items[s] == null:
			return s
	return null

func _is_mouse_in_window() -> bool:
	return panel_cont.get_rect().has_point(get_local_mouse_position())

func _input(event):
	if event is InputEventMouseMotion:
		if window_grabbed:
			position += event.relative

func _on_slot_clicked(_index):
	if slots[_index].item:
		Global.set_drag_data(my_owner.inventory.inventory_items[_index], my_owner.inventory)

func _on_slot_dropped(_index, _dropped_inventory):
	var from = null
	if Global.drag_item_data:
		for i in Global.drag_item_data.keys():
			print(i)


func _on_panel_container_gui_input(event):
	if event.is_action_pressed("primary_attack"):
		window_grabbed = true
	if event.is_action_released("primary_attack") and window_grabbed:
		window_grabbed = false
