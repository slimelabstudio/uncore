class_name Enemy
extends CharacterBody2D


@export_category("General")
@export var enemy_name : String

@export_category("Components")
@export var health_component : HealthComponent

@onready var hitbox : HitboxComponent = $HitboxComponent
@onready var hp_comp : HealthComponent = $HealthComponent

@onready var anim_player : AnimationPlayer = $AnimationPlayer

func can_see_player() -> bool:
	return false
