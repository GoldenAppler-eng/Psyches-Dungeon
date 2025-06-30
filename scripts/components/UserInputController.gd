extends InputController

func get_movement_axis() -> Vector2:
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	var vertical_direction := Input.get_axis("move_up", "move_down");
	
	return Vector2(horizontal_direction, vertical_direction)
	
func get_attack_request() -> bool:
	return Input.is_action_just_pressed("attack")
