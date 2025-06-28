extends State

@export var idle_state : State

func enter() -> void:
	super()
	
func exit() -> void:
	super()
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	if controller.get_movement_axis() == Vector2(0, 0):
		return idle_state
	
	return null
