extends RigidBody2D

@onready var pickup_sfx : AudioStreamPlayer = $PickupSfx
@onready var pickup_area : Area2D = $PickupArea

func _on_area_2d_player_entered(body : Node2D) -> void:
	GlobalSignalBus.coin_collected.emit()
	
	pickup_sfx.play()
	visible = false
	pickup_area.monitoring = false

func _on_pickup_sfx_finished() -> void:
	queue_free()
