class_name TaskHandler
extends Node2D

signal task_finished
signal current_task_changed
signal task_progress_made

@export var task_pool : Array[Task]

var current_task : Task
var next_task : Task

var _finished_flag : bool = false

func _ready() -> void:
	for task in task_pool:
		task.init()
		
	GlobalSignalBus.task_requirement_doubled.connect(_on_task_requirement_doubled)
	GlobalSignalBus.psyche_task_request.connect(_on_psyche_task_received)

func _process(delta : float) -> void:			
	if not current_task:
		return
		
	if current_task.get_is_finished() and not _finished_flag:
		_process_task_finished()
	
func change_task() -> void:
	if current_task:
		current_task.progress_made.disconnect(_on_current_task_progress_made)
	
	current_task = next_task
	current_task.set_active(true)
	current_task.progress_made.connect(_on_current_task_progress_made)
	
	_finished_flag = false
	generate_new_next_task()
	
	current_task_changed.emit()

func generate_new_current_task() -> void:
	if current_task:
		current_task.progress_made.disconnect(_on_current_task_progress_made)
	
	current_task = _get_random_task()
	current_task.set_active(true)
	current_task.progress_made.connect(_on_current_task_progress_made)

	_finished_flag = false
	
	current_task_changed.emit()
	
func generate_new_next_task() -> void:
	next_task = _get_random_task()

func _get_random_task() -> Task:
	var rand_task : Task = task_pool.pick_random() as Task
	rand_task = rand_task.duplicate()
	rand_task.generate_new()
		
	return rand_task

func _process_task_finished() -> void:
	_finished_flag = true
	task_finished.emit()
		
func get_current_task_description() -> String:
	return current_task.get_task_description_formatted(false)

func get_current_task_description_with_progress() -> String:
	return current_task.get_task_description_formatted(true)

func get_next_task_description() -> String:
	return next_task.get_task_description_formatted(false)

func _on_task_requirement_doubled() -> void:
	current_task.double_requirement()
	current_task_changed.emit()

func _on_psyche_task_received() -> void:
	generate_new_current_task()	

func _on_current_task_progress_made() -> void:
	task_progress_made.emit()
