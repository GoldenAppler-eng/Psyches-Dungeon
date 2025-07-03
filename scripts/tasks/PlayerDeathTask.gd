class_name PlayerDeathTask
extends Task

func _init() -> void:
	GlobalSignalBus.player_death.connect(_on_task_progress_made)
