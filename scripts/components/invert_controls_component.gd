extends Node2D

var invert_dict : Dictionary = {
	"move_up" : "move_down",
	"move_left" : "move_right"
}

var input_map_actions : Array[String] = [
	"move_up",
	"move_down",
	"move_right",
	"move_left"
]

var original_input_events : Dictionary

func _ready() -> void:
	GlobalCardTimer.timeout.connect(_on_destroy_timer_timeout)
	_store_original_controls()
	
	_invert_controls()

func _store_original_controls() -> void:
	for action in input_map_actions:
		original_input_events[action] = []
		
		for event in InputMap.action_get_events(action):
			original_input_events[action].append(event)

func _revert_original_controls() -> void:
	for action in input_map_actions:
		InputMap.action_erase_events(action)
		
		for event : InputEvent in original_input_events[action]:
			InputMap.action_add_event(action, event)

func _on_destroy_timer_timeout() -> void:
	_revert_original_controls()
	queue_free.call_deferred()

func _invert_controls() -> void:
	for action : String in invert_dict.keys():
		var tmp_events : Array[InputEvent] = InputMap.action_get_events(action)
		
		InputMap.action_erase_events(action)
		
		for event in InputMap.action_get_events(invert_dict[action]):
			InputMap.action_add_event(action, event)
		
		InputMap.action_erase_events(invert_dict[action])
		
		for event in tmp_events:
			InputMap.action_add_event(invert_dict[action], event)
