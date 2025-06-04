extends Node

const TIME_MODIFIER = 0.5

func _init() -> void:
	GlobalCardTimer.timeout.connect(_on_global_card_timer_timeout)
	GlobalCardTimer.start(GlobalCardTimer.wait_time * TIME_MODIFIER)

func _on_global_card_timer_timeout() -> void:
	GlobalCardTimer.wait_time /= TIME_MODIFIER
	queue_free.call_deferred()
