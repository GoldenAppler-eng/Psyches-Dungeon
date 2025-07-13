extends Node2D

@export var input_controller : InputController
@export var length : float = 5

func _draw() -> void:
	draw_line(Vector2(0,0), input_controller.get_movement_axis() * length, Color.GREEN,  3)
	
func _process(delta: float) -> void:	
	queue_redraw()
