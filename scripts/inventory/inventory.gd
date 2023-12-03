class_name Inventory
extends Resource

@export var inventory_items : Array[Item] = []

func make_items_unique():
	var temp_items = []
	for i in inventory_items:
		temp_items.append(i.duplicate())
	inventory_items = temp_items
	return temp_items

func add_item(_item : Item):
	pass

func remove_item(_item : Item):
	pass

func switch_item(item_a : Item, item_b : Item):
	pass

func get_item_at(_index : int) -> Item:
	return inventory_items[_index]
