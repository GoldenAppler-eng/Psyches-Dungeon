extends Node2D

enum TASK_TYPE { DEFEAT = 0, DEFEAT_GOLD, COLLECT, OPEN, ACTIVATE, TRAVEL }

@onready var task_display_label : Label = $TaskDisplayLabel

var current_task_type : int

var task_completion_counter : int = 0
var task_completion_amount : int = 5 

var direction_dict : Dictionary = {
	0 : "upwards",
	1 : "downwards",
	2 : "right",
	4 : "left"
}

var task_completion_direction : int = 0

func _ready() -> void:
	GlobalSignalBus.coin_collected.connect(_on_coin_collected)
	
	current_task_type = TASK_TYPE.COLLECT

func _process(delta : float) -> void:
	if task_completion_counter >= task_completion_amount:
		GlobalSignalBus.task_completed.emit(0)
	
	var task_text : String
	
	match current_task_type:
		TASK_TYPE.DEFEAT:
			task_text = "Defeat (" + str(task_completion_counter) + "/" + str(task_completion_amount) + ") enemies"
		TASK_TYPE.DEFEAT_GOLD:
			task_text = "Defeat (" + str(task_completion_counter) + "/" + str(task_completion_amount) + ") golden enemies"
		TASK_TYPE.COLLECT:
			task_text = "Collect (" + str(task_completion_counter) + "/" + str(task_completion_amount) + ") coins"
		TASK_TYPE.OPEN:
			task_text = "Open (" + str(task_completion_counter) + "/" + str(task_completion_amount) + ") chests"
		TASK_TYPE.ACTIVATE:
			task_text = "Activate (" + str(task_completion_counter) + "/" + str(task_completion_amount) + ") traps"
		TASK_TYPE.TRAVEL:
			task_text = "Go " + direction_dict[task_completion_direction] + " into another room (" + str(task_completion_counter) + "/" + str(task_completion_amount) + ") times in a row"	
	
	task_display_label.text = task_text

func _on_coin_collected() -> void:
	if current_task_type == TASK_TYPE.COLLECT:
		task_completion_counter += 1
