extends Area2D

var prev_room_area : Area2D

var rooms_to_disable : Array[Area2D]

func _process(delta : float) -> void:
	if rooms_to_disable.is_empty():
		return
	
	for room_area in rooms_to_disable:
		if room_area == prev_room_area:
			continue

		room_area.owner.process_mode = PROCESS_MODE_DISABLED
		rooms_to_disable.erase(room_area)

func _on_room_exited(area : Area2D) -> void:
	GlobalSignalBus.room_exited.emit(area)
	
	get_tree().create_timer(1, false, false, false).timeout.connect(_disable_room.bind(area), CONNECT_ONE_SHOT)
	
func _disable_room(area : Area2D) -> void:	
	rooms_to_disable.append(area)
	
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
