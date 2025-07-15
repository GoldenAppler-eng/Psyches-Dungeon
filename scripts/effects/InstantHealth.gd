extends Node

func _init() -> void:
	var player_regeneration_component : RegenerationComponent = Global.global_player.find_child("RegenerationComponent") as RegenerationComponent
	player_regeneration_component.regenerate_health(1)
	
	queue_free.call_deferred()
