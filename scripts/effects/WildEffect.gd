class_name WildEffect
extends Resource

@export var effect_type : Global.EFFECT_TYPE
@export var effect_name : String
@export var action_script : GDScript

func run_action() -> void:
	if action_script:
		action_script.new()
