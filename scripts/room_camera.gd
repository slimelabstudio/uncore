extends Camera2D

@onready var chrom_abb_shader := $shaders/chrom_abb

@export var lean_smooth : float = 10.0
@export var lean_scale : float = 0.2

var shake_power : float = 0.0

var chrom_abb_intensity : float = 0.0

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

func set_chrom_abb(_amt : float):
	chrom_abb_intensity = _amt
	chrom_abb_shader.material.set_shader_parameter("active", true)

func _process(delta):
	set_cam_lean(delta)
	
	if shake_power > 0.0:
		set_cam_shake(shake_power)
		shake_power = lerp(shake_power, 0.0, delta*8)
	
	position = lerp(position, target.position, 4 * delta)
	
	if chrom_abb_intensity > 0.0:
		chrom_abb_intensity = move_toward(chrom_abb_intensity, 0.0, 16*delta)
		var rand = chrom_abb_intensity+randf_range(-1.0, 1.0)
		chrom_abb_shader.material.set_shader_parameter("offset", rand*4)
	else:
		chrom_abb_shader.material.set_shader_parameter("active", false)
