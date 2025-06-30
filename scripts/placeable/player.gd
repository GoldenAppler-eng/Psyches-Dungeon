class_name Player
extends DamagableBody2D

@onready var respawn_timer : Timer = $%RespawnTimer

@export var main_state_machine : StateMachine

@export var animation_controller : AnimationController
@export var sfx_player : SfxPlayer
@export var movement_controller : MovementController
@export var input_controller : InputController

var init_position : Vector2 

func _ready() -> void:
	animation_controller.init()
	sfx_player.init()
	movement_controller.init(self)
	
	main_state_machine.init(input_controller, animation_controller, sfx_player, movement_controller)
	
	GlobalSignalBus.player_respawn.connect(_on_received_player_respawn_signal)
	GlobalSignalBus.revert_controls.connect(_on_revert_controls)
	GlobalSignalBus.shift_controls.connect(_on_revert_controls)
	GlobalSignalBus.invert_controls.connect(_on_revert_controls)
	
	GlobalSignalBus.retry.connect(_on_game_retry)
		
	Global.global_player = self
	
	init_position = global_position
	
func _physics_process(delta : float) -> void:
	main_state_machine.process_physics(delta)
		
func _die() -> void:
	GlobalSignalBus.player_death.emit()

func _on_game_retry() -> void:
	global_position = init_position

func _on_received_player_respawn_signal() -> void:
	respawn_timer.start()

func _on_game_over_timer_timeout() -> void:
	GlobalSignalBus.game_over.emit()

func _on_revert_controls() -> void:
	Input.action_release("move_down")
	Input.action_release("move_up")
	Input.action_release("move_right")
	Input.action_release("move_left")
	
