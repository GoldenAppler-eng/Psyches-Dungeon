extends InputController

@export var actor : CharacterBody2D
@export var attack_detection_area : Area2D
@export var obstruction_detectors : Array[Array]

var direction_weights : Array[float] = []
var direction_dictionary : Dictionary = {
	0: Vector2(0, -1),
	1: Vector2(1, -1),
	2: Vector2(1, 0),
	3: Vector2(1, 1),
	4: Vector2(0, 1),
	5: Vector2(-1, 1),
	6: Vector2(-1, 0),
	7: Vector2(-1, -1)
}

var _target_player : Player
var _player_in_attack_range : bool = false

func init() -> void:
	_target_player = Global.global_player
	_connect_signals()

	_initialize_direction_weights()

func get_movement_axis() -> Vector2:	
	return _get_target_direction()
	
func get_attack_request() -> bool:
	return _player_in_attack_range

func _initialize_direction_weights() -> void:
	for i in 8:
		direction_weights.append(0)

func _get_target_direction() -> Vector2:
	_calculate_direction_weights()
	
	var target_direction_index : int = _find_max_unobstructed_direction_weight_index()
	var target_direction : Vector2 = direction_dictionary[target_direction_index]
	
	return target_direction.normalized() 

func _calculate_direction_weights() -> void:
	for i in direction_weights.size():
		var testing_direction : Vector2 = direction_dictionary[i]
		var player_direction : Vector2 = _target_player.global_position - actor.global_position
		
		direction_weights[i] = testing_direction.normalized().dot(player_direction)

func _find_max_unobstructed_direction_weight_index() -> int:
	var direction_index : int = 0
	var max_direction_weight : float = -100000.0
	
	for i in direction_weights.size():
		if _is_direction_obstructed(i):
			continue
		
		if max_direction_weight >= direction_weights[i]:
			continue
		
		max_direction_weight = direction_weights[i]
		direction_index = i
	
	return direction_index

func _is_direction_obstructed(direction_index : int) -> bool:
	var nodepath_group : Array = obstruction_detectors[direction_index]

	for nodepath : NodePath in nodepath_group:
		var raycast : RayCast2D = get_node(nodepath) as RayCast2D
		
		if raycast.is_colliding():
			return true
	
	return false

func _connect_signals() -> void:
	attack_detection_area.area_entered.connect(_on_attack_detection_area_area_entered)
	attack_detection_area.area_exited.connect(_on_attack_detection_area_area_exited)

func _on_attack_detection_area_area_entered(area : Area2D) -> void:
	_player_in_attack_range = true
	
func _on_attack_detection_area_area_exited(area : Area2D) -> void:
	_player_in_attack_range = false
