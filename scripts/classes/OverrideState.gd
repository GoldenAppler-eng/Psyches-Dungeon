class_name OverrideState
extends State

@export var override_priority : int = 0

var held_state : State

var finished := false
var override_flag := false

func enter() -> void:
	super()
	
	finished = false
	override_flag = false
	
func exit() -> void:
	super()
		
func process_frame(delta : float) -> State:
	if finished:
		return held_state
	
	return null
	
func process_physics(delta : float) -> State:
	if finished:
		return held_state
	
	return null

func set_held_state(state : State) -> void:
	held_state = state

func is_override_triggered() -> bool:
	return override_flag
