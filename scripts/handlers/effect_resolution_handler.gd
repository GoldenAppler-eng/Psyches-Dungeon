extends Node2D

@export var effects_to_resolve : Array[WildEffect]

func _process(delta : float) -> void:
	if effects_to_resolve:
		var eff : WildEffect = effects_to_resolve.pop_front()
		
		eff.run_action()
