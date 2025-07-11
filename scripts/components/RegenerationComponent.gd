class_name RegenerationComponent
extends Node2D

signal full_regeneration_finished

@export var health_component : HealthComponent

@export var regeneration_start_timer : Timer
@export var regeneration_step_timer : Timer

@export var regen_amt : int = 10

func _ready() -> void:
	regeneration_start_timer.timeout.connect(_on_regeneration_start_timer_timeout)
	regeneration_step_timer.timeout.connect(_on_regeneration_step_timer_timeout)	
	
func start_regeneration() -> void:
	regeneration_start_timer.start()
	
func stop_regeneration() -> void:
	regeneration_start_timer.stop()
	regeneration_step_timer.stop()
	
func _on_regeneration_start_timer_timeout() -> void:
	regeneration_step_timer.start()

func _on_regeneration_step_timer_timeout() -> void:
	health_component.change_health(regen_amt)
	
	if health_component.is_health_full():
		stop_regeneration()
		full_regeneration_finished.emit()

func is_regenerating() -> bool:
	return not regeneration_step_timer.is_stopped()
