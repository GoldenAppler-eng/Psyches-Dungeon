extends State

@export var living_state : State
@export var invincibility_timer : Timer

@export var movement_state_machine : StateMachine
@export var attack_state_machine : StateMachine

var _invincible_flag : bool = false

func extra_init() -> void:
	invincibility_timer.timeout.connect(_on_invincibility_timer_timeout)

func enter() -> void:
	super()
	
	_invincible_flag = true
	invincibility_timer.start()
	
func exit() -> void:
	super()
	
func process_frame(delta : float) -> State:
	movement_state_machine.process_frame(delta)
	attack_state_machine.process_frame(delta)	
	
	return null
	
func process_physics(delta : float) -> State:
	movement_state_machine.process_physics(delta)
	attack_state_machine.process_physics(delta)	
	
	if not _invincible_flag:
		return living_state
	
	return null

func _on_invincibility_timer_timeout() -> void:
	_invincible_flag = false
