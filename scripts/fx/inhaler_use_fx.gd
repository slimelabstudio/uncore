extends Node2D

@onready var anim_sprite := $AnimatedSprite2D

@export var rise_speed : float 

func _physics_process(delta):
	position += (Vector2.UP * rise_speed) * delta


func _on_animated_sprite_2d_animation_finished():
	queue_free()
