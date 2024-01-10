class_name Player
extends CharacterBody2D

const PLAYER_INV_BASE := preload("res://scenes/ui/player_inventory_ui.tscn")
const PLAYER_HUD_BASE := preload("res://scenes/ui/player_hud.tscn")

var process_character : bool = true

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var body_graphic : Sprite2D = $body
@onready var hands_graphic : Sprite2D = $hands/holding_item

@export var SPEED = 50.0
@export var JUMP_VELOCITY = -260.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var player_hands : PlayerHands

#EQUIPMENT and ENERGY (STAMINA)
var current_equipment : int = 1   #0 = NONE, 1 = DASH, 2 = SHIELD
var equipment_energy_charges : int = 1
var equipment_active : bool = false
@export var max_equipment_energy_charges : int = 1.0

#EQUIPMENT VARIABLES 
var dash_direction : Vector2
@export var dash_speed : float = 100.0
@onready var dash_obstacle_check : RayCast2D = $dash_obstacle_check

var player_hud_ref : Control = null
var inventory_ui_ref : Control = null
@export var normal_inventory : Inventory
@export var implant_inventory : Inventory

var dead : bool = false

@export_category("Audio")
@export var footstep_sfx_player : AudioStreamPlayer2D
@export var damaged_sound : AudioStream

func _enter_tree():
	add_to_group("Player")
	Global.player_ref = self

func _ready():
	equipment_energy_charges = max_equipment_energy_charges
	
	#var hud = PLAYER_HUD_BASE.instantiate()
	#Global.ui_canvas_ref.add_child.call_deferred(hud)
	#player_hud_ref = hud
	#
	#var ui = PLAYER_INV_BASE.instantiate()
	#Global.ui_canvas_ref.add_child.call_deferred(ui)
	#inventory_ui_ref = ui
	#inventory_ui_ref.toggle_ui()
	#Global.player_inventory_ref = inventory_ui_ref

func get_input() -> Vector2:
	var vec = Vector2()
	var inp_x = Input.get_axis("left", "right")
	var inp_y = Input.get_axis("up", "down")
	vec = Vector2(inp_x, inp_y)
	return vec.normalized()

func _physics_process(delta):
	move_and_slide()

func _process(delta):
	if not dead:
		if get_global_mouse_position().x < position.x:
			body_graphic.flip_h = true
			hands_graphic.flip_v = true
		else:
			body_graphic.flip_h = false
			hands_graphic.flip_v = false

func apply_knockback(dir : Vector2, amt : float):
	velocity += dir * amt

func has_energy() -> bool:
	return true if equipment_energy_charges > 0 else false



func _on_health_component_damage_taken():
	Global.room_manager.camera_ref.set_chrom_abb(3.0)
	SignalBus.shake_cam.emit(20.0)
	AudioManager.play_sound_at(global_position, damaged_sound)
	Global.sleep(0.1)

func _on_health_component_dead():
	$StateMachine.queue_free()
	$hitbox_component.queue_free()
	$health_component.queue_free()
	
	#apply_knockback(Vector2.RIGHT, 60.0)
	var vt = create_tween()
	vt.tween_property(self, "velocity", Vector2.ZERO, 1.5).finished.connect(func f():
		$CollisionShape2D.queue_free())
	
	dead = true
	
	Engine.time_scale = 0.25
	anim_player.play("death")
	Global.room_manager.camera_ref.set_chrom_abb(4.0)
	SignalBus.shake_cam.emit(20.0)
	Global.sleep(0.14)
	var t = create_tween()
	t.tween_property(Engine, "time_scale", 1.0, 2.0)
