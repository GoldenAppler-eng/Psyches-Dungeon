class_name DamageableHitboxComponent
extends Area2D

signal took_damage

@export var health_component : HealthComponent

@export var disable_on_hit : bool = false

var enabled : bool = true

func take_damage(amt : int) -> void:
	if not enabled:
		return
	
	health_component.change_health(-amt)
	took_damage.emit()
	
	if disable_on_hit:
		set_enabled(false)

func set_enabled(enabled : bool) -> void:
	self.enabled = enabled
