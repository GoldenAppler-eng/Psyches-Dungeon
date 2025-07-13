class_name Trap
extends RigidBody2D

@export var damager_hitbox_component : DamagerHitboxComponent

@onready var reset_timer : Timer = %ResetTimer
@onready var activate_buffer_timer: Timer = %ActivateBufferTimer
@onready var animated_sprite_2d : AnimatedSprite2D = %AnimatedSprite2D

@onready var activated_sfx : AudioStreamPlayer = %ActivatedSfx

var _activated : bool = false
var _is_activating : bool = false

var bodies_entered : int = 0

func _process(delta : float) -> void:
	if not _activated:
		return
	
	damager_hitbox_component.deal_damage_to_area()

func _set_activated(activated : bool) -> void:
	_activated = activated
	animated_sprite_2d.frame = 2 if activated else 0
	
	if activated:
		activated_sfx.play()

func _on_reset_timer_timeout() -> void:
	_set_activated(false)
	
func _on_activation_area_2d_body_entered(body: Node2D) -> void:
	reset_timer.stop()
	bodies_entered += 1
	
	if _activated:
		return
	
	start_activation_process()
	GlobalSignalBus.trap_activated.emit(body)

func start_activation_process() -> void:
	activate_buffer_timer.start()
	_is_activating = true
	
	animated_sprite_2d.frame = 1

func _on_activation_area_2d_body_exited(body: Node2D) -> void:
	bodies_entered -= 1
	
	if bodies_entered == 0:
		reset_timer.start()

func _on_activate_buffer_timer_timeout() -> void:
	_set_activated(true)	
	_is_activating = false
