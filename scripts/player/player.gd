class_name Player
extends CharacterBody2D

const PLAYER_INV_BASE := preload("res://scenes/ui/player_inventory_ui.tscn")
const PLAYER_HUD_BASE := preload("res://scenes/ui/player_hud.tscn")

var process_character : bool = true

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var body_graphic : Sprite2D = $body
@onready var hands_graphic : Sprite2D = $hands/holding_item

@onready var detection_area : Area2D = $detection_area
var closest_detection : Area2D = null
var focused_detection = null

const SPEED = 50.0
const JUMP_VELOCITY = -260.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var player_hands : PlayerHands

var player_hud_ref : Control = null
var inventory_ui_ref : Control = null
@export var normal_inventory : Inventory
@export var implant_inventory : Inventory

var _paused = false

func _enter_tree():
	add_to_group("Player")

func _ready():
	var hud = PLAYER_HUD_BASE.instantiate()
	Global.ui_canvas_ref.add_child.call_deferred(hud)
	player_hud_ref = hud
	
	var ui = PLAYER_INV_BASE.instantiate()
	Global.ui_canvas_ref.add_child.call_deferred(ui)
	inventory_ui_ref = ui
	inventory_ui_ref.toggle_ui()
	Global.player_inventory_ref = inventory_ui_ref

func get_input() -> float:
	return Input.get_axis("left", "right")

func _physics_process(delta):
	move_and_slide()

func _process(delta):
	if get_global_mouse_position().x < position.x:
		body_graphic.flip_h = true
		hands_graphic.flip_v = true
	else:
		body_graphic.flip_h = false
		hands_graphic.flip_v = false
			
	get_closest_detection()
	if focused_detection:
		if Input.is_action_just_pressed("interact"):
			if focused_detection.owner is ItemDrop:
				pickup_item(focused_detection.owner.item)


func get_closest_detection():
	var detections = detection_area.get_overlapping_areas()
	if detections.size() > 0:
		var dist := 1000.0
		for d in detections:
			var new_dist = position.distance_to(d.position)
			if new_dist < dist:
				dist = position.distance_squared_to(d.position)
				focused_detection = d

func pickup_item(_item):
	if _item is Weapon:
		print("Here")
