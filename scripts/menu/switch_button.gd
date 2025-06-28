@tool
class_name SwitchButton
extends Control

signal button_switched(value : int)
signal button_switched_pressed(value : int)
signal button_pressed

signal button_on_focus_exited

@export var button_text : String
@export var button_minimum_length : float

@onready var button: Button = $HBoxContainer/Button

func _ready() -> void:
	button.text = button_text
	button.custom_minimum_size.x = button_minimum_length
	
	focus_entered.connect(_on_focus_entered)
	
	button.pressed.connect(_on_button_pressed)
	button.focus_exited.connect(_on_button_focus_exited)
		
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		button.text = button_text
		button_minimum_length = button.size.x

		return
	
	if not button.has_focus():
		return
	
	if Input.is_action_just_pressed("option_left"):
		button_switched.emit(-1)
	elif Input.is_action_just_pressed("option_right"):
		button_switched.emit(1)	

	if Input.is_action_pressed("option_left"):
		button_switched_pressed.emit(-1)
	elif Input.is_action_pressed("option_right"):
		button_switched_pressed.emit(1)	

func init() -> void:
	_set_button_focus_neighbours()

func set_button_text(text : String) -> void:
	button_text = text
	button.text = button_text
	
func _set_button_focus_neighbours() -> void:
	button.focus_neighbor_bottom = _get_button_path_to_neighbour(focus_neighbor_bottom)
	button.focus_neighbor_top = _get_button_path_to_neighbour(focus_neighbor_top)
	button.focus_neighbor_left = _get_button_path_to_neighbour(focus_neighbor_left)
	button.focus_neighbor_right = _get_button_path_to_neighbour(focus_neighbor_right)
	
	button.focus_next = _get_button_path_to_neighbour(focus_next)
	button.focus_previous = _get_button_path_to_neighbour(focus_previous)
	
func _get_button_path_to_neighbour(neighbour : NodePath) -> NodePath:
	var neighbour_node : Control = get_node_or_null(neighbour)
	
	if neighbour_node:
		return button.get_path_to(neighbour_node)

	return button.get_path_to(button)

func _on_focus_entered() -> void:
	button.grab_focus()
	
func _on_button_pressed() -> void:
	button_pressed.emit()

func _on_button_focus_exited() -> void:
	button_on_focus_exited.emit()
