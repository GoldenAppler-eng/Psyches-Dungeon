class_name Player
extends CharacterBody2D

@onready var respawn_timer : Timer = $%RespawnTimer

@export var main_state_machine : StateMachine
@export var movement_state_machine : StateMachine
@export var attack_state_machine : StateMachine

@export var animation_controller : AnimationController
@export var sfx_player : SfxPlayer
@export var movement_controller : MovementController
@export var input_controller : InputController

@export var health_component : HealthComponent
@export var regeneration_component : RegenerationComponent

@export var damageable_hitbox_component : DamageableHitboxComponent

var init_position : Vector2 

func _ready() -> void:
	animation_controller.init()
	sfx_player.init()
	movement_controller.init(self)
	
	main_state_machine.init(input_controller, animation_controller, sfx_player, movement_controller)
	movement_state_machine.init(input_controller, animation_controller, sfx_player, movement_controller)
	attack_state_machine.init(input_controller, animation_controller, sfx_player, movement_controller)

	GlobalSignalBus.player_respawn.connect(_on_received_player_respawn_signal)
	
	GlobalSignalBus.retry.connect(_on_game_retry)
		
	Global.global_player = self
	
	init_position = global_position
	
func _physics_process(delta : float) -> void:
	main_state_machine.process_physics(delta)

func _on_game_retry() -> void:
	global_position = init_position
	
	main_state_machine.complete_reset_state_machine()
	movement_state_machine.complete_reset_state_machine()
	attack_state_machine.complete_reset_state_machine()

	health_component.reset_health()
	damageable_hitbox_component.reset_hitbox()
	
	regeneration_component.stop_override_regneration()
	regeneration_component.stop_continuous_regeneration()

func _on_received_player_respawn_signal() -> void:
	respawn_timer.start()

func _on_game_over_timer_timeout() -> void:
	GlobalSignalBus.game_over.emit()
