extends Node

func _init() -> void:
	Global.lucky_flag = true
	
	GlobalSignalBus.card_changed.connect(_on_card_changed, CONNECT_ONE_SHOT)
	
func _on_card_changed() -> void:
	Global.lucky_flag = false
