extends Control

@export var selected_weapon_display : TextureRect
@export var off_weapon_display : TextureRect
@export var ammo_count_text : Label 


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
		ammo_count_text.text = str(_weapon.weapon_cur_mag_count)+"/"+str(_weapon.weapon_mag_size)
