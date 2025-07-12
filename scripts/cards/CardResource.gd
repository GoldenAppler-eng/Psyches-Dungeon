class_name CardResource
extends Resource

var task_text : String = ""
var effect_text : String = ""

@export var effect_type : Global.EFFECT_TYPE = Global.EFFECT_TYPE.NONE

func get_effect_color_hex() -> String:
	match effect_type:
		Global.EFFECT_TYPE.NONE:
			return "#fffff"
		Global.EFFECT_TYPE.PSYCHE:
			return "#ff0000"
		Global.EFFECT_TYPE.GOAL:
			return "#6abe30"
		Global.EFFECT_TYPE.CONTROL:
			return "#639bff"
		
	return "#fffff"
