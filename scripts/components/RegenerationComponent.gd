class_name RegenerationComponent
extends Node2D

@export var health_component : HealthComponent

@export var regeneration_start_timer : Timer
@export var regeneration_step_timer : Timer

@export var regen_amt : int = 10

func _ready() -> void:
	pass	
	
func _on_regeneration_start_timer_timeout() -> void:
	regeneration_step_timer.start()

func _on_regeneration_step_timer_timeout() -> void:
	health_component.change_health(regen_amt)
	
	if health_component.is_health_full():
		regeneration_step_timer.stop()
