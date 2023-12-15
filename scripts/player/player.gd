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

@export var SPEED = 50.0
@export var JUMP_VELOCITY = -260.0

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

func get_input() -> Vector2:
	var vec = Vector2()
	var inp_x = Input.get_axis("left", "right")
	var inp_y = Input.get_axis("up", "down")
	vec = Vector2(inp_x, inp_y)
	return vec.normalized()

func _physics_process(delta):
	velocity.limit_length(SPEED)
	
	move_and_slide()

func _process(delta):
	if get_global_mouse_position().x < position.x:
		body_graphic.flip_h = true
		hands_graphic.flip_v = true
	else:
		body_graphic.flip_h = false
		hands_graphic.flip_v = false
	
	if focused_detection:
		if Input.is_action_just_pressed("interact"):
			if focused_detection is Door:
				if focused_detection.is_exit:
					focused_detection.enter(1)
				else:
					focused_detection.enter(-1)
			elif focused_detection is RoomDoor:
				focused_detection.enter()

func pickup_item(_item):
	if _item is Weapon:
		print("Here")


func _on_detection_area_area_entered(area):
	if area.owner is Door or area.owner is RoomDoor:
		focused_detection = area.owner
func _on_detection_area_area_exited(area):
	if area.owner is Door or area.owner is RoomDoor:
		focused_detection = null
