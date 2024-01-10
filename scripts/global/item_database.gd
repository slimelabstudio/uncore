extends Node

const ITEM_LIST : Dictionary = {
	#MELEE WEAPONS
	
	#BULLET WEAPONS
	101 : preload("res://scripts/items/weapons/bullet/service_pistol.tres"),
	102 : preload("res://scripts/items/weapons/bullet/machine_gun.tres"),
	103 : preload("res://scripts/items/weapons/bullet/sub_machinegun.tres"),
	
	#SHELL WEAPONS
	201 : preload("res://scripts/items/weapons/shell/pump_shotgun.tres"),
	
	#ENERGY WEAPONS
}

#const IMPLANT_LIST : Dictionary = {
#
#}
#

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
