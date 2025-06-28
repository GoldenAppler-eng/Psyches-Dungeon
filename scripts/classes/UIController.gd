class_name UIController
extends Control

func _set_button_focus_neighbours(control_button : Control) -> void:
	control_button.focus_neighbor_bottom = _get_button_path_to_neighbour(control_button, focus_neighbor_bottom)
	control_button.focus_neighbor_top = _get_button_path_to_neighbour(control_button, focus_neighbor_top)
	control_button.focus_neighbor_left = _get_button_path_to_neighbour(control_button, focus_neighbor_left)
	control_button.focus_neighbor_right = _get_button_path_to_neighbour(control_button, focus_neighbor_right)
	
	control_button.focus_next = _get_button_path_to_neighbour(control_button, focus_next)
	control_button.focus_previous = _get_button_path_to_neighbour(control_button, focus_previous)
	
func _get_button_path_to_neighbour(control_button : Control, neighbour : NodePath) -> NodePath:
	var neighbour_node : Control = get_node_or_null(neighbour)
	
	if neighbour_node:
		return control_button.get_path_to(neighbour_node)

	return ""
