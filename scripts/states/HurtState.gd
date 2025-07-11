extends State

@export var invincible_state : State
@export var dead_state : State

@export var health_component : HealthComponent
@export var damageable_hitbox_component : DamageableHitboxComponent
@export var hurt_timer : Timer

@export var knockback_decay_curve : Curve

var _hurt : bool = true

var _knockback_speed : float = 0
var _knockback_direction : Vector2 = Vector2(0, 0)

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
	_knockback_direction = Vector2(0, 0)
	
	movement_controller.stop_movement()
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	if _hurt:
		var curve_sample : float = (hurt_timer.wait_time - hurt_timer.time_left) / hurt_timer.wait_time
		var knockback_speed_modifier : float = 1 - knockback_decay_curve.sample(curve_sample)
		movement_controller.move_with_custom_speed(delta, _knockback_speed * knockback_speed_modifier, _knockback_direction)
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

func _on_take_knockback(knockback_speed : float, incoming_direction : Vector2) -> void:
	_knockback_speed = knockback_speed
	_knockback_direction = incoming_direction
