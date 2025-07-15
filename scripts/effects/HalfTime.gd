extends Node

const TIME_MODIFIER = 0.5

var original_wait_time : float

func _init() -> void:
	GlobalSignalBus.card_changed.connect(_on_card_changed, CONNECT_ONE_SHOT)
	
	original_wait_time = GlobalCardTimer.wait_time
	GlobalCardTimer.start(original_wait_time * TIME_MODIFIER)

func _revert_wait_time() -> void:
	GlobalCardTimer.wait_time = original_wait_time

func _on_card_changed() -> void:
	_revert_wait_time()
	GlobalCardTimer.start()
	
	queue_free.call_deferred()
