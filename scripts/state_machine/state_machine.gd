class_name StateMachine
extends Node

@export var initial_state : State
var current_state : State

var override_states : Array[OverrideState] = []

func init(controller : InputController, anim_player : AnimationController, sfx_player : SfxPlayer, movement_controller : MovementController) -> void:
	for state : State in get_children():
		state.init(controller, anim_player, sfx_player, movement_controller) 
		
		if state is OverrideState:
			override_states.append(state)
		
	change_state(initial_state)

func process_frame(delta: float) -> void:
	check_for_override()
	
	var next_state : State = current_state.process_frame(delta)
	
	if next_state:
		change_state(next_state)
	
func process_physics(delta : float) -> void:
	check_for_override()
	
	var next_state : State = current_state.process_physics(delta)
	
	if next_state:
		change_state(next_state)

func change_state(next_state : State) -> void:
	if current_state:
		current_state.exit()
	current_state = next_state
	current_state.enter()

func reset_state_machine() -> void:
	change_state(initial_state)

func check_for_override() -> void:
	var override_state : OverrideState = check_state_override_request()

	if override_state:
		override_state.set_held_state(current_state)
		change_state(override_state)

func check_state_override_request() -> OverrideState:
	var override_state : OverrideState = null
	
	for state : OverrideState in override_states:
		if not state.is_override_triggered():
			continue
		
		if not override_state:
			override_state = state
			continue
		
		if state.override_priority > override_state.override_priority:
			override_state = state
	
	return override_state
