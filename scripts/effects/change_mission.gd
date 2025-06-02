extends Node

func _init() -> void:
	GlobalSignalBus.psyche_task_request.emit()
	
	queue_free.call_deferred()
