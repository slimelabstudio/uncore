class_name PlayerHands
extends Node2D

@export var holding_sprite : Sprite2D 

@export var utility_item : Utility

@export var primary_weapon : Weapon
@export var secondary_weapon : Weapon

var currently_equipped : Weapon = null

var my_firerate : float = 0.0
var my_reload_speed : float = 0.0
var my_projectile = null

var my_shoot_timer : Timer

@export var reload_progress_bar : Control

var orig_position : Vector2

func _ready():
	await owner.ready
	
	orig_position = position
	
	if primary_weapon != null:
		equip_weapon(primary_weapon)
	
	Global.player_hud_ref.set_hud(primary_weapon, secondary_weapon)
	if currently_equipped:
		pass
		Global.player_hud_ref.update_ammo_count(currently_equipped)
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
				print(diff)
				if (get_current_ammo_reserve()-diff) > 0:
					currently_equipped.weapon_cur_mag_count = currently_equipped.weapon_mag_size
					use_reserve_ammo(diff)
					Global.player_hud_ref.update_ammo_count(currently_equipped)
				else:
					currently_equipped.weapon_cur_mag_count += get_current_ammo_reserve()
					set_reserve_ammo(0)
					Global.player_hud_ref.update_ammo_count(currently_equipped)
				currently_equipped.on_reload_cooldown = false
				reload_progress_bar.cancel_reload()
				return

func equip_weapon(_next_item : Weapon):
	currently_equipped = _next_item
	holding_sprite.texture = currently_equipped.weapon_sprite
	my_firerate = currently_equipped.weapon_fire_rate
	my_reload_speed = currently_equipped.weapon_reload_time
	
	AudioManager.play_sound_at(global_position, currently_equipped.equip_sound)

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
		Global.player_hud_ref.set_hud(currently_equipped, item_to_switch)
		Global.player_hud_ref.update_ammo_count(currently_equipped)

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
					Global.room_manager.add_child(bullet)
				currently_equipped.weapon_cur_mag_count -= currently_equipped.weapon_ammo_per_shot
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
					Global.room_manager.add_child(slug)
				else:
					for shots in range(5):
						var shell = currently_equipped.SHELL_SCENE.instantiate()
						var ab_dir = (get_global_mouse_position() - global_position).normalized()
						var acc = currently_equipped.weapon_accuracy
						var rand_acc = Vector2(randf_range(-acc,acc), randf_range(-acc,acc))
						shell.direction = ab_dir + rand_acc
						shell.global_position = holding_sprite.global_position + (shell.direction*2)
						Global.room_manager.add_child(shell)
				currently_equipped.weapon_cur_mag_count -= currently_equipped.weapon_ammo_per_shot
			3:
				#ENERGY WEAPON
				var laser = currently_equipped.ENERGY_BEAM_SCENE.instantiate()
				var dir = (get_global_mouse_position() - global_position).normalized()
				Global.room_manager.add_child(laser)
				laser.global_position = holding_sprite.global_position+(dir*2)
				laser.setup(dir, currently_equipped.weapon_damage)
		
		currently_equipped._shoot()
		Global.player_hud_ref.update_ammo_count(currently_equipped)
		AudioManager.play_sound_at(global_position, currently_equipped.attack_sound, "attack_player")
		SignalBus.shake_cam.emit(currently_equipped.shake_power)
	else:
		AudioManager.play_sound_at(global_position, currently_equipped.empty_sound)
		return
	
	var kick_dir = (global_position - get_global_mouse_position()).normalized()
	position += kick_dir*currently_equipped.kick_power

func reload_weapon():
	if currently_equipped.weapon_cur_mag_count < currently_equipped.weapon_mag_size:
		print("RELOAD")
		currently_equipped._reload()
		reload_progress_bar.start_reload(currently_equipped.weapon_reload_time)

func set_inventory_slots():
	owner.inventory_ui_ref.set_item_slots(primary_weapon, secondary_weapon, utility_item)

func set_reserve_ammo(new_val : int):
	currently_equipped.weapon_reserve_ammo = new_val

func use_reserve_ammo(amount : int):
	currently_equipped.weapon_reserve_ammo -= amount

#func set_reserve_ammo(amount : int):
	#match currently_equipped.weapon_type:
		#1: #Bullets
			#current_bullets = amount
		#2: #Shell
			#current_shells = amount
		#3: #Energy
			#current_energy = amount

func get_current_ammo_reserve():
	return currently_equipped.weapon_reserve_ammo

func spawn_casing():
	var type = currently_equipped.weapon_type
	var casing = currently_equipped.CASING_SCENE.instantiate()
	Global.room_manager.add_child(casing)
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
