class_name Door
extends Node2D

var is_exit : bool = false

signal entered(dir)

func enter(dir):
	emit_signal("entered", dir)
