extends Node

@export var task_handler : TaskHandler

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		GlobalSignalBus.game_start.emit()

	if Input.is_action_just_pressed("open_chest"):
		task_handler.task_finished.emit()
