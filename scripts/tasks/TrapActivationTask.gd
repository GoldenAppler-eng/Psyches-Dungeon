class_name TrapActivationTask
extends Task

func _init() -> void:
	GlobalSignalBus.trap_activated.connect(_on_trap_activated)

func _on_trap_activated(activating_body : Node2D) -> void:
	if activating_body is Player:
		_on_task_progress_made()
