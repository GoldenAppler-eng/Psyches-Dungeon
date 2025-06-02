extends Camera2D

func _ready() -> void:
	GlobalSignalBus.room_changed.connect(_on_room_changed)

func _on_room_changed(direction : int, room_area : Node2D) -> void:
	global_position = room_area.global_position
