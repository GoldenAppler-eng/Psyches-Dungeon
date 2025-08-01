class_name EffectHandler
extends Node2D

@export var effects_to_resolve : Array[WildEffect]

func _ready() -> void:
	GlobalSignalBus.retry.connect(_on_game_retry)

func _process(delta : float) -> void:
	if effects_to_resolve:
		var effect : WildEffect = effects_to_resolve.pop_front()
		
		effect.run_action()
		
func add_effect_to_resolve(eff : WildEffect) -> void:
	effects_to_resolve.append(eff)

func _on_game_retry() -> void:
	effects_to_resolve = []
