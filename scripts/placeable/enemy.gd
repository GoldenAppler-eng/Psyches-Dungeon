class_name Enemy
extends CharacterBody2D

const GOLD_CHANCE : float = .2

@export var main_state_machine : StateMachine
@export var movement_state_machine : StateMachine

@export var input_controller : InputController
@export var movement_controller : MovementController
@export var anim_player : AnimationController
@export var sfx_player : SfxPlayer

@export var _guaranteed_gold : bool
var _is_golden : bool = false
	
var _decided_is_golden : bool = false	
	
func _ready() -> void:
	input_controller.init()
	movement_controller.init(self)
	anim_player.init()
	sfx_player.init()
		
	main_state_machine.init(input_controller, anim_player, sfx_player, movement_controller)
	movement_state_machine.init(input_controller, anim_player, sfx_player, movement_controller)
		
func _physics_process(delta : float) -> void:	
	main_state_machine.process_physics(delta)
	
	if not _decided_is_golden:
		_decide_is_golden()

func _decide_is_golden() -> void:
	if _guaranteed_gold or randf() < GOLD_CHANCE or Global.gold_rush_flag:
		_is_golden = true
		anim_player.play_animation_overlay("gold")
		
	_decided_is_golden = true
	
