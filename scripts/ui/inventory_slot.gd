class_name ItemSlotUI
extends Control

@export var icon : TextureRect
@export var count : Label

func display_item(_item : Item):
	if _item is Item:
		icon.texture = _item.item_icon
		if _item.item_can_stack:
			count.text = str(_item.item_amount)
		else:	count.text = ""
	else:
		icon.texture = null
		count.text = ""
