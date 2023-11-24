extends Node


const item_list : Array[Item] = [
	#FOOD
	preload("res://scripts/items/apple.tres"),
	#RESOURCES
	
	#TOOLS
	
	#WEAPONS
	
	#ARMOR
	
	#UTILITY
]
func _enter_tree():
	for i in item_list:
		i = i.duplicate(true)
		var id = ResourceUID.create_id()
		i.item_id = id
