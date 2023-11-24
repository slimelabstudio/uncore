extends Node

const save_path := "user://save_data.save"

func save_data(_resource : Resource, _path : String):
	ResourceSaver.save(_resource, _path)

func load_data(_path : String):
	if ResourceLoader.exists(_path):
		return load(_path)
	return null
