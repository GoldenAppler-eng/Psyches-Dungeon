extends Area2D

var prev_room_area : Area2D

func _on_room_exited(area : Area2D) -> void:
	GlobalSignalBus.room_exited.emit(area)
	
	get_tree().create_timer(5, false, false, false).timeout.connect(_disable_room.bind(area), CONNECT_ONE_SHOT)
	
func _disable_room(area : Area2D) -> void:	
	if area == prev_room_area:
		return
	
	area.owner.process_mode = PROCESS_MODE_DISABLED

func _on_new_room_entered(area : Area2D) -> void:
	GlobalSignalBus.room_entered.emit(area)
	
	if not prev_room_area:
		prev_room_area = area
		return
	
	area.owner.process_mode = PROCESS_MODE_INHERIT
	
	var travel_direction : int = -1
	
	if area.global_position.x > prev_room_area.global_position.x:
		travel_direction = Global.DIRECTION.EAST
	elif area.global_position.x < prev_room_area.global_position.x:
		travel_direction = Global.DIRECTION.WEST
	elif area.global_position.y < prev_room_area.global_position.y:
		travel_direction = Global.DIRECTION.NORTH
	elif area.global_position.y > prev_room_area.global_position.y:
		travel_direction = Global.DIRECTION.SOUTH
	
	prev_room_area = area
	
	GlobalSignalBus.room_changed.emit(travel_direction, area)
