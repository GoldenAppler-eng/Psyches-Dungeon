class_name DamagerHitboxComponent
extends Area2D

@export var damage : int
@export var knockback_speed : float

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
		damageable_hitbox.take_knockback(knockback_speed, (damageable_hitbox.global_position - global_position).normalized())

func deal_damage_to_area_owner() -> void:
	for area in get_overlapping_areas():
		var damageable_hitbox : DamageableHitboxComponent = area.owner.find_child("DamageableHitbox") as DamageableHitboxComponent
		
		if not damageable_hitbox:
			continue
		
		damageable_hitbox.take_damage(damage)
		damageable_hitbox.take_knockback(knockback_speed, (damageable_hitbox.global_position - global_position).normalized())
