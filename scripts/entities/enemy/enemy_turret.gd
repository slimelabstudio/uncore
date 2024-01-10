extends Enemy

const BULLET_SCENE := preload("res://scenes/projectiles/enemy/enemy_bullet.tscn")

@onready var hitbox := $hitbox_component
@onready var hp_comp := $health_component

@export var player_detection : RayCast2D
@export var detection_distance : float = 128.0

##Time it takes to fire after storing target position
@export var shot_delay_time : float = 1.0
var shot_countdown_timer : float = 0.0

##Time between shots
@export var shot_cooldown_time : float = 1.0
var shot_cooldown_timer : float = 0.0

@export_category("AUDIO")
@export var attack_sound : AudioStream
@export var spotted_sound : AudioStream
@export var damaged_sound : AudioStream
@export var death_sound : AudioStream

@onready var graphic : Sprite2D = $graphic
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var hit_shader_cooldown : Timer = $hit_shader_cooldown

var awake : bool = false
var ready_to_shoot : bool = false

var target_position : Vector2

var dead : bool = false

func _ready():
	shot_cooldown_timer = shot_cooldown_time
	
	hitbox.enabled = false
	set_collision_layer_value(8, false)

func player_detected() -> bool:
	if player_detection.is_colliding():
		if player_detection.get_collider().name == "main_player":
			return true
		return false
	return false

func play_wake_sound(): #Trying to limit the amount of entity sounds
	if randf() < 0.5:
		AudioManager.play_sound_at(global_position, spotted_sound)

func _process(delta):
	if not dead:
		var player_pos = Global.player_ref.global_position
		
		var dist_to_player = (player_pos - position).length()
		player_detection.target_position = (player_pos - position).normalized() * detection_distance
		
		if shot_cooldown_timer > 0.0:
			shot_cooldown_timer = move_toward(shot_cooldown_timer, 0.0, delta)
		
		if player_detected():
			if not awake:
				anim_player.play("wake")
				
				hitbox.enabled = true
				
				await anim_player.animation_finished
				
				set_collision_layer_value(8, true)
				
				awake = true
			else:
				if player_pos.x < position.x:
					graphic.flip_h = false
				if player_pos.x > position.x:
					graphic.flip_h = true
				
				if shot_cooldown_timer <= 0 and not ready_to_shoot:
					target_position = player_pos
					shot_countdown_timer = shot_delay_time
					ready_to_shoot = true
		
		if ready_to_shoot:
			if shot_countdown_timer > 0.0:
				shot_countdown_timer = move_toward(shot_countdown_timer, 0.0, delta)
			else:
				shoot()

func shoot():
	var dir = (target_position - position).normalized()
	var b = BULLET_SCENE.instantiate()
	b.direction = dir
	b.global_position = position
	get_parent().add_child(b)
	ready_to_shoot = false
	shot_cooldown_timer = shot_cooldown_time
	
	#Shoot sound 
	AudioManager.play_sound_at(global_position, attack_sound)


func _on_health_component_damage_taken():
	graphic.material.set_shader_parameter("enabled", true)
	graphic.scale = Vector2(1.2,1.2)
	hit_shader_cooldown.start(0.1)
	
	#Audio
	AudioManager.play_sound_at(global_position, damaged_sound)
	
	Global.sleep()

func _on_hit_shader_cooldown_timeout():
	graphic.material.set_shader_parameter("enabled", false)
	graphic.scale = Vector2(1.0,1.0)

func _on_health_component_dead():
	graphic.material.set_shader_parameter("enabled", true)
	var st = Timer.new()
	add_child(st)
	st.start(0.1)
	st.timeout.connect(func t_o():	graphic.material.set_shader_parameter("enabled", false))
	anim_player.play("death")
	dead = true
	
	#Audio
	AudioManager.play_sound_at(global_position, death_sound)
	
	$health_component.queue_free()
	$hitbox_component.queue_free()
	$CollisionShape2D.queue_free()
