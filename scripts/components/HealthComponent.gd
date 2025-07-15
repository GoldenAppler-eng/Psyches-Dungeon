class_name HealthComponent
extends Node2D

signal health_regened
signal health_lost

@export var max_health : int = 5
var current_health : int

func _ready() -> void:
	current_health = max_health
	
func change_health(amt : int) -> void:
	if amt > 0 and not current_health == max_health:
		health_regened.emit()
	elif amt < 0 and not current_health == 0:
		health_lost.emit()
		
	current_health += amt
	current_health = clamp(current_health, 0, max_health)

func is_health_full() -> bool:	
	return current_health == max_health
