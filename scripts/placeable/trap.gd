class_name Trap
extends RigidBody2D

@export var damager_hitbox_component : DamagerHitboxComponent

@onready var reset_timer : Timer = %ResetTimer
@onready var animated_sprite_2d : AnimatedSprite2D = %AnimatedSprite2D

@onready var activated_sfx : AudioStreamPlayer = %ActivatedSfx

var activated : bool = false

var bodies_entered : int = 0

func _process(delta : float) -> void:
	if not activated:
		return
	
	damager_hitbox_component.deal_damage_to_area()

func _set_activated(activated : bool) -> void:
	self.activated = activated
	animated_sprite_2d.frame = 1 if activated else 0
	
	if activated:
		activated_sfx.play()

func _on_reset_timer_timeout() -> void:
	_set_activated(false)
	
func _on_activation_area_2d_body_entered(body: Node2D) -> void:
	reset_timer.stop()
	bodies_entered += 1
	
	if activated:
		return
		
	_set_activated(true)	
	GlobalSignalBus.trap_activated.emit(body)

func _on_activation_area_2d_body_exited(body: Node2D) -> void:
	bodies_entered -= 1
	
	if bodies_entered == 0:
		reset_timer.start()
