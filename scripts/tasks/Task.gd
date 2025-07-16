class_name Task
extends Resource

signal progress_made

const format_placeholder : String = "{_}"

enum TASK_STATUS { ACTIVE = 0, INACTIVE, FINISHED }

@export_multiline var task_description : String
@export var min_requirement : int = 1
@export var max_requirement : int = 1

var _requirement_amount : int = 1
var _progress_counter : int = 0

var status : TASK_STATUS = TASK_STATUS.INACTIVE

func init() -> void:
	pass 
	
func generate_new() -> void:
	reset_task_progress()
	generate_new_requirement()

func reset_task_progress() -> void:
	_progress_counter = 0

func generate_new_requirement() -> void:
	_requirement_amount = randi_range(min_requirement, max_requirement)
	
func get_task_description_formatted(counter_included : bool) -> String:
	var replacement_str : String = str(_requirement_amount)
	
	if counter_included:
		replacement_str = _add_progress_counter_str(replacement_str)
	
	return task_description.format({"requirement_amount" : replacement_str}, format_placeholder)

func double_requirement() -> void:
	_requirement_amount *= 2

func set_active(active : bool) -> void:
	status = TASK_STATUS.ACTIVE if active else TASK_STATUS.INACTIVE

func get_is_finished() -> bool:
	return status == TASK_STATUS.FINISHED

func _add_progress_counter_str(string : String) -> String:
	return "(" + str(_progress_counter) + "/" + string + ")"

func _on_task_progress_made() -> void:
	if not status == TASK_STATUS.ACTIVE:
		return
	
	_progress_counter += 1
	progress_made.emit()
	
	if _progress_counter >= _requirement_amount:
		status = TASK_STATUS.FINISHED
