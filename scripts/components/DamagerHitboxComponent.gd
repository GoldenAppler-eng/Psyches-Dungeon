class_name DamagerHitboxComponent
extends Area2D

@export var damage : int

func apply_damage() -> void:
	for area in get_overlapping_areas():
		if area.owner is Enemy:
			var enemy : Enemy = area.owner as Enemy
			enemy.apply_damage(damage)
