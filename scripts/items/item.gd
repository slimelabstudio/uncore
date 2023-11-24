class_name Item
extends Resource

enum ITEM_TYPES {
	FOOD,
	POTION,
	WEAPON,
	AMOUR,
	RESOURCE,
}
@export var item_type : ITEM_TYPES

@export var item_name : String
@export var item_icon : Texture
@export var item_id : int

@export var item_can_stack : bool 
@export var item_max_stack : int
@export var item_amount : int = 1

@export var item_buy_price : int 
@export var item_sell_price : int
