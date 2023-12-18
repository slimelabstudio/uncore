extends Camera2D

@export var lean_smooth : float = 10.0
@export var lean_scale : float = 0.2

var target = null

func set_cam_lean(_delta : float):
	var mouse_pos = get_global_mouse_position()
	
	var lean = (mouse_pos - position) * lean_scale
	
	offset = lerp(offset, lean, _delta * lean_smooth)

func _process(delta):
	set_cam_lean(delta)
	
	position = target.position
