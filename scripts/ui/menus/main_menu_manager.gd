extends Node2D

@export var initial_menu : Control

@export var main : Control
@export var options : Control
@export var credits : Control
@export var style_select : Control

var active_menu : Control = null
var previous_menu : Control = null

@export_category("AUDIO")
@export var button_hover_sound : AudioStream
@export var button_press_sound : AudioStream
@export var hover_proceed_sound : AudioStream
@export var press_proceed_sound : AudioStream
@export var options_slider_move_sound : AudioStream

func _ready():
	#IF AN OLD SAVE OF THE TOWER EXISTS - DELETE IT 
	if ResourceLoader.exists("user://towerdata.res"):
		DirAccess.remove_absolute("user://towerdata.res")
	
	initial_menu.visible = true
	active_menu = initial_menu
	
	$CanvasLayer/svc/sv/sub_menus/style_select.proceed.connect(start_game)
	
	$CanvasLayer/svc/sv/sub_menus/main/menu_options/play.mouse_entered.connect(on_button_hover)
	$CanvasLayer/svc/sv/sub_menus/main/menu_options/options.mouse_entered.connect(on_button_hover)
	$CanvasLayer/svc/sv/sub_menus/main/menu_options/quit.mouse_entered.connect(on_button_hover)
	$CanvasLayer/svc/sv/sub_menus/options/back.mouse_entered.connect(on_button_hover)
	$CanvasLayer/svc/sv/sub_menus/credits/back.mouse_entered.connect(on_button_hover)

func start_game():
	get_tree().change_scene_to_packed(load("res://scenes/tower/tower.tscn"))


func _on_play_pressed():
	previous_menu = active_menu
	active_menu.visible = false
	active_menu = style_select
	active_menu.visible = true
	
	AudioManager.play_gen_sound(button_press_sound)

func _on_options_pressed():
	previous_menu = active_menu
	active_menu.visible = false
	active_menu = options
	active_menu.visible = true
	
	AudioManager.play_gen_sound(button_press_sound)

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	active_menu.visible = false
	active_menu = previous_menu
	active_menu.visible = true
	previous_menu = null
	
	AudioManager.play_gen_sound(button_press_sound)

func on_button_hover():
	AudioManager.play_gen_sound(button_hover_sound)
