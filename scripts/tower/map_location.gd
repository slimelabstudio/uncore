class_name LocationNode
extends Area2D



@onready var icon : Sprite2D = $icon

var location_id : int 
#var location_type : LOC_TYPES

func _ready():
	mouse_entered.connect(on_mouse_enter)
	mouse_exited.connect(on_mouse_exit)

func on_mouse_enter():
	SignalBus.map_node_hovered.emit(self)
func on_mouse_exit():
	SignalBus.map_node_hovered.emit(null)

func setup(_id : int, _type : Global.LOCATION_TYPES):
	location_id = _id
	
	match _type:
		0:
			icon.frame = 0
			name = "safe_"+str(location_id)
		1:
			icon.frame = 4
			name = "loot_"+str(location_id)
		2:
			icon.frame = 3
			name = "combat_"+str(location_id)
		3:
			icon.frame = 5
			name = "npc_"+str(location_id)
		4:
			icon.frame = 6
			name = "boss_"+str(location_id)
