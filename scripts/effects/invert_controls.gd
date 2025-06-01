extends Node

var invert_controls_component_prefab : PackedScene = load("res://prefabs/components/invert_controls_component.tscn")

func _init() -> void:
	var component : Node = invert_controls_component_prefab.instantiate()
	Global.global_player.add_child.call_deferred(component)
	queue_free.call_deferred()
