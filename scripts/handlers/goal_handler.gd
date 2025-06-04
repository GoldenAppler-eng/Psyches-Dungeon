class_name GoalHandler
extends Node2D

const MARKER_WIDTH := 32
const MARKER_HEIGHT := 32

const GAP_WIDTH := 16

@export var goal_marker_prefab : PackedScene

@onready var initial_goal_marker : Node2D = $%initial_goal_marker

var goal_marker_array : Array[Node2D]

var goal_completion_counter : int = 0

func _ready() -> void:
	goal_marker_array.append(initial_goal_marker)
	
	while goal_marker_array.size() < Global.INIT_NUM_GOAL:
		add_marker()

func _process(delta : float) -> void:
	pass

func mark_completed_task(effect_type : int) -> void:
	if goal_completion_counter >= goal_marker_array.size():
		return
	
	var marker : Node2D = goal_marker_array[goal_completion_counter]
	var marker_icon : AnimatedSprite2D = marker.find_child("icon") as AnimatedSprite2D
	
	marker_icon.frame = effect_type
	
	goal_completion_counter += 1

func add_marker() -> void:
	var new_marker : Node2D = goal_marker_prefab.instantiate() as Node2D
	
	add_child(new_marker)
	
	goal_marker_array.append(new_marker)
	
	new_marker.global_position = global_position
	new_marker.position.x = - (goal_marker_array.size() * (GAP_WIDTH + MARKER_WIDTH) - GAP_WIDTH)

func remove_marker() -> void:
	if goal_marker_array.size() <= Global.MIN_NUM_GOAL:
		return
	
	var last_marker : Node2D = goal_marker_array.pop_back()
	
	remove_child(last_marker)
