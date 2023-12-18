extends Node


var PLAYER_REF : Player = null

func spawn_player(_pos : Vector2):
	var player = Global.MAIN_PLAYER_SCENE
	var p = player.instantiate()
	p.global_position = _pos
	$SubViewport.add_child(p)
	PLAYER_REF = p

func place_camera():
	var cam = Global.ROOM_CAM_SCENE.instantiate()
	cam.target = PLAYER_REF
	

func _on_room_gen_finished(_spawn_pos):
	spawn_player(_spawn_pos)
