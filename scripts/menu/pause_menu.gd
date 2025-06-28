extends Menu

@export var idle_menu : Menu

@export var settings_ui : SettingsUI

func enter() -> void:
	super()
	
	_set_settings_enabled(true)
	set_game_paused(true)	
	
func exit() -> void:
	super()
	
	_set_settings_enabled(false)
	set_game_paused(false)

func process_frame(delta : float) -> Menu:
	if Input.is_action_just_pressed("pause"):
		return idle_menu
	
	return null
	
func process_physics(delta : float) -> Menu:
	return null

func process_input(event : InputEvent) -> Menu:
	return null

func _set_settings_enabled(enabled : bool) -> void:
	settings_ui.visible = enabled
	settings_ui.process_mode = PROCESS_MODE_INHERIT if enabled else PROCESS_MODE_DISABLED
	
	if enabled:
		settings_ui.grab_focus()
