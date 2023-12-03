class_name Weapon
extends Item

const BULLET_SCENE := preload("res://scenes/projectiles/bullet.tscn")

enum WEAPON_TYPES {
	MELEE,
	BULLET,
	SHELL,
	ENERGY,
}
@export var weapon_type : WEAPON_TYPES

@export var weapon_damage : int

@export var weapon_full_auto : bool = false
@export var weapon_fire_rate : float 

@export var weapon_mag_size : int 
@export var weapon_cur_mag_count : int
@export var weapon_ammo_per_shot : int

@export var weapon_reload_time : float 

@export var weapon_accuracy : float

@export var weapon_sprite : Texture
