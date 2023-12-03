extends Control

@export var character_container : Control

@export var backpack_container : Control

@export var implant_container : Control

@export var passive_container : Control

@export var run_tracker_container : Control

@export var equipped_items_container : Control
@export var primary_wep_slot : ItemSlotUI
@export var secondary_wep_slot : ItemSlotUI
@export var utility_slot : ItemSlotUI

func toggle_ui():
	visible = !visible
	return visible

func set_item_slots(primary : Weapon, secondary : Weapon, utility : Item):
	if primary:
		primary_wep_slot.display_item(primary)
	if secondary:
		secondary_wep_slot.display_item(secondary)
	if utility:
		utility_slot.display_item(utility)
