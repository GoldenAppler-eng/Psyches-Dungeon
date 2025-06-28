class_name SwitchButton
extends Control

signal button_switched(value : int)

@export var button_text : String

@onready var button: Button = $HBoxContainer/Button

func _ready() -> void:
	button.text = button_text
	
	focus_entered.connect(_on_focus_entered)
	_set_button_focus_neighbours()
	
func _process(delta: float) -> void:
	if not button.has_focus():
		return
	
	if Input.is_action_just_pressed("option_left"):
		button_switched.emit(-1)
	elif Input.is_action_just_pressed("option_right"):
		button_switched.emit(1)	

func set_button_text(text : String) -> void:
	button_text = text
	button.text = button_text
	
func _set_button_focus_neighbours() -> void:
	button.focus_neighbor_bottom = focus_neighbor_bottom
	button.focus_neighbor_top = focus_neighbor_top
	button.focus_neighbor_left = focus_neighbor_left
	button.focus_neighbor_right = focus_neighbor_right
	
	button.focus_next = focus_next
	button.focus_previous = focus_previous

func _on_focus_entered() -> void:
	button.grab_focus()
	
