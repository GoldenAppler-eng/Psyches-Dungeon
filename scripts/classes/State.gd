class_name State
extends Node

var controller : InputController
var anim_player : AnimationController
var sfx_player : SfxPlayer
var movement_controller : MovementController

func init(pcontroller : InputController, panim_player : AnimationController, psfx_player : SfxPlayer, pmovement_controller : MovementController) -> void:
	controller = pcontroller
	anim_player = panim_player
	sfx_player = psfx_player
	movement_controller = pmovement_controller
	
	extra_init()

func extra_init() -> void:
	pass

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process_frame(delta : float) -> State:
	return null
	
func process_physics(delta : float) -> State:
	return null
