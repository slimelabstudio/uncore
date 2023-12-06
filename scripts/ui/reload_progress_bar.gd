extends Control

@export var progress_bar : ProgressBar 

var tween : Tween 

func set_progress(_value : float):
	progress_bar.value = _value

func _ready():
	set_progress(0.0)
	visible = false

func start_reload(_time : float):
	set_progress(0.0)
	visible = true
	tween = create_tween()
	tween.tween_method(set_progress, 0.0, 1.0, _time)

func cancel_reload():
	tween.kill()
	visible = false
