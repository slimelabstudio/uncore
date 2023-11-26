extends Control

@export var icon : TextureRect

func _enter_tree():
	position = get_global_mouse_position()

func setup(_item : Item):
	icon.texture = _item.item_icon

func _process(delta):
	position = lerp(position, get_global_mouse_position(), 12.0 * delta)

func kill():
	queue_free()
