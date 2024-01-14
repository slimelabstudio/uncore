extends Node2D

@export var initial_menu : Control

@export var main : Control
@export var options : Control
@export var credits : Control
@export var style_select : Control

var active_menu : Control = null
var previous_menu : Control = null


func _ready():
	if ResourceLoader.exists("user://towerdata.res"):
		DirAccess.remove_absolute("user://towerdata.res")
	
	initial_menu.visible = true
	active_menu = initial_menu
	
	$CanvasLayer/sub_menus/style_select.proceed.connect(start_game)

func start_game():
	print("Start game | " + str(Global.chosen_equipment_style))



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
