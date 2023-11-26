class_name Weapon
extends Item

enum WEP_TYPE {
	PROJECTILE,
	MELEE,
	THROWABLE,
}
@export var weapon_type : WEP_TYPE 

@export_category("Projectile Weapon")
@export var proj_weapon_damage : int 
@export var proj_weapon_firerate : float
@export var proj_weapon_magazine_max : int
@export var proj_weapon_reload_speed : float

@export_category("Melee Weapon")
@export var mel_weapon_attack_speed : float
@export var mel_weapon_attack_damage : int

@export_category("Throwable Weapon")
