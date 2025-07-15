extends Node

func _init() -> void:
	GlobalSignalBus.timer_hidden.emit()
	
	queue_free.call_deferred()
