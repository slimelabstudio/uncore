class_name LocationNode
extends Area2D

@onready var icon : Sprite2D = $icon

var location_type : int = -1

var hovered : bool = false

var cleared : bool = false

func _ready():
	mouse_entered.connect(on_mouse_enter)
	mouse_exited.connect(on_mouse_exit)

func on_mouse_enter():
	hovered = true
	#print(str(hovered) + ", " + name)
	SignalBus.map_node_hovered.emit(self)
func on_mouse_exit():
	hovered = false
	#print(str(hovered) + ", " + name)
	SignalBus.map_node_hovered.emit(null)

func _process(delta):
	if Input.is_action_just_pressed("primary_attack") and hovered:
		SignalBus.map_node_selected.emit(self)
		#print("selected " + name)

func setup(_type : Global.LOCATION_TYPES):
	location_type = _type
	match location_type:
		0:
			icon.frame = 0
			name = "safe_"+str(get_index())
		1:
			icon.frame = 4
			name = "loot_"+str(get_index())
		2:
			icon.frame = 3
			name = "combat_"+str(get_index())
		3:
			icon.frame = 5
			name = "npc_"+str(get_index())
		4:
			icon.frame = 6
			name = "boss_"+str(get_index())
