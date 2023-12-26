extends Camera2D

@export var lean_smooth : float = 10.0
@export var lean_scale : float = 0.2

var shake_power : float = 0.0

var target = null

func _ready():
	SignalBus.shake_cam.connect(on_cam_shake)

func set_cam_lean(_delta : float):
	var mouse_pos = get_global_mouse_position()
	
	var lean = (mouse_pos - position) * lean_scale
	
	offset = lerp(offset, lean, _delta * lean_smooth)

func set_cam_shake(_amount : float = 1.0):
	var rand_amt = randf_range(-_amount, _amount)
	offset += Vector2(rand_amt, rand_amt)

func on_cam_shake(_power : float = 1.0):
	shake_power = _power

func _process(delta):
	set_cam_lean(delta)
	
	if shake_power > 0.0:
		set_cam_shake(shake_power)
		shake_power = lerp(shake_power, 0.0, delta*8)
	
	position = lerp(position, target.position, 4 * delta)
