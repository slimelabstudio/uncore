class_name PlayerHands
extends Node2D

@export var holding_sprite : Sprite2D 

@export var utility_item : Utility

@export var primary_weapon : Weapon
@export var secondary_weapon : Weapon

var currently_equipped : Weapon = null

#AMMO
@export var max_bullets : int = 10
var current_bullets : int = 0
@export var max_shells : int = 10
var current_shells : int = 0
@export var max_energy : int = 10
var current_energy : int = 0

var my_damage : int = 0
var my_firerate : float = 0.0
var my_reload_speed : float = 0.0
var my_projectile = null

var my_shoot_timer : Timer

@export var reload_progress_bar : Control

var orig_position : Vector2


func _ready():
	await owner.ready
	
	orig_position = position
	
	current_bullets = max_bullets/2
	current_shells = (max_shells/2)-2
	current_energy = max_energy/2
	
	if primary_weapon != null:
		equip_weapon(primary_weapon)
	else:
		print("No weapon equipped")
	
	#owner.player_hud_ref.set_hud(primary_weapon, secondary_weapon)
	#if currently_equipped:
		#DEFAULT TO DISPLAY BULLETS
		#owner.player_hud_ref.update_ammo_count(currently_equipped, current_bullets)
	#set_inventory_slots()

func _process(delta):
	look_at(get_global_mouse_position())
	
	if position != orig_position:
		position = lerp(position, orig_position, delta * 18)
	
	if get_global_mouse_position().y < global_position.y:
		get_child(0).z_index = -1
	else:
		get_child(0).z_index = 0
	
	if currently_equipped:
		if secondary_weapon:
			if Input.is_action_just_pressed("switch_wep"):
				switch_weapon()
		if !currently_equipped.on_reload_cooldown:
			if currently_equipped.weapon_full_auto:
				if Input.is_action_pressed("primary_attack") and !currently_equipped.on_shot_cooldown:
					shoot_weapon()
			else:
				if Input.is_action_just_pressed("primary_attack") and !currently_equipped.on_shot_cooldown:
					shoot_weapon()
			
			if Input.is_action_just_pressed("reload") and get_current_ammo_reserve() > 0:
				reload_weapon()
		
		if currently_equipped.on_shot_cooldown:
			if currently_equipped.shot_cooldown_time_left > 0:
				currently_equipped.shot_cooldown_time_left -= delta
			else:
				if currently_equipped.weapon_is_pump:
					await spawn_casing()
				currently_equipped.on_shot_cooldown = false
		
		if currently_equipped.on_reload_cooldown:
			if currently_equipped.reload_time_elapsed < currently_equipped.weapon_reload_time:
				currently_equipped.reload_time_elapsed += delta
			else:
				#Amount needed to fill the gun
				var diff = abs(abs(currently_equipped.weapon_cur_mag_count)-abs(currently_equipped.weapon_mag_size))
				if (get_current_ammo_reserve()-diff) >= currently_equipped.weapon_mag_size:
					var type = currently_equipped.weapon_type
					match type:
						1:
							#BULLET
							current_bullets -= diff
						2:
							#SHELL
							current_shells -= diff
						3:
							#ENERGY
							current_energy -= diff
					currently_equipped.weapon_cur_mag_count = currently_equipped.weapon_mag_size
					#owner.player_hud_ref.update_ammo_count(currently_equipped, get_current_ammo_reserve())
				currently_equipped.on_reload_cooldown = false
				reload_progress_bar.cancel_reload()
				return

func equip_weapon(_next_item : Weapon):
	currently_equipped = _next_item
	holding_sprite.texture = currently_equipped.weapon_sprite
	my_damage = currently_equipped.weapon_damage
	my_firerate = currently_equipped.weapon_fire_rate
	my_reload_speed = currently_equipped.weapon_reload_time

