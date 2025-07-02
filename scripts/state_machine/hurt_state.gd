extends State

@export var invincible_state : State
@export var dead_state : State

@export var health_component : HealthComponent
@export var damageable_hitbox_component : DamageableHitboxComponent
@export var hurt_timer : Timer

var _hurt : bool = true
var _knockback_speed : float = 0

func extra_init() -> void:	
	hurt_timer.timeout.connect(_on_hurt_timer_timeout)
	damageable_hitbox_component.took_knockback.connect(_on_take_knockback)

func enter() -> void:
	super()
	
	anim_player.play_animation("hit")
	anim_player.play_animation_overlay("hit")
	sfx_player.play_sfx("hit")
	
	_hurt = true
	hurt_timer.start()
	
func exit() -> void:
	super()
	
	anim_player.clear_all_animation_overlay()
	_knockback_speed = 0
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	if _hurt:
		movement_controller.move()
		
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

func _on_take_knockback(knockback_speed : float) -> void:
	_knockback_speed = knockback_speed
