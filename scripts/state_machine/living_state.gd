extends State

@export var hurt_state : State

@export var damageable_hitbox_component : DamageableHitboxComponent

@export var movement_state_machine : StateMachine
@export var attack_state_machine : StateMachine

var _hurt_flag : bool = false

func extra_init() -> void:
	movement_state_machine.init(controller, anim_player, sfx_player, movement_controller)
	attack_state_machine.init(controller, anim_player, sfx_player, movement_controller)

	damageable_hitbox_component.took_damage.connect(_on_take_damage)

func enter() -> void:
	super()
	
	_hurt_flag = false
	damageable_hitbox_component.set_enabled(true)
	
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
	
	if _hurt_flag:
		return hurt_state
	
	return null

func _on_take_damage() -> void:
	_hurt_flag = true
