extends Label

@export var task_handler : TaskHandler

@onready var task_completed_sfx: AudioStreamPlayer = %TaskCompletedSfx

func _ready() -> void:
	task_handler.current_task_changed.connect(_on_current_task_changed)
	task_handler.task_finished.connect(_on_task_finished)
	
func _on_current_task_changed() -> void:
	text = task_handler.get_current_task_description_with_progress()

func _on_task_finished() -> void:
	task_completed_sfx.play()
