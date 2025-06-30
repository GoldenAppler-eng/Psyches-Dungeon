extends State

@export var idle_state : State

@export var damager_hitbox_component : DamagerHitboxComponent

func enter() -> void:
	super()
	
	anim_player.play_animation("run")
	
func exit() -> void:
	super()
	
	movement_controller.stop_movement()
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	if controller.get_movement_axis() == Vector2(0, 0):
		return idle_state
	
	var movement_direction : Vector2 = controller.get_movement_axis()
	movement_controller.move(delta, movement_direction)
	
	if movement_direction.x > 0:
		anim_player.flip_animation_h(true)
		damager_hitbox_component.flip_hitbox_h(true)
	elif movement_direction.x < 0:
		anim_player.flip_animation_h(false)
		damager_hitbox_component.flip_hitbox_h(false)
	
	return null
