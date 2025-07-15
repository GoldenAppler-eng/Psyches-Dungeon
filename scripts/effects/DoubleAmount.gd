extends Node

func _init() -> void:
	GlobalSignalBus.task_requirement_doubled.emit()
	
	queue_free.call_deferred()
