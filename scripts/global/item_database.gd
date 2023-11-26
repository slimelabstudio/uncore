extends Node

const ITEM_LIST : Dictionary = {
	0 : preload("res://scripts/items/handgun.tres"),
	1 : preload("res://scripts/items/pump_shotgun.tres"),
}


func get_item_by_name(_name : String) -> Item:
	for i in ITEM_LIST:
		if ITEM_LIST[i].item_name == _name:
			return ITEM_LIST[i]
	return null

func get_item_by_id(_id : int) -> Item:
	for i in ITEM_LIST:
		if i == _id:
			return ITEM_LIST[i]
	return null
