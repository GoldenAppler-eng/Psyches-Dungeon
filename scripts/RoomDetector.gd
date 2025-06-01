extends Area2D

func _on_new_room_entered(area : Area2D) -> void:
	GlobalSignalBus.room_changed.emit(0, area)
