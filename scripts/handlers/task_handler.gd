class_name TaskHandler
extends Node2D

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
	GlobalSignalBus.chest_opened.connect(_on_chest_opened)
	GlobalSignalBus.trap_activated.connect(_on_trap_activated)
	GlobalSignalBus.enemy_death.connect(_on_enemy_death)
	GlobalSignalBus.player_death.connect(_on_player_death)
	GlobalSignalBus.room_changed.connect(_on_room_changed)

	current_task_type = Global.TASK_TYPE.COLLECT

func _process(delta : float) -> void:
	if task_completion_counter >= task_completion_amount:
		signal_task_completed()
	
	var task_text : String
	
	match current_task_type:
		Global.TASK_TYPE.DEFEAT:
			task_text = "Defeat (" + str(task_completion_counter) + "/" + str(task_completion_amount) + ") enemies"
		Global.TASK_TYPE.DEFEAT_GOLD:
			task_text = "Defeat (" + str(task_completion_counter) + "/" + str(task_completion_amount) + ") golden enemies"
		Global.TASK_TYPE.COLLECT:
			task_text = "Collect (" + str(task_completion_counter) + "/" + str(task_completion_amount) + ") coins"
		Global.TASK_TYPE.OPEN:
			task_text = "Open (" + str(task_completion_counter) + "/" + str(task_completion_amount) + ") chests"
		Global.TASK_TYPE.ACTIVATE:
			task_text = "Activate (" + str(task_completion_counter) + "/" + str(task_completion_amount) + ") traps"
		Global.TASK_TYPE.DIE:
			task_text = "Die"
		Global.TASK_TYPE.TRAVEL:
			task_text = "Go " + direction_dict[task_completion_direction] + " into another room (" + str(task_completion_counter) + "/" + str(task_completion_amount) + ") times in a row"	
	
	task_display_label.text = task_text

func set_task_type(type : int, amt : int) -> void:
	reset_counter()
	
	current_task_type = type
	task_completion_amount = amt

func reset_counter() -> void :
	task_completion_counter = 0

func _on_coin_collected() -> void:
	if current_task_type == Global.TASK_TYPE.COLLECT:
		task_completion_counter += 1
		
func _on_chest_opened() -> void:
	if current_task_type == Global.TASK_TYPE.OPEN:
		task_completion_counter += 1
		
func _on_trap_activated(activating_body : Node2D) -> void:
	if current_task_type == Global.TASK_TYPE.ACTIVATE and activating_body is Player:
		task_completion_counter += 1
		
func _on_enemy_death(is_gold : bool) -> void:
	if current_task_type == Global.TASK_TYPE.DEFEAT:
		task_completion_counter += 1
	elif current_task_type == Global.TASK_TYPE.DEFEAT_GOLD and is_gold:
		task_completion_counter += 1
		
func _on_player_death() -> void:
	if current_task_type == Global.TASK_TYPE.DIE:
		signal_task_completed()
		
func _on_room_changed(direction : int, room_area : Node2D) -> void:
	if current_task_type == Global.TASK_TYPE.TRAVEL:
		if task_completion_direction == direction:
			task_completion_counter += 1
		else:
			reset_counter()
			
func signal_task_completed() -> void:
	reset_counter()
	GlobalSignalBus.task_completed.emit(current_task_type)
