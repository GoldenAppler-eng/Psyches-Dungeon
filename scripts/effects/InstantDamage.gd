extends Node

func _init() -> void:
	var player_damagable_hitbox : DamageableHitboxComponent = Global.global_player.find_child("DamageableHitbox") as DamageableHitboxComponent
	player_damagable_hitbox.take_damage(1)
	
	queue_free.call_deferred()
