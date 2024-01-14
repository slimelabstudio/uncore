extends Control

@onready var display := $TextureRect

func set_visual(img : Texture):
	display.texture = img
