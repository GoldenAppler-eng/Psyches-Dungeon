extends Camera2D

var rooms_entered : Array[Node2D] = []

func _ready() -> void:
	GlobalSignalBus.room_entered.connect(_on_room_entered)	
	GlobalSignalBus.room_exited.connect(_on_room_exited)

func _on_room_entered(room_area : Node2D) -> void:
	rooms_entered.append(room_area)
	
	global_position = rooms_entered.back().global_position
	
func _on_room_exited(room_area : Node2D) -> void:
	rooms_entered.remove_at(rooms_entered.find(room_area))
	
	if rooms_entered.is_empty():
		return
	
	global_position = rooms_entered.back().global_position
