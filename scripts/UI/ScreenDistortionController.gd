extends UIController

@onready var control_button: SwitchButton = $VBoxContainer/control_button

var distortion_enabled : bool = true
var display_distortion_enabled : bool = distortion_enabled

func _ready() -> void:
	control_button.button_switched.connect(_on_control_button_switched)
	control_button.button_pressed.connect(_on_control_button_pressed)
	control_button.button_on_focus_exited.connect(_on_control_button_focus_exited)
	
	focus_entered.connect(_on_focus_entered)
	
	_update_control_button_text()
	_set_button_focus_neighbours(control_button)
	control_button.init()

func _on_control_button_switched(value : int) -> void:
	display_distortion_enabled = not display_distortion_enabled	
	
	_update_control_button_text()

func _on_control_button_pressed() -> void:
	distortion_enabled = display_distortion_enabled
	
	Global.screen_distortion_enabled = distortion_enabled

func _on_control_button_focus_exited() -> void:
	display_distortion_enabled = distortion_enabled
	_update_control_button_text()

func _on_focus_entered() -> void:
	control_button.grab_focus()

func _update_control_button_text() -> void:
	control_button.set_button_text("ON" if display_distortion_enabled else "OFF")
