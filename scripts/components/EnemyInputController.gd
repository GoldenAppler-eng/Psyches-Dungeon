extends InputController

@export var actor : CharacterBody2D

@export var object_detection_area: Area2D

var _target_player : Player
var _target_direction : Vector2
var avoided_objects : Array[Node2D] = []

func init() -> void:
	_target_player = Global.global_player
	
	_connect_signals()

func get_movement_axis() -> Vector2:
	return _get_target_direction()
	
func get_attack_request() -> bool:
	return false

func _get_target_direction() -> Vector2:
	var normalized_vector2_to_player : Vector2 = (_target_player.global_position - actor.global_position).normalized()
	_target_direction = normalized_vector2_to_player
	
	for object in avoided_objects:
		if object == self:
			continue
		
		var normalized_vector2_to_object : Vector2 = (object.global_position - actor.global_position).normalized()
		var object_direction_weight : float = normalized_vector2_to_player.dot(normalized_vector2_to_object)
			
		if object is Enemy:
			object_direction_weight = 1 - abs(object_direction_weight)
	
		_target_direction -= object_direction_weight * normalized_vector2_to_object
		
	if _target_direction.dot(normalized_vector2_to_player) >= 0:
		_target_direction = _target_direction.normalized()
	else:
		_target_direction = normalized_vector2_to_player
		
	return _target_direction

func _connect_signals() -> void:
	object_detection_area.body_entered.connect(_on_object_detection_area_body_entered)
	object_detection_area.body_exited.connect(_on_object_detection_area_body_exited)

func _on_object_detection_area_body_entered(body : Node2D) -> void:
	avoided_objects.append(body)

func _on_object_detection_area_body_exited(body : Node2D) -> void:
	if avoided_objects.has(body):
		avoided_objects.remove_at(avoided_objects.find(body))
