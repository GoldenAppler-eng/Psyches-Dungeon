extends State

@export var living_state : State
@export var invincibility_timer : Timer

@export var sub_state_machines : Array[StateMachine]

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
	_process_sub_state_machines_frame(delta)
	
	return null
	
func process_physics(delta : float) -> State:
	_process_sub_state_machines_physics(delta)
	
	if not _invincible_flag:
		return living_state
	
	return null

func _on_invincibility_timer_timeout() -> void:
	_invincible_flag = false

func _reset_sub_state_machines() -> void:
	for state_machine in sub_state_machines:
		state_machine.reset_state_machine()
	
func _process_sub_state_machines_frame(delta : float) -> void:
	for state_machine in sub_state_machines:
		state_machine.process_frame(delta)	
	
func _process_sub_state_machines_physics(delta : float) -> void:
	for state_machine in sub_state_machines:
		state_machine.process_physics(delta)
