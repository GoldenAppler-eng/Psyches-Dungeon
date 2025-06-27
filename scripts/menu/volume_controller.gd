extends Control

@export var control_button : Button

@export_enum("Master", "Music", "Sfx") var bus_name : String

var volume_value : int = 100

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	
	control_button.pressed.connect(_on_volume_control_button_pressed)

func _on_focus_entered() -> void:
	control_button.grab_focus()

func _on_volume_control_button_pressed() -> void:
	var index : int = AudioServer.get_bus_index(bus_name)
	var value : float = volume_value / 100.0
	
	AudioServer.set_bus_volume_db(index, linear_to_db(value))
