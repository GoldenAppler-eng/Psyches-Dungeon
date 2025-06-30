class_name DamageableHitboxComponent
extends Area2D

@export var health_component : HealthComponent

func take_damage(amt : int) -> void:
	health_component.change_health(-amt)
