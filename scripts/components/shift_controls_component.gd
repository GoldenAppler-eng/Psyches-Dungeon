extends Node2D

@onready var destroy_timer : Timer = $%DestroyTimer

var shift_dict : Dictionary = {
	"move_up" : "move_left",
	"move_right" : "move_up",
	"move_down" : "move_right",
	"move_left" : "move_down"
}

var unshift_dict : Dictionary = {
	"move_left" : "move_up",
	"move_down" : "move_left",
	"move_right" : "move_down",
	"move_up" : "move_right"
}

func _ready() -> void:
	_shift_controls()

func _on_destroy_timer_timeout() -> void:
	_unshift_controls()
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

func _unshift_controls() -> void:
	var prev_events : Array[InputEvent]
	
	for action : String in unshift_dict.keys():
		if prev_events.is_empty():
			prev_events = InputMap.action_get_events(action)
		
			InputMap.action_erase_events(action)
			
			for event in InputMap.action_get_events(unshift_dict[action]):
				InputMap.action_add_event(action, event)
		else:
			var tmp_events : Array[InputEvent] = InputMap.action_get_events(action)

			InputMap.action_erase_events(action)
			
			for event in prev_events:
				InputMap.action_add_event(action, event)
				
			prev_events = tmp_events
