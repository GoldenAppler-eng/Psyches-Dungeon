class_name LossHandler
extends Node2D

var loss_counter : int = 0

func _process(delta : float) -> void:
	pass

func mark_loss() -> void:
	var marker : Node2D = get_node_or_null("loss_marker_" + str(loss_counter)) as Node2D
	
	if not marker:
		return
	
	var marker_icon : Node2D = marker.find_child("icon") as Node2D
	
	marker_icon.visible = true
	
	loss_counter += 1
