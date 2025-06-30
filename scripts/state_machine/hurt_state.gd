extends State

@export var living_state : State
@export var dead_state : State

@export var health_component : HealthComponent
@export var invincibility_timer : Timer

var _invincible : bool = true

func extra_init() -> void:	
	invincibility_timer.timeout.connect(_on_invincibility_timer_timeout)

func enter() -> void:
	super()
	
	anim_player.play_animation("hit")
	sfx_player.play_sfx("hit")
	
	_invincible = true
	invincibility_timer.start()
	
func exit() -> void:
	super()
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	if _invincible:
		return null
	
	if check_dead():
		return dead_state
	
	return living_state

func check_dead() -> bool:
	if health_component.current_health == 0:
		return true
		
	return false

func _on_invincibility_timer_timeout() -> void:
	_invincible = false
