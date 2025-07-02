class_name Enemy
extends CharacterBody2D

const GOLD_CHANCE := .4
const KNOCKBACK_SPEED := 100.0

@onready var attack_detection_area : Area2D = $AttackDetectionArea
@onready var object_detection_area : Area2D = $ObjectDetectionArea

@onready var animated_sprite_2d : AnimatedSprite2D = $%AnimatedSprite2D

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
	
func _physics_process(delta : float) -> void:	
	pass

func _on_object_detection_area_body_entered(body : Node2D) -> void:
	avoided_objects.append(body)

func _on_object_detection_area_body_exited(body : Node2D) -> void:
	if avoided_objects.has(body):
		avoided_objects.remove_at(avoided_objects.find(body))
