extends RayCast2D

var dmg : int = 0

@export var line : Line2D

var can_damage : bool = true 

#Called when the node is ready
func setup(dir : Vector2, _dmg : int):
	line.width = 6
	target_position = dir * 10000
	
	dmg = _dmg
	
	$muzzle_sparks.rotation = dir.angle()
	$muzzle_sparks.emitting = true
	
	var t = create_tween()
	t.tween_property(line, "width", 0.0, 0.2)
	t.finished.connect(func f(): queue_free())

func hit(pos : Vector2):
	line.points[1] = to_local(get_collision_point())
	can_damage = false

func _process(delta):
	if is_colliding():
		if can_damage:
			if get_collider() is HitboxComponent:
				get_collider().hit.emit(dmg)
			hit(get_collision_point())
