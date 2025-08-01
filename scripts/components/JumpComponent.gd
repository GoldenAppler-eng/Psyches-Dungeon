class_name JumpComponent
extends Node2D

const MOVEMENT_VELOCITY := 10
const JUMP_VELOCITY := -150 
const FALL_GRAVITY := 200

var jump_origin : Vector2
var jump_direction : Vector2
var sprite : Node2D

var original_sprite_offset : Vector2
var original_sprite_z_index : int

var y_velocity : float = 0

func _ready() -> void:
	if not(get_parent() is PhysicsBody2D):
		queue_free()
	
	var jump_angle : float = deg_to_rad(randf_range(0, 360))
	jump_direction = Vector2(cos(jump_angle), sin(jump_angle))
	
	sprite = find_sprite_child(get_parent())
	
	if not sprite:
		return
	
	original_sprite_offset = sprite.position
	original_sprite_z_index = sprite.z_index
	
	sprite.z_index = 5
	y_velocity = JUMP_VELOCITY
	
	get_parent().process_mode = PROCESS_MODE_DISABLED

func find_sprite_child(root : Node) -> Node2D:
	for child in root.get_children():
		if child is Sprite2D or child is AnimatedSprite2D:
			return child
		else:
			var sprite_child : Node2D = find_sprite_child(child)
			
			if sprite_child:
				return sprite_child
	
	return null

func _process(delta : float) -> void:
	var parent : PhysicsBody2D = get_parent() as PhysicsBody2D
	
	parent.global_position += jump_direction * MOVEMENT_VELOCITY * delta;	
	
	y_velocity += FALL_GRAVITY * delta
	
	sprite.position.y += y_velocity * delta
	
	if sprite.position.y > original_sprite_offset.y:
		sprite.position = original_sprite_offset
		sprite.z_index = original_sprite_z_index
		
		parent.process_mode = PROCESS_MODE_INHERIT
		queue_free()
	
