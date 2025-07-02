class_name Enemy
extends CharacterBody2D

const GOLD_CHANCE := .4
const KNOCKBACK_SPEED := 100.0

@onready var animated_sprite_2d: AnimatedSprite2D = $EnemyAnimationController/AnimatedSprite2D
var _is_golden := false

@export var _guaranteed_gold : bool

@export var main_state_machine : StateMachine
@export var movement_state_machine : StateMachine

@export var input_controller : InputController
@export var movement_controller : MovementController
@export var anim_player : AnimationController
@export var sfx_player : SfxPlayer
	
func _ready() -> void:
	input_controller.init()
	movement_controller.init(self)
	anim_player.init()
	sfx_player.init()
	
	_decide_is_golden()
	
	main_state_machine.init(input_controller, anim_player, sfx_player, movement_controller)
	movement_state_machine.init(input_controller, anim_player, sfx_player, movement_controller)
	
func _physics_process(delta : float) -> void:	
	main_state_machine.process_physics(delta)

func _decide_is_golden() -> void:
	if _guaranteed_gold or randf() < GOLD_CHANCE:
		_is_golden = true
		anim_player.play_animation_overlay("gold")
