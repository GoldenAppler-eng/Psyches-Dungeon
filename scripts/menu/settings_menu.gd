class_name SettingsMenu
extends Control

@export var main_scene : Node2D

@onready var container : VBoxContainer = %container

@onready var resolution_button : Button = %resolution_button
@onready var resolution_selector : Button = %resolution_selector

@onready var window_mode_button : Button = %window_mode_button
@onready var window_mode_selector : Button = %window_mode_selector

@onready var master_volume_button : Button = %master_volume_button
@onready var master_volume_selector : Button = %master_volume_selector

@onready var music_volume_button : Button = %music_volume_button
@onready var music_volume_selector : Button = %music_volume_selector

@onready var sfx_volume_button : Button = %sfx_volume_button
@onready var sfx_volume_selector : Button = %sfx_volume_selector

var paused := false

signal ui_switch

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

var master_volume_value : int = 100
var music_volume_value : int = 100
var sfx_volume_value : int = 100

func _ready() -> void:
	var str : String = RESOLUTION_INDEX[resolution_mode_index]
	resolution_selector.text = _get_arrowed_text(str)
	
	str = WINDOW_MODE_INDEX[window_mode_index]
	window_mode_selector.text = _get_arrowed_text(str)
	
	master_volume_value = 100 * db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	music_volume_value = 100 * db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sfx_volume_value = 100 * db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sfx")))

func _process(delta : float) -> void:
	master_volume_selector.text = _get_arrowed_text(str(master_volume_value))
	music_volume_selector.text = _get_arrowed_text(str(music_volume_value))
	sfx_volume_selector.text = _get_arrowed_text(str(sfx_volume_value))
	
	if Input.is_action_just_pressed("option_left") or Input.is_action_just_pressed("option_right"):
		ui_switch.emit()
	
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

	if Input.is_action_pressed("option_right"):
		if master_volume_selector.has_focus():
			master_volume_value += 1
			master_volume_value %= 100
			
			if master_volume_value < 0:
				master_volume_value = 100
				
		if music_volume_selector.has_focus():
			music_volume_value += 1
			music_volume_value %= 100
			
			if music_volume_value < 0:
				music_volume_value = 100
				
		if sfx_volume_selector.has_focus():
			sfx_volume_value += 1
			sfx_volume_value %= 100
			
			if sfx_volume_value < 0:
				sfx_volume_value = 100
				
	if Input.is_action_pressed("option_left"):
		if master_volume_selector.has_focus():
			master_volume_value -= 1
			master_volume_value %= 100
			
			if master_volume_value < 0:
				master_volume_value = 100
				
		if music_volume_selector.has_focus():
			music_volume_value -= 1
			music_volume_value %= 100
			
			if music_volume_value < 0:
				music_volume_value = 100
				
		if sfx_volume_selector.has_focus():
			sfx_volume_value -= 1
			sfx_volume_value %= 100
			
			if sfx_volume_value < 0:
				sfx_volume_value = 100



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

func _on_master_volume_button_pressed() -> void:
	master_volume_selector.grab_focus()

func _on_master_volume_selector_pressed() -> void:
	var index : int = AudioServer.get_bus_index("Master")
	var value : float = master_volume_value / 100.0
	
	AudioServer.set_bus_volume_db(index, linear_to_db(value))

func _on_music_volume_button_pressed() -> void:
	music_volume_selector.grab_focus()

func _on_music_volume_selector_pressed() -> void:
	var index : int = AudioServer.get_bus_index("Music")
	var value : float = music_volume_value / 100.0
	
	AudioServer.set_bus_volume_db(index, linear_to_db(value))

func _on_sfx_volume_button_pressed() -> void:
	sfx_volume_selector.grab_focus()

func _on_sfx_volume_selector_pressed() -> void:
	var index : int = AudioServer.get_bus_index("Sfx")
	var value : float = sfx_volume_value / 100.0
	
	AudioServer.set_bus_volume_db(index, linear_to_db(value))

func _on_master_volume_selector_focus_exited() -> void:
	var index : int = AudioServer.get_bus_index("Master")
	var value : float = db_to_linear(AudioServer.get_bus_volume_db(index))
	
	master_volume_value = value * 100

func _on_music_volume_selector_focus_exited() -> void:
	var index : int = AudioServer.get_bus_index("Music")
	var value : float = db_to_linear(AudioServer.get_bus_volume_db(index))
	
	music_volume_value = value * 100

func _on_sfx_volume_selector_focus_exited() -> void:
	var index : int = AudioServer.get_bus_index("Sfx")
	var value : float = db_to_linear(AudioServer.get_bus_volume_db(index))
	
	sfx_volume_value = value * 100
