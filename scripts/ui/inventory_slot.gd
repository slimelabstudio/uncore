class_name ItemSlotUI
extends Control

enum SLOT_TYPES {
	NONE,
	HEAD,
	EYE,
	ARM,
	CHEST,
	HAND,
	LEG,
	FOOT,
	PRIMARY,
	SECONDARY,
	UTILITY,
}
@export var slot_type : SLOT_TYPES

@export var main_cont : PanelContainer

@export var icon : TextureRect
@export var count : Label
@export var can_be_picked : bool = true

var mouse_over_slot := false

var my_owner = null

func display_item(_item : Item):
	if _item is Item:
		icon.texture = _item.item_icon
		if _item.item_can_stack:
			count.text = str(_item.item_amount)
		else:	count.text = ""
	else:
		icon.texture = null
		count.text = ""

func on_mouse_entered():
	mouse_over_slot = true
func on_mouse_exited():
	mouse_over_slot = false
