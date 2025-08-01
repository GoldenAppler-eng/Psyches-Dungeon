extends State

@export var respawn_intermediate_state : State

@export var regeneration_component : RegenerationComponent

var _full_regeneration_flag : bool = false

func enter() -> void:
	super()
	
	_full_regeneration_flag = false
	regeneration_component.start_override_regeneration()
	
func exit() -> void:
	super()
	
	regeneration_component.stop_override_regneration()
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	if _full_regeneration_flag:
		return respawn_intermediate_state
	
	return null

func extra_init() -> void:
	regeneration_component.full_regeneration_finished.connect(_on_fully_regenerated)
	
func _on_fully_regenerated() -> void:
	_full_regeneration_flag = true
