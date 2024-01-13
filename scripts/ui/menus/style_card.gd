extends Control

@export var style_index : int #This will set what equipment the player has -> Pass into player

@export var style_name : String
@export_multiline var style_description : String

var clicked_position : Vector2

signal selected(n, d, i)

func set_card(c_name, c_desc, c_ind):
	emit_signal("selected", c_name, c_desc, c_ind)
