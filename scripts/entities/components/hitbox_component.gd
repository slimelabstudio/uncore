class_name HitboxComponent
extends Area2D

@export var enabled : bool = true

signal hit(_dmg)




func _on_area_entered(area):
	if enabled:
		emit_signal("hit", area.dmg)
	else:
		return
