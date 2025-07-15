extends Node

func _init() -> void:
	GlobalSignalBus.card_changed.connect(_on_card_changed, CONNECT_ONE_SHOT)
	
	Global.double_marker_flag = true
	
func _on_card_changed() -> void:
	Global.double_marker_flag = false
	
	queue_free.call_deferred()
