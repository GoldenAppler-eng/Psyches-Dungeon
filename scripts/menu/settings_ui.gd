class_name SettingsUI
extends Control

@onready var container : VBoxContainer = %container

@onready var resolution_button : Button = %resolution_button
@onready var resolution_selector : Button = %resolution_selector

@onready var window_mode_button : Button = %window_mode_button
@onready var window_mode_selector : Button = %window_mode_selector

const WINDOW_MODE_INDEX : Dictionary = {
	0 : "Fullscreen",
	1 : "Windowed",
	2 : "Windowed Borderless"
}

const RESOLUTION_INDEX : Dictionary = {
	0 : "1920x1080",
	1 : "1152x648",
	2 : "1280x720"
}

const WINDOW_MODE_DICT : Dictionary = {
	"Fullscreen" : 0,
	"Windowed" : 1,
	"Windowed(Borderless)" : 2
}

const RESOLUTION_DICT : Dictionary = {
	"1920x1080" : Vector2i(1920, 1080),
	"1152x648" : Vector2(1152, 648),
	"1280x720" : Vector2i(1280, 720)
}

var window_mode_index : int = 0
var resolution_mode_index : int = 0

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	
	var str : String = RESOLUTION_INDEX[resolution_mode_index]
	resolution_selector.text = _get_arrowed_text(str)
	
	str = WINDOW_MODE_INDEX[window_mode_index]
	window_mode_selector.text = _get_arrowed_text(str)

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("option_right"):	
		if resolution_selector.has_focus():
			resolution_mode_index += 1
			resolution_mode_index %= RESOLUTION_DICT.size()
			
			var str : String = RESOLUTION_INDEX[resolution_mode_index]
			resolution_selector.text = _get_arrowed_text(str)
		
		if window_mode_selector.has_focus():
			window_mode_index += 1
			window_mode_index %= WINDOW_MODE_DICT.size()
			
			var str : String = WINDOW_MODE_INDEX[window_mode_index]
			window_mode_selector.text = _get_arrowed_text(str)
	
	if Input.is_action_just_pressed("option_left"):	
		if resolution_selector.has_focus():
			resolution_mode_index -= 1
			resolution_mode_index %= RESOLUTION_DICT.size()
			
			if resolution_mode_index < 0:
				resolution_mode_index = RESOLUTION_DICT.size() - 1
			
			var str : String = RESOLUTION_INDEX[resolution_mode_index]
			resolution_selector.text = _get_arrowed_text(str)
			
		if window_mode_selector.has_focus():
			window_mode_index -= 1
			window_mode_index %= WINDOW_MODE_DICT.size()
			
			if window_mode_index < 0:
				window_mode_index = WINDOW_MODE_DICT.size() - 1
			
			var str : String = WINDOW_MODE_INDEX[window_mode_index]
			window_mode_selector.text = _get_arrowed_text(str)

func _on_focus_entered() -> void:
	resolution_button.grab_focus()

func _get_arrowed_text(str : String) -> String:
	var aug_str : String = "< "
	
	aug_str += str
	
	aug_str += " >"
	
	return aug_str

func _on_resolution_button_pressed() -> void:
	resolution_selector.grab_focus()

func _on_resolution_selector_pressed() -> void:	
	DisplayServer.window_set_size(RESOLUTION_DICT[RESOLUTION_INDEX[resolution_mode_index]])
	
func _on_window_mode_button_pressed() -> void:
	window_mode_selector.grab_focus()

func _on_window_mode_selector_pressed() -> void:
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
