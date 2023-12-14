extends Camera2D

var target = null


func _physics_process(delta):
	if target:
		position = lerp(position, target.position, 1.0)

func _process(delta):
	var inp_x = Input.get_axis("left", "right")
	var inp_y = Input.get_axis("up", "down")
	
	position += Vector2(inp_x, inp_y) * 120 * delta
