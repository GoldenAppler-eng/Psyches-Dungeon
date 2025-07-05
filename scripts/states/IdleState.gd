extends State

@export var move_state : State

func enter() -> void:
	super()
	
	anim_player.play_animation("idle")
	
func exit() -> void:
	super()
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	if not controller.get_movement_axis() == Vector2(0, 0):
		return move_state
	
	return null
