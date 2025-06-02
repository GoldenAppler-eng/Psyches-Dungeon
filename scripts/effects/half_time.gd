extends Node

const TIME_MODIFIER = 0.5

func _init() -> void:
	GlobalCardTimer.start(GlobalCardTimer.wait_time * TIME_MODIFIER)
	
	queue_free.call_deferred()
