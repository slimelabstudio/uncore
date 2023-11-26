extends Node2D

@export var inventory : Inventory

@onready var sprite := $Sprite2D

var items_to_spawn : int = 1

func _ready():
	#Initialize inventory
	inventory.make_items_unique()
	inventory.init_ui(self, Global.ui_canvas_ref)
	inventory.toggle_ui()
	
	items_to_spawn = randi_range(1, 5)
	fill_chest(items_to_spawn)

func fill_chest(num_items : int):
	for i in range(num_items):
		var rand_item = randi_range(0, ItemDatabase.ITEM_LIST.size()-1)
		var _item = ItemDatabase.ITEM_LIST[rand_item]
		inventory.add_item(_item)

func open():
	sprite.frame_coords = Vector2(1,0)
	inventory.ui_ref.visible = true

func close():
	sprite.frame_coords = Vector2(0,0)
	inventory.ui_ref.visible = false

func set_selected(_val : bool):
	if _val == true:
		$Sprite2D.material.set_shader_parameter("outline_thickness", 1.0)
	else:
		$Sprite2D.material.set_shader_parameter("outline_thickness", 0.0)



func _on_area_2d_area_exited(area):
	if area.owner is Player:
		set_selected(false)
		close()
