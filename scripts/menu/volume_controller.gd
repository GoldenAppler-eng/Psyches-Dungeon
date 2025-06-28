@tool
extends Control

@export_enum("Master", "Music", "Sfx") var bus_name : String

@onready var volume_label: Label = $VBoxContainer/volume_label
@onready var control_button: SwitchButton = $VBoxContainer/control_button

const MAX_VOLUME_VALUE : int = 100
var volume_value : int = MAX_VOLUME_VALUE

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	control_button.button_switched_pressed.connect(_on_volume_control_button_switched)

	volume_label.text = bus_name + " Volume"

	volume_value = 100 * db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_name)))
	_update_volume_control_button_text()
	
	_set_button_focus_neighbours()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():		
		volume_label.text = bus_name + " Volume"

func _on_focus_entered() -> void:
	control_button.grab_focus()

func _on_volume_control_button_switched(value : int) -> void:
	volume_value += value
	volume_value %= MAX_VOLUME_VALUE + 1
			
	if volume_value < 0:
		volume_value = MAX_VOLUME_VALUE
	
	var index : int = AudioServer.get_bus_index(bus_name)
	var percentage_volume_value : float = volume_value / 100.0
	
	AudioServer.set_bus_volume_db(index, linear_to_db(percentage_volume_value))
	_update_volume_control_button_text()
	
func _update_volume_control_button_text() -> void:
	control_button.set_button_text(str(volume_value))

func _set_button_focus_neighbours() -> void:
	control_button.focus_neighbor_bottom = focus_neighbor_bottom
	control_button.focus_neighbor_top = focus_neighbor_top
	control_button.focus_neighbor_left = focus_neighbor_left
	control_button.focus_neighbor_right = focus_neighbor_right
	
	control_button.focus_next = focus_next
	control_button.focus_previous = focus_previous
