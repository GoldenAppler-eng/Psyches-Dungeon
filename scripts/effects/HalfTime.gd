extends Node

const TIME_MODIFIER = 0.5

var original_wait_time : float

func _init() -> void:
	GlobalCardTimer.timeout.connect(_on_global_card_timer_timeout)
	GlobalSignalBus.task_completed.connect(_on_task_completed)
	
	original_wait_time = GlobalCardTimer.wait_time
	
	GlobalCardTimer.start(original_wait_time * TIME_MODIFIER)

func _revert_wait_time() -> void:
	GlobalCardTimer.wait_time = original_wait_time

func _on_global_card_timer_timeout() -> void:
	_revert_wait_time()
	queue_free.call_deferred()
	
func _on_task_completed(task_type : int) -> void:
	_revert_wait_time()
	queue_free.call_deferred()
