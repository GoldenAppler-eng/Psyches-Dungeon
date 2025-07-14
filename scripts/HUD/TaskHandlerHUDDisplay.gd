extends Label

@export var task_handler : TaskHandler

@onready var task_completed_sfx: AudioStreamPlayer = %TaskCompletedSfx

func _ready() -> void:
	task_handler.current_task_changed.connect(_on_current_task_changed)
	task_handler.task_finished.connect(_on_task_finished)
	task_handler.task_progress_made.connect(_on_task_progress_made)
	
func _on_current_task_changed() -> void:
	_update_task_text()
	
func _on_task_finished() -> void:
	task_completed_sfx.play()

func _on_task_progress_made() -> void:
	_update_task_text()
	
func _update_task_text() -> void:
	text = task_handler.get_current_task_description_with_progress()
