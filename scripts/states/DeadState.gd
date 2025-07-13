extends State

@export var respawn_state : State

func enter() -> void:
	super()
	
	anim_player.play_animation("death")
	GlobalSignalBus.player_death.emit()
	
func exit() -> void:
	super()
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	return respawn_state
