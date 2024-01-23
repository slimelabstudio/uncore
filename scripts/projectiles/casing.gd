extends AnimatableBody2D

@onready var collider : CollisionShape2D = $CollisionShape2D

@onready var casing_sprites : Dictionary = {
	"BULLET" : preload("res://textures/fx/weapons/bullet_casing.png"),
	"SHELL" : preload("res://textures/fx/weapons/shell_casing.png"),
}

@onready var sprite : Sprite2D = $Sprite2D

@export var life_time : float

var velocity : Vector2 = Vector2.ZERO

func _ready():
	sprite.scale *= randf_range(0.5,0.7)
	sprite.rotation_degrees = randf_range(0.0, 360.0)
	velocity = Vector2(randf_range(-2, 2), randf_range(-6.0, 6.0))
	
	var t = Timer.new()
	t.autostart = true
	t.one_shot = true
	add_child(t)
	t.start(life_time)
	t.timeout.connect(_on_death)

func _process(delta):
	position = Vector2(round(position.x), round(position.y))

func _physics_process(delta):
	velocity = lerp(velocity, Vector2.ZERO, 16 * delta)
	
	var collision = move_and_collide(velocity)
	if collision:
		velocity = Vector2.ZERO

func _on_death():
	var t = create_tween()
	t.tween_property(sprite, "modulate", Color(Color.WHITE, 0.0), 1.0)
	t.finished.connect(func done(): queue_free())
