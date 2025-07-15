extends Node

func _init() -> void:
	GlobalSignalBus.timer_hidden.emit(true)
	GlobalSignalBus.card_changed.connect(_on_card_changed, CONNECT_ONE_SHOT)
	
func _on_card_changed() -> void:
	GlobalSignalBus.timer_hidden.emit(false)
	queue_free.call_deferred()
