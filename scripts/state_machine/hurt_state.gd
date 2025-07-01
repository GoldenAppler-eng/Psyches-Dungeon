extends State

@export var invincible_state : State
@export var dead_state : State

@export var health_component : HealthComponent
@export var hurt_timer : Timer

var _hurt : bool = true

func extra_init() -> void:	
	hurt_timer.timeout.connect(_on_hurt_timer_timeout)

func enter() -> void:
	super()
	
	anim_player.play_animation("hit")
	sfx_player.play_sfx("hit")
	
	_hurt = true
	hurt_timer.start()
	
func exit() -> void:
	super()
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	if _hurt:
		return null
	
	if check_dead():
		return dead_state
	
	return invincible_state

func check_dead() -> bool:
	if health_component.current_health == 0:
		return true
		
	return false

func _on_hurt_timer_timeout() -> void:
	_hurt = false
