class_name ChestOpeningTask
extends Task

func _init() -> void:
	GlobalSignalBus.chest_opened.connect(_on_task_progress_made)
