class_name Weapon
extends Item

const BULLET_SCENE := preload("res://scenes/projectiles/bullet.tscn")
const SHELL_SCENE := preload("res://scenes/projectiles/shell.tscn")
const SLUG_SCENE := preload("res://scenes/projectiles/slug.tscn")

const CASING_SCENE := preload("res://scenes/fx/casing.tscn")


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
var shot_cooldown_time_left : float
var on_shot_cooldown : bool = false

@export var weapon_mag_size : int 
@export var weapon_cur_mag_count : int
@export var weapon_ammo_per_shot : int

@export var weapon_reload_time : float
var reload_time_elapsed : float
var on_reload_cooldown : bool

@export var weapon_accuracy : float

@export var weapon_sprite : Texture

@export var weapon_is_slug : bool
@export var weapon_is_pump : bool

func _reload():
	reload_time_elapsed = 0.0
	on_reload_cooldown = true

func _shoot():
	shot_cooldown_time_left = weapon_fire_rate
	on_shot_cooldown = true
