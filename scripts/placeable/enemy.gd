class_name Enemy
extends CharacterBody2D


const GOLD_CHANCE := .4
const KNOCKBACK_SPEED := 100.0

@export var jump_component_prefab : PackedScene

@onready var attack_detection_area : Area2D = $%AttackDetectionArea
@onready var object_detection_area : Area2D = $%ObjectDetectionArea

@onready var attack_cooldown_timer : Timer = $%AttackCooldownTimer
@onready var invincibility_timer : Timer = $%InvincibilityTimer

@onready var animated_sprite_2d : AnimatedSprite2D = $%AnimatedSprite2D

@export var dropped_item : PackedScene

var target_player : Player

var _is_golden := false

@export var _guaranteed_gold : bool

var avoided_objects : Array[Node2D] = []

var _target_direction : Vector2
var _knockback_direction : Vector2
	
func _ready() -> void:
	if _guaranteed_gold:
		_is_golden = true
		(animated_sprite_2d.material as ShaderMaterial).set_shader_parameter("is_golden", true)
	
	target_player = Global.global_player

func _physics_process(delta : float) -> void:	
	pass

func _get_target_direction() -> void:
	var normalized_vector2_to_player : Vector2 = (target_player.global_position - global_position).normalized()
	_target_direction = normalized_vector2_to_player
	
	for object in avoided_objects:
		if object == self:
			continue
		
		var normalized_vector2_to_object : Vector2 = (object.global_position - global_position).normalized()
		var object_direction_weight : float = normalized_vector2_to_player.dot(normalized_vector2_to_object)
			
		if object is Enemy:
			object_direction_weight = 1 - abs(object_direction_weight)
	
		_target_direction -= object_direction_weight * normalized_vector2_to_object
		
	if _target_direction.dot(normalized_vector2_to_player) >= 0:
		_target_direction = _target_direction.normalized()
	else:
		_target_direction = normalized_vector2_to_player

func _die() -> void:	
	animated_sprite_2d.play("death")
	
	if _is_golden:
		var item : Node = dropped_item.instantiate()
		var jump_comp : Node = jump_component_prefab.instantiate()
		
		get_parent().add_child(item)	
		item.add_child(jump_comp)
		
		item.global_position = global_position
		
	GlobalSignalBus.enemy_death.emit(_is_golden)

func _on_object_detection_area_body_entered(body : Node2D) -> void:
	avoided_objects.append(body)

func _on_object_detection_area_body_exited(body : Node2D) -> void:
	if avoided_objects.has(body):
		avoided_objects.remove_at(avoided_objects.find(body))
