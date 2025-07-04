class_name GoalMarker
extends Node2D

const DEFAULT_FRAME : int = 3

@onready var icon : AnimatedSprite2D = %icon

func reset_icon() -> void:
	icon.frame = DEFAULT_FRAME
	
func set_icon(goal_type : int) -> void:
	icon.frame = goal_type
	
func set_active(active : bool) -> void:
	visible = active
	
	if not active:
		reset_icon()
