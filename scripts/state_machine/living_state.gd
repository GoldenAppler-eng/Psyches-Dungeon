extends State

@export var hurt_state : State

@export var movement_state_machine : StateMachine
@export var attack_state_machine : StateMachine

func enter() -> void:
	super()
	
func exit() -> void:
	super()
	
	movement_state_machine.reset_state_machine()
	attack_state_machine.reset_state_machine()
	
func process_frame(delta : float) -> State:
	movement_state_machine.process_frame(delta)
	attack_state_machine.process_frame(delta)	
	
	return null
	
func process_physics(delta : float) -> State:
	movement_state_machine.process_physics(delta)
	attack_state_machine.process_physics(delta)	
	
	return null
