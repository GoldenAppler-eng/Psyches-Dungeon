extends Node

var shift_controls_component_prefab : PackedScene = load("res://prefabs/components/shift_controls_component.tscn")

func _init() -> void:
	var component : Node = shift_controls_component_prefab.instantiate()
	Global.global_player.add_child.call_deferred(component)
	queue_free.call_deferred()
