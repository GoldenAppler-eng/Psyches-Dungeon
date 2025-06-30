class_name Player
extends DamagableBody2D

@onready var respawn_timer : Timer = $%RespawnTimer

var init_position : Vector2 

func _ready() -> void:
	GlobalSignalBus.player_respawn.connect(_on_received_player_respawn_signal)
	GlobalSignalBus.revert_controls.connect(_on_revert_controls)
	GlobalSignalBus.shift_controls.connect(_on_revert_controls)
	GlobalSignalBus.invert_controls.connect(_on_revert_controls)
	
	GlobalSignalBus.retry.connect(_on_game_retry)
		
	Global.global_player = self
	
	init_position = global_position
	
func _physics_process(delta : float) -> void:
	pass
		
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
	
