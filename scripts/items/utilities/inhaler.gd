class_name Inhaler
extends Utility

enum INHALER_TYPES {
	Health,
	Damage,
	Speed,
	FireRate,
	Armor
}
@export var inhaler_type : INHALER_TYPES

@export var inhaler_use_sound : AudioStream

func use() -> Dictionary:
	match inhaler_type:
		0: #HEALTH
			return { 
				"buff" : "hp",
				"value" : "2",
				}
		1: #DAMAGE
			return { 
				"buff" : "dmg", 
				"value" : "1",
				}
		2: #SPEED
			return { 
				"buff" : "spd",
				"value" : "50", 
				}
		3: #FIRERATE
			return { 
				"buff" : "fr",
				"value" : "1.5",
				}
		4: #ARMOR
			return { 
				"buff" : "arm",
				"value" : "2",
				}
		_:
			return {}
	return {}
