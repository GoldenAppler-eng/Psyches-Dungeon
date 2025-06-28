class_name DamagerHitboxComponent
extends Area2D

@export var damage : int

func deal_damage_to_area() -> void:
	for area in get_overlapping_areas():
		if not (area.owner is Enemy):
			continue
			
		var enemy : Enemy = area.owner as Enemy
		enemy.apply_damage(damage)
