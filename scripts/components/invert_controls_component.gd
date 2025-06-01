extends Node2D

@onready var destroy_timer : Timer = $%DestroyTimer

var invert_dict : Dictionary = {
	"move_up" : "move_down",
	"move_left" : "move_right"
}

func _ready() -> void:
	_invert_controls()

func _on_destroy_timer_timeout() -> void:
	_invert_controls()
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
