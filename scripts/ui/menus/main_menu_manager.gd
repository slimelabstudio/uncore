extends Node2D

const processing_screen_scene := preload("res://scenes/fx/processing_screen.tscn")

@export var initial_menu : Control

@export var main : Control
@export var options : Control
@export var credits : Control
@export var style_select : Control

var active_menu : Control = null
var previous_menu : Control = null


func _ready():
	#IF AN OLD SAVE OF THE TOWER EXISTS - DELETE IT 
	if ResourceLoader.exists("user://towerdata.res"):
		DirAccess.remove_absolute("user://towerdata.res")
	
	initial_menu.visible = true
	active_menu = initial_menu
	
	$CanvasLayer/sub_menus/style_select.proceed.connect(start_game)

func start_game():
	var ps = processing_screen_scene.instantiate()
	$CanvasLayer.add_child(ps)
	ps.find_child("AnimationPlayer").play("in")
	
	await get_tree().create_timer(5.0).timeout
	
	get_tree().change_scene_to_packed(load("res://scenes/tower/tower.tscn"))


func _on_play_pressed():
	previous_menu = active_menu
	active_menu.visible = false
	active_menu = style_select
	active_menu.visible = true

func _on_options_pressed():
	previous_menu = active_menu
	active_menu.visible = false
	active_menu = options
	active_menu.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	active_menu.visible = false
	active_menu = previous_menu
	active_menu.visible = true
	previous_menu = null
