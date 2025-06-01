class_name JumpComponent
extends Node2D

const MOVEMENT_VELOCITY := 100
const JUMP_VELOCITY := -150 
const FALL_GRAVITY := 200

var jump_origin : Vector2
var jump_direction : Vector2
var sprite : Node2D

var original_sprite_offset : Vector2

var y_velocity : float = 0

func _ready() -> void:
	if not(get_parent() is PhysicsBody2D):
		queue_free()
	
	var jump_angle : float = deg_to_rad(randf_range(0, 360))
	jump_direction = Vector2(cos(jump_angle), sin(jump_angle))
	
	for child in get_parent().get_children():
		if (child is Sprite2D or child is AnimatedSprite2D) and not sprite:
			sprite = child
			break 
			
	original_sprite_offset = sprite.position
	y_velocity = JUMP_VELOCITY
	
	get_parent().set_process_mode(PROCESS_MODE_DISABLED)

func _process(delta : float) -> void:
	var parent : PhysicsBody2D = get_parent() as PhysicsBody2D
	
	parent.global_position += jump_direction * MOVEMENT_VELOCITY * delta;	
	
	y_velocity += FALL_GRAVITY * delta
	
	sprite.position.y += y_velocity * delta
	
	if sprite.position.y > original_sprite_offset.y:
		sprite.position = original_sprite_offset
		parent.set_process_mode(PROCESS_MODE_INHERIT)
		queue_free()
	
