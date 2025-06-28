class_name State
extends Node

var controller : InputController
var anim_player : AnimationController
var sfx_player : SfxPlayer
var movement_controller : MovementController

func init(controller : InputController, anim_player : AnimationController, sfx_player : SfxPlayer, movement_controller : MovementController) -> void:
	self.controller = controller
	self.anim_player = anim_player
	self.sfx_player = sfx_player
	self.movement_controller = movement_controller

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	return null
