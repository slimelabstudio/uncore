class_name Player
extends CharacterBody2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var graphic : Sprite2D = $Sprite2D

const SPEED = 50.0
const JUMP_VELOCITY = -260.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var inventory : Inventory

func _ready():
	#Initialize inventory
	inventory.make_items_unique()
	inventory.init_ui(self, find_child("player_ui"))

func get_input() -> float:
	return Input.get_axis("left", "right")

func _physics_process(delta):
	move_and_slide()

func _input(event):
	if event.is_action_pressed("inventory"):
		inventory.toggle_ui()
