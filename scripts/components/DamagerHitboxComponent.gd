class_name DamagerHitboxComponent
extends Area2D

@export var damage : int

var damager_hitbox_offset : float

func _ready() -> void:
	damager_hitbox_offset = position.x

func flip_hitbox_h(flipped : bool) -> void:
	position.x = -damager_hitbox_offset if flipped else damager_hitbox_offset;

func deal_damage_to_area() -> void:
	for area in get_overlapping_areas():
		if not (area is DamageableHitboxComponent):
			continue
			
		var damageable_hitbox : DamageableHitboxComponent = area as DamageableHitboxComponent
		damageable_hitbox.take_damage(damage)
