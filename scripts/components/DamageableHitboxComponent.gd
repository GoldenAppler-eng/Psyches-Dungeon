class_name DamageableHitboxComponent
extends Area2D

signal took_damage
signal took_knockback(knockback_speed : float, incoming_direction : Vector2)

@export var health_component : HealthComponent

@export var disable_on_hit : bool = false

@export var can_take_knockback : bool = false
@export var knockback_resistance : float = 0

var _enabled : bool = true

func reset_hitbox() -> void:
	set_enabled(true)

func take_damage(amt : int) -> void:
	if not _enabled:
		return
	
	health_component.change_health(-amt)
	took_damage.emit()
	
	if disable_on_hit:
		set_enabled(false)

func take_knockback(knockback_speed : float, incoming_direction : Vector2) -> void:
	if can_take_knockback:
		took_knockback.emit(knockback_speed / (knockback_resistance + 1), incoming_direction)

func set_enabled(enabled : bool) -> void:
	_enabled = enabled
