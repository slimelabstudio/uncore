class_name Utility
extends Item

enum UTILITY_TYPES {
	HEALTH,
	STAMINA,
	POWER,
	ARMOR
}
@export var util_type : UTILITY_TYPES

@export var util_time_to_use : float

func use():
	match util_type:
		0:
			print("Here")
