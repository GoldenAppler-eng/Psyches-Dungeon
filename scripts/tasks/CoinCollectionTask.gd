class_name CoinCollectionTask
extends Task

func _init() -> void:
	GlobalSignalBus.coin_collected.connect(_on_task_progress_made)
