class_name ItemSlotUI
extends Control

@export var main_cont : PanelContainer

@export var icon : TextureRect
@export var count : Label

var item : Item = null

var mouse_over_slot := false

var my_owner = null

signal clicked(_index)
signal dropped(_index, _dropped_inventory)

func _ready():
	main_cont.mouse_entered.connect(on_mouse_entered)
	main_cont.mouse_exited.connect(on_mouse_exited)

func display_item(_item : Item):
	if _item is Item:
		icon.texture = _item.item_icon
		if _item.item_can_stack:
			count.text = str(_item.item_amount)
		else:	count.text = ""
		item = _item
	else:
		item = null
		icon.texture = null
		count.text = ""

func _process(delta):
	if mouse_over_slot:
		if Input.is_action_just_pressed("primary_attack"):
			emit_signal("clicked", get_index())
		if Input.is_action_just_released("primary_attack"):
			emit_signal("dropped", get_index(), my_owner.inventory)

func on_mouse_entered():
	mouse_over_slot = true
func on_mouse_exited():
	mouse_over_slot = false
