extends Enemy

@export var move_speed : float = 100.0
@export var chase_speed : float = 150.0

@export var min_rand_move_distance : float = 16.0
@export var max_rand_move_distance : float = 64.0

@onready var obstacle_detection := $obstacle_detection
@onready var graphic := $Sprite2D

@onready var player_detection := $player_detection

var player_spotted : bool = false

var move_direction : Vector2
var _velocity : Vector2
var movement_threshold : int = 16.0

var turn_dir : int = 1

@onready var change_turn_dir_timer := $change_turn_dir
@export var MIN_TURN_CHANGE_TIME := 0.5
@export var MAX_TURN_CHANGE_TIME := 3.0

func _ready():
	change_turn_dir_timer.start(randf_range(MIN_TURN_CHANGE_TIME, MAX_TURN_CHANGE_TIME))

func can_see_player() -> bool:
	if player_detection.is_colliding():
		if player_detection.get_collider() is Player:
			return true
	return false

var detection_distance := 200
func _process(delta):
	var dir = (Global.player_ref.global_position - global_position).normalized()
	player_detection.target_position = dir * detection_distance


func _on_change_turn_dir_timeout():
	turn_dir *= -1
	change_turn_dir_timer.start(randf_range(MIN_TURN_CHANGE_TIME, MAX_TURN_CHANGE_TIME))
