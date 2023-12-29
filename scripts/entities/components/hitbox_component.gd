class_name HitboxComponent
extends Area2D

signal hit(_dmg)




func _on_area_entered(area):
	if area is Projectile:
		emit_signal("hit", area.dmg)
