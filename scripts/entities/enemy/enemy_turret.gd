extends Enemy

@export var detection_area : ShapeCast2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer

var awake : bool = false

func player_detected() -> bool:
	return detection_area.is_colliding()

func _process(delta):
	if not awake:
		if player_detected():
			anim_player.play("wake")
			awake = true
