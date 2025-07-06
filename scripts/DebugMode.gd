extends Node

@export var task_handler : TaskHandler

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_finish_task"):
		task_handler.task_finished.emit()

	if Input.is_action_just_pressed("debug_fail_task"):
		GlobalCardTimer.timeout.emit()
