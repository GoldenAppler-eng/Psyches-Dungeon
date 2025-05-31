extends StaticBody2D

func _on_area_2d_player_entered(body : Node2D) -> void:
	GlobalSignalBus.coin_collected.emit()
	queue_free()
