class_name MovementController
extends Node

var actor : CharacterBody2D

@export var max_speed : float
var current_speed : float

func init(actor : CharacterBody2D) -> void:
	self.actor = actor

func move(delta : float, direction : Vector2) -> void:
	var horizontal_direction : float = direction.x
	var vertical_direction : float = direction.y
	
	current_speed = max_speed
	
	if horizontal_direction and vertical_direction :
		current_speed *= sin(deg_to_rad(45))
			
	actor.velocity.x = horizontal_direction * current_speed * delta
	actor.velocity.y = vertical_direction * current_speed * delta

	actor.move_and_slide()

func stop_movement() -> void:
	actor.velocity.x = 0
	actor.velocity.y = 0

	actor.move_and_slide()
