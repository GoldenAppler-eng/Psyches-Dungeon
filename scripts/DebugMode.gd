extends Node

@export var task_handler : TaskHandler

@export var player_invincible : bool = false
@export var mute_audio : bool = false

func _ready() -> void:
	if mute_audio:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_finish_task"):
		task_handler.task_finished.emit()

	if Input.is_action_just_pressed("debug_fail_task"):
		GlobalCardTimer.timeout.emit()
		
	if player_invincible:
		Global.global_player.find_child("DamageableHitbox").monitorable = false
