class_name Weapon
extends Item

const BULLET_SCENE := preload("res://scenes/projectiles/bullet.tscn")
const SHELL_SCENE := preload("res://scenes/projectiles/shell.tscn")
const SLUG_SCENE := preload("res://scenes/projectiles/slug.tscn")
const ENERGY_BEAM_SCENE := preload("res://scenes/projectiles/energy_beam.tscn")

const CASING_SCENE := preload("res://scenes/fx/casing.tscn")


enum WEAPON_TYPES {
	MELEE,
	BULLET,
	SHELL,
	ENERGY,
	EXPLOSIVE,
	HIGH_VELOCITY,
	HEAT_SEEKER,
	INCENDIARY,
	STICKY_BOMB
}
@export var weapon_type : WEAPON_TYPES

@export var weapon_damage : int

@export var weapon_full_auto : bool = false
@export var weapon_fire_rate : float
var shot_cooldown_time_left : float
var on_shot_cooldown : bool = false

@export var weapon_mag_size : int 
@export var weapon_reserve_ammo : int
var weapon_cur_mag_count : int = weapon_mag_size
@export var weapon_ammo_per_shot : int

@export var weapon_reload_time : float
var reload_time_elapsed : float
var on_reload_cooldown : bool

@export var weapon_accuracy : float

@export var weapon_sprite : Texture

@export var weapon_is_slug : bool
@export var weapon_is_pump : bool

@export var shake_power : float = 1.0
@export var kick_power : float = 1.0

@export_category("Audio")
@export var equip_sound : AudioStream
@export var attack_sound : AudioStream
##For projectile weapons only
@export var empty_sound : AudioStream
##For projectile weapons only
@export var reload_sound : AudioStream
##For pump-action weapons only
@export var pump_sound : AudioStream

func _reload():
	reload_time_elapsed = 0.0
	on_reload_cooldown = true

func _shoot():
	shot_cooldown_time_left = weapon_fire_rate
	on_shot_cooldown = true
