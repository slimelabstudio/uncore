extends Control

@onready var selected_name := $style_name
@onready var selected_desc := $style_desc

@onready var map_nav_up : TextureButton = $up
@onready var map_nav_down : TextureButton = $down

var current_card_style : int = 1

@export var equipment_styles : Array[Equipment]

@export var map_view : VBoxContainer
@export var pros_view : VBoxContainer
@export var cons_view : VBoxContainer

signal proceed

func _ready():
	if current_card_style == 0:
		map_nav_up.disabled = true
	
	if current_card_style == equipment_styles.size() - 1:
		map_nav_down.disabled = true
	
	change_card(equipment_styles[current_card_style])

func change_card(new_card : Equipment):
	for child in pros_view.get_children():
		child.queue_free()
	for child in cons_view.get_children():
		child.queue_free()
	
	selected_name.text = new_card.equipment_name
	selected_desc.text = new_card.equipment_desc
	
	map_view.get_child(current_card_style).get_child(0).visible = false
	
	current_card_style = new_card.equipment_style_index
	
	for pro in new_card.equipment_pros:
		var l = Label.new()
		pros_view.add_child(l)
		l.add_theme_font_override("font", load("res://dogicapixel.ttf"))
		l.add_theme_font_size_override("font_size", 5)
		l.add_theme_color_override("font_color", Color.GREEN)
		l.text = pro
	
	for con in new_card.equipment_cons:
		var l = Label.new()
		cons_view.add_child(l)
		l.add_theme_font_override("font", load("res://dogicapixel.ttf"))
		l.add_theme_font_size_override("font_size", 5)
		l.add_theme_color_override("font_color", Color.RED)
		l.text = con
	
	$style_card.set_visual(new_card.equipment_visual)
	map_view.get_child(current_card_style).get_child(0).visible = true


func _on_up_pressed():
	change_card(equipment_styles[current_card_style - 1])
	
	if map_nav_down.disabled:
		map_nav_down.disabled = false
	
	if current_card_style == 0:
		map_nav_up.disabled = true

func _on_down_pressed():
	change_card(equipment_styles[current_card_style + 1])
	
	if map_nav_up.disabled:
		map_nav_up.disabled = false
	
	if current_card_style == equipment_styles.size() - 1:
		map_nav_down.disabled = true

func _on_proceed_mouse_entered():
	$proceed/AnimatedSprite2D.play()
func _on_proceed_mouse_exited():
	$proceed/AnimatedSprite2D.play_backwards()

func _on_proceed_pressed():
	Global.chosen_equipment_style = current_card_style
	emit_signal("proceed")
