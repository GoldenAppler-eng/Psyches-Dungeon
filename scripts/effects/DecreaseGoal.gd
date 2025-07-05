extends Node

func _init() -> void:
	GlobalSignalBus.change_goal_count.emit(-1)
	
	queue_free.call_deferred()
