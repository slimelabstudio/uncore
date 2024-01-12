extends Node2D

@export var initial_menu : Control

@export var main : Control
@export var options : Control
@export var credits : Control

var active_menu : Control = null
var previous_menu : Control = null


func _ready():
	if ResourceLoader.exists("user://towerdata.res"):
		DirAccess.remove_absolute("user://towerdata.res")
	
	initial_menu.visible = true
	active_menu = initial_menu


func _on_play_pressed():
	previous_menu = active_menu

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
