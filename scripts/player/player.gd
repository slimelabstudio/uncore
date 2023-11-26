class_name Player
extends CharacterBody2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var graphic : Sprite2D = $Sprite2D

@onready var detection_area : Area2D = $detection_area
var closest_detection : Area2D = null

const SPEED = 50.0
const JUMP_VELOCITY = -260.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var inventory : Inventory

func _ready():
	#Initialize inventory
	inventory.make_items_unique()
	inventory.init_ui(self, Global.ui_canvas_ref)
	inventory.toggle_ui()

func get_input() -> float:
	return Input.get_axis("left", "right")

func _physics_process(delta):
	move_and_slide()

func _process(delta):
	if detection_area.get_overlapping_areas().size() > 0:
		closest_detection = get_closest_detection()
		if closest_detection:	
			closest_detection.owner.set_selected(true)

func get_closest_detection() -> Area2D:
	var closest = null
	for a in detection_area.get_overlapping_areas():
		var dist = position.distance_to(a.position)
		if !closest:	closest = a
		else:
			var current_dist = position.distance_to(closest.position)
			if  dist > current_dist:
				closest = a
	return closest

func _input(event):
	if event.is_action_pressed("inventory"):
		inventory.toggle_ui()
	
	if event.is_action_pressed("interact") and closest_detection:
		closest_detection.owner.open()
