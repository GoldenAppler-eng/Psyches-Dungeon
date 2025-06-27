extends Menu

@export var idle_menu : Menu

@export var settings_ui : SettingsUI

func enter() -> void:
	super()
	
	settings_ui.visible = true
	settings_ui.process_mode = PROCESS_MODE_INHERIT
	settings_ui.custom_grab_focus()
	
	game_node.process_mode = PROCESS_MODE_DISABLED
	
	GlobalCardTimer.process_mode = PROCESS_MODE_DISABLED
	
func exit() -> void:
	super()
	
	settings_ui.visible = false
	settings_ui.process_mode = PROCESS_MODE_DISABLED
	
	game_node.process_mode = PROCESS_MODE_INHERIT
	
	GlobalCardTimer.process_mode = PROCESS_MODE_INHERIT		

func process_frame(delta : float) -> Menu:
	if Input.is_action_just_pressed("pause"):
		return idle_menu
	
	return null
	
func process_physics(delta : float) -> Menu:
	return null

func process_input(event : InputEvent) -> Menu:
	return null
