class_name PlayerHands
extends Node2D

@export var holding_sprite : Sprite2D 

@export var utility_item : Utility

@export var primary_weapon : Weapon
@export var secondary_weapon : Weapon

#@export var utility_item : Utility

var currently_equipped : Weapon = null

var my_damage : int = 0
var my_firerate : float = 0.0
var my_reload_speed : float = 0.0
var my_projectile = null

var my_shoot_timer : Timer

var can_shoot : bool = true

func _ready():
	await owner.ready
	
	my_shoot_timer = Timer.new()
	add_child.call_deferred(my_shoot_timer)
	my_shoot_timer.timeout.connect(on_shot_cooldown)
	
	if primary_weapon != null:
		equip_weapon(primary_weapon)
	else:
		print("No weapon equipped")
	
	owner.player_hud_ref.set_hud(primary_weapon, secondary_weapon)
	set_inventory_slots()

func _process(delta):
	look_at(get_global_mouse_position())
	
	if currently_equipped:
		if currently_equipped.weapon_full_auto:
			if Input.is_action_pressed("primary_attack") and can_shoot:
				shoot_weapon()
		else:
			if Input.is_action_just_pressed("primary_attack") and can_shoot:
				shoot_weapon()

func _input(event):
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN) and event.pressed:
			switch_weapon()
			return

func equip_weapon(_next_item : Weapon):
	currently_equipped = _next_item
	holding_sprite.texture = currently_equipped.weapon_sprite
	my_damage = currently_equipped.weapon_damage
	my_firerate = currently_equipped.weapon_fire_rate
	my_reload_speed = currently_equipped.weapon_reload_time

func switch_weapon():
	if primary_weapon != null and secondary_weapon != null:
		var item_to_switch = currently_equipped
		if currently_equipped == primary_weapon:
			equip_weapon(secondary_weapon)
		else:
			equip_weapon(primary_weapon)
		owner.player_hud_ref.set_hud(currently_equipped, item_to_switch)

func shoot_weapon():
	if currently_equipped.weapon_cur_mag_count >= currently_equipped.weapon_ammo_per_shot: 
		var type = currently_equipped.weapon_type
		match type:
			0:
				#MELEE WEAPON
				pass
			1:
				#BULLET WEAPON
				for shots in range(currently_equipped.weapon_ammo_per_shot):
					var bullet = currently_equipped.BULLET_SCENE.instantiate()
					bullet.global_position = holding_sprite.global_position
					var ab_dir = (get_global_mouse_position() - global_position).normalized()
					var acc = currently_equipped.weapon_accuracy
					var rand_acc = Vector2(randf_range(-acc,acc), randf_range(-acc,acc))
					bullet.direction = ab_dir + rand_acc
					get_tree().root.add_child(bullet)
				currently_equipped.weapon_cur_mag_count -= currently_equipped.weapon_ammo_per_shot
			2:
				#SHELL WEAPON
				pass
			3:
				#ENERGY WEAPON
				pass
		can_shoot = false
		my_shoot_timer.start(my_firerate)
		owner.player_hud_ref.update_ammo_count(currently_equipped)
	else:
		print("NO AMMO")
		return

func on_shot_cooldown():
	can_shoot = true

func set_inventory_slots():
	owner.inventory_ui_ref.set_item_slots(primary_weapon, secondary_weapon, utility_item)
