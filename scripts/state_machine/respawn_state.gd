extends State

@export var living_state : State

@export var regeneration_component : RegenerationComponent

func enter() -> void:
	super()
	
	regeneration_component.start_regeneration()
	
func exit() -> void:
	super()
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	return null
