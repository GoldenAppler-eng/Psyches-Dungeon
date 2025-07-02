class_name DamageableHitboxComponent
extends Area2D

signal took_damage
signal took_knockback(knockback_speed : float)

@export var health_component : HealthComponent

@export var disable_on_hit : bool = false

@export var can_take_knockback : bool = false
@export var knockback_resistance : float = 0

var enabled : bool = true

func take_damage(amt : int) -> void:
	if not enabled:
		return
	
	health_component.change_health(-amt)
	took_damage.emit()
	
	if disable_on_hit:
		set_enabled(false)

func take_knockback(knockback_speed : float) -> void:
	if can_take_knockback:
		took_knockback.emit(knockback_speed / (knockback_resistance + 1))

func set_enabled(enabled : bool) -> void:
	self.enabled = enabled
