extends Enemy

@export var move_speed : float = 100.0

@export var min_rand_move_distance : float = 16.0
@export var max_rand_move_distance : float = 64.0

@onready var obstacle_detection := $obstacle_detection
@onready var graphic := $Sprite2D

#var player_spotted : bool = false

var move_direction : Vector2
var _velocity : Vector2
var movement_threshold : int = 16.0


func _physics_process(delta):
	move_and_slide()
