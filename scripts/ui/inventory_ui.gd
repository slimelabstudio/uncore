class_name InventoryUI
extends Control

const ITEM_SLOT := preload("res://scenes/ui/inventory_slot.tscn")

@export var slot_container : HFlowContainer

var slots : Array[ItemSlotUI] = []

var my_owner = null

func draw_ui(_inventory : Inventory, _owner):
	for i in _inventory.inventory_items.size():
		var s = ITEM_SLOT.instantiate()
		s.display_item(_inventory.inventory_items[i])
		slot_container.add_child(s)
		slots.append(s)
	_inventory.inv_items_changed.connect(_on_items_changed)
	my_owner = _owner

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
