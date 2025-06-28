class_name State
extends Node

var controller : InputController
var anim_player : AnimationPlayer

func init(controller : InputController, anim_player : AnimationPlayer) -> void:
	self.controller = controller
	self.anim_player = anim_player

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	return null
