extends StaticBody2D

func _on_area_2d_player_entered(body) -> void:
	if body is Player:
		GlobalSignalBus.coin_collected.emit()
		queue_free()
