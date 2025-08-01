extends UIController

@onready var control_button: SwitchButton = $VBoxContainer/control_button

const WINDOW_MODE_INDEX : Dictionary = {
	0 : "Fullscreen",
	1 : "Windowed",
	2 : "Windowed(No B.)"
}

var window_mode_index : int = 0
var display_window_mode_index : int = window_mode_index

func _ready() -> void:
	control_button.button_switched.connect(_on_control_button_switched)
	control_button.button_pressed.connect(_on_control_button_pressed)
	control_button.button_on_focus_exited.connect(_on_control_button_focus_exited)
	
	focus_entered.connect(_on_focus_entered)
	
	_update_control_button_text()
	_set_button_focus_neighbours(control_button)
	control_button.init()

func _on_control_button_switched(value : int) -> void:
	display_window_mode_index += value
	display_window_mode_index %= WINDOW_MODE_INDEX.size()
	
	if display_window_mode_index < 0:
		display_window_mode_index = WINDOW_MODE_INDEX.size() - 1
	
	_update_control_button_text()

func _on_control_button_pressed() -> void:
	window_mode_index = display_window_mode_index
	
	match window_mode_index:
		0 : 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		1 : 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2 : 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

	
func _on_control_button_focus_exited() -> void:
	display_window_mode_index = window_mode_index
	_update_control_button_text()

func _on_focus_entered() -> void:
	control_button.grab_focus()

func _update_control_button_text() -> void:
	control_button.set_button_text(WINDOW_MODE_INDEX[display_window_mode_index])
