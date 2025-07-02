extends OverrideState

@export var damager_hitbox : DamagerHitboxComponent

@export var attack_cooldown_timer : Timer

var attack_ready : bool = true

func extra_init() -> void:
	anim_player.animation_finished.connect(_on_animation_finished)
	attack_cooldown_timer.timeout.connect(_on_attack_cooldown_timer_timeout)

func enter() -> void:
	super()
	
	attack_ready = false
	attack_cooldown_timer.start()
	
	damager_hitbox.deal_damage_to_area()
	
	sfx_player.play_sfx("attack")
	anim_player.play_animation("attack")
	
func exit() -> void:
	super()
	
func process_frame(delta : float) -> State:
	return super(delta)
	
func process_physics(delta : float) -> State:
	return super(delta)

func _on_animation_finished(anim_name : StringName) -> void:
	if anim_name == "attack":
		finished = true

func _on_attack_cooldown_timer_timeout() -> void:
	attack_ready = true

func is_override_triggered() -> bool:
	if attack_ready and controller.get_attack_request():
		override_flag = true
	
	return override_flag
