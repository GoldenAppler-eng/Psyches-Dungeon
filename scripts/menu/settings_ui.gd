class_name SettingsUI
extends Control

@onready var container : VBoxContainer = %container

@onready var resolution_controller: MarginContainer = $MarginContainer/container/resolution_controller

@onready var window_mode_button : Button = %window_mode_button
@onready var window_mode_selector : Button = %window_mode_selector

const WINDOW_MODE_INDEX : Dictionary = {
	0 : "Fullscreen",
	1 : "Windowed",
	2 : "Windowed Borderless"
}

const WINDOW_MODE_DICT : Dictionary = {
	"Fullscreen" : 0,
	"Windowed" : 1,
	"Windowed(Borderless)" : 2
}

var window_mode_index : int = 0

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	
	var str : String = WINDOW_MODE_INDEX[window_mode_index]
	window_mode_selector.text = _get_arrowed_text(str)

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("option_right"):	
		if window_mode_selector.has_focus():
			window_mode_index += 1
			window_mode_index %= WINDOW_MODE_DICT.size()
			
			var str : String = WINDOW_MODE_INDEX[window_mode_index]
			window_mode_selector.text = _get_arrowed_text(str)
	
	if Input.is_action_just_pressed("option_left"):				
		if window_mode_selector.has_focus():
			window_mode_index -= 1
			window_mode_index %= WINDOW_MODE_DICT.size()
			
			if window_mode_index < 0:
				window_mode_index = WINDOW_MODE_DICT.size() - 1
			
			var str : String = WINDOW_MODE_INDEX[window_mode_index]
			window_mode_selector.text = _get_arrowed_text(str)

func _on_focus_entered() -> void:
	resolution_controller.grab_focus()

func _get_arrowed_text(str : String) -> String:
	var aug_str : String = "< "
	
	aug_str += str
	
	aug_str += " >"
	
	return aug_str

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
