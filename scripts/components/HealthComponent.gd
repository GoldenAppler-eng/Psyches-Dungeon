class_name HealthComponent
extends Node2D

signal health_regened
signal health_lost

@export var max_health : int
var current_health : int

func _ready() -> void:
	current_health = max_health
	
func change_health(amt : int) -> void:
	current_health += amt
	
	if amt > 0:
		health_regened.emit()
	elif amt < 0:
		health_lost.emit()
