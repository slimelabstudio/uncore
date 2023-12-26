class_name HealthComponent
extends Node

@export var hitbox_component : HitboxComponent

@export var max_health : int = 1
var current_health : int = 1

signal damage_taken
signal dead

func take_damage(amount : int):
	if (current_health - amount) < 0:
		die()
		return
	
	current_health -= amount
	
	emit_signal("damage_taken")

func heal(amount : int):
	if (current_health + amount) > max_health:
		current_health = max_health
		return
	
	current_health += amount

func die():
	emit_signal("dead")
