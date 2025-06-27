extends Menu

@export var pause_menu : Menu

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func process_frame(delta : float) -> Menu:
	if Input.is_action_just_pressed("pause"):
		return pause_menu
	
	return null
	
func process_physics(delta : float) -> Menu:
	return null

func process_input(event : InputEvent) -> Menu:
	return null
