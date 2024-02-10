extends Control

@export var selected_weapon_display : TextureRect
@export var off_weapon_display : TextureRect
@export var ammo_count_text : Label 

@onready var background_health_chunks : Array
@onready var foreground_health_chunks : Array

func _ready():
	background_health_chunks = $hp_bg.get_children()
	foreground_health_chunks = $hp_fg.get_children()
	
	Global.player_hud_ref = self

func set_hud(_selected : Weapon, _off : Weapon):
	if _selected:
		selected_weapon_display.texture = _selected.item_icon
		if _off:
			off_weapon_display.texture = _off.item_icon
		ammo_count_text.text = str(_selected.weapon_cur_mag_count)+"/"+str(_selected.weapon_mag_size)
	else:
		ammo_count_text.text = ""

func update_ammo_count(_weapon : Weapon):
	if _weapon:
		ammo_count_text.text = str(_weapon.weapon_cur_mag_count)+"/"+str(_weapon.weapon_reserve_ammo)

func set_health_bar(max_health : int, current_health : int):
	for chunk in background_health_chunks:
		chunk.visible = false
	for chunk in foreground_health_chunks:
		chunk.visible = false
	
	for m in range(max_health):
		background_health_chunks[m].visible = true
	
	for m in range(current_health):
		foreground_health_chunks[m].visible = true
