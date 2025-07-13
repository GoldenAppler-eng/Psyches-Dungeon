extends InputController

enum STATE { BATTLE, SCATTER }

@export var actor : CharacterBody2D
@export var attack_detection_area : Area2D

@export var direction_change_timer : Timer
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

var initial_position : Vector2
var _target_direction : Vector2

var current_state : int

var _target_player_is_dead : bool = false
var _can_change_direction : bool = true

func init() -> void:
	_target_player = Global.global_player
	_connect_signals()
	
	initial_position = actor.global_position
	current_state = STATE.BATTLE
	_initialize_direction_weights()

func get_movement_axis() -> Vector2:	
	return _get_target_direction()
	
func get_attack_request() -> bool:
	return _player_in_attack_range and not _target_player_is_dead

func _initialize_direction_weights() -> void:
	for i in 8:
		direction_weights.append(0)

func _get_target_direction() -> Vector2:	
	if not _can_change_direction:
		return _target_direction
	
	if _target_player_is_dead:
		current_state = STATE.SCATTER
	else:
		current_state = STATE.BATTLE
	
	if current_state == STATE.SCATTER:
		if (actor.global_position - initial_position).length() < 10:
			return Vector2(0, 0)
	
	_calculate_direction_weights()
	
	var target_direction_index : int = _find_max_unobstructed_direction_weight_index()	
	var target_direction : Vector2 = direction_dictionary[target_direction_index]
	
	_target_direction = target_direction.normalized()
	_can_change_direction = false
	
	return _target_direction

func _calculate_direction_weights() -> void:
	match current_state:
		STATE.BATTLE:
			_calculate_direction_weights_for_battle()
		STATE.SCATTER:
			_calculate_direction_weights_for_scatter()
	
func _calculate_direction_weights_for_battle() -> void:
	for i in direction_weights.size():
		var testing_direction : Vector2 = direction_dictionary[i]
		var player_direction : Vector2 = _target_player.global_position - actor.global_position

		var dot : float = testing_direction.normalized().dot(player_direction)
		var weight_modifier : float = clamp(0, player_direction.length()/100.0, 1)
		
		direction_weights[i] = dot * weight_modifier
		
		var dot2 : float = 	testing_direction.normalized().dot(player_direction.rotated(deg_to_rad(100)))
		direction_weights[i] += dot2 * ( 1 - weight_modifier )
		
func _calculate_direction_weights_for_scatter() -> void:
	for i in direction_weights.size():
		var testing_direction : Vector2 = direction_dictionary[i]
		var intial_position_direction : Vector2 = initial_position - actor.global_position

		var dot : float = testing_direction.normalized().dot(intial_position_direction)
		direction_weights[i] = dot

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
	attack_detection_area.area_entered.connect(_on_attack_detection_area_entered)
	attack_detection_area.area_exited.connect(_on_attack_detection_area_exited)

	direction_change_timer.timeout.connect(_on_direction_change_timer_timeout)

	GlobalSignalBus.player_death.connect(_on_player_death)
	GlobalSignalBus.player_respawn.connect(_on_player_respawn)

func _on_attack_detection_area_entered(area : Area2D) -> void:
	_player_in_attack_range = true
	
func _on_attack_detection_area_exited(area : Area2D) -> void:
	_player_in_attack_range = false
	
func _on_direction_change_timer_timeout() -> void:
	_can_change_direction = true	
	
func _on_player_death() -> void:
	_target_player_is_dead = true

func _on_player_respawn() -> void:
	_target_player_is_dead = false
