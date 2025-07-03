class_name RoomTravelTask
extends Task

const _DIRECTION_DICT : Dictionary = {
	Global.DIRECTION.NORTH : "upwards",
	Global.DIRECTION.SOUTH : "downwards",
	Global.DIRECTION.EAST : "right",
	Global.DIRECTION.WEST : "left"
}

@export var need_consecutive : bool = false

var _requirement_direction : Global.DIRECTION = Global.DIRECTION.NORTH

func _init() -> void:
	GlobalSignalBus.room_changed.connect(_on_room_changed)

func generate_new_requirement() -> void:
	super()
	
	_requirement_direction = randi_range(Global.DIRECTION.NORTH, Global.DIRECTION.WEST)

func get_task_description_formatted(counter_included : bool) -> String:
	var replacement_str_amount : String = str(_requirement_amount)
	var replacement_direction : String = _DIRECTION_DICT[_requirement_direction]
	
	if counter_included:
		replacement_str_amount = _add_progress_counter_str(replacement_str_amount)
	
	return task_description.format({"requirement_amount" : replacement_str_amount, "requirement_direction" : replacement_direction}, format_placeholder)

func _on_room_changed(direction : int, room_area : Node2D) -> void:
	if not direction == _requirement_direction:
		if need_consecutive:
			reset_task_progress()
		
		return
		
	_on_task_progress_made()
