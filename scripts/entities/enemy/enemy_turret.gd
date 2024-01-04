extends Enemy

const BULLET_SCENE := preload("res://scenes/projectiles/enemy/enemy_bullet.tscn")

@export var player_detection : RayCast2D

##Time it takes to fire after storing target position
@export var shot_delay_time : float = 1.0
var shot_countdown_timer : float = 0.0

##Time between shots
@export var shot_cooldown_time : float = 1.0
var shot_cooldown_timer : float = 0.0

@export_category("Audio")
@export var vocal_damaged_sound_player : AudioStreamPlayer2D
@export var vocal_spotted_sound_player : AudioStreamPlayer2D
@export var vocal_death_sound_player : AudioStreamPlayer2D
@export var vocal_general_sound_player : AudioStreamPlayer2D
@export var attack_sound_player : AudioStreamPlayer2D

@onready var graphic : Sprite2D = $graphic
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var hit_shader_cooldown : Timer = $hit_shader_cooldown

var detection_distance : float = 128.0

var awake : bool = false
var ready_to_shoot : bool = false

var target_position : Vector2

var dead : bool = false

func _ready():
	shot_cooldown_timer = shot_cooldown_time

func player_detected() -> bool:
	if player_detection.is_colliding():
		if player_detection.get_collider().name == "main_player":
			return true
		return false
	return false

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
				await anim_player.animation_finished
				detection_distance = 160.0
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
	attack_sound_player.play()


func _on_health_component_damage_taken():
	graphic.material.set_shader_parameter("enabled", true)
	graphic.scale = Vector2(1.2,1.2)
	hit_shader_cooldown.start(0.1)
	
	#Audio
	vocal_damaged_sound_player.play()
	
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
	vocal_death_sound_player.play()
	
	$health_component.queue_free()
	$hitbox_component.queue_free()
	$CollisionShape2D.queue_free()
