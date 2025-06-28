extends Control

@onready var control_button: SwitchButton = $VBoxContainer/control_button

const RESOLUTION_TEXT_DICT : Dictionary = {
	0 : "1920x1080",
	1 : "1152x648",
	2 : "1280x720"
}

const RESOLUTION_VECTOR2_DICT : Dictionary = {
	0 : Vector2i(1920, 1080),
	1 : Vector2(1152, 648),
	2 : Vector2i(1280, 720)
}

var resolution_mode_index : int = 0
var display_resolution_mode_index : int = resolution_mode_index

func _ready() -> void:
	control_button.button_switched.connect(_on_control_button_switched)
	control_button.button_pressed.connect(_on_control_button_pressed)
	control_button.button_on_focus_exited.connect(_on_control_button_focus_exited)
	
	focus_entered.connect(_on_focus_entered)
	
	_update_control_button_text()
	_set_button_focus_neighbours()

func _on_control_button_switched(value : int) -> void:
	display_resolution_mode_index += value
	display_resolution_mode_index %= RESOLUTION_TEXT_DICT.size()
	
	if display_resolution_mode_index < 0:
		display_resolution_mode_index = RESOLUTION_TEXT_DICT.size() - 1		
	
	_update_control_button_text()

func _on_control_button_pressed() -> void:
	resolution_mode_index = display_resolution_mode_index
	
	DisplayServer.window_set_size(RESOLUTION_VECTOR2_DICT[resolution_mode_index])

func _on_control_button_focus_exited() -> void:
	display_resolution_mode_index = resolution_mode_index
	_update_control_button_text()

func _on_focus_entered() -> void:
	control_button.grab_focus()

func _update_control_button_text() -> void:
	control_button.set_button_text(RESOLUTION_TEXT_DICT[display_resolution_mode_index])

func _set_button_focus_neighbours() -> void:
	control_button.focus_neighbor_bottom = focus_neighbor_bottom
	control_button.focus_neighbor_top = focus_neighbor_top
	control_button.focus_neighbor_left = focus_neighbor_left
	control_button.focus_neighbor_right = focus_neighbor_right
	
	control_button.focus_next = focus_next
	control_button.focus_previous = focus_previous
