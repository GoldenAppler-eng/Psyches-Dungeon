class_name StateMachine
extends Node

@export var initial_state : State
var current_state : State

func init(controller : InputController, anim_player : AnimationController, sfx_player : SfxPlayer, movement_controller : MovementController) -> void:
	for state : State in get_children():
		state.init(controller, anim_player, sfx_player, movement_controller) 
	
	change_state(initial_state)

func process_frame(delta: float) -> void:
	var next_state : State = current_state.process_frame(delta)
	
	if next_state:
		change_state(next_state)
	
func process_physics(delta : float) -> void:
	var next_state : State = current_state.process_physics(delta)
	
	if next_state:
		change_state(next_state)

func change_state(next_state : State) -> void:
	if current_state:
		current_state.exit()
	current_state = next_state
	current_state.enter()
	
