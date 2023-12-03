class_name ItemDrop
extends Node2D

@export var ground_check : RayCast2D
@export var icon : Sprite2D
@export var anim : AnimationPlayer

var can_be_picked_up : bool = false

var velocity : Vector2 = Vector2.ZERO

var item = null 

func set_drop(_item : Item):
	item = _item
	icon.texture = item.item_icon

func _ready():
	set_drop(ItemDatabase.get_item_by_name("pump shotgun").duplicate())
	
	velocity = Vector2(randf_range(-40, 40), randf_range(-100,-50))
	
	await get_tree().create_timer(1).timeout
	can_be_picked_up = true
	anim.play("bob")
 
func _physics_process(delta):
	if not ground_check.is_colliding():
		velocity.y = move_toward(velocity.y, 300.0, 300.0 * delta)
	else:
		velocity.y = 0
		if velocity.x != 0:
			velocity.x = move_toward(velocity.x, 0.0, 120.0 * delta)
	velocity.y = clampf(velocity.y, -300, 300)
	
	position += velocity * delta

func _on_pickup_detection_body_entered(body):
	pass