func switch_weapon():
	if primary_weapon != null and secondary_weapon != null:
		if currently_equipped.on_reload_cooldown:
			currently_equipped.reload_time_elapsed = 0.0
			currently_equipped.on_reload_cooldown = false
			reload_progress_bar.cancel_reload()
		var item_to_switch = currently_equipped
		if currently_equipped == primary_weapon:
			equip_weapon(secondary_weapon)
		else:
			equip_weapon(primary_weapon)
		owner.player_hud_ref.set_hud(currently_equipped, item_to_switch)
		owner.player_hud_ref.update_ammo_count(currently_equipped, get_current_ammo_reserve())

func shoot_weapon():
	#THIS FUNCTION NEEDS A REFACTOR 
	#THIS IS TERRIBLY UGLY.
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
					var ab_dir = (get_global_mouse_position() - global_position).normalized()
					var acc = currently_equipped.weapon_accuracy
					var rand_acc = Vector2(randf_range(-acc,acc), randf_range(-acc,acc))
					bullet.direction = ab_dir + rand_acc
					bullet.global_position = holding_sprite.global_position + (bullet.direction*2)
					get_parent().get_parent().add_child(bullet)
				currently_equipped.weapon_cur_mag_count -= currently_equipped.weapon_ammo_per_shot
				#owner.player_hud_ref.update_ammo_count(currently_equipped, current_bullets)
				spawn_casing()
			2:
				#SHELL WEAPON
				if currently_equipped.weapon_is_slug:
					var slug = currently_equipped.SLUG_SCENE.instantiate()
					var ab_dir = (get_global_mouse_position() - global_position).normalized()
					var acc = currently_equipped.weapon_accuracy
					var rand_acc = Vector2(randf_range(-acc,acc), randf_range(-acc,acc))
					slug.direction = ab_dir + rand_acc
					slug.global_position = holding_sprite.global_position + (slug.direction*2)
					get_parent().get_parent().add_child(slug)
				else:
					for shots in range(5):
						var shell = currently_equipped.SHELL_SCENE.instantiate()
						var ab_dir = (get_global_mouse_position() - global_position).normalized()
						var acc = currently_equipped.weapon_accuracy
						var rand_acc = Vector2(randf_range(-acc,acc), randf_range(-acc,acc))
						shell.direction = ab_dir + rand_acc
						shell.global_position = holding_sprite.global_position + (shell.direction*2)
						get_parent().get_parent().add_child(shell)
				currently_equipped.weapon_cur_mag_count -= currently_equipped.weapon_ammo_per_shot
				owner.player_hud_ref.update_ammo_count(currently_equipped, current_shells)
			3:
				#ENERGY WEAPON
				pass
		currently_equipped._shoot()
		SignalBus.shake_cam.emit(currently_equipped.shake_power)
	else:
		print("NO AMMO")
		return
	
	var kick_dir = (global_position - get_global_mouse_position()).normalized()
	position += kick_dir*4

func reload_weapon():
	if currently_equipped.weapon_cur_mag_count < currently_equipped.weapon_mag_size:
		currently_equipped._reload()
		reload_progress_bar.start_reload(currently_equipped.weapon_reload_time)

func set_inventory_slots():
	owner.inventory_ui_ref.set_item_slots(primary_weapon, secondary_weapon, utility_item)

func get_current_ammo_reserve():
	match currently_equipped.weapon_type:
		0:
			#MELEE
			return 
		1:
			#BULLETS
			return current_bullets
		2:
			#SHELL
			return current_shells
		3:
			#ENERGY
			return current_energy

func spawn_casing():
	var type = currently_equipped.weapon_type
	var casing = currently_equipped.CASING_SCENE.instantiate()
	get_parent().get_parent().add_child(casing)
	casing.global_position = global_position
	match type:
		0:
			#MELEE
			pass
		1:
			#BULLET
			casing.sprite.texture = casing.casing_sprites["BULLET"]
		2:
			#SHELL
			casing.sprite.texture = casing.casing_sprites["SHELL"]
