extends Node2D

var shift_dict : Dictionary = {
	"move_up" : "move_left",
	"move_right" : "move_up",
	"move_down" : "move_right",
	"move_left" : "move_down"
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
	
	_shift_controls()

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

func _shift_controls() -> void:
	var prev_events : Array[InputEvent]
	
	for action : String in shift_dict.keys():
		if prev_events.is_empty():
			prev_events = InputMap.action_get_events(action)
		
			InputMap.action_erase_events(action)
			
			for event in InputMap.action_get_events(shift_dict[action]):
				InputMap.action_add_event(action, event)
		else:
			var tmp_events : Array[InputEvent] = InputMap.action_get_events(action)

			InputMap.action_erase_events(action)
			
			for event in prev_events:
				InputMap.action_add_event(action, event)
				
			prev_events = tmp_events
