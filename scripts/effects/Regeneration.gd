extends Node

func _init() -> void:
	GlobalSignalBus.card_changed.connect(_on_card_changed, CONNECT_ONE_SHOT)
	
	var player_regeneration_component : RegenerationComponent = Global.global_player.find_child("RegenerationComponent") as RegenerationComponent
	player_regeneration_component.start_continuous_regen()

func _on_card_changed() -> void:
	var player_regeneration_component : RegenerationComponent = Global.global_player.find_child("RegenerationComponent") as RegenerationComponent
	player_regeneration_component.stop_continuous_regeneration()
	
	queue_free.call_deferred()
