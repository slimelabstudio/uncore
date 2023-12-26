class_name TowerPlayer
extends CharacterBody2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var graphic : Sprite2D = $Sprite2D

const SPEED = 120.0
const JUMP_VELOCITY = -340.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1080.0

var jump_held : bool = false

func get_input() -> float:
	return Input.get_axis("left", "right")

func _physics_process(delta):
	move_and_slide()
