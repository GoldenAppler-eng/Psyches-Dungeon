extends State

@export var hurt_state : State

@export var damageable_hitbox_component : DamageableHitboxComponent

@export var sub_state_machines : Array[StateMachine]

var _hurt_flag : bool = false

func extra_init() -> void:
	damageable_hitbox_component.took_damage.connect(_on_take_damage)

func enter() -> void:
	super()
	
	_hurt_flag = false
	damageable_hitbox_component.set_enabled(true)
	
func exit() -> void:
	super()
		
	_reset_sub_state_machines()
	
func process_frame(delta : float) -> State:
	_process_sub_state_machines_frame(delta)
	
	return null
	
func process_physics(delta : float) -> State:
	_process_sub_state_machines_physics(delta)
	
	if _hurt_flag:
		return hurt_state
	
	return null

func _on_take_damage() -> void:
	_hurt_flag = true

func _reset_sub_state_machines() -> void:
	for state_machine in sub_state_machines:
		state_machine.reset_state_machine()
	
func _process_sub_state_machines_frame(delta : float) -> void:
	for state_machine in sub_state_machines:
		state_machine.process_frame(delta)	
	
func _process_sub_state_machines_physics(delta : float) -> void:
	for state_machine in sub_state_machines:
		state_machine.process_physics(delta)
