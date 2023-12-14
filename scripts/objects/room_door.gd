class_name RoomDoor
extends Node2D

var room_cleared : bool = false

signal entered

func enter():
	emit_signal("entered")
