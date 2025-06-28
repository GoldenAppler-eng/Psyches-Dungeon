extends Control

@onready var control_button: SwitchButton = $control_button

@export_enum("Master", "Music", "Sfx") var bus_name : String

const MAX_VOLUME_VALUE : int = 100
var volume_value : int = MAX_VOLUME_VALUE

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	
	control_button.button_switched.connect(_on_volume_control_button_switched)

	volume_value = 100 * db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_name)))
	_update_volume_control_button_text()

func _on_focus_entered() -> void:
	control_button.grab_focus()

func _on_volume_control_button_switched(value : int) -> void:
	volume_value += value
	volume_value %= MAX_VOLUME_VALUE
			
	if volume_value < 0:
		volume_value = MAX_VOLUME_VALUE
	
	var index : int = AudioServer.get_bus_index(bus_name)
	var percentage_volume_value : float = volume_value / 100.0
	
	AudioServer.set_bus_volume_db(index, linear_to_db(percentage_volume_value))
	_update_volume_control_button_text()
	
func _update_volume_control_button_text() -> void:
	control_button.set_button_text(str(volume_value))
