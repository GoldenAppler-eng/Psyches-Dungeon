extends State

@export var passive_state : State

@export var damager_hitbox : DamagerHitboxComponent
@export var damageable_hitbox : DamageableHitboxComponent

var attack_finished := false

func extra_init() -> void:
	anim_player.animation_finished.connect(_on_animation_finished)

func enter() -> void:
	super()
		
	attack_finished = false
	damager_hitbox.deal_damage_to_area()
	
	sfx_player.play_sfx("attack")
	anim_player.play_animation("attack")
	
func exit() -> void:
	super()
		
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	if attack_finished:
		return passive_state
	
	return null

func _on_animation_finished(anim_name : StringName) -> void:
	if anim_name == "attack":
		attack_finished = true
